Return-path: <mchehab@gaivota>
Received: from smtp.ispras.ru ([83.149.198.201]:36730 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757858Ab0LMQRU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Dec 2010 11:17:20 -0500
From: Alexander Strakh <strakh@ispras.ru>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	Andy Walls <awalls@md.metrocast.net>
Subject: BUG: return from function without mutex_unlock   in drivers/media/video/cx231xx/cx231xx-core.c
Date: Mon, 13 Dec 2010 19:35:22 +0300
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201012131936.13172.strakh@ispras.ru>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

	KERNEL_VERSION: 2.6.36
        SUBJECT: return from function without mutex_unlock   in 
drivers/media/video/cx231xx/cx231xx-core.c 

        SUBSCRIBE:
1.  In line 282 in function cx231xx_read_ctrl_reg mutex was locked.
2.  If usb_control_msg returns ret<0 then we exit from function 
cx231xx_read_ctrl_reg without unlocking mutex. In other (ret>=0) case mutex 
has been unlocked before exiting in line 295.

 282        mutex_lock(&dev->ctrl_urb_lock);
 283        ret = usb_control_msg(dev->udev, pipe, req,
 284                              USB_DIR_IN | USB_TYPE_VENDOR | 
USB_RECIP_DEVICE,
 285                              val, reg, dev->urb_buf, len, HZ);
 286        if (ret < 0) {
 287                cx231xx_isocdbg(" failed!\n");
 288                /* mutex_unlock(&dev->ctrl_urb_lock); */
 289                return ret;
 290        }
 291
 292        if (len)
 293                memcpy(buf, dev->urb_buf, len);
 294
 295        mutex_unlock(&dev->ctrl_urb_lock);

Found by Linux Device Drivers Verification Project
