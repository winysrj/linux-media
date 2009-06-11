Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f172.google.com ([209.85.222.172]:39690 "EHLO
	mail-pz0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759278AbZFKGsG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 02:48:06 -0400
Received: by pzk2 with SMTP id 2so215830pzk.33
        for <linux-media@vger.kernel.org>; Wed, 10 Jun 2009 23:48:08 -0700 (PDT)
Subject: Re: [PATCH] ov511.c: video_register_device() return zero on success
From: "Figo.zhang" <figo1802@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, mark@alpha.dyndns.org,
	Hans Verkuil <hverkuil@xs4all.nl>, cpbotha@ieee.org,
	kraxel@bytesex.org, claudio@conectiva.com
In-Reply-To: <20090611014014.6aa4eea0@pedra.chehab.org>
References: <1243752113.3425.12.camel@myhost>
	 <20090610223951.3013892b@pedra.chehab.org>
	 <20090611014014.6aa4eea0@pedra.chehab.org>
Content-Type: text/plain
Date: Thu, 11 Jun 2009 14:39:56 +0800
Message-Id: <1244702396.3423.39.camel@myhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2009-06-11 at 01:40 -0300, Mauro Carvalho Chehab wrote:
> Em Wed, 10 Jun 2009 22:39:51 -0300
> Mauro Carvalho Chehab <mchehab@redhat.com> escreveu:
> 
> > Em Sun, 31 May 2009 14:41:52 +0800
> > "Figo.zhang" <figo1802@gmail.com> escreveu:
> > 
> > > video_register_device() return zero on success, it would not return a positive integer.
> > > 
> > > Signed-off-by: Figo.zhang <figo1802@gmail.com>
> > > --- 
> > >  drivers/media/video/ov511.c |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/drivers/media/video/ov511.c b/drivers/media/video/ov511.c
> > > index 9af5532..816427e 100644
> > > --- a/drivers/media/video/ov511.c
> > > +++ b/drivers/media/video/ov511.c
> > > @@ -5851,7 +5851,7 @@ ov51x_probe(struct usb_interface *intf, const struct usb_device_id *id)
> > >  			break;
> > >  
> > >  		if (video_register_device(ov->vdev, VFL_TYPE_GRABBER,
> > > -			unit_video[i]) >= 0) {
> > > +			unit_video[i]) == 0) {
> > >  			break;
> > >  		}
> > >  	}
> > 
> > Nack.
> > 
> > Errors are always negative. So, any zero or positive value indicates that no error occurred.
> > 
> > Yet, the logic for forcing ov51x to specific minor number seems broken: it will
> > end by registering the device twice, if used.
> > 
> > So, that part of the function needs a rewrite. I'll fix it.
> > 
> 
> Hmm... the issue seems more complex than I've imagined...
> 
> When ov511 were written, it was assumed that video_register_device(dev, v, nr)
> would have the following behavior:
> 
> 	if nr = -1, it would do dynamic minor allocation;
> 	if nr >= 0, it would allocate to 'nr' minor or fail.
> 
> With the original behavior.
> 
> The ov511_probe registering loop is doing something like this (I did a cleanup
> to allow a better understand of the logic):
> 
> <snip>
> #define OV511_MAX_UNIT_VIDEO 16
> ...
> static int unit_video[OV511_MAX_UNIT_VIDEO];
> ...
> module_param_array(unit_video, int, &num_uv, 0);
> MODULE_PARM_DESC(unit_video,
>   "Force use of specific minor number(s). 0 is not allowed.");
> ...
> static int
> ov51x_probe(struct usb_interface *intf, const struct usb_device_id *id)
> {
> ...
>         for (i = 0; i < OV511_MAX_UNIT_VIDEO; i++) {
>                 /* Minor 0 cannot be specified; assume user wants autodetect */
>                 if (unit_video[i] == 0)
>                         break;
> 
>                 if (video_register_device(ov->vdev, VFL_TYPE_GRABBER,
>                                         unit_video[i]) >= 0)
>                         goto register_succeded;
>         }
> 
>         /* Use the next available one */
>         if (video_register_device(ov->vdev, VFL_TYPE_GRABBER, -1) < 0) {
>                 err("video_register_device failed");
>                 goto error;
> 
> register_succeeded:
>         dev_info(&intf->dev, "Device at %s registered to minor %d\n",
>                  ov->usb_path, ov->vdev->minor);
> </snip>
> 
> So, if you probe ov511 with a list of device numbers, for example:
> 
> modprobe ov511 4,1,3
> 

you means specify the minior video
device: /dev/vidoe4,/dev/video1, /dev/video3 ? 

it maybe : modprobe ov511 unit_video=4,1,3
  
> And assuming that you have 5 ov511 devices, and connect they one by one,
> they'll gain the following device numbers (at the connection order):
> /dev/video4
> /dev/video1
> /dev/video3
> /dev/video0
> /dev/video2
> 
> However, changeset 9133:
> 
> changeset:   9133:64aed7485a43
> parent:      9073:4db9722caf4f
> user:        Hans Verkuil <hverkuil@xs4all.nl>
> date:        Sat Oct 04 13:36:54 2008 +0200
> summary:     v4l: disconnect kernel number from minor
> 
> Changed the behavior video_register_device(dev, v, nr):
> 
> + nr = find_next_zero_bit(video_nums[type], minor_cnt, nr == -1 ? 0 : nr);
> 
> So, instead of accepting just -1 or nr, it will now do:
> 	if nr = -1, it will do dynamic minor allocation (as before);
> 	if nr >= 0, it will also do dynamic minor allocation, but starting from nr.
> 
> So, the new code won't fail if nr is already allocated, but it will return the
> next unallocated nr.
> 
> With the ov511 code, this means that you'll have, instead:
> 
> /dev/video5
> /dev/video6
> /dev/video7
> /dev/video8
> /dev/video9
> 
> So, changeset 9133 actually broke the ov511 probe original behavior.
> 
> In order to restore the original behavior, the probe logic should be replaced
> by something else (like the approach taken by em28xx).
> 
> Also, changeset 9133 may also cause other side effects on other drivers that
> were expecting the original behavior.
> 
> To make things worse, the function comment doesn't properly explain the current
> behavior.
> 
> ---
> 
> Figo,
> 
> Since we are in the middle of a merge window, it is unlikely that I'll have
> enough time to properly fix it right now (since my priority right now is to
> merge the existing patches).
> 
> As you started proposing a patch for it, maybe you could try to fix it and
> check about similar troubles on other drivers.
> 
> Cheers,
> Mauro


in v2, if insmod without specify 'unit_video', it use autodetect video device.
if specify the 'unit_video', it will try to detect start from nr.

Signed-off-by: Figo.zhang <figo1802@gmail.com>
--- 
 drivers/media/video/ov511.c |   32 +++++++++++++++++---------------
 1 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/media/video/ov511.c b/drivers/media/video/ov511.c
index 9af5532..293695f 100644
--- a/drivers/media/video/ov511.c
+++ b/drivers/media/video/ov511.c
@@ -180,7 +180,7 @@ module_param(force_palette, int, 0);
 MODULE_PARM_DESC(force_palette, "Force the palette to a specific value");
 module_param(backlight, int, 0);
 MODULE_PARM_DESC(backlight, "For objects that are lit from behind");
-static unsigned int num_uv;
+static unsigned int num_uv = 0;
 module_param_array(unit_video, int, &num_uv, 0);
 MODULE_PARM_DESC(unit_video,
   "Force use of specific minor number(s). 0 is not allowed.");
@@ -5845,22 +5845,24 @@ ov51x_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	ov->vdev->parent = &intf->dev;
 	video_set_drvdata(ov->vdev, ov);
 
-	for (i = 0; i < OV511_MAX_UNIT_VIDEO; i++) {
-		/* Minor 0 cannot be specified; assume user wants autodetect */
-		if (unit_video[i] == 0)
-			break;
-
-		if (video_register_device(ov->vdev, VFL_TYPE_GRABBER,
-			unit_video[i]) >= 0) {
-			break;
+	/*if num_uv is zero, it autodetect*/
+	if(num_uv == 0){
+		if ((ov->vdev->minor == -1) &&
+	    		video_register_device(ov->vdev, VFL_TYPE_GRABBER, -1) < 0) {
+			err("video_register_device failed");
+			goto error;
 		}
-	}
+	}else {
+		for (i = 0; i < num_uv; i++) {
+			/* Minor 0 cannot be specified; assume user wants autodetect */
+			if (unit_video[i] == 0)
+				break;
 
-	/* Use the next available one */
-	if ((ov->vdev->minor == -1) &&
-	    video_register_device(ov->vdev, VFL_TYPE_GRABBER, -1) < 0) {
-		err("video_register_device failed");
-		goto error;
+			if (video_register_device(ov->vdev, VFL_TYPE_GRABBER,
+				unit_video[i]) == 0) {
+				break;
+			}
+		}
 	}
 
 	dev_info(&intf->dev, "Device at %s registered to minor %d\n",


