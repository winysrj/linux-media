Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway10.websitewelcome.com ([67.18.125.9]:45393 "HELO
	gateway10.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751307Ab0BLDTs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Feb 2010 22:19:48 -0500
Received: from [66.15.212.169] (port=10295 helo=[10.140.5.12])
	by gator886.hostgator.com with esmtpsa (SSLv3:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <pete@sensoray.com>)
	id 1NfjT1-0005cl-Mn
	for linux-media@vger.kernel.org; Thu, 11 Feb 2010 18:33:07 -0600
Subject: [PATCH 0/5] go7007 staging changes
From: Pete Eberlein <pete@sensoray.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 11 Feb 2010 16:32:50 -0800
Message-Id: <1265934770.4626.249.camel@pete-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

This series moves most of the subdevice drivers used by the go7007
driver out of the staging directory.  The sony-tuner, ov7640, tw2804 and
tw9903 are converted to use the v4l2_subdev API, and the wis- versions
are made obsolete.  The wis-saa7113 and wis-saa7115 drivers are
obsolete, and don't add anything not already in the existing saa7113 and
saa7115 video decoder drivers.  The audio chip driver wis-uda1342
doesn't belong in 

If these changes are accepted, it should be determined if the go7007
driver can be moved out of staging, or what work remains to be done.

Pete Eberlein

[PATCH 1/5] go7007: driver id cleanup
[PATCH 2/5] sony-tuner: Subdev conversion from wis-sony-tuner
[PATCH 3/5] tw2804: video decoder subdev conversion
[PATCH 4/5] tw9903: video decoder subdev conversion
[PATCH 5/5] ov7640: sensor driver subdev conversion

 b/linux/drivers/media/common/tuners/sony-tuner.c |  695 +++++++++++++++++++++++
 b/linux/drivers/media/video/ov7640.c             |  141 ++++
 b/linux/drivers/media/video/tw2804.c             |  398 +++++++++++++
 b/linux/drivers/media/video/tw9903.c             |  370 ++++++++++++
 linux/Documentation/video4linux/CARDLIST.tuner   |    3 
 linux/drivers/media/common/tuners/Kconfig        |    8 
 linux/drivers/media/common/tuners/Makefile       |    1 
 linux/drivers/media/common/tuners/tuner-types.c  |   12 
 linux/drivers/media/video/Kconfig                |   19 
 linux/drivers/media/video/Makefile               |    3 
 linux/drivers/staging/go7007/go7007-driver.c     |   55 -
 linux/drivers/staging/go7007/go7007-priv.h       |   18 
 linux/drivers/staging/go7007/go7007-usb.c        |   30 
 linux/drivers/staging/go7007/wis-i2c.h           |   11 
 linux/drivers/staging/go7007/wis-ov7640.c        |    2 
 linux/drivers/staging/go7007/wis-sony-tuner.c    |    2 
 linux/include/media/tuner.h                      |    4 
 linux/include/media/v4l2-chip-ident.h            |    1 
 18 files changed, 1692 insertions(+), 81 deletions(-)



