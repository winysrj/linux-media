Return-Path: <SRS0=J9mZ=O3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45980C43387
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 22:03:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3E79218AC
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 22:03:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="l3+V3dJS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbeLRWDD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 18 Dec 2018 17:03:03 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:33758 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727034AbeLRWDC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Dec 2018 17:03:02 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 812DC549;
        Tue, 18 Dec 2018 23:03:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1545170580;
        bh=2jrx7mUQk+Fbu0V+h/9QSZFaGTQ7drS0MyDWPBvRKvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l3+V3dJSsPA1pxmkrDJhpF4rv5AfcecEJYDaJ2G00gcQfGUQcg9/wDUlLPrfJq7vB
         NmbdOQrk6n1vO5b6rW9mmqvzzS8p00wXT4DA+kv1lvo1yy7jXRQ8EggD4E3lXqgzaC
         ZjAr3XG3L1xSGw70OXSqgN6KBe9IAm8A5gCyhpv8=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH] v4l2-ctrls.c/uvc: zero v4l2_event
Date:   Wed, 19 Dec 2018 00:03:52 +0200
Message-ID: <4077901.8aWBV7DY5T@avalon>
Organization: Ideas on Board Oy
In-Reply-To: <7ae211a5-29e2-0458-befc-20ef391d87e0@xs4all.nl>
References: <7ae211a5-29e2-0458-befc-20ef391d87e0@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

Thank you for the patch.

On Tuesday, 18 December 2018 15:37:08 EET Hans Verkuil wrote:
> Control events can leak kernel memory since they do not fully zero the
> event. The same code is present in both v4l2-ctrls.c and uvc_ctrl.c, so
> fix both.
> 
> It appears that all other event code is properly zeroing the structure,
> it's these two places.

Indeed :-(

maybe s/it's these/it's only these/ ?

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I assume you will merge this directly, without a need for me to take the patch 
in my UVC branch ?

> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> Reported-by: syzbot+4f021cf3697781dbd9fb@syzkaller.appspotmail.com
> ---
> For details see:
> https://syzkaller.appspot.com/bug?extid=4f021cf3697781dbd9fb ---
> diff --git a/drivers/media/usb/uvc/uvc_ctrl.c
> b/drivers/media/usb/uvc/uvc_ctrl.c index d45415cbe6e7..14cff91b7aea 100644
> --- a/drivers/media/usb/uvc/uvc_ctrl.c
> +++ b/drivers/media/usb/uvc/uvc_ctrl.c
> @@ -1212,7 +1212,7 @@ static void uvc_ctrl_fill_event(struct uvc_video_chain
> *chain,
> 
>  	__uvc_query_v4l2_ctrl(chain, ctrl, mapping, &v4l2_ctrl);
> 
> -	memset(ev->reserved, 0, sizeof(ev->reserved));
> +	memset(ev, 0, sizeof(*ev));
>  	ev->type = V4L2_EVENT_CTRL;
>  	ev->id = v4l2_ctrl.id;
>  	ev->u.ctrl.value = value;
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c
> b/drivers/media/v4l2-core/v4l2-ctrls.c index 5e3806feb5d7..8a82427c4d54
> 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -1387,7 +1387,7 @@ static u32 user_flags(const struct v4l2_ctrl *ctrl)
> 
>  static void fill_event(struct v4l2_event *ev, struct v4l2_ctrl *ctrl, u32
> changes) {
> -	memset(ev->reserved, 0, sizeof(ev->reserved));
> +	memset(ev, 0, sizeof(*ev));
>  	ev->type = V4L2_EVENT_CTRL;
>  	ev->id = ctrl->id;
>  	ev->u.ctrl.changes = changes;

-- 
Regards,

Laurent Pinchart



