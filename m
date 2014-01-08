Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39855 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaAHJ6d (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jan 2014 04:58:33 -0500
Date: Wed, 8 Jan 2014 12:58:40 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: a.hajda@samsung.com
Cc: linux-media@vger.kernel.org
Subject: re: [media] Add driver for Samsung S5K5BAF camera sensor
Message-ID: <20140108095840.GA10979@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Andrzej Hajda,

The patch 7d459937dc09: "[media] Add driver for Samsung S5K5BAF
camera sensor" from Dec 5, 2013, leads to the following
static checker warning:

	drivers/media/i2c/s5k5baf.c:1043 s5k5baf_set_power()
	warn: add some parenthesis here?

drivers/media/i2c/s5k5baf.c
  1036  static int s5k5baf_set_power(struct v4l2_subdev *sd, int on)
  1037  {
  1038          struct s5k5baf *state = to_s5k5baf(sd);
  1039          int ret = 0;
  1040  
  1041          mutex_lock(&state->lock);
  1042  
  1043          if (!on != state->power)
                    ^^^^^^^^^^^^^^^^^^^
This would be cleaner if it were "if (on == state->power)"

  1044                  goto out;
  1045  
  1046          if (on) {

regards,
dan carpenter

