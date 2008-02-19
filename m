Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0910.google.com ([209.85.198.188])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <eduardhc@gmail.com>) id 1JRVvd-0005GN-Ne
	for linux-dvb@linuxtv.org; Tue, 19 Feb 2008 18:06:50 +0100
Received: by rv-out-0910.google.com with SMTP id b22so1949566rvf.41
	for <linux-dvb@linuxtv.org>; Tue, 19 Feb 2008 09:06:34 -0800 (PST)
Message-ID: <617be8890802190906k44b2aba2r7a4302f801f72658@mail.gmail.com>
Date: Tue, 19 Feb 2008 18:06:34 +0100
From: "Eduard Huguet" <eduardhc@gmail.com>
To: "Matthias Schwarzott" <zzam@gentoo.org>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: [linux-dvb] Windows RegSpy data for Avermedia DVB-S Pro (A700)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1406471274=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1406471274==
Content-Type: multipart/alternative;
	boundary="----=_Part_8295_27776431.1203440794287"

------=_Part_8295_27776431.1203440794287
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,
    I just discovered that the RegSpy program mentioned in the wiki is not this
RegSpy <http://www.utils32.com/regspy.asp> but the one included with
D-Scaler... I was becoming crazy trying to read throught a zillion registry
changes that occur during AverTV programa execution, looking for something
related to "GPIO-whatever".... :D

Anyway, here's the info that RegSpy (the good one...) gives me about my card
in Windows:

3 states dumped

----------------------------------------------------------------------------------

SAA7133 Card - State 0:
SAA7134_I2S_OUTPUT_FORMAT:       00
(00000000)
SAA7134_I2S_OUTPUT_LEVEL:        00
(00000000)
SAA7134_TS_PARALLEL:             04 *
(00000100)
SAA7134_GPIO_GPMODE:             00040000   (00000000 00000100 00000000
00000000)
SAA7134_GPIO_GPSTATUS:           0046f200   (00000000 01000110 11110010
00000000)
SAA7134_ANALOG_IN_CTRL1:         84
(10000100)
SAA7133_ANALOG_IO_SELECT:        02
(00000010)
SAA7133_AUDIO_CLOCK_NOMINAL:     03187de7   (00000011 00011000 01111101
11100111)
SAA7133_PLL_CONTROL:             03
(00000011)
SAA7133_AUDIO_CLOCKS_PER_FIELD:  0001e000   (00000000 00000001 11100000
00000000)
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000
00000000)
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000
00000000)
SAA7134_VIDEO_PORT_CTRL8:        00
(00000000)
SAA7134_I2S_OUTPUT_SELECT:       00
(00000000)
SAA7134_I2S_AUDIO_OUTPUT:        10
(00010000)
SAA7134_TS_PARALLEL_SERIAL:      00 *
(00000000)
SAA7134_TS_SERIAL0:              00 *
(00000000)
SAA7134_TS_SERIAL1:              00
(00000000)
SAA7134_TS_DMA0:                 00 *
(00000000)
SAA7134_TS_DMA1:                 00 *
(00000000)
SAA7134_TS_DMA2:                 00
(00000000)
SAA7134_SPECIAL_MODE:            01
(00000001)


Changes: State 0 -> State 1:
SAA7134_TS_PARALLEL:             04       -> 64
(-00-----)
SAA7134_TS_PARALLEL_SERIAL:      00       -> b9
(0-000--0)
SAA7134_TS_SERIAL0:              00       -> 40
(-0------)
SAA7134_TS_DMA0:                 00       -> 35
(--00-0-0)
SAA7134_TS_DMA1:                 00       -> 01
(-------0)

5 changes


----------------------------------------------------------------------------------

