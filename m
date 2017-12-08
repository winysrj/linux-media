Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:56013 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753138AbdLHKYc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Dec 2017 05:24:32 -0500
Subject: Re: [PATCH v9 19/28] rcar-vin: use different v4l2 operations in media
 controller mode
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se>
 <20171208010842.20047-20-niklas.soderlund+renesas@ragnatech.se>
 <4037381.ip89KhYXee@avalon>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <6398626e-36a1-6f4a-5bd5-c65b81a62ac1@xs4all.nl>
Date: Fri, 8 Dec 2017 11:24:26 +0100
MIME-Version: 1.0
In-Reply-To: <4037381.ip89KhYXee@avalon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

>> +static const struct v4l2_ioctl_ops rvin_mc_ioctl_ops = {
>> +	.vidioc_querycap		= rvin_querycap,
>> +	.vidioc_try_fmt_vid_cap		= rvin_mc_try_fmt_vid_cap,
>> +	.vidioc_g_fmt_vid_cap		= rvin_g_fmt_vid_cap,
>> +	.vidioc_s_fmt_vid_cap		= rvin_mc_s_fmt_vid_cap,
>> +	.vidioc_enum_fmt_vid_cap	= rvin_enum_fmt_vid_cap,
>> +
>> +	.vidioc_enum_input		= rvin_mc_enum_input,
>> +	.vidioc_g_input			= rvin_g_input,
>> +	.vidioc_s_input			= rvin_s_input,
> 
> The input API makes no sense for MC-based devices.

We've had this discussion before:

https://patchwork.linuxtv.org/patch/41857/

There was never a v3 of that patch, so nothing was done with it.

The issue here is that the spec requires G/S_INPUT to be present for
video nodes. There currently is no exception for MC devices.

Regards,

	Hans
