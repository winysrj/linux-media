Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:52252 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbaF3O4j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Jun 2014 10:56:39 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N7Z00BQCLID3N80@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 30 Jun 2014 10:56:37 -0400 (EDT)
Date: Mon, 30 Jun 2014 11:56:33 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Vincent McIntyre <vincent.mcintyre@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: regression: (repost) firmware loading for dvico dual digital 4
Message-id: <20140630115633.6c5b5d95.m.chehab@samsung.com>
In-reply-to: <CAEsFdVOLAE+VzZ0pQv33Ga-vEN4D3=0ktcFjn4ejZ1rR=nww7w@mail.gmail.com>
References: <CAEsFdVOLAE+VzZ0pQv33Ga-vEN4D3=0ktcFjn4ejZ1rR=nww7w@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 30 Jun 2014 23:19:46 +1000
Vincent McIntyre <vincent.mcintyre@gmail.com> escreveu:

> Hi,
> 
> I am reposting this since it got ignored/missed last time around...
> 
> On 5/14/14, Vincent McIntyre <vincent.mcintyre@gmail.com> wrote:
> > Hi,
> >
> > Antti asked me to report this.
> >
> > I built the latest media_build git on Ubuntu 12.04, with 3.8.0 kernel,
> > using './build --main-git'.
> > The attached tarball has the relvant info.
> >
> > Without the media_build modules, firmware loads fine (file dmesg.1)
> > Once I build and install the media_build modules, the firmware no
> > longer loads. (dmesg.2)
> >
> > The firmware loading issue appears to have been reported to ubuntu (a
> > later kernel, 3.11)  with a possible fix proposed, see
> > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1291459
> >
> > I can post lspci etc details if people want.
> >
> 
> An updated version of the tar file is attached.
> 
> dmesg.1 is from 3.8.0-38 plus media-build modules and shows the
> firmware loading issue.
> The media-build HEAD revision was
>   commit e4a8d40f63afa8b0276ea7758d9b4d32e64a964d
>   Author: Hans Verkuil <hans.verkuil@cisco.com>
>   Date:   Wed Jun 18 10:27:51 2014 +0200
> 
> dmesg.2 is from 3.8.0-42 with the ubuntu-provided modules and does not
> show the issue.
> 
> The issue occurs in later ubuntu kernels, 3.11 as noted previously
> and 3.13.0-30.
> 
> The OS is ubuntu 12.04 LTS, amd64.
> 
> I looked into bisecting this but could not figure out a procedure
> since the 'build' script tries really hard to use the latest
> media-build and kernel sources. It looks like one has to run the
> media-build 'make' against a checkout of the vanilla kernel that
> roughly corresponds in time (or at least is not from a time later than
> the current media-build revision that is checked out).

> 
> 
> Please respond this time

Next time, please add the logs directly at the email, as this makes
clearer about what's the problem and what driver has the issues.

Anyway, based on this:

[   16.332247] xc2028 0-0061: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
[   16.344378] cxusb: i2c wr: len=64 is too big!

I suspect that the enclosed patch should fix your issue. Please test. If it
works, please reply to this email with:
	Tested-by: your name <your@email>

Cheers,
Mauro

-

cxusb: increase buffer lenght to 80 bytes

As reported by Vincent:
	[   16.332247] xc2028 0-0061: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
	[   16.344378] cxusb: i2c wr: len=64 is too big!

64 bytes is too short for firmware load on this device. So, increase it
to 80 bytes.

Reported-by: Vincent McIntyre <vincent.mcintyre@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
index 6acde5ee4324..a22726ccca64 100644
--- a/drivers/media/usb/dvb-usb/cxusb.c
+++ b/drivers/media/usb/dvb-usb/cxusb.c
@@ -44,7 +44,7 @@
 #include "atbm8830.h"
 
 /* Max transfer size done by I2C transfer functions */
-#define MAX_XFER_SIZE  64
+#define MAX_XFER_SIZE  80
 
 /* debug */
 static int dvb_usb_cxusb_debug;