SAA7133 Card - State 1:
SAA7134_I2S_OUTPUT_FORMAT:       00
(00000000)
SAA7134_I2S_OUTPUT_LEVEL:        00
(00000000)
SAA7134_TS_PARALLEL:             64
(01100100)                             (was: 04)
SAA7134_GPIO_GPMODE:             00040000   (00000000 00000100 00000000
00000000)
SAA7134_GPIO_GPSTATUS:           0046f200   (00000000 01000110 11110010
00000000)
SAA7134_ANALOG_IN_CTRL1:         84
(10000100)
SAA7133_ANALOG_IO_SELECT:        02
(00000010)
SAA7133_AUDIO_CLOCK_NOMINAL:     03187de7   (00000011 00011000 01111101
11100111)
SAA7133_PLL_CONTROL:             03
(00000011)
SAA7133_AUDIO_CLOCKS_PER_FIELD:  0001e000   (00000000 00000001 11100000
00000000)
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000
00000000)
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000
00000000)
SAA7134_VIDEO_PORT_CTRL8:        00
(00000000)
SAA7134_I2S_OUTPUT_SELECT:       00
(00000000)
SAA7134_I2S_AUDIO_OUTPUT:        10
(00010000)
SAA7134_TS_PARALLEL_SERIAL:      b9
(10111001)                             (was: 00)
SAA7134_TS_SERIAL0:              40
(01000000)                             (was: 00)
SAA7134_TS_SERIAL1:              00
(00000000)
SAA7134_TS_DMA0:                 35
(00110101)                             (was: 00)
SAA7134_TS_DMA1:                 01
(00000001)                             (was: 00)
SAA7134_TS_DMA2:                 00
(00000000)
SAA7134_SPECIAL_MODE:            01
(00000001)


Changes: State 1 -> Register Dump:

0 changes




I've tried using the GPIO status and mode listed here in the driver
initialisation (saa7134-cards.c file), but no luck. The card still doesn't
want to tune...

Regards,
  Eduard

------=_Part_8295_27776431.1203440794287
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi, <br>&nbsp;&nbsp;&nbsp; I just discovered that the RegSpy program mentio=
ned in the wiki is not <a href=3D"http://www.utils32.com/regspy.asp">this R=
egSpy</a> but the one included with D-Scaler... I was becoming crazy trying=
 to read throught a zillion registry changes that occur during AverTV progr=
ama execution, looking for something related to &quot;GPIO-whatever&quot;..=
.. :D<br>
<br>Anyway, here&#39;s the info that RegSpy (the good one...) gives me abou=
t my card in Windows:<br><br style=3D"font-family: courier new,monospace;">=
<span style=3D"font-family: courier new,monospace;">3 states dumped</span><=
br style=3D"font-family: courier new,monospace;">
<br style=3D"font-family: courier new,monospace;"><span style=3D"font-famil=
y: courier new,monospace;">------------------------------------------------=
----------------------------------</span><br style=3D"font-family: courier =
new,monospace;">
<br style=3D"font-family: courier new,monospace;"><span style=3D"font-famil=
y: courier new,monospace;">SAA7133 Card - State 0:</span><br style=3D"font-=
family: courier new,monospace;"><span style=3D"font-family: courier new,mon=
ospace;">SAA7134_I2S_OUTPUT_FORMAT:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 00&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (00000000)&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp; </span><br style=3D"font-family: courier new,monospace;">
<span style=3D"font-family: courier new,monospace;">SAA7134_I2S_OUTPUT_LEVE=
L:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 00&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; (00000000)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><br=
 style=3D"font-family: courier new,monospace;"><span style=3D"font-family: =
