Return-Path: <SRS0=PlsX=Q4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD494C43381
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 16:22:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6D1720836
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 16:22:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="MGF6yYFY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbfBUQWP (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Feb 2019 11:22:15 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:50966 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbfBUQWO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Feb 2019 11:22:14 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id x1LGLv8j071286;
        Thu, 21 Feb 2019 10:21:57 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1550766117;
        bh=dwXIpucj52QHWAMU/Paziwg2QdnUK3QomtqWyubJYJA=;
        h=Date:From:To:CC:Subject:References:In-Reply-To;
        b=MGF6yYFYg2nOSa6bN4/tHtJ8ODUUDY68GXuJZxo9X8Y9gE8c5ZEWWTYQvQyXRZT7A
         VJrrkC7HolEjadY7vJGXdrLBpPGaalMg4n/AfYfgr4Obf8r33aAFara2b+b1psz9dP
         tm5gyep+9P/dRXUTNYSGK73Mhgkvb/vgMLkOefvI=
Received: from DLEE100.ent.ti.com (dlee100.ent.ti.com [157.170.170.30])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x1LGLvOs013829
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 21 Feb 2019 10:21:57 -0600
Received: from DLEE107.ent.ti.com (157.170.170.37) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1591.10; Thu, 21
 Feb 2019 10:21:56 -0600
Received: from dlep33.itg.ti.com (157.170.170.75) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_0,
 cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.1.1591.10 via Frontend Transport;
 Thu, 21 Feb 2019 10:21:56 -0600
Received: from ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by dlep33.itg.ti.com (8.14.3/8.13.8) with SMTP id x1LGLuSN016878;
        Thu, 21 Feb 2019 10:21:56 -0600
Date:   Thu, 21 Feb 2019 10:20:20 -0600
From:   Benoit Parrot <bparrot@ti.com>
To:     Maxime Ripard <maxime.ripard@bootlin.com>
CC:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Samuel Bobrowicz <sam@elite-embedded.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Daniel Mack <daniel@zonque.org>,
        Jacopo Mondi <jacopo@jmondi.org>
Subject: Re: [PATCH v4 05/12] media: ov5640: Compute the clock rate at runtime
Message-ID: <20190221162020.keonztyi7yq2a4hg@ti.com>
References: <20181011092107.30715-1-maxime.ripard@bootlin.com>
 <20181011092107.30715-6-maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20181011092107.30715-6-maxime.ripard@bootlin.com>
User-Agent: NeoMutt/20171215
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Maxime,

A couple of questions,

Maxime Ripard <maxime.ripard@bootlin.com> wrote on Thu [2018-Oct-11 04:21:00 -0500]:
> The clock rate, while hardcoded until now, is actually a function of the
> resolution, framerate and bytes per pixel. Now that we have an algorithm to
> adjust our clock rate, we can select it dynamically when we change the
> mode.
> 
> This changes a bit the clock rate being used, with the following effect:
> 
> +------+------+------+------+-----+-----------------+----------------+-----------+
> | Hact | Vact | Htot | Vtot | FPS | Hardcoded clock | Computed clock | Deviation |
> +------+------+------+------+-----+-----------------+----------------+-----------+
> |  640 |  480 | 1896 | 1080 |  15 |        56000000 |       61430400 | 8.84 %    |
> |  640 |  480 | 1896 | 1080 |  30 |       112000000 |      122860800 | 8.84 %    |
> | 1024 |  768 | 1896 | 1080 |  15 |        56000000 |       61430400 | 8.84 %    |
> | 1024 |  768 | 1896 | 1080 |  30 |       112000000 |      122860800 | 8.84 %    |
> |  320 |  240 | 1896 |  984 |  15 |        56000000 |       55969920 | 0.05 %    |
> |  320 |  240 | 1896 |  984 |  30 |       112000000 |      111939840 | 0.05 %    |
> |  176 |  144 | 1896 |  984 |  15 |        56000000 |       55969920 | 0.05 %    |
> |  176 |  144 | 1896 |  984 |  30 |       112000000 |      111939840 | 0.05 %    |
> |  720 |  480 | 1896 |  984 |  15 |        56000000 |       55969920 | 0.05 %    |
> |  720 |  480 | 1896 |  984 |  30 |       112000000 |      111939840 | 0.05 %    |
> |  720 |  576 | 1896 |  984 |  15 |        56000000 |       55969920 | 0.05 %    |
> |  720 |  576 | 1896 |  984 |  30 |       112000000 |      111939840 | 0.05 %    |
> | 1280 |  720 | 1892 |  740 |  15 |        42000000 |       42002400 | 0.01 %    |
> | 1280 |  720 | 1892 |  740 |  30 |        84000000 |       84004800 | 0.01 %    |
> | 1920 | 1080 | 2500 | 1120 |  15 |        84000000 |       84000000 | 0.00 %    |
> | 1920 | 1080 | 2500 | 1120 |  30 |       168000000 |      168000000 | 0.00 %    |
> | 2592 | 1944 | 2844 | 1944 |  15 |        84000000 |      165862080 | 49.36 %   |
> +------+------+------+------+-----+-----------------+----------------+-----------+

Is the computed clock above the same for both parallel and CSI2?

I want to add controls for PIXEL_RATE and LINK_FREQ, would you have any
quick pointer on taking the computed clock and translating that into the
PIXEL_RATE and LINK_FREQ values?

I am trying to use this sensor with TI CAL driver which at the moment uses
the PIXEL_RATE values in order to compute ths_settle and ths_term values
needed to program the DPHY properly. This is similar in behavior as the way
omap3isp relies on this info as well.

Regards,
Benoit 

> 
> Only the 640x480, 1024x768 and 2592x1944 modes are significantly affected
> by the new formula.
> 
> In this case, 640x480 and 1024x768 are actually fixed by this change.
> Indeed, the sensor was sending data at, for example, 27.33fps instead of
> 30fps. This is -9%, which is roughly what we're seeing in the array.
> Testing these modes with the new clock setup actually fix that error, and
> data are now sent at around 30fps.
> 
> 2592x1944, on the other hand, is probably due to the fact that this mode
> can only be used using MIPI-CSI2, in a two lane mode, and never really
> tested with a DVP bus.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---
>  drivers/media/i2c/ov5640.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> index 5114d401b8eb..34eaa9dd5237 100644
> --- a/drivers/media/i2c/ov5640.c
> +++ b/drivers/media/i2c/ov5640.c
> @@ -1915,7 +1915,8 @@ static int ov5640_set_mode(struct ov5640_dev *sensor)
>  	 * which is 8 bits per pixel.
>  	 */
>  	bpp = sensor->fmt.code == MEDIA_BUS_FMT_JPEG_1X8 ? 8 : 16;
> -	rate = mode->pixel_clock * bpp;
> +	rate = mode->vtot * mode->htot * bpp;
> +	rate *= ov5640_framerates[sensor->current_fr];
>  	if (sensor->ep.bus_type == V4L2_MBUS_CSI2) {
>  		rate = rate / sensor->ep.bus.mipi_csi2.num_data_lanes;
>  		ret = ov5640_set_mipi_pclk(sensor, rate);
> -- 
> 2.19.1
> 
