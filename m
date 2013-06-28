Return-path: <linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.72)
	(envelope-from <andre8525@hotmail.com>) id 1UsYs1-0007yq-09
	for linux-dvb@linuxtv.org; Fri, 28 Jun 2013 15:37:49 +0200
Received: from dub0-omc3-s10.dub0.hotmail.com ([157.55.2.19])
	by mail.tu-berlin.de (exim-4.72/mailfrontend-6) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1UsYrz-0000fP-3v; Fri, 28 Jun 2013 15:37:48 +0200
Message-ID: <DUB112-W32D548FE8BC315C702CB33B9760@phx.gbl>
From: Andrew Andonopoulos <andre8525@hotmail.com>
To: "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
Date: Fri, 28 Jun 2013 16:37:45 +0300
MIME-Version: 1.0
Subject: [linux-dvb] DVB-S and DVB-T card
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1610051763=="
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1610051763==
Content-Type: multipart/alternative;
	boundary="_fa2c0544-8f53-4113-8b11-7b5f1ef79f99_"

--_fa2c0544-8f53-4113-8b11-7b5f1ef79f99_
Content-Type: text/plain; charset="iso-8859-7"
Content-Transfer-Encoding: quoted-printable

Hi to all=2C
I have a WinTV-HVR-4400-HD model 1278 card installed in ubuntu machine. The=
 info for the machine and the card are the following:
Uname -a3.5.0-23-generic #35~precise1-Ubuntu SMP Fri Jan 25 17:15:33 UTC 20=
13 i686 i686 i386 GNU/Linux
Uname -r3.5.0-23-generic
lspci -v05:00.0 Multimedia video controller: Conexant Systems=2C Inc. CX238=
87/8 PCIe Broadcast Audio and Video Decoder with 3D Comb (rev 04)	Subsystem=
: Hauppauge computer works Inc. WinTV-HVR-4400-HD model 1278	Flags: bus mas=
ter=2C fast devsel=2C latency 0=2C IRQ 16	Memory at d0000000 (64-bit=2C non=
-prefetchable) [size=3D2M]	Capabilities: [40] Express Endpoint=2C MSI 00	Ca=
pabilities: [80] Power Management version 3	Capabilities: [90] Vital Produc=
t Data	Capabilities: [a0] MSI: Enable- Count=3D1/1 Maskable- 64bit+	Capabil=
ities: [100] Advanced Error Reporting	Capabilities: [200] Virtual Channel	K=
ernel driver in use: cx23885	Kernel modules: cx23885

dmesg 168.028877] i2c i2c-7: tda10071: found a 'NXP TDA10071' in cold state=
=2C will try to load a firmware[  168.028881] i2c i2c-7: tda10071: download=
ing firmware from file 'dvb-fe-tda10071.fw'[  172.563465] i2c i2c-7: tda100=
71: firmware version 1.21.31.2[  172.563468] i2c i2c-7: tda10071: found a '=
NXP TDA10071' in warm state
and
[   11.710725] cx23885_dvb_register() allocating 1 frontend(s)[   11.710931=
] cx23885[0]: cx23885 based dvb card[  168.028881] i2c i2c-7: tda10071: dow=
nloading firmware from file 'dvb-fe-tda10071.fw'

I also installed dvBlast and dvb-apps to be able to scan and stream. When i=
 am trying to scan i get the following message:
WARNING: frontend type (QPSK) is not compatible with requested tuning type =
(OFDM)
Looks like the card is using DVB-S but the scan DVB-T. Unfortunately i have=
 1 adapter only:
root@andrew-Lenovo:/usr/share/dvb/dvb-t# ls -l /dev/dvb/total 0drwxr-xr-x 2=
 root root 120 Jun 28 13:56 adapter0
and 1 frontend:
root@andrew-Lenovo:/usr/share/dvb/dvb-t# ls -l /dev/dvb/adapter0/total 0crw=
-rw---- 1 root video 212=2C 1 Jun 28 13:56 demux0crw-rw---- 1 root video 21=
2=2C 2 Jun 28 13:56 dvr0crw-rw---- 1 root video 212=2C 0 Jun 28 13:56 front=
end0crw-rw---- 1 root video 212=2C 3 Jun 28 13:56 net0



Any idea how i can resolve it?=20
Thank you for your time=2CAndrew


 		 	   		  =

