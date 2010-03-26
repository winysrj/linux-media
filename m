Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1678 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165Ab0CZL6Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Mar 2010 07:58:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 2/3 v2] V4L: v4l2-subdev driver for AK8813 and AK8814 TV-encoders from AKM
Date: Fri, 26 Mar 2010 12:58:34 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Magnus Damm <damm@opensource.se>,
	"linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
References: <Pine.LNX.4.64.1003171103030.4354@axis700.grange> <Pine.LNX.4.64.1003181051420.4485@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1003181051420.4485@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003261258.34469.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 18 March 2010 11:28:32 Guennadi Liakhovetski wrote:
> diff --git a/drivers/media/video/ak881x.c b/drivers/media/video/ak881x.c
...
> +static int ak881x_s_std_output(struct v4l2_subdev *sd, v4l2_std_id std)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	struct ak881x *ak881x = to_ak881x(client);
> +	u8 vp1;
> +
> +	switch (std) {
> +	case V4L2_STD_NTSC_M:
> +	default:
> +		vp1 = 0;
> +		ak881x->lines = 480;
> +		break;
> +	case V4L2_STD_NTSC_443:
> +		vp1 = 3;
> +		ak881x->lines = 480;
> +		break;
> +	case V4L2_STD_PAL_M:
> +		vp1 = 5;
> +		ak881x->lines = 480;
> +		break;
> +	case V4L2_STD_PAL_60:
> +		vp1 = 7;
> +		ak881x->lines = 480;
> +		break;
> +	case V4L2_STD_PAL_B:
> +	case V4L2_STD_PAL_D:
> +	case V4L2_STD_PAL_G:
> +	case V4L2_STD_PAL_H:
> +	case V4L2_STD_PAL_I:
> +		vp1 = 0xf;
> +		ak881x->lines = 576;
> +	}
> +
> +	reg_set(client, AK881X_VIDEO_PROCESS1, vp1, 0xf);
> +
> +	return 0;
> +}

This is not correct. The std is a bitmask but multiple bits can be set
(and usually are). In general this should be written like this:

if (std == V4L2_STD_NTSC_443) {
	vp1 = 3;
	ak881x->lines = 480;
} else if (std == V4L2_STD_PAL_M) {
	...
} else if (std == V4L2_STD_PAL_60) {
	...
} else if (std & V4L2_STD_PAL) {
	...
} else if (std & V4L2_STD_NTSC) {
	...
} else {
	/* No SECAM or PAL_N/Nc supported */
	return -EINVAL;
}

In all modern video encoders or decoders all PAL variants are handled
automatically. Only some very old tuners have restrictions.

I would also be surprised if this device didn't handle SECAM as well.

Changing the code like this will also fix the problem you had with ENUMSTD.
Requiring applications to show the full list of all variants is something
the end user will not understand (heck, *I* wouldn't understand either!).

My experience is that the list of formats that really matter is this:

NTSC
NTSC-443
PAL-M
PAL-N
PAL-Nc
PAL-60
(PAL-I in rare cases)
PAL (all others)
SECAM-BGH
SECAM-DK
SECAM-L
(SECAM-Lc is no longer used in practice)

In the case of S-Video/Composite input or output this list is even shorter:

NTSC-443
NTSC
PAL-M
PAL-N
PAL-Nc
PAL-60
PAL
SECAM

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
