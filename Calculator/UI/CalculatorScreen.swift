import SwiftUI

enum MathOperation {
    case divide
    case multiple
    case minus
    case plus
}

struct CalculatorScreen: View {
    
    static let initialStringValue = "0"
    static let defaultEmptyValue = 0.0
    static let negativeNumberSymbol = "-"
    static let numberDeviderSymbol = "."
    static let zeroIntegerPartNumberSymbol  = "0."
    
    
    @State var currentNumber = initialStringValue
    @State var buffer = defaultEmptyValue
    @State var operation: MathOperation?
    
    var currentValue: Double {
        Double(currentNumber) ?? Self.defaultEmptyValue
    }
    
    var body: some View {
        VStack(spacing: 0) {
          //Spacer().border(.yellow)
          Rectangle()
            .frame(width: .infinity, height: .infinity)
//            .border(.yellow)
            TextPanel(text: $currentNumber)
                .padding([.bottom], 10)
            ButtonPanel { buttonType in
                handleTap(buttonType: buttonType)
            }//.border(.white)
        }
        .background(.black)
    }
    
    func handleTap(buttonType: CalcButtonType) {
        switch buttonType {
        case .clear:
            currentNumber = Self.initialStringValue
        case .inversion:
            if currentNumber.hasPrefix(Self.negativeNumberSymbol) {
                currentNumber.trimPrefix(Self.negativeNumberSymbol)
            } else {
                currentNumber = Self.negativeNumberSymbol + currentNumber
            }
        case .percent:
            let result = currentValue / 100
            currentNumber = "\(result)"
        case .divide:
            buffer = currentValue
            currentNumber = Self.initialStringValue
            operation = .divide
        case .multiple:
            buffer = currentValue
            currentNumber = Self.initialStringValue
            operation = .multiple
        case .minus:
            buffer = currentValue
            currentNumber = Self.initialStringValue
            operation = .minus
        case .plus:
            buffer = currentValue
            currentNumber = Self.initialStringValue
            operation = .plus
        case .equal:
            guard let operation = operation else { return }
            let result: Double
            switch operation {
            case .divide:
                result = buffer / currentValue
            case .multiple:
                result = buffer * currentValue
            case .minus:
                result = buffer - currentValue
            case .plus:
                result = buffer + currentValue
            }
            currentNumber = "\(result)"
            buffer = Self.defaultEmptyValue
            self.operation = nil
        case .dot:
            guard !currentNumber.contains(Self.numberDeviderSymbol) else {return }
            currentNumber.append(Self.numberDeviderSymbol)
        case .number(let number):
            guard currentNumber.count <= 15 else { return }
            currentNumber.append("\(number)")
            if !currentNumber.hasPrefix(Self.zeroIntegerPartNumberSymbol) {
                currentNumber.trimPrefix(Self.initialStringValue)
            }
        }
    }
    
}

struct TextPanel: View {
    
    @Binding var text: String
    
    var body: some View {
        Text(text)
            .lineLimit(1)
            .minimumScaleFactor(0.1)
            .foregroundColor(.white)
            .font(Font.system(size: 90, weight: .thin))
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding([.leading, .trailing], 30)
//            .border(.green)
    }
    
}


struct ButtonPanel: View {
    
    let action: (CalcButtonType) -> Void
    
    var body: some View {
        let symbolsStyle = CalcButtonStyle(parameters: .symbols)
        let actionStyle = CalcButtonStyle(parameters: .action)
        let numberStyle = CalcButtonStyle(parameters: .number)
        Grid(horizontalSpacing: 10, verticalSpacing: 10) {
            GridRow {
                makeButton(.clear, symbolsStyle)
                makeButton(.inversion, symbolsStyle)
                makeButton(.percent, symbolsStyle)
                makeButton(.divide, actionStyle)
            }
            GridRow {
                makeButton(.number(7), numberStyle)
                makeButton(.number(8), numberStyle)
                makeButton(.number(9), numberStyle)
                makeButton(.multiple, actionStyle)
            }
            GridRow {
                makeButton(.number(4), numberStyle)
                makeButton(.number(5), numberStyle)
                makeButton(.number(6), numberStyle)
                makeButton(.minus, actionStyle)
            }
            GridRow {
                makeButton(.number(1), numberStyle)
                makeButton(.number(2), numberStyle)
                makeButton(.number(3), numberStyle)
                makeButton(.plus, actionStyle)
            }
            GridRow {
                makeButton(.number(0), numberStyle)
                Spacer()
                makeButton(.dot, numberStyle)
//                makeButton(.equal, numberStyle)
              CalcButton(type: .equal, action: action).buttonStyle(numberStyle)
            }
        }.fixedSize(horizontal: false, vertical: true)
    }
    
    func makeButton(
        _ type: CalcButtonType,
        _ style: CalcButtonStyle
    ) -> some View {
        CalcButton(type: type, action: action).buttonStyle(style)
    }
}

enum CalcButtonType {
    case clear
    case inversion
    case percent
    case divide
    case multiple
    case minus
    case plus
    case equal
    case dot
    case number(Int)
    
    var title: String {
        switch self {
        case .clear:
            return "AC"
        case .inversion:
            return "±"
        case .percent:
            return "%"
        case .divide:
            return "÷"
        case .multiple:
            return "x"
        case .minus:
            return "-"
        case .plus:
            return "+"
        case .equal:
            return "="
        case .dot:
            return "."
        case .number(let number):
            return "\(number)"
        }
    }
}


struct CalcButton: View {
    
    let type: CalcButtonType
    let action: (CalcButtonType) -> Void

    var body: some View {
        Button(type.title) {
            action(type)
        }
    }
    
}

struct CalcButtonStyle: ButtonStyle {
    
    let parameters: CalcButtonStyleParameters
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(parameters.titleColor)
            .font(Font.system(size: 100))
            .minimumScaleFactor(0.1)
            .padding(20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .aspectRatio(1, contentMode: .fit)
            .background(parameters.backgroundColor)
            .cornerRadius(.infinity)
            .opacity(configuration.isPressed ? 0.5 : 1.0)
    }
}

struct CalcButtonStyleParameters {
    let titleColor: Color
    let backgroundColor: Color
    
  static let symbols = CalcButtonStyleParameters(titleColor: .black, backgroundColor: .gray)
  static let number = CalcButtonStyleParameters(titleColor: .white, backgroundColor: Color(.calculatorNumber))
    static let action = CalcButtonStyleParameters(titleColor: .white, backgroundColor: Color(.orange))
}

struct CalculatorScreen_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorScreen()
    }
}
