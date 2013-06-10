Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:42500 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab3FJNp3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jun 2013 09:45:29 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MO600ER7JHBPU80@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 10 Jun 2013 14:45:27 +0100 (BST)
Message-id: <51B5D876.2000704@samsung.com>
Date: Mon, 10 Jun 2013 15:45:26 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Arun Kumar K <arun.kk@samsung.com>
Cc: linux-media@vger.kernel.org, k.debski@samsung.com,
	jtp.park@samsung.com, avnd.kiran@samsung.com,
	arunkk.samsung@gmail.com
Subject: Re: [PATCH 5/6] [media] V4L: Add VP8 encoder controls
References: <1370870586-24141-1-git-send-email-arun.kk@samsung.com>
 <1370870586-24141-6-git-send-email-arun.kk@samsung.com>
In-reply-to: <1370870586-24141-6-git-send-email-arun.kk@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

On 06/10/2013 03:23 PM, Arun Kumar K wrote:
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index fccd08b..2cf17d4 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -456,6 +456,23 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>  		"RGB full range (0-255)",
>  		NULL,
>  	};
> +	static const char * const vpx_num_partitions[] = {
> +		"1 partition",
> +		"2 partitions",
> +		"4 partitions",
> +		"8 partitions",
> +		NULL,
> +	};
> +	static const char * const vpx_num_ref_frames[] = {
> +		"1 reference frame",
> +		"2 reference frame",
> +		NULL,
> +	};

Have you considered using V4L2_CTRL_TYPE_INTEGER_MENU control type for this ?
One example is V4L2_CID_ISO_SENSITIVITY control.

> +/*  VPX streams, specific to multiplexed streams */
> +#define V4L2_CID_VPX_NUM_PARTITIONS		(V4L2_CID_VPX_BASE+0)
> +enum v4l2_vp8_num_partitions {
> +	V4L2_VPX_1_PARTITION	= 0,
> +	V4L2_VPX_2_PARTITIONS	= (1 << 1),
> +	V4L2_VPX_4_PARTITIONS	= (1 << 2),
> +	V4L2_VPX_8_PARTITIONS	= (1 << 3),
> +};

I think we could still have such standard value definitions if needed,
but rather in form of:

#define V4L2_VPX_1_PARTITION	1
#define V4L2_VPX_2_PARTITIONS	2
#define V4L2_VPX_4_PARTITIONS	4
#define V4L2_VPX_8_PARTITIONS	8

> +#define V4L2_CID_VPX_IMD_DISABLE_4X4		(V4L2_CID_VPX_BASE+1)
> +#define V4L2_CID_VPX_NUM_REF_FRAMES		(V4L2_CID_VPX_BASE+2)
> +enum v4l2_vp8_num_ref_frames {
> +	V4L2_VPX_1_REF_FRAME	= 0,
> +	V4L2_VPX_2_REF_FRAME	= 1,
> +};

Regards,
Sylwester
