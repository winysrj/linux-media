Return-path: <mchehab@gaivota>
Received: from mail2.matrix-vision.com ([85.214.244.251]:37592 "EHLO
	mail2.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab1EIMis (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 May 2011 08:38:48 -0400
Message-ID: <4DC7DEC9.1000400@matrix-vision.de>
Date: Mon, 09 May 2011 14:32:09 +0200
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: locking in OMAP ISP subdevs
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Laurent,

I can't find where the locking is handled for ISP subdev standard ioctls
like ccdc_v4l2_pad_ops.set_fmt().  Using the CCDC as an example, it
looks to me like the following sequence happens when e.g. format is set
on CCDC pad 0:

1. # media-ctl --set-format '"OMAP3 ISP CCDC":0 [Y8 640x480]'

2. v4l2-dev.c:v4l2_ioctl()

this calls vdev->fops->unlocked_ioctl, which was set to
v4l2-subdev.c:subdev_ioctl() in "v4l2_subdev_fops" in
v4l2-device.c:v4l2_device_register_subdev_nodes()

3. v4l2-subdev.c:subdev_ioctl()
4. video_usercopy()
5. v4l2-ioctl.c:__video_usercopy()
6. v4l2-subdev.c:subdev_do_ioctl()
7. ispccdc.c:ccdc_set_format()

ccdc_set_format() sets ccdc->formats[pad], access to which should be
serialized, but I don't see how this happens.  In the call sequence
above, the only opportunity I see is in (2), but only then if
ccdc->subdev.devnode.lock is set, which doesn't seem to be done.

Can you clarify this for me?  What mutex is held during a call to
ccdc_set_format()?

-Michael

MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
