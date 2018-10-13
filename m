Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42482 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbeJMIIS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 13 Oct 2018 04:08:18 -0400
Received: by mail-wr1-f65.google.com with SMTP id g15-v6so15108943wru.9
        for <linux-media@vger.kernel.org>; Fri, 12 Oct 2018 17:33:22 -0700 (PDT)
Subject: Re: [PATCH v3 10/16] gpu: ipu-v3: image-convert: select optimal seam
 positions
To: Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media@vger.kernel.org,
        Steve Longerbeam <slongerbeam@gmail.com>
Cc: Nicolas Dufresne <nicolas@ndufresne.ca>, kernel@pengutronix.de
References: <20180918093421.12930-1-p.zabel@pengutronix.de>
 <20180918093421.12930-11-p.zabel@pengutronix.de>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <d3e2a6ec-2961-2f97-7a53-d016bc6ad515@gmail.com>
Date: Fri, 12 Oct 2018 17:33:17 -0700
MIME-Version: 1.0
In-Reply-To: <20180918093421.12930-11-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 09/18/2018 02:34 AM, Philipp Zabel wrote:

<snip>
> +/*
> + * Tile left edges are required to be aligned to multiples of 8 bytes
> + * by the IDMAC.
> + */
> +static inline u32 tile_left_align(const struct ipu_image_pixfmt *fmt)
> +{
> +	return fmt->planar ? 8 * fmt->uv_width_dec : 64 / fmt->bpp;
> +}
<snip>

As I indicated, shouldn't this be

return fmt->planar ? 8 * fmt->uv_width_dec : 8;

?

Just from a unit analysis perspective, "64 / fmt->bp" has
units of pixels / 8-bytes, it should have units of bytes.

Steve
