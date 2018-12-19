Return-Path: <SRS0=l98e=O4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D6B7C43387
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 08:17:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1C4A2184A
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 08:17:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="oQ4wMY8F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728011AbeLSIQ4 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 19 Dec 2018 03:16:56 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:59654 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727918AbeLSIQ4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Dec 2018 03:16:56 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id E5E1F549;
        Wed, 19 Dec 2018 09:16:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1545207413;
        bh=+Ihrvuu9I/2e5fhOT+vLeKL9NXmmQ+qENjywXMfbDT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oQ4wMY8FWSRd7kGGpkQIQ1D4aAgkEPC3PL5IhSFHZFiSM9LhKYr/PDkoRXe2z6sBc
         KtKp/htgkTaaEh2dVkHsjXn4wNw9t5xwgxypl97Ba4QDjRmB5vSPtTKdDn0HfY6v+t
         T+CDcid66zLPqB6CT00+sxowJHLHsBjqa7+4tDJk=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Alistair Strachan <astrachan@google.com>
Cc:     linux-kernel@vger.kernel.org, syzbot <syzkaller@googlegroups.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH v2] media: uvcvideo: Fix 'type' check leading to overflow
Date:   Wed, 19 Dec 2018 10:17:46 +0200
Message-ID: <7327024.PA5BtzYvEC@avalon>
Organization: Ideas on Board Oy
In-Reply-To: <20181219013248.94850-1-astrachan@google.com>
References: <20181219013248.94850-1-astrachan@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Alistair,

Thank you for the patch.

On Wednesday, 19 December 2018 03:32:48 EET Alistair Strachan wrote:
> From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Are you sure you don't want to keep authorship ? I've merely reviewed v1 and 
proposed an alternative implementation :-) Let me know what you would prefer 
and I'll apply this to my tree.

> When initially testing the Camera Terminal Descriptor wTerminalType
> field (buffer[4]), no mask is used. Later in the function, the MSB is
> overloaded to store the descriptor subtype, and so a mask of 0x7fff
> is used to check the type.
> 
> If a descriptor is specially crafted to set this overloaded bit in the
> original wTerminalType field, the initial type check will fail (falling
> through, without adjusting the buffer size), but the later type checks
> will pass, assuming the buffer has been made suitably large, causing an
> overflow.
> 
> Avoid this problem by checking for the MSB in the wTerminalType field.
> If the bit is set, assume the descriptor is bad, and abort parsing it.
> 
> Originally reported here:
> https://groups.google.com/forum/#!topic/syzkaller/Ot1fOE6v1d8
> A similar (non-compiling) patch was provided at that time.
> 
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Alistair Strachan <astrachan@google.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: linux-media@vger.kernel.org
> Cc: kernel-team@android.com
> ---
> v2: Use an alternative fix suggested by Laurent
>  drivers/media/usb/uvc/uvc_driver.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_driver.c
> b/drivers/media/usb/uvc/uvc_driver.c index bc369a0934a3..7fde3ce642c4
> 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -1065,11 +1065,19 @@ static int uvc_parse_standard_control(struct
> uvc_device *dev, return -EINVAL;
>  		}
> 
> -		/* Make sure the terminal type MSB is not null, otherwise it
> -		 * could be confused with a unit.
> +		/*
> +		 * Reject invalid terminal types that would cause issues:
> +		 *
> +		 * - The high byte must be non-zero, otherwise it would be
> +		 *   confused with a unit.
> +		 *
> +		 * - Bit 15 must be 0, as we use it internally as a terminal
> +		 *   direction flag.
> +		 *
> +		 * Other unknown types are accepted.
>  		 */
>  		type = get_unaligned_le16(&buffer[4]);
> -		if ((type & 0xff00) == 0) {
> +		if ((type & 0x7f00) == 0 || (type & 0x8000) != 0) {
>  			uvc_trace(UVC_TRACE_DESCR, "device %d videocontrol "
>  				"interface %d INPUT_TERMINAL %d has invalid "
>  				"type 0x%04x, skipping\n", udev->devnum,

-- 
Regards,

Laurent Pinchart



