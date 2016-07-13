Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:42084 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750901AbcGMPYS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2016 11:24:18 -0400
Date: Wed, 13 Jul 2016 12:23:31 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Philippe De Muyter <phdm@macqel.be>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [PATCH 1/2] [media] v4l2-subdev.h: allow
 V4L2_FRMIVAL_TYPE_CONTINUOUS & _STEPWISE
Message-ID: <20160713122331.62f03637@recife.lan>
In-Reply-To: <1465683659-12221-1-git-send-email-phdm@macqel.be>
References: <56E7FC02.50006@xs4all.nl>
	<1465683659-12221-1-git-send-email-phdm@macqel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 12 Jun 2016 00:20:59 +0200
Philippe De Muyter <phdm@macqel.be> escreveu:

> add max_interval and step_interval to struct
> v4l2_subdev_frame_interval_enum.
> 
> When filled correctly by the sensor driver, those fields must be
> used as follows by the intermediate level :
> 
> 	struct v4l2_frmivalenum *fival;
> 	struct v4l2_subdev_frame_interval_enum fie;
> 
> 	if (fie.max_interval.numerator == 0) {
> 		fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
> 		fival->discrete = fie.interval;
> 	} else if (fie.step_interval.numerator == 0) {
> 		fival->type = V4L2_FRMIVAL_TYPE_CONTINUOUS;
> 		fival->stepwise.min = fie.interval;
> 		fival->stepwise.max = fie.max_interval;
> 	} else {
> 		fival->type = V4L2_FRMIVAL_TYPE_STEPWISE;
> 		fival->stepwise.min = fie.interval;
> 		fival->stepwise.max = fie.max_interval;
> 		fival->stepwise.step = fie.step_interval;
> 	}
> 
> Signed-off-by: Philippe De Muyter <phdm@macqel.be>
> ---
>  include/uapi/linux/v4l2-subdev.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/v4l2-subdev.h b/include/uapi/linux/v4l2-subdev.h
> index dbce2b554..846dd36 100644
> --- a/include/uapi/linux/v4l2-subdev.h
> +++ b/include/uapi/linux/v4l2-subdev.h
> @@ -127,7 +127,9 @@ struct v4l2_subdev_frame_interval_enum {
>  	__u32 height;
>  	struct v4l2_fract interval;
>  	__u32 which;
> -	__u32 reserved[8];
> +	struct v4l2_fract max_interval;
> +	struct v4l2_fract step_interval;
> +	__u32 reserved[4];

As this changes the userspace API, you need to also patch the
Documentation/media to reflect such change and explain the meaning
for the new fields.

Please notice that the rst documentation is under the "docs-next"
branch at the media_tree.git. You should either patch against that
or wait for the end for 4.8-rc1, where the documentation will be
merged back on the master branch.

>  };
>  
>  /**


-- 
Thanks,
Mauro
