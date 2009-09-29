Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-yw0-f187.google.com ([209.85.211.187])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <scottpricepdx@gmail.com>) id 1MsQDg-0000uZ-Nz
	for linux-dvb@linuxtv.org; Tue, 29 Sep 2009 02:05:29 +0200
Received: by ywh17 with SMTP id 17so5606013ywh.3
	for <linux-dvb@linuxtv.org>; Mon, 28 Sep 2009 17:04:54 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 28 Sep 2009 17:04:54 -0700
Message-ID: <22a33c6b0909281704n4edb5b0eh8073fdef6758f3a4@mail.gmail.com>
From: Scott Price <scottpricepdx@gmail.com>
To: "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
Subject: [linux-dvb] Need help with Hauppauge WinTV-HVR 1290 (with Conexant
	cx-23888 chip & Samsung tuner, ATSC/QAM, Media Center, IR Remote)
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0385808572=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0385808572==
Content-Type: multipart/alternative; boundary=00163630f949f9174d0474ac298c

--00163630f949f9174d0474ac298c
Content-Type: text/plain; charset=ISO-8859-1

Hello, I'm relatively new to Linux (Ubuntu Jaunty 64) on an HP Quad-core AMD
64, 2.8Mhz, 8 GB RAM. This card does not seem to be supported (as of yet),
however, I was able to get the driver to load (cx23885) using the insmod
option for card=20 (Hauppauge WinTV-HVR 1255 I think) with no errors. I have
downloaded all of the latest v4l-dvb drivers using HG, and tried to download
the firmware, but the documentation that came with 2.6.26-15-generic points
to an ftp site at Hauppauge that is not there any more. After trying card=20
with insmod, I did a make distclean and re-installed the v4l-dvb with no
errors. It looked as if it loaded the firmware with that install, and
created a dvb folder under /dev with an adapter0. From this point I am
stuck. I can't reboot without losing the card=20 for the module, it goes
back to card=0 generic with automatic detection. None of the TV software
will recognize the card -- still. Can someone tell me what to do to save the
card info and get a TV program to work? I would be very grateful.

Thank you.

--00163630f949f9174d0474ac298c
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello, I&#39;m relatively new to Linux (Ubuntu Jaunty 64) on an HP Quad-cor=
e AMD 64, 2.8Mhz, 8 GB RAM. This card does not seem to be supported (as of =
yet), however, I was able to get the driver to load (cx23885) using the ins=
mod option for card=3D20 (Hauppauge WinTV-HVR 1255 I think) with no errors.=
 I have downloaded all of the latest v4l-dvb drivers using HG, and tried to=
 download the firmware, but the documentation that came with 2.6.26-15-gene=
ric points to an ftp site at Hauppauge that is not there any more. After tr=
ying card=3D20 with insmod, I did a make distclean and re-installed the v4l=
-dvb with no errors. It looked as if it loaded the firmware with that insta=
ll, and created a dvb folder under /dev with an adapter0. From this point I=
 am stuck. I can&#39;t reboot without losing the card=3D20 for the module, =
it goes back to card=3D0 generic with automatic detection. None of the TV s=
oftware will recognize the card -- still. Can someone tell me what to do to=
 save the card info and get a TV program to work? I would be very grateful.=
<br>
<br>Thank you.<br>

--00163630f949f9174d0474ac298c--


--===============0385808572==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0385808572==--
