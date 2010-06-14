Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay02.digicable.hu ([92.249.128.188]:47257 "EHLO
	relay02.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119Ab0FNO6R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jun 2010 10:58:17 -0400
Message-ID: <4C164387.1000608@freemail.hu>
Date: Mon, 14 Jun 2010 16:58:15 +0200
From: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Krivchikov Sergei <sergei.krivchikov@gmail.com>,
	Jean-Francois Moine <moinejf@free.fr>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: genius islim 310 webcam test
References: <68c794d61003301249u138e643am20bb264375c3dfe1@mail.gmail.com>	<4BB2E42B.4090302@freemail.hu> <AANLkTikIivyjNkVYlo4CKCJcFK_UW5J28qG48cnWQBm8@mail.gmail.com>
In-Reply-To: <AANLkTikIivyjNkVYlo4CKCJcFK_UW5J28qG48cnWQBm8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergei, thanks for the report.

Hi Jean-Francois, I got this report about a working Genius iSlim 310
webcam. Maybe it would be a good idea to add the device 0x093a:0x2625
in pac7302.c. Should I send a patch for you?

Regards,

	Márton Németh

Krivchikov Sergei wrote:
> Hi! All works.
> From: http://forum.ubuntu.ru/index.php?topic=9767.msg717310#msg717310
> and
> http://stemp.wordpress.com/2009/11/03/karmic-get-the-latest-drivers-for-gspca-uvc-usbvideo-and-other/
> 
> |1. sudo aptitude install mercurial build-essential linux-headers
> libncurses5-dev
> ||2. hg clone http://linuxtv.org/hg/v4l-dvb/
> ||3. cd v4l-dvb
> 4. Add to | v4l-dvb/linux/drivers/media/video/gspca/pac7302.c in section
> 
> /* -- module initialisation -- */
> static const struct usb_device_id device_table[] __devinitconst = {
> 	{USB_DEVICE(0x06f8, 0x3009)},
> 	{USB_DEVICE(0x093a, 0x2620)},
> 	{USB_DEVICE(0x093a, 0x2621)},
> 	{USB_DEVICE(0x093a, 0x2622), .driver_info = FL_VFLIP},
> 
> 	{USB_DEVICE(0x093a, 0x2624), .driver_info = FL_VFLIP},
> *	{USB_DEVICE(0x093a, 0x2625)}*,
> 	{USB_DEVICE(0x093a, 0x2626)},
> 	{USB_DEVICE(0x093a, 0x2628)},
> 	{USB_DEVICE(0x093a, 0x2629), .driver_info = FL_VFLIP},
> 
> 	{USB_DEVICE(0x093a, 0x262a)},
> 	{USB_DEVICE(0x093a, 0x262c)},
> 	{}
> };
> 
> 
> 
> |5. sudo cp /boot/config-`uname -r` v4l/.config|
> |6. sudo make menuconfig|
> Set <M> in "Multimedia Support -> Video Capture adapters -> V4L USB
> devices -> GSPCA -> pac7302.c and Uncheck all other devices if you want.
> |7. make
> 8. sudo make install|
> 
> 
> Thanks!

