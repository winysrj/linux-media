Return-Path: <SRS0=BdY7=QG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67894C282D7
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 09:17:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D4A22083B
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 09:17:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="P2IxBx6H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730223AbfA3JRn (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 30 Jan 2019 04:17:43 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:48542 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbfA3JRn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Jan 2019 04:17:43 -0500
Received: from pendragon.ideasonboard.com (85-76-73-0-nat.elisa-mobile.fi [85.76.73.0])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 056C641;
        Wed, 30 Jan 2019 10:17:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1548839862;
        bh=/LZyEzxwZT/FR3/ySvAsXexsFYloSoTOH8hDoTVpA3s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P2IxBx6HlmDfls/SvpP2P1sVOO5/i+1Z+q69INoIhoHcAuHQnJ2hc4DYsLp+T+VCy
         OWZrKCCQWCGIm50h7Heli4pDWJcc9XXV+q93kjeoY4SwK/oZ7Cwp4tg5DKL24fQZI5
         x0i38EsY+wNE+eIKDW8au7i6x0jT94eIm7rRt9a8=
Date:   Wed, 30 Jan 2019 11:17:37 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     linux-media@vger.kernel.org, chiranjeevi.rapolu@intel.com
Subject: Re: [PATCH 1/1] uvc: Avoid NULL pointer dereference at the end of
 streaming
Message-ID: <20190130091737.GB4336@pendragon.ideasonboard.com>
References: <20190129214944.16875-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190129214944.16875-1-sakari.ailus@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Sakari,

Thank you for the patch.

On Tue, Jan 29, 2019 at 11:49:44PM +0200, Sakari Ailus wrote:
> The UVC video driver converts the timestamp from hardware specific unit to
> one known by the kernel at the time when the buffer is dequeued. This is
> fine in general, but the streamoff operation consists of the following
> steps (among other things):
> 
> 1. uvc_video_clock_cleanup --- the hardware clock sample array is
>    released and the pointer to the array is set to NULL,
> 
> 2. buffers in active state are returned to the user and
> 
> 3. buf_finish callback is called on buffers that are prepared. buf_finish
>    includes calling uvc_video_clock_update that accesses the hardware
>    clock sample array.
> 
> The above is serialised by a queue specific mutex. Address the problem by
> skipping the clock conversion if the hardware clock sample array is
> already released.
> 
> Reported-by: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
> Tested-by: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

The analysis looks good to me.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
> Hi Laurent,
> 
> This seems like something that's been out there for a while... I'll figure
> out soon which stable kernels should receive it, if any.

Should I wait for the proper Fixes: and Cc:stable tags before queuing
this patch then ?

>  drivers/media/usb/uvc/uvc_video.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
> index 84525ff047450..a30c5e1893e72 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -676,6 +676,13 @@ void uvc_video_clock_update(struct uvc_streaming *stream,
>  	if (!uvc_hw_timestamps_param)
>  		return;
>  
> +	/*
> +	 * We may get called if there are buffers done but not dequeued by the
> +	 * user. Just bail out in that case.
> +	 */
> +	if (!clock->samples)
> +		return;
> +
>  	spin_lock_irqsave(&clock->lock, flags);
>  
>  	if (clock->count < clock->size)

-- 
Regards,

Laurent Pinchart
