Return-Path: <SRS0=J9mZ=O3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FA1DC43387
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 13:49:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C38ED218A1
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 13:49:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="OiSLWbyj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbeLRNtj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 18 Dec 2018 08:49:39 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:33139 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbeLRNti (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Dec 2018 08:49:38 -0500
Received: by mail-io1-f68.google.com with SMTP id t24so12806741ioi.0
        for <linux-media@vger.kernel.org>; Tue, 18 Dec 2018 05:49:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pA4nt4aVFFPaTzQH8bJfQiEnbChzH/tGIfeFL5zvVZo=;
        b=OiSLWbyjPUf7HdBukFTMGND/dN0q4M8KQPdPJYBu4h/ataPgLHdSQe05HER8vJe/dX
         9BH8YBbABwga1TmIqubVVxvQjtEFk7hOpWiZOnOn9/ZZepplUo6hMRS84NYP/UB6TWrU
         oBXyFOoShxRzSlm4KyquzQNc6NxzO2y5Vv8LA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pA4nt4aVFFPaTzQH8bJfQiEnbChzH/tGIfeFL5zvVZo=;
        b=bAkKr0BDTFItXBNARApGlcGf9LoSORhlCaNBYFizK82FOYl/+3ytoVddrSo5Xmx1MC
         OOZ12PSiPEcw+mhF11bjVVB6emyDc0jQNUg/ZqO9SnYuRB1oX7X4X90rFfKu4fX1dvG5
         +w1I6fcYb2K0u1Gjx64bs5eZuZYf97TLK3017xH3GI5ZpEUdQ0Cjnk0tyC5COam2+y0t
         igXSZHGDGEP4jan1OZTnLKC0Z3bTZRdufURXN+SZTCRLs1KUMBYKnI5EZEtl3DX3pFTD
         GOwAl/yFS0xiPocmqd8zPMi1zGlXboYFMpk4h8Em5C8oFptrJxqN3dvtNNrCSFh3uz1z
         h5ug==
X-Gm-Message-State: AA+aEWZuyN8rEc7VvgC+6RRkiIMT5GQuoC0fPvTaomYikeWYbEp0wXuJ
        dgskriQvxN0NA0oMFdoH4ldFUGriWm6t+K53LU6zgQ==
X-Google-Smtp-Source: AFSGD/V8nGmRQ7B7u7hTv7mxbzix3eC+3VLfbktIR5lRJGM4XbrME2Lo2Xs9B99HFJTvroX8+M82ILMHEilwO+z/Mq0=
X-Received: by 2002:a5e:c609:: with SMTP id f9mr13585934iok.114.1545140977804;
 Tue, 18 Dec 2018 05:49:37 -0800 (PST)
MIME-Version: 1.0
References: <cover.b1632e0c1a10c3f9f674e00142a554fa79eac762.1543826654.git-series.maxime.ripard@bootlin.com>
 <0f291e65286bbf7ec5e2a59f63f9791c4e526405.1543826654.git-series.maxime.ripard@bootlin.com>
In-Reply-To: <0f291e65286bbf7ec5e2a59f63f9791c4e526405.1543826654.git-series.maxime.ripard@bootlin.com>
From:   Jagan Teki <jagan@amarulasolutions.com>
Date:   Tue, 18 Dec 2018 19:19:26 +0530
Message-ID: <CAMty3ZDwxH3m5b6FyB3eg60+Bcxp3fHKxxzmXZ8CfUq3KcAgLA@mail.gmail.com>
Subject: Re: [PATCH v6 09/12] media: ov5640: Make the return rate type more explicit
To:     Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media <linux-media@vger.kernel.org>,
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
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Dec 3, 2018 at 2:14 PM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
>
> In the ov5640_try_frame_interval function, the ret variable actually holds
> the frame rate index to use, which is represented by the enum
> ov5640_frame_rate in the driver.
>
> Make it more obvious.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> Tested-by: Adam Ford <aford173@gmail.com> #imx6dq
> ---
>  drivers/media/i2c/ov5640.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> index abca08d669be..6cdf5ee0e4fa 100644
> --- a/drivers/media/i2c/ov5640.c
> +++ b/drivers/media/i2c/ov5640.c
> @@ -2052,8 +2052,8 @@ static int ov5640_try_frame_interval(struct ov5640_dev *sensor,
>                                      u32 width, u32 height)
>  {
>         const struct ov5640_mode_info *mode;
> +       enum ov5640_frame_rate rate = OV5640_30_FPS;

This is breaking setting 15fps via media-ctl.

Initializing rate to OV5640_15_FPS will satisfy all fps rate changes.