courier new,monospace;">SAA7134_TS_PARALLEL:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 04 *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; (00000100)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><br style=3D"fon=
t-family: courier new,monospace;">
<span style=3D"font-family: courier new,monospace;">SAA7134_GPIO_GPMODE:&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 00040=
000&nbsp;&nbsp; (00000000 00000100 00000000 00000000)&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
</span><br style=3D"font-family: courier new,monospace;"><span style=3D"fon=
t-family: courier new,monospace;">SAA7134_GPIO_GPSTATUS:&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0046f200&nbsp;&nbsp; (00000000 01=
000110 11110010 00000000)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><br style=3D"font-fam=
ily: courier new,monospace;">
<span style=3D"font-family: courier new,monospace;">SAA7134_ANALOG_IN_CTRL1=
:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 84&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; (10000100)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </spa=
n><br style=3D"font-family: courier new,monospace;"><span style=3D"font-fam=
ily: courier new,monospace;">SAA7133_ANALOG_IO_SELECT:&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp; 02&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (0=
0000010)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><br style=3D"font-family: =
courier new,monospace;">
<span style=3D"font-family: courier new,monospace;">SAA7133_AUDIO_CLOCK_NOM=
INAL:&nbsp;&nbsp;&nbsp;&nbsp; 03187de7&nbsp;&nbsp; (00000011 00011000 01111=
101 11100111)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><br style=3D"font-family: courier=
 new,monospace;"><span style=3D"font-family: courier new,monospace;">SAA713=
3_PLL_CONTROL:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; 03&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (00000011)&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><br style=3D"font-family: courier ne=
w,monospace;">
<span style=3D"font-family: courier new,monospace;">SAA7133_AUDIO_CLOCKS_PE=
R_FIELD:&nbsp; 0001e000&nbsp;&nbsp; (00000000 00000001 11100000 00000000)&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; </span><br style=3D"font-family: courier new,monospace;=
"><span style=3D"font-family: courier new,monospace;">SAA7134_VIDEO_PORT_CT=
RL0:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 00000000&nbsp;&nbsp; (000000=
00 00000000 00000000 00000000)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><br style=3D"fon=
t-family: courier new,monospace;">
<span style=3D"font-family: courier new,monospace;">SAA7134_VIDEO_PORT_CTRL=
4:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 00000000&nbsp;&nbsp; (00000000=
 00000000 00000000 00000000)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><br style=3D"font-=
family: courier new,monospace;"><span style=3D"font-family: courier new,mon=
ospace;">SAA7134_VIDEO_PORT_CTRL8:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
; 00&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (00000000)&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp; </span><br style=3D"font-family: courier new,monospac=
e;">
<span style=3D"font-family: courier new,monospace;">SAA7134_I2S_OUTPUT_SELE=
CT:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 00&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp; (00000000)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><br styl=
e=3D"font-family: courier new,monospace;"><span style=3D"font-family: couri=
er new,monospace;">SAA7134_I2S_AUDIO_OUTPUT:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; 10&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (00010000)&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><br style=3D"font-family: courier ne=
w,monospace;">
<span style=3D"font-family: courier new,monospace;">SAA7134_TS_PARALLEL_SER=
IAL:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 00 *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
 (00000000)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><br style=3D"font-famil=
y: courier new,monospace;"><span style=3D"font-family: courier new,monospac=
e;">SAA7134_TS_SERIAL0:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp; 00 *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (000000=
00)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><br style=3D"font-family: couri=
er new,monospace;">
<span style=3D"font-family: courier new,monospace;">SAA7134_TS_SERIAL1:&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
00&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (00000000)&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; </span><br style=3D"font-family: courier new,monospace;=
"><span style=3D"font-family: courier new,monospace;">SAA7134_TS_DMA0:&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp; 00 *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (00000000)&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp; </span><br style=3D"font-family: courier new,mon=
ospace;">
<span style=3D"font-family: courier new,monospace;">SAA7134_TS_DMA1:&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; 00 *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (00000000)&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp; </span><br style=3D"font-family: courier new,monos=
pace;"><span style=3D"font-family: courier new,monospace;">SAA7134_TS_DMA2:=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp; 00&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (0=
0000000)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><br style=3D"font-family: =
courier new,monospace;">
<span style=3D"font-family: courier new,monospace;">SAA7134_SPECIAL_MODE:&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 01&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (00000001)&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp; </span><br style=3D"font-family: courier new,monospace;"><br styl=
e=3D"font-family: courier new,monospace;">
<br style=3D"font-family: courier new,monospace;"><span style=3D"font-famil=
y: courier new,monospace;">Changes: State 0 -&gt; State 1:</span><br style=
=3D"font-family: courier new,monospace;"><span style=3D"font-family: courie=
r new,monospace;">SAA7134_TS_PARALLEL:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 04&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
-&gt; 64&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (-00-----)&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; </span><br style=3D"font-family: courier new,monospace;">
<span style=3D"font-family: courier new,monospace;">SAA7134_TS_PARALLEL_SER=
IAL:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 00&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; -=
&gt; b9&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (0-000--0)&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; </span><br style=3D"font-family: courier new,monospace;"><span style=3D=
"font-family: courier new,monospace;">SAA7134_TS_SERIAL0:&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 00&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp; -&gt; 40&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
 (-0------)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><br style=3D"font-family: courier new,=
