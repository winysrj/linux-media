Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.juropnet.hu ([212.24.188.131]:59260 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256Ab1KTOol (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Nov 2011 09:44:41 -0500
Message-ID: <4EC908C1.70408@mailbox.hu>
Date: Sun, 20 Nov 2011 15:03:45 +0100
From: Istvan Varga <istvan_v@mailbox.hu>
MIME-Version: 1.0
To: john@kents.id.au
CC: john <r.john.kent@gmail.com>, linux-media@vger.kernel.org
Subject: Re: Leadtek PxDVR3200H and mythbuntu 11.04/11.10
References: <4EC85824.4030301@gmail.com>
In-Reply-To: <4EC85824.4030301@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------000201070409070905000407"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000201070409070905000407
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 11/20/2011 02:30 AM, john wrote:

> I have tried downloading clean v4l repositories and trying to patch for
> xc4000 but I can't get it to compile.

XC4000 support is included in the V4L repositories starting from
staging/for_v3.1, if you have recent sources, then no patching is
needed.

> As well, I'm in Australia so I need the 7MHz version particular to our
> transmission type.

The driver does support 7 MHz bandwidth.

You need a firmware file for XC4000, I have attached it in case it is
not included yet with the V4L sources. Note that the firmware available
at kernellabs.com is not compatible with the driver in the V4L
repositories.


--------------000201070409070905000407
Content-Type: application/octet-stream;
 name="dvb-fe-xc4000-1.4.fw"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="dvb-fe-xc4000-1.4.fw"

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
AQWtszLzAQX0szLzAQXPszLzAQXV1ADEgC/E8wUFnoRDL8TzBQWPhEcvxPMFBZXwGQX6EwTS
twIj8CjwGQX60x8vz9IBwgGiIwIj8CjwGQX6ggaCJ9P/wwdP7/MBBarTOBIj8CDwGQX68Cjw
GQX60rTwKPAZBfrgBAq702QjNNCgwA8AA/AZBfrVAMVw4AUG7NUPLvmHeS/5hmgAZ4AIgAjW
FAAG8BkF+uAABq7wDfAZBfrQCuAABv6gEfAZBfrQBsBg4AAG7IAk8BkF+tHy8BjwGQX64AAG
zPAZBfrgAAbe8BkF+tL68CiACYAJ8BkF+tK18CiADYAL8BkF+tK78CjwGQX64AAGl+AAByfw
DvAZBirwCvsI+wEGU/cY9wEGENgA2A0Ih/aAqGf5KPiUGXv5AQZT2B34iHiL2QEsifgFBoy7
stkAyQQouQhY+Yj5BQZx2QDJBCe52QDJ0AeX+Xj5AQZW+QUGgPAK2BXXAMew2QjbAMsE+QEG
OvqA96y5kqiDB3vwGQYx1wDHrNgM+YD3nKiD+YDynImdiZ/XAMc0F3v5AQZTqIMHe/qA+gEG
R/qg96y5kvAZBkfwBvAZBlTaAMocF4r3nKmT+JzZDgmb9pCpY/qQ9Kypk/qQ8qyqo9cA+nyq
o/dg+nzYAMiMq7P4vPAG8ALZDgmb9pCpY/qQ9KyplfqQ8qzYAMiMq7P4vPAG8AL4nNoAymQH
itkA95zaAMocF4r3nPAZBnG7stgAyFDZAMkESJvZAPic8AbwAvAO0gngAgb+0AgN/GIwDuwQ
EoAE8ALQAuAABv6BHYMTghWEFx/0Hd7QASzPLM3wAtIBwmDgAgbskkjU5/FIgR4RIaQQ9AEG
vtQIARTwGQbB1PjE/wEUkRjU6vNI4AQKtBA01OHzSPMNQBPwAtAIwAjSC+ACBv6TOAAD0ubx
KNOAogHgAgugICEiMZIuAALwAtIDwmDgAgbsgDqAC7AC0gtzMtI/LMKESh1P8ALwCtIAwqTy
DMKo8SjxAQbxwpzxKMKg8ijwBvACwIDgAAcC8ALAIOAABuzwAvAK0wDDnPMcw6DzLMOk8wzT
AMOo8zjzAQcK8AbwAvAK0Q3BeNAAwKTwHMCg8BzApPAcwKjxCPEBBxzwBvAC0QDBlPAYwZjx
GPAC0QDBmPEM8ALUDy/UgRkt1BET1AFkQYRCtEIuTmIjY0OjM/MNLPwczvAC0wHDAfQ4hQPW
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
CAAEADsF/wADAAIuAAMAAh8ABQAAAACIgAoABAACAMAABAABgBuACv//gAAAAAAAAAAAAAAA
rgAAAAAEAAUAAAADACkHAA0AERsGMBAMCA2NCRUvAA0AEgAAAAAAAAAAAAAAAAsAGAAAFopA
AAAAIAANABkAAAAAAAAAAAAAAAADABYDAAYADRkgizwAAwAeAAADAB8EAAMAICkAAwAhBgAK
ACMACAlomgJaJgADACcGAAQANQAIAAYAOiuvrxAABAA7Bf8AAwACLgADAAIfAAUAAAAAiIAK
AAQAAgDAAAQAAYAHgAr//wAAAAAHAAAABAAAALgAAAAABAAFAAAAAwApBwANABEUCAAADAja
tNoLLQANABILW2WiJGjRVWkVYwALABgAABaKQAAAACAADQAZAbYVFrGm0qkSQWYACAAMV2b0
ZtTUAAMAFgEABgANGSCLPAADAB4BAAMAHwQAAwAgKQADACEGAAoAIwAICWiaAlomAAMAJwAA
BAA1AAgABgA6K4+PEAAEADsH/wADAAIuAAMAAh8ABQAAAACIgAoABAACAAQABAABgVmACv//
AIAAAAcAAAAEAAAAuAAAAAAEAAUAAAADACkHAA0AERQIAAAMCNq02gstAA0AEgtbZaIkaNFV
aRVjAAsAGAAAFopAAAAAIAANABkBthUWsabSqRJBZgAIAAxXZvRm1NQAAwAWAQAGAA0ZIIs8
AAMAHgIAAwAfBAADACApAAMAIQYACgAjAAgJaJoCWiYAAwAnQAAEADUACAAGADorj48QAAQA
Owf/AAMAAi4AAwACHwAFAAAAAIiACgAEAAIAeAAEAAGBWYAK//8AAAAABwAAAAgAAAC4AAAA
AAQABQAAAAMAKQcADQARFAgAAAwI2rTaCy0ADQASC1tloiRo0VVpFWMACwAYAAAWikAAAAAg
AA0AGQAtCW21ptJZFkFlAAgADFdm9GbU1AADABYBAAYADRkgizwAAwAeAQADAB8EAAMAICkA
AwAhBgAKACMACAlomgJaJgADACcAAAQANQAIAAYAOiuPjxAABAA7B/8AAwACLgADAAIfAAUA
AAAAiIAKAAQAAgAEAAQAAYHZgAr//wCAAAAHAAAACAAAALgAAAAABAAFAAAAAwApBwANABEU
CAAADAjatNoLLQANABILW2WiJGjRVWkVYwALABgAABaKQAAAACAADQAZAC0JbbWm0lkWQWUA
CAAMV2b0ZtTUAAMAFgEABgANGSCLPAADAB4BAAMAHwQAAwAgKQADACEGAAoAIwAICWiaAlom
AAMAJ0EABAA1AAgABgA6K4+PEAAEADsH/wADAAIuAAMAAh8ABQAAAACIgAoABAACATQABAAB
gdmACv//AAAAAAcAAAACAAAAvQAAAAAEAAUAAAADACkHAAMAFwIADQARFAgAAAwI2rTaCy0A
DQASC1tloiRo0VVpFWMACwAYAAAWikAAAAAgAA0AGQAtCW21ptJZFkFlAAgADFdm9GbU1AAD
ABYBAAYADRkgizwAAwAeAAADAB8EAAMAICkAAwAhBgAKACMACAlomgJaJgADACcAAAQANQAI
AAYAOiuPjxAABAA7B/8AAwACLgADAAIfAAUAAAAAiIAKAAQAAgAAAAQAAYHZgAr//wCAAAAH
AAAAAgAAALgAAAAABAAFAAAAAwApBwANABEUCAAADAjatNoLLQANABILW2WiJGjRVWkVYwAL
ABgAABaKQAAAACAADQAZAC0JbbWm0lkWQWUACAAMV2b0ZtTUAAMAFgEABgANGSCLPAADAB4C
AAMAHwQAAwAgKQADACEGAAoAIwAICWiaAlomAAMAJ0AABAA1AAgABgA6K4+PEAAEADsH/wAD
AAIuAAMAAh8ABQAAAACIgAoABAACAHgABAABgdmACv//AAAAAAcAAAABAAAAuAAAAAAEAAUA
AAADACkHAA0AERQIAAAMCNq02gstAA0AEgtbZaIkaNFVaRVjAAsAGAAAFopAAAAAIAANABkB
thUWsabSqRJBZgAIAAxXZvRm1NQAAwAWAQAGAA0ZIIs8AAMAHgAAAwAfBAADACApAAMAIQYA
CgAjAAgJaJoCWiYAAwAnAAAEADUACAAGADorj48QAAQAOwf/AAMAAi4AAwACHwAFAAAAAIiA
CgAEAAIAAAAEAAGBWYAK//8AgAAABwAAAAEAAAC4AAAAAAQABQAAAAMAKQcADQARFAgAAAwI
2rTaCy0ADQASC1tloiRo0VVpFWMACwAYAAAWikAAAAAgAA0AGQG2FRaxptKpEkFmAAgADFdm
9GbU1AADABYBAAYADRkgizwAAwAeAgADAB8EAAMAICkAAwAhBgAKACMACAlomgJaJgADACdA
AAQANQAIAAYAOiuPjxAABAA7B/8AAwACLgADAAIfAAUAAAAAiIAKAAQAAgB4AAQAAYFZgAr/
/wAAAAAQAAAADAAAALgAAAAABAAFAAAAAwApBwANABEUCAAADAjatNoLLQANABIBGyWiNKop
hbalpgALABgAABaKQAAAACAADQAZAAAAAAAAAAAAAAAACAAMV2b0ZtTUAAMAFgEABgANGSCL
PAADAB4BAAMAHwQAAwAgKQADACEGAAoAIwAICWiaAlomAAMAJwEABAA1AAgABgA6K4+PEAAE
ADsH/wADAAIuAAMAAh8ABQAAAACIgAoABAACAIAABAABgEmACv//AIAAABAAAAAMAAAAuAAA
AAAEAAUAAAADACkHAA0AEQAAAAAAAAAAAAEpAA0AEgEbJaI0qimFtqWmAAsAGAAAFopAAAAA
IAANABkAAAAAAAAAAAAAAAAIAAxXQPKq1NQAAwAWAQAGAA0ZIIs8AAMAHgIAAwAfBAADACAp
AAMAIQYACgAjAAkIBEJCARAAAwAnQAAEADUACAAGADorr68QAAQAOwf/AAMAAi4AAwACHwAF
AAAAAIiACgAEAAIAeAAEAAGASYAK//8AAAAA4AAAAAwAAAC4AAAAAAQABQAAAAMAKQcADQAR
FAgAAAwI2rTaCy0ADQASARslojSqKYW2paYACwAYAAAWikAAAAAgAA0AGQAAAAAAAAAAAAAA
AAgADFdm9GbU1AADABYBAAYADRkgizwAAwAeAAADAB8EAAMAICkAAwAhBgAKACMACAlomgJa
JgADACcBAAQANQAIAAYAOiuPjxAABAA7B/8AAwACLgADAAIfAAUAAAAAiIAKAAQAAgCAAAQA
AYBJgAr//wCAAADgAAAADAAAALgAAAAABAAFAAAAAwApBwANABEAAAAAAAAAAAABKQANABIB
GyWiNKophbalpgALABgAABaKQAAAACAADQAZAAAAAAAAAAAAAAAACAAMV0DyqtTUAAMAFgEA
BgANGSCLPAADAB4CAAMAHwQAAwAgKQADACEGAAoAIwAJCARCQgEQAAMAJ0AABAA1AAgABgA6
K6+vEAAEADsH/wADAAIuAAMAAh8ABQAAAACIgAoABAACAHgABAABgEmACv//AAAAAOAAMgQD
AAAAuAAAAAAEAAUAAAADACkHAA0AERQIAAAMCNq02gstAA0AEgEbJaI0qimFtqWmAAsAGAAA
FopAAAAAIAANABkAAAAAAAAAAAAAAAAIAAxXZvRm1NQAAwAWAQAGAA0ZIIs8AAMAHgAAAwAf
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
AAAAiBPAAAAAHAiCnLQAAClmRlaTHBsiuNgAAoFhRloLHADSm5IAAAFallqcHBkikm2ACkla
plpjHB9SlNgAEm1WRlqMHBziSSUAJaFqVmocHAaySpIAEklpVmqVHBoCSwAACTFkBmmMHAiC
nLQAAClmRlaTHAWzbtgCpcFWhpoUHA0TN+ACkk1WBqaNHBTS2NgCS4FihpUaHArS7bgCU21l
RpZLHBvS23ICRwFaVoQSHB3SkpgCVMFpRqoVHAmykkkCS5FmpqmlAAAAYAAAAAAAAAAAzCnA
AAAAHB0DbtgCk4KWRpocHB0DbtgCk4KWRpocHB0DbtgCk4KWRpocHB0DbtgCk4KWRpocHB0D
btgCk4KWRpocHB0DbtgCk4KWRpocHB0DbtgCk4KWRpocHB0DbtgCk4KWRpocHB0DbtgCk4KW
RpocHB0DbtgCk4KWRpocHB0DbtgCk4KWRpocHB0DbtgCk4KWRpocHB0DbtgCk4KWRpocHB0D
btgCk4KWRpocHB0DbtgCk4KWRpocHB0DbtgCk4KWRpocAAAAYAAAAAAAAAAAEA7AAAAAHAlA
G22SSqGVVWUJHBqgH+ASVgGVBWgKHB3gJJISXaGaVVYZHBsgBxgSUkmEhVWRHAKwG24AACWl
VqqWHATQGNgAAU2hhqmdHB2wE24AAG2lVqVTHBqAENgACm2iRqmdHAlAG22SSqGVVWUJHBhw
DbQTbsGVhZkSHB5ADLQSMAGZRRAQHAJQCkmTJJGZpWWiHBkACXAS22GaRVkZHBmQEkASkk2V
BWaLHBcQE3IStwGVlWQRHApgE24SSUmalWpjAAAAYAAAAAAAAAAAKA/AAAAAHAIQCk4AG3Gl
ZpVaHA5ADbgAC3GqhpWrHAwwCngAAC2pRppcHAggABIAAJGlVpVSHAggABIAAJGlVpVSHBYw
ACkASUmmVqZcHB5AAW4AbcGlZqodHA0AASmAXaGmppUqHAIQCk4AG3GlZpVaHBsgBxgSUkmE
hVWRHA0ALdgSTIGqRVYhHATQGNgAAU2hhqmdHB5AG2wAAm2qhqVrHBqAENgACm2iRqmdHA7w
EkoACcGpZqUjHAGQCSWAEqGlZqYcAAAAYAAAAAAAAAAA3A/AAAAAHBQwAAWAU8GmlqUjHA0A
ASmAXaGmppUqHAoQA24AUnGlVpWTHAmQAlQASS2phpWjHAqAAU2AhsGqZokrHAWwAA2Am3Gp
VpVaHAzQACmAxsGqZoYrHB0CSZABbsFVhqkMHBQwAAWAU8GmlqUjHAGQCSWAEqGlZqYcHAIQ
Ck4AG3GlZpVaHB0AC7QACU2lRpqVHAwwCngAAC2pRppcHA4wCSkAAUmplpljHAggABIAAJGl
VpVSHAggABIAAJGlVpVSAAAAYAAAAAAAAAAA0BHAAAAAHA5CRgAAZaFEBmUCHBqCW9gAVJFm
RlaTHAsiUm4ASmFmZlUZHAZyVbQAACVmRmpUHB0CSTIAA5FlZmZTHAGySngACSVmhmqdHA0i
SlAACWFpRmUSHBziSSUAJaFqVmocHA5CRgAAZaFEBmUCHBsiSkkAOMFVZhIKHBCyS3IA3cFZ
VmkLHBqiSsAA/wFaBlQRHApiSSkAm3FalmpcHB8SVuAAm5FZBlZKHBGSUkmAkgFZplQZHAly
W5gASUlZhmVSAAAAYAAAAAAAAAAAXBLAAAAAHB0CSTIAA5FlZmZTHAGySngACSVmhmqdHA0i
SlAACWFpRmUSHBziSSUAJaFqVmocHA6ylwAAE4FUBloDHA0Cm3gADaFWRlYKHAoipJIAAAFa
llmbHA4ipsAAAnFlBlVJHB0CSTIAA5FlZmZTHB8SVuAAm5FZBlZKHBGSUkmAkgFZplQZHAly
W5gASUlZhmVSHA5CRgAAZaFEBmUCHBqCW9gAVJFmRlaTHAsiUm4ASmFmZlUZHAZyVbQAACVm
RmpUAAAAYAAAAAAAAAAA7BjAAAAAHBz0htgEk3FFhmWLHAqUklQEtwFlhlQRHA5Ekk2EklFp
ZlqcHB/k7bgG3IFZhqYUHBvk25IG6MFmlpIbHB5FLtgHNsFmRqkUHB0F+NgHtsFRhqULHB/1
thgHtsGohmUiHBz0htgEk3FFhmWLHAsSRhgEkm2ERpVKHA0CUkmE24GlZpkbHAqyU5IFLgGq
ZpgrHAliSS2FxgGmpogrHBsiSkwFLwGqhmgrHA3UkmwE3QFWhmQSHBNUmNgE3gFSRlQJAAAA
YAAAAAAAAAAABB/AAAAAHAgQAAAAAMAABAIBHAgQAAAAAMAABAIBHAgQAAAAAMAABAIBHBOb
huAB+MJJBJISHAqLRtgBtsKJhJkiHB+5JuABtsJqBKokHAr5vxgONwKkhigjHAlJP+ANvwKl
BmgbHAgQAAAAAMAABAIBHBsm/xgNxsGYhokbHBE5JcANwAFVBkABHA2ZRhgPxsFEhokLHA0J
huAONwGFBhgKHA5JBhgBuMGEhKITHB2bhxgB+MFERKIDHBQ7QAAANwGABCgK
--------------000201070409070905000407--
