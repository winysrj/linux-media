Return-Path: <SRS0=J9mZ=O3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4272C43387
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 09:42:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3DC421849
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 09:42:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="MW/Kutmz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbeLRJmH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 18 Dec 2018 04:42:07 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:38432 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbeLRJmH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Dec 2018 04:42:07 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id AE2C953A;
        Tue, 18 Dec 2018 10:42:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1545126124;
        bh=XunOINnwadmpU9sTmIhA/wdBl8KY10IfxKFHeeqi4ks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MW/KutmzKu1sS4EtaZ2OypD2PbyvAUhmLLhlisfU0C8tEiKaY1QQ7VgzkDSIdqJgt
         sGx7/fnkCccezUr5U6B1fJgxJYNlLAlmqhe/wuBRJPiBpDrKWhwjeOGQG9tCFVerrQ
         rRUEyOU6GZ7azOMi+lGY07RRyJyLu7Bl3Ie+OWpc=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Alistair Strachan <astrachan@google.com>
Cc:     linux-kernel@vger.kernel.org, syzbot <syzkaller@googlegroups.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH] media: uvcvideo: Fix 'type' check leading to overflow
Date:   Tue, 18 Dec 2018 11:42:54 +0200
Message-ID: <45456214.XvNNoR8qLh@avalon>
Organization: Ideas on Board Oy
In-Reply-To: <20181217210222.115419-1-astrachan@google.com>
References: <20181217210222.115419-1-astrachan@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Alistair,

Thank you for the patch.

On Monday, 17 December 2018 23:02:22 EET Alistair Strachan wrote:
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
> This problem could be resolved in a few different ways, but this fix
> applies the same initial type check as used by UVC_ENTITY_TYPE (once we
> have a 'term' structure.) Such crafted wTerminalType fields will then be
> treated as *generic* Input Terminals, not as CAMERA or
> MEDIA_TRANSPORT_INPUT, avoiding an overflow.
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
>  drivers/media/usb/uvc/uvc_driver.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_driver.c
> b/drivers/media/usb/uvc/uvc_driver.c index bc369a0934a3..279a967b8264
> 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -1082,11 +1082,11 @@ static int uvc_parse_standard_control(struct
> uvc_device *dev, p = 0;
>  		len = 8;
> 
> -		if (type == UVC_ITT_CAMERA) {
> +		if ((type & 0x7fff) == UVC_ITT_CAMERA) {
>  			n = buflen >= 15 ? buffer[14] : 0;
>  			len = 15;
> 
> -		} else if (type == UVC_ITT_MEDIA_TRANSPORT_INPUT) {
> +		} else if ((type & 0x7fff) == UVC_ITT_MEDIA_TRANSPORT_INPUT) {
>  			n = buflen >= 9 ? buffer[8] : 0;
>  			p = buflen >= 10 + n ? buffer[9+n] : 0;
>  			len = 10;

How about rejecting invalid types instead ? Something along the lines of

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index b62cbd800111..33a22c016456 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1106,11 +1106,19 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 			return -EINVAL;
 		}
 
-		/* Make sure the terminal type MSB is not null, otherwise it
-		 * could be confused with a unit.
+		/*
+		 * Reject invalid terminal types that would cause issues:
+		 *
+		 * - The high byte must be non-zero, otherwise it would be
+		 *   confused with a unit.
+		 *
+		 * - Bit 15 must be 0, as we use it internally as a terminal
+		 *   direction flag.
+		 *
+		 * Other unknown types are accepted.
 		 */
 		type = get_unaligned_le16(&buffer[4]);
-		if ((type & 0xff00) == 0) {
+		if ((type & 0x7f00) == 0 || (type & 0x8000) != 0) {
 			uvc_trace(UVC_TRACE_DESCR, "device %d videocontrol "
 				"interface %d INPUT_TERMINAL %d has invalid "
 				"type 0x%04x, skipping\n", udev->devnum,

-- 
Regards,

Laurent Pinchart