monospace;">
<span style=3D"font-family: courier new,monospace;">SAA7134_TS_DMA0:&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; 00&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; -&gt; 35&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (--00-0-0)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><br style=
=3D"font-family: courier new,monospace;"><span style=3D"font-family: courie=
r new,monospace;">SAA7134_TS_DMA1:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 00&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; -&gt; 01&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (---=
----0)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp; </span><br style=3D"font-family: courier new,monos=
pace;">
<br style=3D"font-family: courier new,monospace;"><span style=3D"font-famil=
y: courier new,monospace;">5 changes</span><br style=3D"font-family: courie=
r new,monospace;"><br style=3D"font-family: courier new,monospace;"><br sty=
le=3D"font-family: courier new,monospace;">
<span style=3D"font-family: courier new,monospace;">-----------------------=
-----------------------------------------------------------</span><br style=
=3D"font-family: courier new,monospace;"><br style=3D"font-family: courier =
new,monospace;">
<span style=3D"font-family: courier new,monospace;">SAA7133 Card - State 1:=
</span><br style=3D"font-family: courier new,monospace;"><span style=3D"fon=
t-family: courier new,monospace;">SAA7134_I2S_OUTPUT_FORMAT:&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp; 00&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (0=
0000000)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><br style=3D"font-family: =
courier new,monospace;">
<span style=3D"font-family: courier new,monospace;">SAA7134_I2S_OUTPUT_LEVE=
L:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 00&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; (00000000)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><br=
 style=3D"font-family: courier new,monospace;"><span style=3D"font-family: =
courier new,monospace;">SAA7134_TS_PARALLEL:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 64&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp; (01100100)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (was: 04)&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; </span><br style=3D"font-family: courier new,monospace;">
<span style=3D"font-family: courier new,monospace;">SAA7134_GPIO_GPMODE:&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 00040=
000&nbsp;&nbsp; (00000000 00000100 00000000 00000000)&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
</span><br style=3D"font-family: courier new,monospace;"><span style=3D"fon=
t-family: courier new,monospace;">SAA7134_GPIO_GPSTATUS:&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0046f200&nbsp;&nbsp; (00000000 01=
000110 11110010 00000000)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><br style=3D"font-fam=
ily: courier new,monospace;">
<span style=3D"font-family: courier new,monospace;">SAA7134_ANALOG_IN_CTRL1=
:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 84&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; (10000100)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </spa=
n><br style=3D"font-family: courier new,monospace;"><span style=3D"font-fam=
ily: courier new,monospace;">SAA7133_ANALOG_IO_SELECT:&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp; 02&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (0=
0000010)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><br style=3D"font-family: =
courier new,monospace;">
<span style=3D"font-family: courier new,monospace;">SAA7133_AUDIO_CLOCK_NOM=
INAL:&nbsp;&nbsp;&nbsp;&nbsp; 03187de7&nbsp;&nbsp; (00000011 00011000 01111=
101 11100111)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><br style=3D"font-family: courier=
 new,monospace;"><span style=3D"font-family: courier new,monospace;">SAA713=
