Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26752 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab3KMJjg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Nov 2013 04:39:36 -0500
Date: Wed, 13 Nov 2013 12:39:23 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: gshark.jeong@gmail.com
Cc: linux-media@vger.kernel.org
Subject: re: [media] media: i2c: add driver for dual LED Flash, lm3560
Message-ID: <20131113093923.GA2557@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Daniel Jeong,

The patch 7f6b11a18c30: "[media] media: i2c: add driver for dual LED
Flash, lm3560" from Oct 16, 2013, leads to the following
static checker warning: "drivers/media/i2c/lm3560.c:196
lm3560_get_ctrl()
	 warn: inconsistent returns mutex:&flash->lock: locked (184
	[s32min-(-1)], 192 [0]) unlocked (196 [(-22)])"

drivers/media/i2c/lm3560.c
   171  /* V4L2 controls  */
   172  static int lm3560_get_ctrl(struct v4l2_ctrl *ctrl, enum lm3560_led_id led_no)
   173  {
   174          struct lm3560_flash *flash = to_lm3560_flash(ctrl, led_no);
   175  
   176          mutex_lock(&flash->lock);
   177  
   178          if (ctrl->id == V4L2_CID_FLASH_FAULT) {
   179                  int rval;
   180                  s32 fault = 0;
   181                  unsigned int reg_val;
   182                  rval = regmap_read(flash->regmap, REG_FLAG, &reg_val);
   183                  if (rval < 0)
   184                          return rval;

Some negative returns mean we are holding the lock.

   185                  if (rval & FAULT_SHORT_CIRCUIT)
   186                          fault |= V4L2_FLASH_FAULT_SHORT_CIRCUIT;
   187                  if (rval & FAULT_OVERTEMP)
   188                          fault |= V4L2_FLASH_FAULT_OVER_TEMPERATURE;
   189                  if (rval & FAULT_TIMEOUT)
   190                          fault |= V4L2_FLASH_FAULT_TIMEOUT;
   191                  ctrl->cur.val = fault;
   192                  return 0;

Positive means we are holding the lock.

   193          }
   194  
   195          mutex_unlock(&flash->lock);
   196          return -EINVAL;

Some mean we unlocked.

   197  }

I also worry that this might be a double lock deadlock because the
caller already holds the lock in get_ctrl(), but I don't know the code
very well.

regards,
dan carpenter

