Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:33189 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950AbZDGT4p (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Apr 2009 15:56:45 -0400
Date: Tue, 7 Apr 2009 12:56:43 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: "Dean A." <dean@sensoray.com>
cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	video4linux-list@redhat.com
Subject: Re: patch: s2255drv high quality mode and video status querying
In-Reply-To: <tkrat.2351cf1cef386315@sensoray.com>
Message-ID: <Pine.LNX.4.58.0904071254290.21204@shell2.speakeasy.net>
References: <tkrat.2351cf1cef386315@sensoray.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 7 Apr 2009, Dean A. wrote:
> +static int vidioc_g_parm(struct file *file, void *priv,
> +			 struct v4l2_streamparm *sp)
> +{
> +	struct s2255_fh *fh = priv;
> +	struct s2255_dev *dev = fh->dev;
> +	if (sp->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		return -EINVAL;

You do not need to check the buffer type, video_ioctl2 does it already.
