Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51738 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752111AbdLHTb7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Dec 2017 14:31:59 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v9 19/28] rcar-vin: use different v4l2 operations in media controller mode
Date: Fri, 08 Dec 2017 21:31:58 +0200
Message-ID: <2189826.vMLFTPGfMy@avalon>
In-Reply-To: <6398626e-36a1-6f4a-5bd5-c65b81a62ac1@xs4all.nl>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se> <4037381.ip89KhYXee@avalon> <6398626e-36a1-6f4a-5bd5-c65b81a62ac1@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Friday, 8 December 2017 12:24:26 EET Hans Verkuil wrote:
> Hi Laurent,
> 
> >> +static const struct v4l2_ioctl_ops rvin_mc_ioctl_ops = {
> >> +	.vidioc_querycap		= rvin_querycap,
> >> +	.vidioc_try_fmt_vid_cap		= rvin_mc_try_fmt_vid_cap,
> >> +	.vidioc_g_fmt_vid_cap		= rvin_g_fmt_vid_cap,
> >> +	.vidioc_s_fmt_vid_cap		= rvin_mc_s_fmt_vid_cap,
> >> +	.vidioc_enum_fmt_vid_cap	= rvin_enum_fmt_vid_cap,
> >> +
> >> +	.vidioc_enum_input		= rvin_mc_enum_input,
> >> +	.vidioc_g_input			= rvin_g_input,
> >> +	.vidioc_s_input			= rvin_s_input,
> > 
> > The input API makes no sense for MC-based devices.
> 
> We've had this discussion before:
> 
> https://patchwork.linuxtv.org/patch/41857/
> 
> There was never a v3 of that patch, so nothing was done with it.
> 
> The issue here is that the spec requires G/S_INPUT to be present for
> video nodes. There currently is no exception for MC devices.

I think we both agree that we should fix the spec :-) It shouldn't be a big 
deal as MC-enabled applications running with an MC-enabled driver don't use 
the input API anyway.

-- 
Regards,

Laurent Pinchart
