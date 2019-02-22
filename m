Return-Path: <SRS0=hjs2=Q5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E307C43381
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 11:10:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C742A206B6
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 11:10:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="MVgGiQb2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726337AbfBVLKA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Feb 2019 06:10:00 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:33762 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbfBVLKA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Feb 2019 06:10:00 -0500
Received: from pendragon.ideasonboard.com (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id EEC782D2;
        Fri, 22 Feb 2019 12:09:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1550833798;
        bh=IOMDel/04PgcpO8fEoNrzjt+NNv0pzrnuLY2gtkWnF8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MVgGiQb29Xqrv/lMDYDA8QA/wfjampxShcK+3y+lQ+lkdRa63Jv1ahsI0Nr2T2Ijt
         TevLoRXablQ5tcOD/HhYSxbEDGlgBFeKclsO5hmIY0AmpmLcPOlaRnhH8JjXAYNCIt
         Cb/GWPLuFLJPfeXJOhXQ8cEzuZsppVbyHh3PsJJo=
Date:   Fri, 22 Feb 2019 13:09:53 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc:     linux-media@vger.kernel.org,
        Helen Koike <helen.koike@collabora.com>
Subject: Re: [PATCH 3/7] vivid: use vzalloc for dev->bitmap_out
Message-ID: <20190222110953.GK3522@pendragon.ideasonboard.com>
References: <20190221142148.3412-1-hverkuil-cisco@xs4all.nl>
 <20190221142148.3412-4-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190221142148.3412-4-hverkuil-cisco@xs4all.nl>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

Thank you for the patch.

On Thu, Feb 21, 2019 at 03:21:44PM +0100, Hans Verkuil wrote:
> When vivid is unloaded it used vfree to free dev->bitmap_out,
> but it was actually allocated using kmalloc. Use vzalloc
> instead, conform what vivid-vid-cap.c does.
> 
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/vivid/vivid-vid-out.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
> index e61b91b414f9..9350ca65dd91 100644
> --- a/drivers/media/platform/vivid/vivid-vid-out.c
> +++ b/drivers/media/platform/vivid/vivid-vid-out.c
> @@ -798,7 +798,7 @@ int vivid_vid_out_s_selection(struct file *file, void *fh, struct v4l2_selection
>  		s->r.height *= factor;
>  		if (dev->bitmap_out && (compose->width != s->r.width ||
>  					compose->height != s->r.height)) {
> -			kfree(dev->bitmap_out);
> +			vfree(dev->bitmap_out);
>  			dev->bitmap_out = NULL;
>  		}
>  		*compose = s->r;
> @@ -941,15 +941,19 @@ int vidioc_s_fmt_vid_out_overlay(struct file *file, void *priv,
>  		return ret;
>  
>  	if (win->bitmap) {
> -		new_bitmap = memdup_user(win->bitmap, bitmap_size);
> +		new_bitmap = vzalloc(bitmap_size);
>  
> -		if (IS_ERR(new_bitmap))
> -			return PTR_ERR(new_bitmap);
> +		if (!new_bitmap)
> +			return -ENOMEM;
> +		if (copy_from_user(new_bitmap, win->bitmap, bitmap_size)) {
> +			vfree(new_bitmap);
> +			return -EFAULT;
> +		}
>  	}
>  
>  	dev->overlay_out_top = win->w.top;
>  	dev->overlay_out_left = win->w.left;
> -	kfree(dev->bitmap_out);
> +	vfree(dev->bitmap_out);
>  	dev->bitmap_out = new_bitmap;
>  	dev->clipcount_out = win->clipcount;
>  	if (dev->clipcount_out)

-- 
Regards,

Laurent Pinchart
