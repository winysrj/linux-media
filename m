Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:53207 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708AbcEDEjQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2016 00:39:16 -0400
Date: Wed, 4 May 2016 06:39:02 +0200
From: Stefan Lippers-Hollmann <s.l-h@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL for v4.6-rc1] media updates
Message-ID: <20160504063902.0af2f4d7@mir>
In-Reply-To: <CA+55aFxAor=MJSGFkynu72AQN75bNTh9kewLR4xe8CpjHQQvZQ@mail.gmail.com>
References: <20160315080552.3cc5d146@recife.lan>
	<20160503233859.0f6506fa@mir>
	<CA+55aFxAor=MJSGFkynu72AQN75bNTh9kewLR4xe8CpjHQQvZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

On 2016-05-03, Linus Torvalds wrote:
> On Tue, May 3, 2016 at 2:38 PM, Stefan Lippers-Hollmann <s.l-h@gmx.de> wrote:
> > Hi
> > [...]  
> >> Mauro Carvalho Chehab (95):  
> > [...]  
> >>       [media] use v4l2_mc_usb_media_device_init() on most USB devices  
> > [...]
> >
> > This change, as part of v4.6-rc6-85-g1248ded, breaks two systems, each
> > equipped with a TeVii s480 (dvb_usb_dw2102) DVB-S2 card, for me (kernel
> > v4.5.3-rc1 is fine):  
> 
> From the oops it looks like the "->prev" pointer in one of the list
> heads in 'mdev' is NULL.
> 
> > [    5.041915] BUG: unable to handle kernel NULL pointer dereference at           (null)
> > [    5.041921] IP: [<ffffffffa0017b18>] media_gobj_create+0xb8/0x100 [media]  
> 
> I can't tell *which* list head it is, but it looks like there's a
> missing call to media_device_init() which is what should have
> initialized those list heads.
> 
> Of course, maybe that list pointer got initialized but then
> overwritten by NULL for some other reason.

Just as a cross-check, this (incomplete, but au0828, cx231xx and em28xx
aren't needed/ loaded on my system) crude revert avoids the problem for 
me on v4.6-rc6-113-g83858a7.

--- a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
@@ -107,7 +107,15 @@ static int dvb_usb_media_device_init(str
 	if (!mdev)
 		return -ENOMEM;
 
-	media_device_usb_init(mdev, udev, d->desc->name);
+	mdev->dev = &udev->dev;
+	strlcpy(mdev->model, d->desc->name, sizeof(mdev->model));
+	if (udev->serial)
+		strlcpy(mdev->serial, udev->serial, sizeof(mdev->serial));
+	strcpy(mdev->bus_info, udev->devpath);
+	mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
+	mdev->driver_version = LINUX_VERSION_CODE;
+
+	media_device_init(mdev);
 
 	dvb_register_media_controller(&adap->dvb_adap, mdev);
 
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
@@ -412,7 +412,15 @@ static int dvb_usbv2_media_device_init(s
 	if (!mdev)
 		return -ENOMEM;
 
-	media_device_usb_init(mdev, udev, d->name);
+	mdev->dev = &udev->dev;
+	strlcpy(mdev->model, d->name, sizeof(mdev->model));
+	if (udev->serial)
+		strlcpy(mdev->serial, udev->serial, sizeof(mdev->serial));
+	strcpy(mdev->bus_info, udev->devpath);
+	mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
+	mdev->driver_version = LINUX_VERSION_CODE;
+
+	media_device_init(mdev);
 
 	dvb_register_media_controller(&adap->dvb_adap, mdev);
 
While testing this, I also noticed that not just the dvb_usb based
dvb_usb_dw2102 is affected, but that also the dvb_usb_v2 based rtl2832
triggers this Oops on its own (given that just reverting 
drivers/media/usb/dvb-usb/dvb-usb-dvb.c wasn't enough).

Regards
	Stefan Lippers-Hollmann
