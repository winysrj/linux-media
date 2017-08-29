Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29132 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751337AbdH2LkI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Aug 2017 07:40:08 -0400
Date: Tue, 29 Aug 2017 14:39:50 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: sakari.ailus@linux.intel.com
Cc: linux-media@vger.kernel.org
Subject: [bug report] media: v4l2-flash-led-class: Create separate
 sub-devices for indicators
Message-ID: <20170829112544.4at4tb6msmgxphc4@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Sakari Ailus,

This is a semi-automatic email about new static checker warnings.

The patch 503dd28af108: "media: v4l2-flash-led-class: Create separate 
sub-devices for indicators" from Jul 18, 2017, leads to the following 
Smatch complaint:

drivers/media/v4l2-core/v4l2-flash-led-class.c:210 v4l2_flash_s_ctrl()
	 error: we previously assumed 'fled_cdev' could be null (see line 200)

drivers/media/v4l2-core/v4l2-flash-led-class.c
   199		struct led_classdev_flash *fled_cdev = v4l2_flash->fled_cdev;
   200		struct led_classdev *led_cdev = fled_cdev ? &fled_cdev->led_cdev : NULL;
                                                ^^^^^^^^^
The patch adds a new check for NULL here

   201		struct v4l2_ctrl **ctrls = v4l2_flash->ctrls;
   202		bool external_strobe;
   203		int ret = 0;
   204	
   205		switch (c->id) {
   206		case V4L2_CID_FLASH_LED_MODE:
   207			switch (c->val) {
   208			case V4L2_FLASH_LED_MODE_NONE:
   209				led_set_brightness_sync(led_cdev, LED_OFF);
   210				return led_set_flash_strobe(fled_cdev, false);
                                                            ^^^^^^^^^
but we had an old unchecked dereference here.

   211			case V4L2_FLASH_LED_MODE_FLASH:
   212				/* Turn the torch LED off */

regards,
dan carpenter
