Return-path: <linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.72)
	(envelope-from <lingstein@gmail.com>) id 1RBCmz-0005AA-Bm
	for linux-dvb@linuxtv.org; Tue, 04 Oct 2011 23:44:37 +0200
Received: from mail-ww0-f48.google.com ([74.125.82.48])
	by mail.tu-berlin.de (exim-4.75/mailfrontend-4) with esmtps
	[TLSv1:RC4-SHA:128] for <linux-dvb@linuxtv.org>
	id 1RBCmz-0004L7-A1; Tue, 04 Oct 2011 23:44:37 +0200
Received: by wwe32 with SMTP id 32so986773wwe.5
	for <linux-dvb@linuxtv.org>; Tue, 04 Oct 2011 14:44:36 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 4 Oct 2011 17:14:36 -0430
Message-ID: <CAMxCp9fgLpKF9FqK4DFuNu78m3gVZ=ZmOY3BU1Q1E4ya6mTjCA@mail.gmail.com>
From: Ling Sequera <lingstein@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] usb analog tv stick Iconbit u100
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0357560941=="
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0357560941==
Content-Type: multipart/alternative; boundary=0016e64805e66e742504ae7fff2e

--0016e64805e66e742504ae7fff2e
Content-Type: text/plain; charset=ISO-8859-1

Regards,

I have a "Mygica u719c usb analog tv stick", lsusb output identify this
device as: "ID 1f4d:0237 G-Tek Electronics Group". Googling, I found that
this device is the same "Iconbit Analog Stick U100 FM", which has support in
the kernel since version 3.0 as shown here. I opened the device to confirm
this information, and effectively, it has two chips, the demod Conexan
"CX23102" and the DVB-T tuner NPX "TDA-18211" (I take it some pictures). I
installed the pre-compiled version of kernel 3.0.4, and the device was
recognised, but only works in the modes: composite and s-video. I check the
source code and I found that it don't support tv tuner mode, I want to add
support for this. The TDA-18211 tuner has support in the kernel in the
module tda18271 according to the thread of this mailing list. I have never
written a module, but I have basic knowledge in C, so I need a book,
reference, API, or something, to write the missing code to add support for
this device as tv tuner. Also I need help understanding how to read
usb-snoop log files and identify the necessary parameters for configure the
code. Excuse about my english, I am from Caracas, Venezuela. Thanks in
advance. I hope for your response.

--0016e64805e66e742504ae7fff2e
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Regards,<br>=A0<br>I have a &quot;Mygica u719c usb analog tv stick&quot;, l=
susb output identify this device as: &quot;ID 1f4d:0237 G-Tek Electronics G=
roup&quot;. Googling, I found that this device is the same &quot;Iconbit An=
alog Stick U100 FM&quot;, which has support in the kernel since version 3.0=
 as shown here. I opened the device to confirm this information, and effect=
ively, it has two chips, the demod Conexan &quot;CX23102&quot; and the DVB-=
T tuner NPX &quot;TDA-18211&quot; (I take it some pictures). I installed th=
e pre-compiled version of kernel 3.0.4, and the device was recognised, but =
only works in the modes: composite and s-video. I check the source code and=
 I found that it don&#39;t support tv tuner mode, I want to add support for=
 this. The TDA-18211 tuner has support in the kernel in the module tda18271=
 according to the thread of this mailing list. I have never written a modul=
e, but I have basic knowledge in C, so I need a book, reference, API, or so=
mething, to write the missing code to add support for this device as tv tun=
er. Also I need help understanding how to read usb-snoop log files and iden=
tify the necessary parameters for configure the code. Excuse about my engli=
sh, I am from Caracas, Venezuela. Thanks in advance. I hope for your respon=
se.<br>

--0016e64805e66e742504ae7fff2e--


--===============0357560941==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0357560941==--
