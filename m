Return-Path: <SRS0=dbhF=R4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95EBAC43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 14:37:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F6ED20879
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 14:37:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729039AbfCYOhj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Mar 2019 10:37:39 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:38068 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbfCYOhj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Mar 2019 10:37:39 -0400
Received: from arch-x1c3 (unknown [IPv6:2a00:5f00:102:0:9665:9cff:feee:aa4d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: evelikov)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id D4AF1281568;
        Mon, 25 Mar 2019 14:37:37 +0000 (GMT)
Date:   Mon, 25 Mar 2019 14:32:08 +0000
From:   Emil Velikov <emil.velikov@collabora.com>
To:     Ezequiel Garcia <ezequiel@collabora.com>
Cc:     linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        linux-rockchip@lists.infradead.org,
        Heiko Stuebner <heiko@sntech.de>,
        Jonas Karlman <jonas@kwiboo.se>
Subject: Re: [PATCH v2 02/11] media: Introduce helpers to fill pixel format
 structs
Message-ID: <20190325143207.GA24966@arch-x1c3>
References: <20190304192529.14200-1-ezequiel@collabora.com>
 <20190304192529.14200-3-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190304192529.14200-3-ezequiel@collabora.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Ezequiel,

On 2019/03/04, Ezequiel Garcia wrote:

> +
> +/* Pixel format and FourCC helpers */
> +
> +/**
> + * struct v4l2_format_info - information about a V4L2 format
> + * @format: 4CC format identifier (V4L2_PIX_FMT_*)
> + * @mem_planes: Number of memory planes, which includes the alpha plane (1 to 4).
> + * @comp_planes: Number of component planes, which includes the alpha plane (1 to 4).
> + * @bpp: Array of per-plane bytes per pixel
> + * @hdiv: Horizontal chroma subsampling factor
> + * @vdiv: Vertical chroma subsampling factor
> + */
> +struct v4l2_format_info {
> +	u32 format;
> +	u8 mem_planes;
> +	u8 comp_planes;
> +	u8 bpp[4];
> +	u8 hdiv;
> +	u8 vdiv;
> +	u8 block_w[4];
> +	u8 block_h[4];

Please don't forget to document block_[wh]. Plus you can draw some extra
inspiration from drm_format_info in include/drm/drm_fourcc.h ;-)

HTH
Emil
