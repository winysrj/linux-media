Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50171 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755468AbcBCEmL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Feb 2016 23:42:11 -0500
Date: Wed, 3 Feb 2016 07:42:02 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: mchehab@osg.samsung.com
Cc: linux-media@vger.kernel.org
Subject: re: [media] em28xx: add media controller support
Message-ID: <20160203044202.GA12152@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro Carvalho Chehab,

The patch 37ecc7b1278f: "[media] em28xx: add media controller
support" from Jan 27, 2016, leads to the following static checker
warning:

	drivers/media/usb/em28xx/em28xx-cards.c:3028 em28xx_media_device_init()
	warn: this array is probably non-NULL. 'dev->name'

drivers/media/usb/em28xx/em28xx-cards.c
  3016  static int em28xx_media_device_init(struct em28xx *dev,
  3017                                      struct usb_device *udev)
  3018  {
  3019  #ifdef CONFIG_MEDIA_CONTROLLER
  3020          struct media_device *mdev;
  3021  
  3022          mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
  3023          if (!mdev)
  3024                  return -ENOMEM;
  3025  
  3026          mdev->dev = &udev->dev;
  3027  
  3028          if (!dev->name)
  3029                  strlcpy(mdev->model, "unknown em28xx", sizeof(mdev->model));
  3030          else
  3031                  strlcpy(mdev->model, dev->name, sizeof(mdev->model));

We either want to remove the NULL test or test for the empty string.

  3032          if (udev->serial)
  3033                  strlcpy(mdev->serial, udev->serial, sizeof(mdev->serial));
  3034          strcpy(mdev->bus_info, udev->devpath);
  3035          mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
  3036          mdev->driver_version = LINUX_VERSION_CODE;
  3037  
  3038          media_device_init(mdev);
  3039  
  3040          dev->media_dev = mdev;
  3041  #endif
  3042          return 0;
  3043  }

regards,
dan carpenter
