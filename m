Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.153])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <scrauny@gmail.com>) id 1MTfCV-00019Y-3X
	for linux-dvb@linuxtv.org; Wed, 22 Jul 2009 19:01:55 +0200
Received: by fg-out-1718.google.com with SMTP id 13so98470fge.2
	for <linux-dvb@linuxtv.org>; Wed, 22 Jul 2009 10:01:51 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 22 Jul 2009 18:01:50 +0100
Message-ID: <79fc70d20907221001v3a56a142v445d9167197ecf0d@mail.gmail.com>
From: Shaun Murdoch <scrauny@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Help Request: DM1105 STV0299 DVB-S PCI - Unable to tune
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1152112116=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1152112116==
Content-Type: multipart/alternative; boundary=000e0cd24eccce4a87046f4e5366

--000e0cd24eccce4a87046f4e5366
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi everyone,
First post so please be gentle :-)

I was wondering if anyone can help me please - I am trying to get a DVB-S
PCI card working with Linux (Ubuntu 9.04). So far I can get the card
recognised by Linux, but it won't tune - Kaffeine does tell me that there i=
s
95% signal and 80% SNR, and I am using the same frequencies etc that a
standard Sky box uses.

The card is very common on eBay so I am sure there are plenty people who
have tried this / would want this working.

Some details that I hope will help someone who knows more than I do about
this!

The card is one of these:
http://cgi.ebay.co.uk/DVB-S-Satellite-TV-Tuner-Video-Capture-PCI-Card-Remot=
e_W0QQitemZ130314645048QQcmdZViewItemQQptZUK_Computing_Computer_Components_=
Graphics_Video_TV_Cards_TW?hash=3Ditem1e575bae38&_trksid=3Dp3286.c0.m14&_tr=
kparms=3D65:12|66:2|39:1|72:1690|293:1|294:50

lspci:
03:09.0 Ethernet controller: Device 195d:1105 (rev 10)

My dmesg output - looks ok?:

$ dmesg | grep DVB
[   12.174738] DVB: registering new adapter (dm1105)
[   12.839501] DVB: registering adapter 0 frontend 0 (ST STV0299 DVB-S)...
[   12.839633] input: DVB on-card IR receiver as
/devices/pci0000:00/0000:00:1e.0/0000:03:09.0/input/input


My output from scan -* the problem*:

$ sudo scan -vvvvvv /usr/share/dvb/dvb-s/Astra-28.2E
scanning /usr/share/dvb/dvb-s/Astra-28.2E
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'

>>> tune to: 11778:v:0:27500
DiSEqC: switch pos 0, 13V, hiband (index 2)
diseqc_send_msg:56: DiSEqC: e0 10 38 f1 00 00
DVB-S IF freq is 1178000
>>> tuning status =3D=3D 0x03
>>> tuning status =3D=3D 0x03
>>> tuning status =3D=3D 0x03
>>> tuning status =3D=3D 0x03
>>> tuning status =3D=3D 0x03
>>> tuning status =3D=3D 0x03
>>> tuning status =3D=3D 0x03
>>> tuning status =3D=3D 0x03
>>> tuning status =3D=3D 0x03
>>> tuning status =3D=3D 0x03
WARNING: >>> tuning failed!!!

*This is the correct satellite for my location (south UK), I believe. Have
tried plenty. Nothing locks.*

I'm using the latest liplianin drivers - did a mercurial checkout and build
today:

$ modinfo dm1105
filename:
/lib/modules/2.6.28-13-server/kernel/drivers/media/dvb/dm1105/dm1105.ko
license:        GPL
description:    SDMC DM1105 DVB driver
author:         Igor M. Liplianin <liplianin@me.by>
srcversion:     46C1B3C3627D1937F75D732
alias:          pci:v0000195Dd00001105sv*sd*bc*sc*i*
alias:          pci:v0000109Fd0000036Fsv*sd*bc*sc*i*
depends:        ir-common,dvb-core
vermagic:       2.6.28-13-server SMP mod_unload modversions
parm:           card:card type (array of int)
parm:           ir_debug:enable debugging information for IR decoding (int)
parm:           adapter_nr:DVB adapter numbers (array of short)

