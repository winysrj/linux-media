Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:39107 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289AbbLLNug convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Dec 2015 08:50:36 -0500
Date: Sat, 12 Dec 2015 11:50:25 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v5 0/3] [media] Fix race between graph enumeration and
 entities registration
Message-ID: <20151212115025.06e54516@recife.lan>
In-Reply-To: <1449874629-8973-1-git-send-email-javier@osg.samsung.com>
References: <1449874629-8973-1-git-send-email-javier@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 11 Dec 2015 19:57:06 -0300
Javier Martinez Canillas <javier@osg.samsung.com> escreveu:

> Hello,
> 
> This series fixes the issue of media device nodes being registered before
> all the media entities and pads links are created so if user-space tries
> to enumerate the graph too early, it may get a partial graph enumeration
> since everything may not been registered yet.
> 
> The solution (suggested by Sakari Ailus) is to separate the media device
> registration from the initialization so drivers can first initialize the
> media device, create the graph and then finally register the media device
> node once is finished.
> 
> This is the fifth version of the series and is a rebase on top of latest
> MC next gen and the only important change is the addition of patch 3/3.
> 
> Patch #1 adds a check to the media_device_unregister() function to know if
> the media device has been registed yet so calling it will be safe and the
> cleanup functions of the drivers won't need to be changed in case register
> failed.
> 
> Patch #2 does the init and registration split, changing all the drivers to
> make the change atomic and also adds a cleanup function for media devices.
> 
> Patch #3 sets a topology version 0 at media device registration to allow
> user-space to know that the graph is "static" (i.e: no graph updates after
> the media device was registered).

Got some troubles when compiling those patches:

drivers/media/usb/dvb-usb/dvb-usb-dvb.c: In function ‘dvb_usb_media_device_init’:
drivers/media/usb/dvb-usb/dvb-usb-dvb.c:104:6: warning: unused variable ‘ret’ [-Wunused-variable]
  int ret;
      ^
drivers/media/usb/dvb-usb/dvb-usb-dvb.c: In function ‘dvb_usb_media_device_register’:
drivers/media/usb/dvb-usb/dvb-usb-dvb.c:129:2: warning: ignoring return value of ‘__media_device_register’, declared with attribute warn_unused_result [-Wunused-result]
  media_device_register(adap->dvb_adap.mdev);
  ^

drivers/media/usb/dvb-usb-v2/dvb_usb_core.c: In function ‘dvb_usbv2_media_device_init’:
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:409:6: warning: unused variable ‘ret’ [-Wunused-variable]
  int ret;
      ^
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c: In function ‘dvb_usbv2_adapter_frontend_init’:
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:706:34: warning: passing argument 1 of ‘dvb_usbv2_media_device_register’ from incompatible pointer type [-Wincompatible-pointer-types]
  dvb_usbv2_media_device_register(&adap->dvb_adap);
                                  ^
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:432:13: note: expected ‘struct dvb_usb_adapter *’ but argument is of type ‘struct dvb_adapter *’
 static void dvb_usbv2_media_device_register(struct dvb_usb_adapter *adap)
             ^
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c: In function ‘dvb_usbv2_media_device_register’:
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:435:2: warning: ignoring return value of ‘__media_device_register’, declared with attribute warn_unused_result [-Wunused-result]
  media_device_register(adap->dvb_adap.mdev);


> 
> Best regards,
> Javier
> 
> Changes in v5:
> - Add kernel-doc for media_device_init() and media_device_register().
> 
> Changes in v4:
> - Remove the model check from BUG_ON() since shold not be fatal.
>   Suggested by Sakari Ailus.
> 
> Changes in v3:
> - Replace the WARN_ON() in media_device_init() for a BUG_ON().
>   Suggested by Sakari Ailus.
> 
> Changes in v2:
> - Reword the documentation for media_device_unregister(). Suggested by Sakari.
> - Added Sakari's Acked-by tag for patch #1.
> - Reword the documentation for media_device_unregister(). Suggested by Sakari.
> - Added Sakari's Acked-by tag for patch #1.
> - Change media_device_init() to return void instead of an error.
>   Suggested by Sakari Ailus.
> - Remove the error messages when media_device_register() fails.
>   Suggested by Sakari Ailus.
> - Fix typos in commit message of patch #2. Suggested by Sakari Ailus.
> 
> Javier Martinez Canillas (3):
>   [media] media-device: check before unregister if mdev was registered
>   [media] media-device: split media initialization and registration
>   [media] media-device: set topology version 0 at media registration
> 
>  drivers/media/common/siano/smsdvb-main.c      |  1 +
>  drivers/media/media-device.c                  | 46 +++++++++++++++++++++++----
>  drivers/media/platform/exynos4-is/media-dev.c | 15 ++++-----
>  drivers/media/platform/omap3isp/isp.c         | 14 ++++----
>  drivers/media/platform/s3c-camif/camif-core.c | 15 ++++++---
>  drivers/media/platform/vsp1/vsp1_drv.c        | 12 +++----
>  drivers/media/platform/xilinx/xilinx-vipp.c   | 12 +++----
>  drivers/media/usb/au0828/au0828-core.c        | 27 ++++++++--------
>  drivers/media/usb/cx231xx/cx231xx-cards.c     | 30 ++++++++---------
>  drivers/media/usb/dvb-usb-v2/dvb_usb_core.c   | 23 ++++++++------
>  drivers/media/usb/dvb-usb/dvb-usb-dvb.c       | 24 ++++++++------
>  drivers/media/usb/siano/smsusb.c              |  5 +--
>  drivers/media/usb/uvc/uvc_driver.c            | 10 ++++--
>  include/media/media-device.h                  | 26 +++++++++++++++
>  14 files changed, 165 insertions(+), 95 deletions(-)
> 
