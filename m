Return-path: <mchehab@pedra>
Received: from mailout2.samsung.com ([203.254.224.25]:53759 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331Ab1DDMUu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Apr 2011 08:20:50 -0400
Received: from epmmp2 (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LJ4003NPNMOGO90@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 04 Apr 2011 21:20:48 +0900 (KST)
Received: from NOSUNGCHUNK01 ([12.23.102.212])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LJ400KN4NMPRM@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 04 Apr 2011 21:20:49 +0900 (KST)
Date: Mon, 04 Apr 2011 21:20:47 +0900
From: Sungchun Kang <sungchun.kang@samsung.com>
Subject: RE: [PATCH] Add support for M-5MOLS 8 Mega Pixel camera
In-reply-to: <1300282723-31536-1-git-send-email-riverful.kim@samsung.com>
To: "'Kim, Heungjun'" <riverful.kim@samsung.com>,
	linux-media@vger.kernel.org
Reply-to: sungchun.kang@samsung.com
Message-id: <007901cbf2c2$bb240bb0$316c2310$%kang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-language: ko
Content-transfer-encoding: 7BIT
References: <1300282723-31536-1-git-send-email-riverful.kim@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi heungjun,
I have tested this version for a few days.

On 03/16/2011 10:30 PM, Kim, Heungjun wrote:
> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Kim, Heungjun
> Sent: Wednesday, March 16, 2011 10:39 PM
> To: linux-media@vger.kernel.org
> Cc: hverkuil@xs4all.nl; laurent.pinchart@ideasonboard.com; Kim,
> Heungjun; Sylwester Nawrocki; Kyungmin Park
> Subject: [PATCH] Add support for M-5MOLS 8 Mega Pixel camera
> 
> Add I2C/V4L2 subdev driver for M-5MOLS camera sensor with integrated
> image signal processor.
> 
> Signed-off-by: Heungjun Kim <riverful.kim@samsung.com>
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> 
> Hi Hans and everyone,
> 
> This is sixth version of M-5MOLS 8 Mega Pixel camera sensor. And, if
> you see
> previous version, you can find at:
> http://www.spinics.net/lists/linux-media/msg29350.html
> 
> This driver patch is fixed several times, and the important issues is
> almost
> corrected. And, I hope that this is the last version one merged for
> 2.6.39.
> I look forward to be reviewed one more time.
> 
> The summary of this version's feature is belows:
> 
> 1. Add focus control
> 	: I've suggest menu type focus control, but I agreed this
> version is
> 	not yet the level accepted. So, I did not use focus control
> which
> 	I suggest.
> 	The M-5MOLS focus routine takes some time to execute. But, the
> user
> 	application calling v4l2 control, should not hanged while
> streaming
> 	using q/dqbuf. So, I use workqueue. I want to discuss the focus
> 	subject on mailnglist next time.
> 

I wonder this feature is dependent on this firmware version?

.....snip

> +static int m5mols_start_monitor(struct v4l2_subdev *sd)
> +{
> +	struct m5mols_info *info = to_m5mols(sd);
> +	int ret;
> +
> +	ret = m5mols_set_mode(sd, MODE_PARAM);
> +	if (!ret)
> +		ret = i2c_w8_param(sd, CAT1_MONITOR_SIZE, info-
> >res_preset);
> +	if (!ret)
> +		ret = i2c_w8_param(sd, CAT1_MONITOR_FPS, info->fps_preset);
> +	if (!ret)
> +		ret = m5mols_set_mode(sd, MODE_MONITOR);
> +	if (!ret && info->do_once) {
> +		/* After probing the driver, this should be callde once.
> */
> +		v4l2_ctrl_handler_setup(&info->handle);
As test result, When sensor is set monitor mode, if this API is called, 
Preview data(get from sensor) is craked. Surely, it is good working if this API is called in paramset mode.
That waw no problem in Version 5. Because it is returned before v4l2_ctrl_handler_init()
In m5mols_init_controls(version 5) :
	ret = i2c_r16_ae(sd, CAT3_MAX_GAIN_MON, (u32 *)&max_ex_mon);
	if (ret) 
		return ret; // if success, return.

My test case is :
S_power->s_fmt->s_stream.

.....
BRs Sungchun.

