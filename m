Return-Path: <SRS0=qcaw=OS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17C54C07E85
	for <linux-media@archiver.kernel.org>; Sun,  9 Dec 2018 12:30:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6357020837
	for <linux-media@archiver.kernel.org>; Sun,  9 Dec 2018 12:30:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="JWC6M3fH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6357020837
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ideasonboard.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbeLIMaK (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 9 Dec 2018 07:30:10 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:57416 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbeLIMaK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Dec 2018 07:30:10 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 67F9D50A;
        Sun,  9 Dec 2018 13:30:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1544358607;
        bh=juGjtmGjtivEkaVF83tolmi5KCxZ8qx2kwfpzMl1WDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JWC6M3fHyXxc9tdGvZ7d8NeAfq3nlTKLrS2RJChrYhIhJkJ5APE1TFQfhmuMkCm3u
         LBIRI8QykYqf0NOxiMCMk+wbtVKW3EkOOISbq5XWbzR1BR9MPIA0ElvcvavbyS9Rqi
         yF61TsmFzA1SMJ50cZ3W/jWizmb3b8ix0Nbg7R2g=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     "French, Nicholas A." <naf@ou.edu>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        David Airlie <airlied@linux.ie>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Adam Stylinski <kungfujesus06@gmail.com>
Subject: Re: [PATCH] media: lgdt330x: fix lock status reporting
Date:   Sun, 09 Dec 2018 14:30:45 +0200
Message-ID: <5723567.48LNoDpVUn@avalon>
Organization: Ideas on Board Oy
In-Reply-To: <20181209071054.GA14422@tivo>
References: <20181209071054.GA14422@tivo>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello Nick,

Thank you for the patch.

On Sunday, 9 December 2018 09:11:18 EET French, Nicholas A. wrote:
> A typo in code cleanup commit db9c1007bc07 ("media: lgdt330x: do
> some cleanups at status logic") broke the FE_HAS_LOCK reporting
> for 3303 chips by inadvertently modifying the register mask.
> 
> The broken lock status is critial as it prevents video capture
> cards from reporting signal strength, scanning for channels,
> and capturing video.
> 
> Fix regression by reverting mask change.
> 
> Signed-off-by: Nick French <naf@ou.edu>

This looks good to me. The patch should have a

Fixes: db9c1007bc07 ("media: lgdt330x: do some cleanups at status logic")

line though. With that added,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

The patch that broke this was committed without any review. Once again we get 
a proof that this isn't an acceptable policy. The review process needs to be 
fixed.

> ---
>  drivers/media/dvb-frontends/lgdt330x.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/dvb-frontends/lgdt330x.c
> b/drivers/media/dvb-frontends/lgdt330x.c index 96807e134886..8abb1a510a81
> 100644
> --- a/drivers/media/dvb-frontends/lgdt330x.c
> +++ b/drivers/media/dvb-frontends/lgdt330x.c
> @@ -783,7 +783,7 @@ static int lgdt3303_read_status(struct dvb_frontend *fe,
> 
>  		if ((buf[0] & 0x02) == 0x00)
>  			*status |= FE_HAS_SYNC;
> -		if ((buf[0] & 0xfd) == 0x01)
> +		if ((buf[0] & 0x01) == 0x01)
>  			*status |= FE_HAS_VITERBI | FE_HAS_LOCK;
>  		break;
>  	default:

-- 
Regards,

Laurent Pinchart



