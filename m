Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:44078 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751158AbcBOKsU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2016 05:48:20 -0500
Subject: Re: [RFC/PATCH] [media] rcar-vin: add Renesas R-Car VIN IP core
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>, mchehab@osg.samsung.com,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hans.verkuil@cisco.com
References: <1455468932-8573-1-git-send-email-niklas.soderlund+renesas@ragnatech.se>
 <56C19A2B.2080502@xs4all.nl>
Cc: linux-renesas-soc@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56C1ACEE.4060203@xs4all.nl>
Date: Mon, 15 Feb 2016 11:48:14 +0100
MIME-Version: 1.0
In-Reply-To: <56C19A2B.2080502@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/15/2016 10:28 AM, Hans Verkuil wrote:
>> +static const struct v4l2_ioctl_ops rvin_ioctl_ops = {
>> +	.vidioc_querycap		= rvin_querycap,
>> +	.vidioc_try_fmt_vid_cap		= rvin_try_fmt_vid_cap,
>> +	.vidioc_g_fmt_vid_cap		= rvin_g_fmt_vid_cap,
>> +	.vidioc_s_fmt_vid_cap		= rvin_s_fmt_vid_cap,
>> +	.vidioc_enum_fmt_vid_cap	= rvin_enum_fmt_vid_cap,
>> +
>> +	/* TODO:
>> +	 * .vidioc_g_selection		= rvin_g_selection,
>> +	 * .vidioc_s_selection		= rvin_s_selection,
>> +	 */
>> +
>> +	.vidioc_enum_input		= rvin_enum_input,
>> +	.vidioc_g_input			= rvin_g_input,
>> +	.vidioc_s_input			= rvin_s_input,
> 
> I'm missing g/s/querystd here!
> 
> (enum_std is handled by the core)
> 
>> +
>> +	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
>> +	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
>> +	.vidioc_querybuf		= vb2_ioctl_querybuf,
>> +	.vidioc_qbuf			= vb2_ioctl_qbuf,
>> +	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
>> +	.vidioc_expbuf			= vb2_ioctl_expbuf,

Please add .vidioc_prepare_buf = vb2_ioctl_prepare_buf here as well.

Regards,

	Hans

>> +
>> +	.vidioc_streamon		= rvin_streamon,
>> +	.vidioc_streamoff		= rvin_streamoff,
>> +
>> +	.vidioc_log_status		= v4l2_ctrl_log_status,
>> +	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
>> +	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
>> +};