--_fa2c0544-8f53-4113-8b11-7b5f1ef79f99_
Content-Type: text/html; charset="iso-8859-7"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<style><!--
.hmmessage P
{
margin:0px=3B
padding:0px
}
body.hmmessage
{
font-size: 12pt=3B
font-family:Calibri
}
--></style></head>
<body class=3D'hmmessage'><div dir=3D'ltr'>Hi to all=2C<div><br></div><div>=
I have a&nbsp=3BWinTV-HVR-4400-HD model 1278 card installed in ubuntu machi=
ne. The info for the machine and the card are the following:</div><div><br>=
</div><div>Uname -a</div><div>3.5.0-23-generic #35~precise1-Ubuntu SMP Fri =
Jan 25 17:15:33 UTC 2013 i686 i686 i386 GNU/Linux</div><div><br></div><div>=
Uname -r</div><div>3.5.0-23-generic</div><div><br></div><div>lspci -v</div>=
<div><div>05:00.0 Multimedia video controller: Conexant Systems=2C Inc. CX2=
3887/8 PCIe Broadcast Audio and Video Decoder with 3D Comb (rev 04)</div><d=
iv><span class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>Subsyst=
em: Hauppauge computer works Inc. WinTV-HVR-4400-HD model 1278</div><div><s=
pan class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>Flags: bus m=
aster=2C fast devsel=2C latency 0=2C IRQ 16</div><div><span class=3D"Apple-=
tab-span" style=3D"white-space:pre">	</span>Memory at d0000000 (64-bit=2C n=
on-prefetchable) [size=3D2M]</div><div><span class=3D"Apple-tab-span" style=
=3D"white-space:pre">	</span>Capabilities: [40] Express Endpoint=2C MSI 00<=
/div><div><span class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>=
Capabilities: [80] Power Management version 3</div><div><span class=3D"Appl=
e-tab-span" style=3D"white-space:pre">	</span>Capabilities: [90] Vital Prod=
uct Data</div><div><span class=3D"Apple-tab-span" style=3D"white-space:pre"=
>	</span>Capabilities: [a0] MSI: Enable- Count=3D1/1 Maskable- 64bit+</div>=
<div><span class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>Capab=
ilities: [100] Advanced Error Reporting</div><div><span class=3D"Apple-tab-=
span" style=3D"white-space:pre">	</span>Capabilities: [200] Virtual Channel=
</div><div><span class=3D"Apple-tab-span" style=3D"white-space:pre">	</span=
>Kernel driver in use: cx23885</div><div><span class=3D"Apple-tab-span" sty=
le=3D"white-space:pre">	</span>Kernel modules: cx23885</div></div><div><br>=
</div><div><br></div><div>dmesg</div><div><div>&nbsp=3B168.028877] i2c i2c-=
7: tda10071: found a 'NXP TDA10071' in cold state=2C will try to load a fir=
mware</div><div>[ &nbsp=3B168.028881] i2c i2c-7: tda10071: downloading firm=
ware from file 'dvb-fe-tda10071.fw'</div><div>[ &nbsp=3B172.563465] i2c i2c=
-7: tda10071: firmware version 1.21.31.2</div><div>[ &nbsp=3B172.563468] i2=
c i2c-7: tda10071: found a 'NXP TDA10071' in warm state</div></div><div><br=
></div><div>and</div><div><br></div><div><div>[ &nbsp=3B 11.710725] cx23885=
_dvb_register() allocating 1 frontend(s)</div><div>[ &nbsp=3B 11.710931] cx=
23885[0]: cx23885 based dvb card</div><div>[ &nbsp=3B168.028881] i2c i2c-7:=
 tda10071: downloading firmware from file 'dvb-fe-tda10071.fw'</div></div><=
div><br></div><div><br></div><div>I also installed dvBlast and dvb-apps to =
be able to scan and stream. When i am trying to scan i get the following me=
ssage:</div><div><br></div><div>WARNING: frontend type (QPSK) is not compat=
ible with requested tuning type (OFDM)</div><div><br></div><div>Looks like =
the card is using DVB-S but the scan DVB-T. Unfortunately i have 1 adapter =
only:</div><div><div><br></div><div>root@andrew-Lenovo:/usr/share/dvb/dvb-t=
# ls -l /dev/dvb/</div><div>total 0</div><div>drwxr-xr-x 2 root root 120 Ju=
n 28 13:56 adapter0</div></div><div><br></div><div>and 1 frontend:</div><di=
v><br></div><div><div>root@andrew-Lenovo:/usr/share/dvb/dvb-t# ls -l /dev/d=
vb/adapter0/</div><div>total 0</div><div>crw-rw---- 1 root video 212=2C 1 J=
un 28 13:56 demux0</div><div>crw-rw---- 1 root video 212=2C 2 Jun 28 13:56 =
dvr0</div><div>crw-rw---- 1 root video 212=2C 0 Jun 28 13:56 frontend0</div=
><div>crw-rw---- 1 root video 212=2C 3 Jun 28 13:56 net0</div></div><div><b=
r></div><div><br></div><div><br></div><div><br></div><div>Any idea how i ca=
n resolve it?&nbsp=3B</div><div><br></div><div>Thank you for your time=2C</=
div><div>Andrew</div><div><br></div><div><br></div><div><br></div> 		 	   	=
	  </div></body>
</html>=

--_fa2c0544-8f53-4113-8b11-7b5f1ef79f99_--


--===============1610051763==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1610051763==--
