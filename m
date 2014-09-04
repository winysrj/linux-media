Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2811 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932426AbaIDGOp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Sep 2014 02:14:45 -0400
Message-ID: <54080340.8050609@xs4all.nl>
Date: Thu, 04 Sep 2014 08:14:24 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Kamil Debski <k.debski@samsung.com>,
	Antti Palosaari <crope@iki.fi>,
	Jonathan McCrohan <jmccrohan@gmail.com>
Subject: Re: [PATCH] v4l2-ctrls: avoid a sparse complain due to __user ptr
References: <3de557fce274288343f3ac7f5b3e0dac87f123bf.1409786360.git.m.chehab@samsung.com>
In-Reply-To: <3de557fce274288343f3ac7f5b3e0dac87f123bf.1409786360.git.m.chehab@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/04/2014 01:19 AM, Mauro Carvalho Chehab wrote:
> c->ptr was already copied to Kernelspace. So, this sparse warning
> is bogus:
> 
>>> drivers/media/v4l2-core/v4l2-ctrls.c:1685:15: sparse: incorrect type in assignment (different address spaces)
>    drivers/media/v4l2-core/v4l2-ctrls.c:1685:15:    expected void *[assigned] p
>    drivers/media/v4l2-core/v4l2-ctrls.c:1685:15:    got void [noderef] <asn:1>*ptr
> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

Nacked-by: Hans Verkuil <hans.verkuil@cisco.com>

Unfortunately, c->ptr can be a true user pointer. For once, this sparse warning
points to a real bug. It's not that easy to fix and I will need to think some
more how this should be handled.

Regards,

	Hans

> 
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index 35d1f3d5045b..ed10e4a9318c 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -1682,7 +1682,7 @@ static int validate_new(const struct v4l2_ctrl *ctrl,
>  			break;
>  		}
>  	}
> -	ptr.p = c->ptr;
> +	ptr.p = (__force void *)c->ptr;
>  	for (idx = 0; !err && idx < c->size / ctrl->elem_size; idx++)
>  		err = ctrl->type_ops->validate(ctrl, idx, ptr);
>  	return err;
> 

