Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:44365 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758199AbZFKWvp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 18:51:45 -0400
Date: Thu, 11 Jun 2009 19:51:39 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Figo.zhang" <figo1802@gmail.com>
Cc: linux-media@vger.kernel.org, mark@alpha.dyndns.org,
	Hans Verkuil <hverkuil@xs4all.nl>, cpbotha@ieee.org,
	kraxel@bytesex.org, claudio@conectiva.com,
	Douglas Landgraf <dougsland@gmail.com>
Subject: Re: [PATCH] ov511.c: video_register_device() return zero on success
Message-ID: <20090611195139.4f1c59e0@pedra.chehab.org>
In-Reply-To: <1244702396.3423.39.camel@myhost>
References: <1243752113.3425.12.camel@myhost>
	<20090610223951.3013892b@pedra.chehab.org>
	<20090611014014.6aa4eea0@pedra.chehab.org>
	<1244702396.3423.39.camel@myhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 11 Jun 2009 14:39:56 +0800
"Figo.zhang" <figo1802@gmail.com> escreveu:

> in v2, if insmod without specify 'unit_video', it use autodetect video device.
> if specify the 'unit_video', it will try to detect start from nr.
> 
> Signed-off-by: Figo.zhang <figo1802@gmail.com>
> --- 
>  drivers/media/video/ov511.c |   32 +++++++++++++++++---------------
>  1 files changed, 17 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/media/video/ov511.c b/drivers/media/video/ov511.c
> index 9af5532..293695f 100644
> --- a/drivers/media/video/ov511.c
> +++ b/drivers/media/video/ov511.c
> @@ -180,7 +180,7 @@ module_param(force_palette, int, 0);
>  MODULE_PARM_DESC(force_palette, "Force the palette to a specific value");
>  module_param(backlight, int, 0);
>  MODULE_PARM_DESC(backlight, "For objects that are lit from behind");
> -static unsigned int num_uv;
> +static unsigned int num_uv = 0;

Never initialize a static var with 0. This just increases the module size. On
Linux, all static vars already initialized with 0.

