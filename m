Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail.icp-qv1-irony-out2.iinet.net.au ([203.59.1.151])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sonofzev@iinet.net.au>) id 1LHTrn-0004lR-IN
	for linux-dvb@linuxtv.org; Tue, 30 Dec 2008 02:57:58 +0100
MIME-Version: 1.0
From: "sonofzev@iinet.net.au" <sonofzev@iinet.net.au>
To: linux-dvb@linuxtv.org
Date: Tue, 30 Dec 2008 10:57:44 +0900
Message-Id: <54510.1230602264@iinet.net.au>
Subject: [linux-dvb] kernel 2.6.28 Fusion Dual Express only one tuner
	registering
Reply-To: sonofzev@iinet.net.au
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1848812318=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1848812318==
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="utf-8"

<HTML>
HI All<BR>
<BR>
I've just updated to 2.6.28 and have noticed something happening. Only one =
tuner appears to be registering.&nbsp; I have done this remotely so can't c=
heck the actual TV output, but noticed only 2 adaptors under /dev/dvb inste=
ad of 3 (I also have a Fusion Lite in the system)<BR>
<BR>
I previously have been using the mercurial repository for the DVB drivers b=
ut this time, as I noticed my card (DViCO FusionHDTV DVB-T Dual Express) wa=
s supported, went for the in-kernel drivers.. <BR>
<BR>
I am wondering if I am doing something wrong with kernel config or if there=
 is an issue with the in-kernel driver.. There have been no hardware change=
s. <BR>
<BR>
Here is the output from "dmesg | grep cx23885" <BR>
<BR>
media1 conf.d # dmesg | grep cx23885<BR>
cx23885 driver version 0.0.1 loaded<BR>
cx23885 0000:03:00.0: PCI INT A -&gt; Link[APC1] -&gt; GSI 16 (level, low) =
-&gt; IRQ 16<BR>
CORE cx23885[0]: subsystem: 18ac:db78, board: DViCO FusionHDTV DVB-T Dual E=
xpress [card=3D11,autodetected]<BR>
ir-kbd-i2c: i2c IR (FusionHDTV) detected at i2c-3/3-006b/ir0 [cx23885[0]]<B=
R>
cx23885_dvb_register() allocating 1 frontend(s)<BR>
cx23885[0]: cx23885 based dvb card<BR>
cx23885[0]: frontend initialization failed<BR>
cx23885_dvb_register() dvb_register failed err =3D -1<BR>
cx23885_dev_setup() Failed to register dvb adapters on VID_B<BR>
cx23885_dvb_register() allocating 1 frontend(s)<BR>
cx23885[0]: cx23885 based dvb card<BR>
DVB: registering new adapter (cx23885[0])<BR>
cx23885_dev_checkrevision() Hardware revision =3D 0xb0<BR>
cx23885[0]/0: found at 0000:03:00.0, rev: 2, irq: 16, latency: 0, mmio: 0xf=
d600000<BR>
cx23885 0000:03:00.0: setting latency timer to 64<BR>
<BR>
Here is the output from "dmesg | grep xc2028"&nbsp; the only thing of note =
being only one tuner is registered<BR>
xc2028 4-0061: creating new instance<BR>
xc2028 4-0061: type set to XCeive xc2028/xc3028 tuner<BR>
xc2028 4-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 =
firmware, ver 2.7<BR>
xc2028 4-0061: Loading firmware for type=3DBASE F8MHZ (3), id 0000000000000=
000.<BR>
xc2028 4-0061: Loading firmware for type=3DD2633 DTV7 (90), id 000000000000=
0000.<BR>
xc2028 4-0061: Loading SCODE for type=3DDTV6 QAM DTV7 DTV78 DTV8 ZARLINK456=
 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.<BR>
<BR>
<BR>
&nbsp;<BR>
<BR>
<BR>
 </HTML>
<BR>=


--===============1848812318==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1848812318==--
