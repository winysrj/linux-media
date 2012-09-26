Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:41578 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab2IZIOA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 04:14:00 -0400
From: Hans Verkuil <hansverk@cisco.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [media] v4l2-subdev: add support for the new edid ioctls
Date: Wed, 26 Sep 2012 10:13:34 +0200
Cc: hans.verkuil@cisco.com, linux-media@vger.kernel.org
References: <20120926080106.GA5268@elgon.mountain>
In-Reply-To: <20120926080106.GA5268@elgon.mountain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209261013.34299.hansverk@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed 26 September 2012 10:01:06 Dan Carpenter wrote:
> Hi Hans,
> 
> The patch ed45ce2cc0b3: "[media] v4l2-subdev: add support for the new
> edid ioctls" from Aug 10, 2012, needs an overflow check the same as the
> other cases in that switch statement.
> 
> drivers/media/v4l2-core/v4l2-ioctl.c
> 
>   2200          case VIDIOC_SUBDEV_G_EDID:
>   2201          case VIDIOC_SUBDEV_S_EDID: {
>   2202                  struct v4l2_subdev_edid *edid = parg;
>   2203  
>   2204                  if (edid->blocks) {
>   2205                          *user_ptr = (void __user *)edid->edid;
>   2206                          *kernel_ptr = (void *)&edid->edid;
>   2207                          *array_size = edid->blocks * 128;
>                                               ^^^^^^^^^^^^^^^^^^
> This can overflow.
> 
>   2208                          ret = 1;
>   2209                  }
>   2210                  break;
>   2211          }

True. Thanks for reporting this! I'll make a fix for it.

Regards,

	Hans