>  module_param_array(unit_video, int, &num_uv, 0);
>  MODULE_PARM_DESC(unit_video,
>    "Force use of specific minor number(s). 0 is not allowed.");
> @@ -5845,22 +5845,24 @@ ov51x_probe(struct usb_interface *intf, const struct usb_device_id *id)
>  	ov->vdev->parent = &intf->dev;
>  	video_set_drvdata(ov->vdev, ov);
>  
> -	for (i = 0; i < OV511_MAX_UNIT_VIDEO; i++) {
> -		/* Minor 0 cannot be specified; assume user wants autodetect */
> -		if (unit_video[i] == 0)
> -			break;
> -
> -		if (video_register_device(ov->vdev, VFL_TYPE_GRABBER,
> -			unit_video[i]) >= 0) {
> -			break;
> +	/*if num_uv is zero, it autodetect*/
> +	if(num_uv == 0){
> +		if ((ov->vdev->minor == -1) &&
> +	    		video_register_device(ov->vdev, VFL_TYPE_GRABBER, -1) < 0) {
> +			err("video_register_device failed");
> +			goto error;
>  		}
> -	}
> +	}else {
> +		for (i = 0; i < num_uv; i++) {
> +			/* Minor 0 cannot be specified; assume user wants autodetect */
> +			if (unit_video[i] == 0)
> +				break;
>  
> -	/* Use the next available one */
> -	if ((ov->vdev->minor == -1) &&
> -	    video_register_device(ov->vdev, VFL_TYPE_GRABBER, -1) < 0) {
> -		err("video_register_device failed");
> -		goto error;
> +			if (video_register_device(ov->vdev, VFL_TYPE_GRABBER,
> +				unit_video[i]) == 0) {
> +				break;
> +			}
> +		}
>  	}
>  
>  	dev_info(&intf->dev, "Device at %s registered to minor %d\n",
> 
> 

Thanks for the trial, but it is still broken (and also have lots of coding
style errors - Please always check your patches with checkpatch.pl).

Due to the hot plug/hot unplug nature of usb devices, the logic for it should
be more complex, since it should need to control the removal/reinsertion of a
device.

Since Douglas helped me with patchwork stuff (thanks, Douglas!), I found some
time for fixing it. Since I don't have any ov511 camera here, it would be nice
if people with this camera can do a review.

---

ov511: Fix unit_video parameter behavior

Fix a regression caused by changeset 9133:64aed7485a43 - v4l: disconnect kernel number from minor

Before the above changeset, ov511_probe used to allow forcing to use a certain
specific set of video devices, like:

modprobe ov511 unit_video=4,1,3 num_uv=3

So, assuming that you have 5 ov511 devices, and connect they one by one,
they'll gain the following device numbers (at the connection order):
/dev/video4
/dev/video1
/dev/video3
/dev/video0
/dev/video2

However, this was changed due to this change at video_register_device():

+ nr = find_next_zero_bit(video_nums[type], minor_cnt, nr == -1 ? 0 : nr);

With the previous behavior, a trial to register on an already allocated mirror
would fail, and a loop would get the next requested minor. However, the current
behavior is to get the next available minor instead of failing. Due to that,
this means that the above modprobe parameter will give, instead:

/dev/video5
/dev/video6
/dev/video7
/dev/video8
/dev/video9

In order to restore the original behavior, a static var were added, storing the
amount of already registered devices.

While there, it also fixes the locking of the probe/disconnect functions.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/linux/drivers/media/video/ov511.c b/linux/drivers/media/video/ov511.c
--- a/linux/drivers/media/video/ov511.c
+++ b/linux/drivers/media/video/ov511.c
@@ -112,6 +112,8 @@ static int framedrop		= -1;
 static int fastset;
 static int force_palette;
 static int backlight;
+/* Bitmask marking allocated devices from 0 to OV511_MAX_UNIT_VIDEO */
+static unsigned long ov511_devused;
 static int unit_video[OV511_MAX_UNIT_VIDEO];
 static int remove_zeros;
 static int mirror;
@@ -5724,7 +5726,7 @@ ov51x_probe(struct usb_interface *intf, 
 	struct usb_device *dev = interface_to_usbdev(intf);
 	struct usb_interface_descriptor *idesc;
 	struct usb_ov511 *ov;
-	int i;
+	int i, rc, nr;
 
 	PDEBUG(1, "probing for device...");
 
@@ -5849,23 +5851,27 @@ ov51x_probe(struct usb_interface *intf, 
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
-		}
-	}
-
-	/* Use the next available one */
-	if ((ov->vdev->minor == -1) &&
-	    video_register_device(ov->vdev, VFL_TYPE_GRABBER, -1) < 0) {
+	mutex_lock(&ov->lock);
+
+	/* Check to see next free device and mark as used */
+	nr = find_first_zero_bit(&ov511_devused, OV511_MAX_UNIT_VIDEO);
+
+	/* Registers device */
+	if (unit_video[nr] != 0)
+		rc = video_register_device(ov->vdev, VFL_TYPE_GRABBER,
+					   unit_video[nr]);
+	else
+		rc = video_register_device(ov->vdev, VFL_TYPE_GRABBER, -1);
+
+	if (rc < 0) {
 		err("video_register_device failed");
-		goto error;
-	}
+		mutex_unlock(&ov->lock);
+		goto error;
+	}
+
+	/* Mark device as used */
+	ov511_devused |= 1 << nr;
+	ov->nr = nr;
 
 	dev_info(&intf->dev, "Device at %s registered to minor %d\n",
 		 ov->usb_path, ov->vdev->minor);
@@ -5873,8 +5879,12 @@ ov51x_probe(struct usb_interface *intf, 
 	usb_set_intfdata(intf, ov);
 	if (ov_create_sysfs(ov->vdev)) {
 		err("ov_create_sysfs failed");
-		goto error;
-	}
+		ov511_devused &= ~(1 << nr);
+		mutex_unlock(&ov->lock);
+		goto error;
+	}
+
+	mutex_lock(&ov->lock);
 
 	return 0;
 
@@ -5910,10 +5920,16 @@ ov51x_disconnect(struct usb_interface *i
 
 	PDEBUG(3, "");
 
+	mutex_lock(&ov->lock);
 	usb_set_intfdata (intf, NULL);
 
-	if (!ov)
-		return;
+	if (!ov) {
+		mutex_unlock(&ov->lock);
+		return;
+	}
+
+	/* Free device number */
+	ov511_devused &= ~(1 << ov->nr);
 
 	if (ov->vdev)
 		video_unregister_device(ov->vdev);
@@ -5931,6 +5947,7 @@ ov51x_disconnect(struct usb_interface *i
 
 	ov->streaming = 0;
 	ov51x_unlink_isoc(ov);
+	mutex_unlock(&ov->lock);
 
 	ov->dev = NULL;
 
diff --git a/linux/drivers/media/video/ov511.h b/linux/drivers/media/video/ov511.h
--- a/linux/drivers/media/video/ov511.h
+++ b/linux/drivers/media/video/ov511.h
@@ -495,6 +495,9 @@ struct usb_ov511 {
 	int has_decoder;	/* Device has a video decoder */
 	int pal;		/* Device is designed for PAL resolution */
 
+	/* ov511 device number ID */
+	int nr;			/* Stores a device number */
+
 	/* I2C interface */
 	struct mutex i2c_lock;	  /* Protect I2C controller regs */
 	unsigned char primary_i2c_slave;  /* I2C write id of sensor */




Cheers,
Mauro
