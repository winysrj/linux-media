Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bay0-omc2-s34.bay0.hotmail.com ([65.54.246.170])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <h_bergersen@hotmail.com>) id 1Kq9av-0000ze-VM
	for linux-dvb@linuxtv.org; Wed, 15 Oct 2008 18:51:36 +0200
Message-ID: <BAY109-W307DF75E4A987746AD9EE585300@phx.gbl>
From: Hans Bergersen <h_bergersen@hotmail.com>
To: <linux-dvb@linuxtv.org>
Date: Wed, 15 Oct 2008 18:50:56 +0200
MIME-Version: 1.0
Subject: [linux-dvb] Mantis 2033 dvb-tuning problems
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1996116447=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1996116447==
Content-Type: multipart/alternative;
	boundary="_b0263390-c7aa-4fab-889b-a79376e34f9b_"

--_b0263390-c7aa-4fab-889b-a79376e34f9b_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi=2C

I have got a Twinhan vp-2033 based card. I run Ubuntu 8.04. I have download=
ed the driver from http://jusst.de/hg/mantis and it compiled just fine. But=
 when i try to tune a channel the tuning fails. It is a newer card with the=
 tda10023 tuner but when the driver loads it uses the tda10021. What do I h=
ave to do to make it use the right tuner? Can i give some options when comp=
iling or when loading the module?

dmesg gives>
[  900.039621] found a VP-2033 PCI DVB-C device on (01:08.0)=2C
[  900.039623]     Mantis Rev 1 [1822:0008]=2C irq: 21=2C latency: 32
[  900.039626]     memory: 0xfdeff000=2C mmio: 0xf8a70000
[  900.043897]     MAC Address=3D[00:08:ca:1c:2c:8e]
[  900.043931] mantis_alloc_buffers (0): DMA=3D0x1fd00000 cpu=3D0xdfd00000 =
size=3D65536
[  900.043937] mantis_alloc_buffers (0): RISC=3D0x36105000 cpu=3D0xf6105000=
 size=3D1000
[  900.044799] DVB: registering new adapter (Mantis dvb adapter)
[  900.564320] mantis_frontend_init (0): Probing for CU1216 (DVB-C)
[  900.565719] TDA10021: i2c-addr =3D 0x0c=2C id =3D 0x7d
[  900.565723] mantis_frontend_init (0): found Philips CU1216 DVB-C fronten=
d (TDA10021) @ 0x0c
[  900.565725] mantis_frontend_init (0): Mantis DVB-C Philips CU1216 fronte=
nd attach success
[  900.565731] DVB: registering frontend 0 (Philips TDA10021 DVB-C)...
[  900.565769] mantis_ca_init (0): Registering EN50221 device
[  900.568719] mantis_ca_init (0): Registered EN50221 device
[  900.568730] mantis_hif_init (0): Adapter(0) Initializing Mantis Host Int=
erface

Try to tune gives>
hasse@hasse-desktop:~$ scan /usr/share/doc/dvb-utils/examples/scan/dvb-c/se=
-comhem
scanning /usr/share/doc/dvb-utils/examples/scan/dvb-c/se-comhem
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 362000000 6875000 0 3
>>> tune to: 362000000:INVERSION_AUTO:6875000:FEC_NONE:QAM_64
WARNING: >>> tuning failed!!!
>>> tune to: 362000000:INVERSION_AUTO:6875000:FEC_NONE:QAM_64 (tuning faile=
d)
WARNING: >>> tuning failed!!!
ERROR: initial tuning failed
dumping lists (0 services)
Done.

Any ideas?

Regards Hans

_________________________________________________________________
Senaste sportnyheterna & rykande f=E4rska resultat!
http://sport.msn.se/=

--_b0263390-c7aa-4fab-889b-a79376e34f9b_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<style>
.hmmessage P
{
margin:0px=3B
padding:0px
}
body.hmmessage
{
FONT-SIZE: 10pt=3B
FONT-FAMILY:Tahoma
}
</style>
</head>
<body class=3D'hmmessage'><div style=3D"text-align: left=3B">Hi=2C<br><br>I=
 have got a Twinhan vp-2033 based card. I run Ubuntu 8.04. I have downloade=
