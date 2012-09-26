Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:28353 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab2IZIBT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 04:01:19 -0400
Date: Wed, 26 Sep 2012 11:01:06 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: hans.verkuil@cisco.com
Cc: linux-media@vger.kernel.org
Subject: re: [media] v4l2-subdev: add support for the new edid ioctls
Message-ID: <20120926080106.GA5268@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

The patch ed45ce2cc0b3: "[media] v4l2-subdev: add support for the new
edid ioctls" from Aug 10, 2012, needs an overflow check the same as the
other cases in that switch statement.

drivers/media/v4l2-core/v4l2-ioctl.c

  2200          case VIDIOC_SUBDEV_G_EDID:
  2201          case VIDIOC_SUBDEV_S_EDID: {
  2202                  struct v4l2_subdev_edid *edid = parg;
  2203  
  2204                  if (edid->blocks) {
  2205                          *user_ptr = (void __user *)edid->edid;
  2206                          *kernel_ptr = (void *)&edid->edid;
  2207                          *array_size = edid->blocks * 128;
                                              ^^^^^^^^^^^^^^^^^^
This can overflow.

  2208                          ret = 1;
  2209                  }
  2210                  break;
  2211          }

regards,
dan carpenter

