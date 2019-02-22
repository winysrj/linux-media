Return-Path: <SRS0=hjs2=Q5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 898F4C43381
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 11:10:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C5AD206B6
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 11:10:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="aUs5BoeI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbfBVLKV (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Feb 2019 06:10:21 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:33776 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbfBVLKV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Feb 2019 06:10:21 -0500
Received: from pendragon.ideasonboard.com (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id DD4CD2D2;
        Fri, 22 Feb 2019 12:10:19 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1550833820;
        bh=ZGRDnOjSQAFpRr++q7XHtIyw96Hs2wx5dlLqYTPRWSo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aUs5BoeIDCEqpmN465A+hM/T4T6NOPtyiJ2YE4E1ukF7rHsP/eQRdzLdzUESoWWFL
         aIGjN6rGX7oMGoL6ZZDRpRWbayvsn5rZOqG9cpVku3ASggoUVX+nKkXUGB9pnE/vtp
         CFaFPhoMyr1xyFiIMO5WK6txvQkopDOU38oJr7zs=
Date:   Fri, 22 Feb 2019 13:10:15 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc:     linux-media@vger.kernel.org,
        Helen Koike <helen.koike@collabora.com>
Subject: Re: [PATCH 1/7] cec: fill in cec chardev kobject to ease debugging
Message-ID: <20190222111015.GL3522@pendragon.ideasonboard.com>
References: <20190221142148.3412-1-hverkuil-cisco@xs4all.nl>
 <20190221142148.3412-2-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190221142148.3412-2-hverkuil-cisco@xs4all.nl>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

Thank you for the patch.

On Thu, Feb 21, 2019 at 03:21:42PM +0100, Hans Verkuil wrote:
> The cec chardev kobject has no name, which made it hard to
> debug when kobject debugging is turned on.
> 
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/cec/cec-core.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/cec/cec-core.c b/drivers/media/cec/cec-core.c
> index cc875dabd765..f5d1578e256a 100644
> --- a/drivers/media/cec/cec-core.c
> +++ b/drivers/media/cec/cec-core.c
> @@ -126,6 +126,7 @@ static int __must_check cec_devnode_register(struct cec_devnode *devnode,
>  	/* Part 2: Initialize and register the character device */
>  	cdev_init(&devnode->cdev, &cec_devnode_fops);
>  	devnode->cdev.owner = owner;
> +	kobject_set_name(&devnode->cdev.kobj, "cec%d", devnode->minor);
>  
>  	ret = cdev_device_add(&devnode->cdev, &devnode->dev);
>  	if (ret) {

-- 
Regards,

Laurent Pinchart
