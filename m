Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8JIuD7v016840
	for <video4linux-list@redhat.com>; Fri, 19 Sep 2008 14:56:13 -0400
Received: from pne-smtpout2-sn1.fre.skanova.net
	(pne-smtpout2-sn1.fre.skanova.net [81.228.11.159])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8JIu8tX008532
	for <video4linux-list@redhat.com>; Fri, 19 Sep 2008 14:56:09 -0400
Message-ID: <48D3F5C6.3050806@gmail.com>
Date: Fri, 19 Sep 2008 20:56:06 +0200
From: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
MIME-Version: 1.0
To: Hans de Goede <j.w.r.degoede@hhs.nl>
References: <62e5edd40809180002t248de932g3c3515bf5081993c@mail.gmail.com>
	<48D3306B.4060001@hhs.nl>
In-Reply-To: <48D3306B.4060001@hhs.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Cc: m560x-driver-devel <m560x-driver-devel@lists.sourceforge.net>,
	video4linux-list@redhat.com
Subject: Re: [PATCH][RFC] Add support for the ALi m5602 usb bridge webcam
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1



Hans de Goede wrote:
| Erik Andrén wrote:
|> Hi,
|> I'm proud to announce the following patch adding support for the ALi
|> m5602
|> usb bridge connected to several different sensors.
|> This driver has been brewing for a long time in the m560x.sf.net
|> project and
|> exists due to the hard work of many persons.
|>
|> libv4l is needed in order to gain support for multiple pixelformats.
|>
|> The patch should apply against the latest v4l-dvb hg tree.
|>
|> Thanks for any feedback,
|> Erik
|>
|
| Hi Erik,
|
| Thanks for doing this, unfortunately the driver which you used as a
| template to start from has various issues (not allowing multiple opens
| for one, interpreting the v4l2 API in interesting ways in other places).
|
| Besides that there is lot of code duplication between isoc mode usb
| webcams.
|
| I would kindly like to ask you to consider porting the m5602 driver to
| the gspca framework, which provides a generic framework for isoc webcams
| and takes a lot of stuff out of the driver and into a more generic
| framework (like try_fmt mode negatiation, isoc mode setup and handling,
| frame buffer management, etc.).
|
| gspca is in the current 2.6.27 kernels, if you look under
| drivers/media/video/gspca you will see drivers for a lot of different
| webcams there, you could for example take the pac207 driver as an
| example, strip it empty and then copy and paste the relevant part of
| your driver to there.
|
| I will help you in anyway I can.
|
| Does this sound like a plan?

Hi Hans and thanks for the feedback.

Frankly, I'd rather not refactor the driver for two reasons:

1) I personally think the gspca code is ugly and hard to understand. The
usb bridge code and sensor code is cludged together. There is a lack of
structure when one source file may be up to +7k lines of code (think
zc3xx.c).
I'm never going to accept to see the m5602 driver be concatenated into
one big chunk like that.
The m5602 driver currently has a nice layout with clear defined layers
and filenames which allow fast integration of new sensors and modularity
and I intend to keep it so.
If it's supposed to be a generic framework, why does it still keep the
name it used when it was a special purpose driver?
Why not rename it to "webcam-framework" or something more sane?

2) The submitted m5602 driver is stable. Sure, it needs some spit and
polish and you never know when a notebook with a new, unsupported sensor
pops out, but it basically works with the libv4l. I haven't investigated
~  the multiple open issue but I'm sure it could be resolved.

I say, merge this driver. Then let anyone wanting to do the conversion
work to adapt it for the gspca later on.

Best regards,
Erik

|
| Regards,
|
| Hans
|
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFI0/XGN7qBt+4UG0ERAsdIAKCtVNauq75DD/pM2xEA15Da1qi/fgCcD9Iv
ovWL/NB0ILftYiCAnFWRRqA=
=dS43
-----END PGP SIGNATURE-----

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