d the driver from <a href=3D"http://jusst.de/hg/mantis" target=3D"_blank">h=
ttp://jusst.de/hg/mantis</a> and it compiled just fine. But when i try to t=
une a channel the tuning fails. It is a newer card with the tda10023 tuner =
but when the driver loads it uses the tda10021. What do I have to do to mak=
e it use the right tuner? Can i give some options when compiling or when lo=
ading the module?<br><br>dmesg gives&gt=3B<br>[&nbsp=3B 900.039621] found a=
 VP-2033 PCI DVB-C device on (01:08.0)=2C<br>[&nbsp=3B 900.039623]&nbsp=3B&=
nbsp=3B&nbsp=3B&nbsp=3B Mantis Rev 1 [1822:0008]=2C irq: 21=2C latency: 32<=
br>[&nbsp=3B 900.039626]&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B memory: 0xfdeff000=
=2C mmio: 0xf8a70000<br>[&nbsp=3B 900.043897]&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B MAC Address=3D[00:08:ca:1c:2c:8e]<br>[&nbsp=3B 900.043931] mantis_alloc=
_buffers (0): DMA=3D0x1fd00000 cpu=3D0xdfd00000 size=3D65536<br>[&nbsp=3B 9=
00.043937] mantis_alloc_buffers (0): RISC=3D0x36105000 cpu=3D0xf6105000 siz=
e=3D1000<br>[&nbsp=3B 900.044799] DVB: registering new adapter (Mantis dvb =
adapter)<br>[&nbsp=3B 900.564320] mantis_frontend_init (0): Probing for CU1=
216 (DVB-C)<br>[&nbsp=3B 900.565719] TDA10021: i2c-addr =3D 0x0c=2C id =3D =
0x7d<br>[&nbsp=3B 900.565723] mantis_frontend_init (0): found Philips CU121=
6 DVB-C frontend (TDA10021) @ 0x0c<br>[&nbsp=3B 900.565725] mantis_frontend=
_init (0): Mantis DVB-C Philips CU1216 frontend attach success<br>[&nbsp=3B=
 900.565731] DVB: registering frontend 0 (Philips TDA10021 DVB-C)...<br>[&n=
bsp=3B 900.565769] mantis_ca_init (0): Registering EN50221 device<br>[&nbsp=
=3B 900.568719] mantis_ca_init (0): Registered EN50221 device<br>[&nbsp=3B =
900.568730] mantis_hif_init (0): Adapter(0) Initializing Mantis Host Interf=
ace<br><br>Try to tune gives&gt=3B<br>hasse@hasse-desktop:~$ scan /usr/shar=
e/doc/dvb-utils/examples/scan/dvb-c/se-comhem<br>scanning /usr/share/doc/dv=
b-utils/examples/scan/dvb-c/se-comhem<br>using '/dev/dvb/adapter0/frontend0=
' and '/dev/dvb/adapter0/demux0'<br>initial transponder 362000000 6875000 0=
 3<br>&gt=3B&gt=3B&gt=3B tune to: 362000000:INVERSION_AUTO:6875000:FEC_NONE=
:QAM_64<br>WARNING: &gt=3B&gt=3B&gt=3B tuning failed!!!<br>&gt=3B&gt=3B&gt=
=3B tune to: 362000000:INVERSION_AUTO:6875000:FEC_NONE:QAM_64 (tuning faile=
d)<br>WARNING: &gt=3B&gt=3B&gt=3B tuning failed!!!<br>ERROR: initial tuning=
 failed<br>dumping lists (0 services)<br>Done.<br><br>Any ideas?<br><br>Reg=
ards Hans<br></div><br /><hr />Hitta n=E5gon att mysa med i h=F6strusket! <=
a href=3D'http://match.se.msn.com/channel/index.aspx?trackingid=3D1002952' =
target=3D'_new'>MSN Dejting</a></body>
</html>=

--_b0263390-c7aa-4fab-889b-a79376e34f9b_--


--===============1996116447==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1996116447==--
