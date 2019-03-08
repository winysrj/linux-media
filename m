Return-Path: <SRS0=k2dg=RL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4FD8C43381
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 10:24:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0B242081B
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 10:24:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbfCHKYH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Mar 2019 05:24:07 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:60213 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbfCHKYE (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2019 05:24:04 -0500
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1h2Cfa-0001hs-Vp; Fri, 08 Mar 2019 11:24:02 +0100
Message-ID: <1552040642.4009.2.camel@pengutronix.de>
Subject: Re: [PATCH v6 1/7] gpu: ipu-v3: ipu-ic: Fix saturation bit offset
 in TPMEM
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>, stable@vger.kernel.org,
        "open list:DRM DRIVERS FOR FREESCALE IMX" 
        <dri-devel@lists.freedesktop.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Fri, 08 Mar 2019 11:24:02 +0100
In-Reply-To: <20190307233356.23748-2-slongerbeam@gmail.com>
References: <20190307233356.23748-1-slongerbeam@gmail.com>
         <20190307233356.23748-2-slongerbeam@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6-1+deb9u1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:1a17
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, 2019-03-07 at 15:33 -0800, Steve Longerbeam wrote:
> The saturation bit was being set at bit 9 in the second 32-bit word
> of the TPMEM CSC. This isn't correct, the saturation bit is bit 42,
> which is bit 10 of the second word.
> 
> Fixes: 1aa8ea0d2bd5d ("gpu: ipu-v3: Add Image Converter unit")
> 
> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/gpu/ipu-v3/ipu-ic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/ipu-v3/ipu-ic.c b/drivers/gpu/ipu-v3/ipu-ic.c
> index 594c3cbc8291..18816ccf600e 100644
> --- a/drivers/gpu/ipu-v3/ipu-ic.c
> +++ b/drivers/gpu/ipu-v3/ipu-ic.c
> @@ -257,7 +257,7 @@ static int init_csc(struct ipu_ic *ic,
>  	writel(param, base++);
>  
>  	param = ((a[0] & 0x1fe0) >> 5) | (params->scale << 8) |
> -		(params->sat << 9);
> +		(params->sat << 10);
>  	writel(param, base++);
>  
>  	param = ((a[1] & 0x1f) << 27) | ((c[0][1] & 0x1ff) << 18) |

Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp
