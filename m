Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3551 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934849Ab3DJR0P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Apr 2013 13:26:15 -0400
From: Hans Verkuil <hansverk@cisco.com>
To: linux-media@vger.kernel.org
Subject: Re: [REVIEWv2 PATCH 12/12] hdpvr: allow g/s_std when in legacy mode.
Date: Wed, 10 Apr 2013 19:25:49 +0200
Cc: leo@lumanate.com, Janne Grunau <j@jannau.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1365418721-23859-1-git-send-email-hverkuil@xs4all.nl> <1365418721-23859-13-git-send-email-hverkuil@xs4all.nl> <201304101827.43541.hverkuil@xs4all.nl>
In-Reply-To: <201304101827.43541.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304101925.49659.hansverk@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed April 10 2013 18:27:43 Hans Verkuil wrote:
> Leo, can you verify that this works for you as well? I tested it without
> problems with MythTV and gstreamer.
> 
> Thanks!
> 
> 	Hans
> 
> Both MythTV and gstreamer expect that they can set/get/query/enumerate the
> standards, even if the input is the component input for which standards
> really do not apply.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/usb/hdpvr/hdpvr-video.c |   40 ++++++++++++++++++++++++---------
>  1 file changed, 29 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
> index 4376309..38724d7 100644
> --- a/drivers/media/usb/hdpvr/hdpvr-video.c
> +++ b/drivers/media/usb/hdpvr/hdpvr-video.c


> -static int vidioc_enum_input(struct file *file, void *priv,
> -				struct v4l2_input *i)
> +static int vidioc_enum_input(struct file *file, void *_fh, struct v4l2_input *i)
>  {
> +	struct hdpvr_fh *fh = _fh;
>  	unsigned int n;
>  
>  	n = i->index;
> @@ -758,13 +761,15 @@ static int vidioc_enum_input(struct file *file, void *priv,
>  
>  	i->audioset = 1<<HDPVR_RCA_FRONT | 1<<HDPVR_RCA_BACK | 1<<HDPVR_SPDIF;
>  
> +	if (fh->legacy_mode)
> +		n = 1;

Oops, these two lines should be removed. Otherwise non-legacy apps like qv4l2 will
break as they rely on accurate capability reporting.

>  	i->capabilities = n ? V4L2_IN_CAP_STD : V4L2_IN_CAP_DV_TIMINGS;
>  	i->std = n ? V4L2_STD_ALL : 0;
>  
>  	return 0;
>  }

Regards,

	Hans
