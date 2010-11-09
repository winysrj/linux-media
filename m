Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <mvreijn@gmail.com>) id 1PFpLG-0005z4-5M
	for linux-dvb@linuxtv.org; Tue, 09 Nov 2010 15:38:34 +0100
Received: from mail-yw0-f54.google.com ([209.85.213.54])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-c) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1PFpLF-0004ji-5D; Tue, 09 Nov 2010 15:38:33 +0100
Received: by ywg4 with SMTP id 4so912138ywg.41
	for <linux-dvb@linuxtv.org>; Tue, 09 Nov 2010 06:38:31 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 9 Nov 2010 15:38:31 +0100
Message-ID: <AANLkTin=npFSbftv-ut_Cv-iZDYw1Dqrj=im5VG7G=CR@mail.gmail.com>
From: Mark van Reijn <mvreijn@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Trying to get unlisted Terratec Cinergy to work
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0010158688=="
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

--===============0010158688==
Content-Type: multipart/alternative; boundary=0016361e7b44d6288504949fb102

--0016361e7b44d6288504949fb102
Content-Type: text/plain; charset=ISO-8859-1

Hi everyone,

I have been trying to get my "Terratec Cinergy HT USB PVR" tuner to work (on
DVB-T). This is a hybrid analog/dvb-t tuner with a hardware MPEG encoder.
Inserting the device does not cause any driver to respond and load. The USB
ID is "0ccd:006b". The PID is not listed in "dvb-usb-ids.h".

After quite a bit of research I have a lot of information on the device. I
also opened it up to check the actual chip versions (took me back to
slackware 3 and graphics cards).
The various components are:
* Cypress CY7C68013A FX2 USB controller
* Intel CE6353 demodulator (should be the same as Zarlink ZL10353)
* XCeive XC3028 tuner
(* Conexant CX25843 a/v decoder)
(* Conexant CX23416 MPEG encoder)

The last two should not be really necessary from what I have learned.

>From what I can see, all components are supported in one way or another.
There are several drivers that mention the combination of FX2, ZL10353 and
XC2028/XC3028, "cxusb" seems to be closest. A copy-paste from existing code
might do the trick.

One thing stands in my way: I have never written C code in my life. I can
read the code and more or less understand what the purpose is, but to
combine stuff into a working driver requires real skills :-)

I have the correct xceive and conexant firmwares, a windows driver with INF,
etc. at my disposal.
Can anyone help me assemble a driver for my device?
TIA,

Mark

--0016361e7b44d6288504949fb102
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi everyone,<br><br>I have been trying to get my &quot;Terratec Cinergy HT =
USB PVR&quot; tuner to work (on DVB-T). This is a hybrid analog/dvb-t tuner=
 with a hardware MPEG encoder. <br>Inserting the device does not cause any =
driver to respond and load. The USB ID is &quot;0ccd:006b&quot;. The PID is=
 not listed in &quot;dvb-usb-ids.h&quot;.<br>
<br>After quite a bit of research I have a lot of information on the device=
. I also opened it up to check the actual chip versions (took me back to sl=
ackware 3 and graphics cards). <br>The various components are:<br>* Cypress=
 CY7C68013A FX2 USB controller<br>
* Intel CE6353 demodulator (should be the same as Zarlink ZL10353)<br>* XCe=
ive XC3028 tuner<br>(* Conexant CX25843 a/v decoder)<br>(* Conexant CX23416=
 MPEG encoder)<br><br>The last two should not be really necessary from what=
 I have learned. <br>
<br>From what I can see, all components are supported in one way or another=
.
 There are several drivers that mention the combination of FX2, ZL10353 and=
 XC2028/XC3028, &quot;cxusb&quot; seems to be closest. A copy-paste from ex=
isting code might do the trick. <br><br>One thing stands in my way: I have =
never written C code in my life. I can read the code and more or less under=
stand what the purpose is, but to combine stuff into a working driver requi=
res real skills :-) <br>
<br>I have the correct xceive and conexant firmwares, a windows driver with=
 INF, etc. at my disposal. <br>Can anyone help me assemble a driver for my =
device? <br>TIA, <br><br>Mark<br>

--0016361e7b44d6288504949fb102--


--===============0010158688==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0010158688==--
