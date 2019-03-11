Return-Path: <SRS0=G3Vt=RO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D997DC43381
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 09:18:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3E932075C
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 09:18:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbfCKJSb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Mar 2019 05:18:31 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:43797 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726897AbfCKJSb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Mar 2019 05:18:31 -0400
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1h3H4f-0004xL-7e; Mon, 11 Mar 2019 10:18:21 +0100
Message-ID: <1552295898.3334.3.camel@pengutronix.de>
Subject: Re: [PATCH] media: video-mux: fix  null pointer dereferences
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Kangjie Lu <kjlu@umn.edu>
Cc:     pakki001@umn.edu, Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 11 Mar 2019 10:18:18 +0100
In-Reply-To: <20190309072056.4618-1-kjlu@umn.edu>
References: <20190309072056.4618-1-kjlu@umn.edu>
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

On Sat, 2019-03-09 at 01:20 -0600, Kangjie Lu wrote:
> devm_kcalloc may fail and return a null pointer. The fix returns
> -ENOMEM upon failures to avoid null pointer dereferences.
> 
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>
> ---
>  drivers/media/platform/video-mux.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/media/platform/video-mux.c b/drivers/media/platform/video-mux.c
> index c33900e3c23e..4135165cdabe 100644
> --- a/drivers/media/platform/video-mux.c
> +++ b/drivers/media/platform/video-mux.c
> @@ -399,9 +399,14 @@ static int video_mux_probe(struct platform_device *pdev)
>  	vmux->active = -1;
>  	vmux->pads = devm_kcalloc(dev, num_pads, sizeof(*vmux->pads),
>  				  GFP_KERNEL);
> +	if (!vmux->pads)
> +		return -ENOMEM;
> +
>  	vmux->format_mbus = devm_kcalloc(dev, num_pads,
>  					 sizeof(*vmux->format_mbus),
>  					 GFP_KERNEL);
> +	if (!vmux->format_mbus)
> +		return -ENOMEM;
>  
>  	for (i = 0; i < num_pads; i++) {
>  		vmux->pads[i].flags = (i < num_pads - 1) ? MEDIA_PAD_FL_SINK

Thank you,
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp
