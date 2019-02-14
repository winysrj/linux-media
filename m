Return-Path: <SRS0=jAfH=QV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC6C9C43381
	for <linux-media@archiver.kernel.org>; Thu, 14 Feb 2019 12:52:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 823C9222B6
	for <linux-media@archiver.kernel.org>; Thu, 14 Feb 2019 12:52:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="NsfyB83F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438539AbfBNMwv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 14 Feb 2019 07:52:51 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:41930 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438534AbfBNMwu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Feb 2019 07:52:50 -0500
Received: from pendragon.ideasonboard.com (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id C66662DF;
        Thu, 14 Feb 2019 13:52:48 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1550148768;
        bh=DiIp9xAWR6Gsjl/H4uYfhcHYAG8clN9qZnt+0XVRYeE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NsfyB83FqdT1wJiTVpeaFlFb4EI7TN4+UILhUfmAdQS6nI5YAaEjq8dGbqjwPtruY
         TIQw/o+2M7w80C5uO2fMJlcPUJc2yxYASQUsGnF+n8Fg6fFvBYzVmP+XdvDp59mHvz
         kSW5vR26Bmg7pa3/lxyLin20hIehGwyzSwV3y+NA=
Date:   Thu, 14 Feb 2019 14:52:45 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] uvc: use usb_make_path to fill in usb_info
Message-ID: <20190214125245.GH3682@pendragon.ideasonboard.com>
References: <13e25527-e44b-2c6d-120c-b6d5d4f3432c@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <13e25527-e44b-2c6d-120c-b6d5d4f3432c@xs4all.nl>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

Thank you for the patch.

On Fri, Feb 01, 2019 at 10:57:31AM +0100, Hans Verkuil wrote:
> The uvc driver uses this function to fill in bus_info for VIDIOC_QUERYCAP,
> so use the same function when filling in the bus_info for the media device.
> 
> The current implementation only fills in part of the info. E.g. if the full
> bus_info is usb-0000:01:00.0-1.4.2, then the media bus_info only has 1.4.2.
> 
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

This makes sense, even if in the long run we'll likely have to revisit
bus info.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree.

> ---
> diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
> index b62cbd800111..068cabf141c1 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -2175,7 +2175,7 @@ static int uvc_probe(struct usb_interface *intf,
>  	if (udev->serial)
>  		strscpy(dev->mdev.serial, udev->serial,
>  			sizeof(dev->mdev.serial));
> -	strscpy(dev->mdev.bus_info, udev->devpath, sizeof(dev->mdev.bus_info));
> +	usb_make_path(udev, dev->mdev.bus_info, sizeof(dev->mdev.bus_info));
>  	dev->mdev.hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
>  	media_device_init(&dev->mdev);
> 

-- 
Regards,

Laurent Pinchart
