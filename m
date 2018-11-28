Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45628 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728262AbeK2D15 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Nov 2018 22:27:57 -0500
Received: by mail-wr1-f66.google.com with SMTP id v6so26920049wrr.12
        for <linux-media@vger.kernel.org>; Wed, 28 Nov 2018 08:25:43 -0800 (PST)
Subject: Re: [PATCH 0/2] Clarify H.264 loop filter offset controls and fix
 them for coda
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kamil Debski <kamil@wypas.org>,
        Jeongtae Park <jtp.park@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>
References: <20181128130122.4916-1-p.zabel@pengutronix.de>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <d6e60d32-d4eb-1d51-1f08-2f3547bb9524@linaro.org>
Date: Wed, 28 Nov 2018 18:25:40 +0200
MIME-Version: 1.0
In-Reply-To: <20181128130122.4916-1-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On 11/28/18 3:01 PM, Philipp Zabel wrote:
> Hi,
> 
> the coda driver handles the H.264 loop filter alpha/beta offset controls
> incorrectly. When trying to fix them, I noticed that the documentation
> is not clear about what these values actually are.
> 
> From the value range of -6 to +6 used in the existing drivers (s5p-mfc,
> venus), it looks like they currently correspond directly to the values
> stored into the slice headers: slice_alpha_c0_offset_div2 and
> slice_beta_offset_div2. These are only half of the actual alpha/beta
> filter offsets.
> 
> The ITU-T Rec. H.264 (02/2016) states:
> 
>   slice_alpha_c0_offset_div2 specifies the offset used in accessing the
>   α [...] deblocking filter tables for filtering operations controlled
>   by the macroblocks within the slice. From this value, the offset that
>   shall be applied when addressing these tables shall be computed as
> 
>       FilterOffsetA = slice_alpha_c0_offset_div2 << 1             (7-32)
> 
>   The value of slice_alpha_c0_offset_div2 shall be in the range of −6 to
>   +6, inclusive. When slice_alpha_c0_offset_div2 is not present in the
>   slice header, the value of slice_alpha_c0_offset_div2 shall be inferred
>   to be equal to 0.
> 
> And the same for slice_beta_offset_div2 / FilterOffsetB.
> 
> Do the s5p-mfc and venus drivers use the controls
> V4L2_MPEG_VIDEO_H264_LOOP_FILTER_ALPHA and _BETA directly as slice
> header fields, and thus their values are to be interpreted as half of
> FilterOffsetA/B defined in the H.264 spec, respectively?

That is correct for Venus encoder, it uses slice header fields directly
[-6, 6].

-- 
regards,
Stan
