Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 310C5C43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 09:09:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 061582085A
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 09:09:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbfAOJJg (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 04:09:36 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40844 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725929AbfAOJJg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 04:09:36 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 6790A634C85;
        Tue, 15 Jan 2019 11:07:54 +0200 (EET)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1gjKhN-0004Kz-QG; Tue, 15 Jan 2019 11:07:53 +0200
Date:   Tue, 15 Jan 2019 11:07:53 +0200
From:   Sakari Ailus <sakari.ailus@iki.fi>
To:     Lubomir Rintel <lkundrak@v3.sk>
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 5/5] media: ov7670: split register setting from
 set_framerate() logic
Message-ID: <20190115090753.igsi76bmmpbahiap@valkosipuli.retiisi.org.uk>
References: <20190115085448.1400135-1-lkundrak@v3.sk>
 <20190115085448.1400135-6-lkundrak@v3.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190115085448.1400135-6-lkundrak@v3.sk>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Jan 15, 2019 at 09:54:48AM +0100, Lubomir Rintel wrote:
> This will allow us to restore the last set frame rate after the device
> returns from a power off.
> 
> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>

Thanks!

I've applied them, and hopefully all is well now.

> ---
>  drivers/media/i2c/ov7670.c | 26 ++++++++++++++------------
>  1 file changed, 14 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
> index d0f40d5f6ca0..6f9a53d4dcfc 100644
> --- a/drivers/media/i2c/ov7670.c
> +++ b/drivers/media/i2c/ov7670.c
> @@ -812,13 +812,24 @@ static void ov7675_get_framerate(struct v4l2_subdev *sd,
>  			(4 * clkrc);
>  }
>  
> +static int ov7675_apply_framerate(struct v4l2_subdev *sd)
> +{
> +	struct ov7670_info *info = to_state(sd);
> +	int ret;
> +
> +	ret = ov7670_write(sd, REG_CLKRC, info->clkrc);
> +	if (ret < 0)
> +		return ret;
> +
> +	return ov7670_write(sd, REG_DBLV, info->pll_bypass ? DBLV_BYPASS : DBLV_X4);

I wrapped this to avoid it exceeding 80... no other changes.

> +}

-- 
Sakari Ailus