3_PLL_CONTROL:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; 03&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (00000011)&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><br style=3D"font-family: courier ne=
w,monospace;">
<span style=3D"font-family: courier new,monospace;">SAA7133_AUDIO_CLOCKS_PE=
R_FIELD:&nbsp; 0001e000&nbsp;&nbsp; (00000000 00000001 11100000 00000000)&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; </span><br style=3D"font-family: courier new,monospace;=
"><span style=3D"font-family: courier new,monospace;">SAA7134_VIDEO_PORT_CT=
RL0:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 00000000&nbsp;&nbsp; (000000=
00 00000000 00000000 00000000)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><br style=3D"fon=
t-family: courier new,monospace;">
<span style=3D"font-family: courier new,monospace;">SAA7134_VIDEO_PORT_CTRL=
4:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 00000000&nbsp;&nbsp; (00000000=
 00000000 00000000 00000000)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><br style=3D"font-=
family: courier new,monospace;"><span style=3D"font-family: courier new,mon=
ospace;">SAA7134_VIDEO_PORT_CTRL8:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
; 00&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (00000000)&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp; </span><br style=3D"font-family: courier new,monospac=
e;">
<span style=3D"font-family: courier new,monospace;">SAA7134_I2S_OUTPUT_SELE=
CT:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 00&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp; (00000000)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><br styl=
e=3D"font-family: courier new,monospace;"><span style=3D"font-family: couri=
er new,monospace;">SAA7134_I2S_AUDIO_OUTPUT:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; 10&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (00010000)&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><br style=3D"font-family: courier ne=
w,monospace;">
<span style=3D"font-family: courier new,monospace;">SAA7134_TS_PARALLEL_SER=
IAL:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; b9&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; (10111001)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (was: 00)&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; </span><br style=3D"font-family: courier new,monospace;"><span style=
=3D"font-family: courier new,monospace;">SAA7134_TS_SERIAL0:&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 40&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (01000000)&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (was: =
00)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><br style=3D"font-family: courier =
new,monospace;">
<span style=3D"font-family: courier new,monospace;">SAA7134_TS_SERIAL1:&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
00&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (00000000)&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; </span><br style=3D"font-family: courier new,monospace;=
"><span style=3D"font-family: courier new,monospace;">SAA7134_TS_DMA0:&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp; 35&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (001101=
01)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp; (was: 00)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><br st=
yle=3D"font-family: courier new,monospace;">
<span style=3D"font-family: courier new,monospace;">SAA7134_TS_DMA1:&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; 01&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (00000001=
)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; (was: 00)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><br styl=
e=3D"font-family: courier new,monospace;"><span style=3D"font-family: couri=
er new,monospace;">SAA7134_TS_DMA2:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 00&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (00000000)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
; </span><br style=3D"font-family: courier new,monospace;">
<span style=3D"font-family: courier new,monospace;">SAA7134_SPECIAL_MODE:&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 01&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (00000001)&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp; </span><br style=3D"font-family: courier new,monospace;"><br styl=
e=3D"font-family: courier new,monospace;">
<br style=3D"font-family: courier new,monospace;"><span style=3D"font-famil=
y: courier new,monospace;">Changes: State 1 -&gt; Register Dump:</span><br =
style=3D"font-family: courier new,monospace;"><br style=3D"font-family: cou=
rier new,monospace;">
<span style=3D"font-family: courier new,monospace;">0 changes</span><br sty=
le=3D"font-family: courier new,monospace;"><br style=3D"font-family: courie=
r new,monospace;"><br style=3D"font-family: courier new,monospace;"><br><br=
>I&#39;ve tried using the GPIO status and mode listed here in the driver in=
itialisation (saa7134-cards.c file), but no luck. The card still doesn&#39;=
t want to tune...<br>
<br>Regards, <br>&nbsp; Eduard<br><br><br>

------=_Part_8295_27776431.1203440794287--


--===============1406471274==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1406471274==--