Have also tried the latest v4l-dvb drivers and get exactly the same tuning
problems.

Finally, dvbtune appears to say I have signal but cannot lock:

$ sudo dvbtune -f 1177800 -s 27500 -p v -m -tone 1 -vvvvvvvvvvv
[sudo] password for shaun:
Using DVB card "ST STV0299 DVB-S"
tuning DVB-S to L-Band:0, Pol:V Srate=3D27500000, 22kHz=3Don
polling....
Getting frontend event
FE_STATUS:
polling....
Getting frontend event
FE_STATUS: FE_HAS_SIGNAL FE_HAS_CARRIER FE_HAS_VITERBI
polling....
Getting frontend event
FE_STATUS: FE_HAS_SIGNAL FE_HAS_CARRIER
polling....
Getting frontend event
FE_STATUS: FE_HAS_SIGNAL FE_HAS_CARRIER FE_HAS_VITERBI
polling....
Getting frontend event
FE_STATUS: FE_HAS_SIGNAL FE_HAS_CARRIER
polling....
Getting frontend event
FE_STATUS: *FE_HAS_SIGNAL FE_HAS_CARRIER* FE_HAS_VITERBI
polling....
Getting frontend event
FE_STATUS: FE_HAS_SIGNAL FE_HAS_CARRIER


So I am thinking that this could be a driver issue? If the card has good
signal and SNR in Kaffeine, and dvbtune says it has signal and carrier - bu=
t
cannot lock?

Please can someone help me debug this?

Thanks a lot!
Shaun

--000e0cd24eccce4a87046f4e5366
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi everyone,<div><br></div><div>First post so please be gentle :-)</div><di=
v><br></div><div>I was wondering if anyone can help me please - I am trying=
 to get a DVB-S PCI card working with Linux (Ubuntu 9.04). So far I can get=
 the card recognised by Linux, but it won&#39;t tune - Kaffeine does tell m=
e that there is 95% signal and 80% SNR, and I am using the same frequencies=
 etc that a standard Sky box uses.</div>
<div><br></div><div>The card is very common on eBay so I am sure there are =
plenty people who have tried this / would want this working.</div><div><br>=
</div><div>Some details that I hope will help someone who knows more than I=
 do about this!</div>
<div><br></div><div>The card is one of these:</div><div><span class=3D"Appl=
e-style-span" style=3D"font-size: 10px; "><a href=3D"http://cgi.ebay.co.uk/=
DVB-S-Satellite-TV-Tuner-Video-Capture-PCI-Card-Remote_W0QQitemZ13031464504=
8QQcmdZViewItemQQptZUK_Computing_Computer_Components_Graphics_Video_TV_Card=
s_TW?hash=3Ditem1e575bae38&amp;_trksid=3Dp3286.c0.m14&amp;_trkparms=3D65:12=
|66:2|39:1|72:1690|293:1|294:50">http://cgi.ebay.co.uk/DVB-S-Satellite-TV-T=
uner-Video-Capture-PCI-Card-Remote_W0QQitemZ130314645048QQcmdZViewItemQQptZ=
UK_Computing_Computer_Components_Graphics_Video_TV_Cards_TW?hash=3Ditem1e57=
5bae38&amp;_trksid=3Dp3286.c0.m14&amp;_trkparms=3D65:12|66:2|39:1|72:1690|2=
93:1|294:50</a></span></div>
<div><br></div><div>lspci:</div><div><div><font class=3D"Apple-style-span" =
face=3D"&#39;courier new&#39;, monospace"><span class=3D"Apple-style-span" =
style=3D"font-size: small;">03:09.0 Ethernet controller: Device 195d:1105 (=
rev 10)</span></font></div>
<div><br></div></div><div>My dmesg output - looks ok?:</div><div><span clas=
s=3D"Apple-style-span" style=3D"font-family: Verdana; font-size: 12px; "><p=
re class=3D"alt2" dir=3D"ltr" style=3D"background-image: initial; backgroun=
d-repeat: initial; background-attachment: initial; -webkit-background-clip:=
 initial; -webkit-background-origin: initial; background-color: rgb(255, 25=
5, 255); color: rgb(0, 0, 0); margin-top: 0px; margin-right: 0px; margin-bo=
ttom: 0px; margin-left: 0px; padding-top: 6px; padding-right: 6px; padding-=
bottom: 6px; padding-left: 6px; border-top-width: 1px; border-right-width: =
1px; border-bottom-width: 1px; border-left-width: 1px; border-top-style: in=
set; border-right-style: inset; border-bottom-style: inset; border-left-sty=
le: inset; border-color: initial; width: 640px; height: 82px; text-align: l=
eft; overflow-x: auto; overflow-y: auto; background-position: initial initi=
al; ">
$ dmesg | grep DVB
[   12.174738] DVB: registering new adapter (dm1105)
[   12.839501] DVB: registering adapter 0 frontend 0 (ST STV0299 DVB-S)...
[   12.839633] input: DVB on-card IR receiver as /devices/pci0000:00/0000:0=
0:1e.0/0000:03:09.0/input/input</pre></span></div><div><br></div><div>My ou=
tput from scan -<b> the problem</b>:</div><div><span class=3D"Apple-style-s=
pan" style=3D"font-family: Verdana; font-size: 12px; "><pre class=3D"alt2" =
dir=3D"ltr" style=3D"background-image: initial; background-repeat: initial;=
 background-attachment: initial; -webkit-background-clip: initial; -webkit-=
