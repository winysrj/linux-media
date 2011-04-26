Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <mjcoogle@gmail.com>) id 1QEoYl-0006rv-EL
	for linux-dvb@linuxtv.org; Tue, 26 Apr 2011 22:09:01 +0200
Received: from mail-qw0-f54.google.com ([209.85.216.54])
	by mail.tu-berlin.de (exim-4.75/mailfrontend-1) with esmtps
	[TLSv1:RC4-SHA:128] for <linux-dvb@linuxtv.org>
	id 1QEoYk-00019y-Lk; Tue, 26 Apr 2011 22:08:35 +0200
Received: by qwc9 with SMTP id 9so564086qwc.41
	for <linux-dvb@linuxtv.org>; Tue, 26 Apr 2011 13:08:32 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 26 Apr 2011 14:08:32 -0600
Message-ID: <BANLkTimGx15EGwbsafJA81m1anbRw+AV2A@mail.gmail.com>
From: Martin Cole <mjcoogle@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] analog OTA tuning
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1050781941=="
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

--===============1050781941==
Content-Type: multipart/alternative; boundary=20cf3005dc486ae80104a1d7e30a

--20cf3005dc486ae80104a1d7e30a
Content-Type: text/plain; charset=ISO-8859-1

Hi,

I need to tune analog OTA channels from a pci-e card.  I bought the
following card:

http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-2200  (I actually have
the 2250)

after installing and downloading the firmware etc, this works fine when
tuning the digital OTA signal that I can see locally.

I am unsure how to change the frontend to attempt to tune analog tv input or
even if this is supported, can someone point me in the right direction to do
this? It looks like I would need to change the tuner type in the driver code
(if analog is supported)

I am aware that no analog broadcasts exist anymore in the US, but where this
will eventually be used still has analog OTA broadcasts.
My test setup for now includes a digital to analog converter, which i would
like to tune with this card, once this works I would test with the actual
OTA signal.

Looking at the tuner chip on the card, suggests that it is possible. The
link on the wiki for the chip is outdated it seems, this is what I found on
the nxp site:

http://www.nxp.com/#/pip/pip=[pip=TDA18271HD]|pp=[t=pip,i=TDA18271HD]

I am happy to dive into the code, but wanted to see if anyone has done this
already or get any suggestions that you more experienced developers could
provide.

Thanks,
--mc

--20cf3005dc486ae80104a1d7e30a
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<br>Hi,<br><br>I need to tune analog OTA channels from a pci-e card.=A0 I b=
ought the following card:<br><br><a href=3D"http://linuxtv.org/wiki/index.p=
hp/Hauppauge_WinTV-HVR-2200">http://linuxtv.org/wiki/index.php/Hauppauge_Wi=
nTV-HVR-2200</a>=A0 (I actually have the 2250)<br>
<br>after installing and downloading the firmware etc, this works fine when=
 tuning the digital OTA signal that I can see locally.<br><br>I am unsure h=
ow to change the frontend to attempt to tune analog tv input or even if thi=
s is supported, can someone point me in the right direction to do this? It =
looks like I would need to change the tuner type in the driver code (if ana=
log is supported)<br>
<br>I am aware that no analog broadcasts exist anymore in the US, but where=
 this will eventually be used still has analog OTA broadcasts.<br>My test s=
etup for now includes a digital to analog converter, which i would like to =
tune with this card, once this works I would test with the actual OTA signa=
l.<br>
<br>Looking at the tuner chip on the card, suggests that it is possible. Th=
e link on the wiki for the chip is outdated it seems, this is what I found =
on the nxp site:<br><br><a href=3D"http://www.nxp.com/#/pip/pip=3D[pip=3DTD=
A18271HD]|pp=3D[t=3Dpip,i=3DTDA18271HD]">http://www.nxp.com/#/pip/pip=3D[pi=
p=3DTDA18271HD]|pp=3D[t=3Dpip,i=3DTDA18271HD]</a><br>
<br>I am happy to dive into the code, but wanted to see if anyone has done =
this already or get any suggestions that you more experienced developers co=
uld provide.<br><br>Thanks,<br>--mc<br><br><br><br>

--20cf3005dc486ae80104a1d7e30a--


--===============1050781941==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1050781941==--