background-origin: initial; background-color: rgb(255, 255, 255); color: rg=
b(0, 0, 0); margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-=
left: 0px; padding-top: 6px; padding-right: 6px; padding-bottom: 6px; paddi=
ng-left: 6px; border-top-width: 1px; border-right-width: 1px; border-bottom=
-width: 1px; border-left-width: 1px; border-top-style: inset; border-right-=
style: inset; border-bottom-style: inset; border-left-style: inset; border-=
color: initial; width: 640px; height: 322px; text-align: left; overflow-x: =
auto; overflow-y: auto; background-position: initial initial; ">
$ sudo scan -vvvvvv /usr/share/dvb/dvb-s/Astra-28.2E
scanning /usr/share/dvb/dvb-s/Astra-28.2E
using &#39;/dev/dvb/adapter0/frontend0&#39; and &#39;/dev/dvb/adapter0/demu=
x0&#39;

&gt;&gt;&gt; tune to: 11778:v:0:27500
DiSEqC: switch pos 0, 13V, hiband (index 2)
diseqc_send_msg:56: DiSEqC: e0 10 38 f1 00 00
DVB-S IF freq is 1178000
&gt;&gt;&gt; tuning status =3D=3D 0x03
&gt;&gt;&gt; tuning status =3D=3D 0x03
&gt;&gt;&gt; tuning status =3D=3D 0x03
&gt;&gt;&gt; tuning status =3D=3D 0x03
&gt;&gt;&gt; tuning status =3D=3D 0x03
&gt;&gt;&gt; tuning status =3D=3D 0x03
&gt;&gt;&gt; tuning status =3D=3D 0x03
&gt;&gt;&gt; tuning status =3D=3D 0x03
&gt;&gt;&gt; tuning status =3D=3D 0x03
&gt;&gt;&gt; tuning status =3D=3D 0x03
WARNING: &gt;&gt;&gt; tuning failed!!!</pre></span></div><div><i>This is th=
e correct satellite for my location (south UK), I believe. Have tried plent=
y. Nothing locks.</i></div><div><br></div><div>I&#39;m using the latest lip=
lianin drivers - did a mercurial checkout and build today:</div>
<div><span class=3D"Apple-style-span" style=3D"font-family: Verdana; font-s=
ize: 12px; "><pre class=3D"alt2" dir=3D"ltr" style=3D"background-image: ini=
tial; background-repeat: initial; background-attachment: initial; -webkit-b=
ackground-clip: initial; -webkit-background-origin: initial; background-col=
or: rgb(255, 255, 255); color: rgb(0, 0, 0); margin-top: 0px; margin-right:=
 0px; margin-bottom: 0px; margin-left: 0px; padding-top: 6px; padding-right=
: 6px; padding-bottom: 6px; padding-left: 6px; border-top-width: 1px; borde=
r-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; borde=
r-top-style: inset; border-right-style: inset; border-bottom-style: inset; =
border-left-style: inset; border-color: initial; width: 640px; height: 226p=
x; text-align: left; overflow-x: auto; overflow-y: auto; background-positio=
n: initial initial; ">
$ modinfo dm1105
filename:       /lib/modules/2.6.28-13-server/kernel/drivers/media/dvb/dm11=
05/dm1105.ko
license:        GPL
description:    SDMC DM1105 DVB driver
author:         Igor M. Liplianin &lt;<a href=3D"mailto:liplianin@me.by">li=
plianin@me.by</a>&gt;
srcversion:     46C1B3C3627D1937F75D732
alias:          pci:v0000195Dd00001105sv*sd*bc*sc*i*
alias:          pci:v0000109Fd0000036Fsv*sd*bc*sc*i*
depends:        ir-common,dvb-core
vermagic:       2.6.28-13-server SMP mod_unload modversions
parm:           card:card type (array of int)
parm:           ir_debug:enable debugging information for IR decoding (int)
parm:           adapter_nr:DVB adapter numbers (array of short)</pre></span=
></div><div>Have also tried the latest v4l-dvb drivers and get exactly the =
same tuning problems.</div><div><br></div><div>Finally, dvbtune appears to =
say I have signal but cannot lock:</div>
<div><span class=3D"Apple-style-span" style=3D"font-family: Verdana; font-s=
ize: 12px; "><pre class=3D"alt2" dir=3D"ltr" style=3D"background-image: ini=
tial; background-repeat: initial; background-attachment: initial; -webkit-b=
ackground-clip: initial; -webkit-background-origin: initial; background-col=
or: rgb(255, 255, 255); color: rgb(0, 0, 0); margin-top: 0px; margin-right:=
 0px; margin-bottom: 0px; margin-left: 0px; padding-top: 6px; padding-right=
: 6px; padding-bottom: 6px; padding-left: 6px; border-top-width: 1px; borde=
r-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; borde=
r-top-style: inset; border-right-style: inset; border-bottom-style: inset; =
border-left-style: inset; border-color: initial; width: 640px; height: 418p=
x; text-align: left; overflow-x: auto; overflow-y: auto; background-positio=
n: initial initial; ">
$ sudo dvbtune -f 1177800 -s 27500 -p v -m -tone 1 -vvvvvvvvvvv
[sudo] password for shaun:
Using DVB card &quot;ST STV0299 DVB-S&quot;
tuning DVB-S to L-Band:0, Pol:V Srate=3D27500000, 22kHz=3Don
polling....
Getting frontend event
FE_STATUS:
polling....
Getting frontend event
FE_STATUS: FE_HAS_SIGNAL FE_HAS_CARRIER FE_HAS_VITERBI
polling....
Getting frontend event
FE_STATUS: FE_HAS_SIGNAL FE_HAS_CARRIER
polling....
Getting frontend event
FE_STATUS: FE_HAS_SIGNAL FE_HAS_CARRIER FE_HAS_VITERBI
polling....
Getting frontend event
FE_STATUS: FE_HAS_SIGNAL FE_HAS_CARRIER
polling....
Getting frontend event
FE_STATUS: <b>FE_HAS_SIGNAL FE_HAS_CARRIER</b> FE_HAS_VITERBI
polling....
Getting frontend event
FE_STATUS: FE_HAS_SIGNAL FE_HAS_CARRIER</pre></span></div><div><br></div><d=
iv>So I am thinking that this could be a driver issue? If the card has good=
 signal and SNR in Kaffeine, and dvbtune says it has signal and carrier - b=
ut cannot lock?</div>
<div><br></div><div>Please can someone help me debug this?</div><div><br></=
div><div>Thanks a lot!</div><div>Shaun</div><div><br></div><div><br></div><=
div><br></div><div><br></div><div><br></div><div><br></div><div><br></div>

--000e0cd24eccce4a87046f4e5366--


--===============1152112116==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1152112116==--
