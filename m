Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:54668 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbeH2GpV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Aug 2018 02:45:21 -0400
Message-ID: <d55bf57ed63ba82524af1dcae3201a513cec9f48.camel@collabora.com>
Subject: Re: [PATCH v3 6/7] media: Add controls for JPEG quantization tables
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Miouyouyou <myy@miouyouyou.fr>,
        Shunqian Zheng <zhengsq@rock-chips.com>
Date: Tue, 28 Aug 2018 23:50:36 -0300
In-Reply-To: <3a92082b201776bfed0f68facc30577cb7d2a5c1.camel@bootlin.com>
References: <20180822165937.8700-1-ezequiel@collabora.com>
         <20180822165937.8700-7-ezequiel@collabora.com>
         <3a92082b201776bfed0f68facc30577cb7d2a5c1.camel@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2018-08-27 at 09:47 +0200, Paul Kocialkowski wrote:
> Hi,
> 
> On Wed, 2018-08-22 at 13:59 -0300, Ezequiel Garcia wrote:
> > From: Shunqian Zheng <zhengsq@rock-chips.com>
> > 
> > Add V4L2_CID_JPEG_LUMA/CHROMA_QUANTIZATION controls to allow userspace
> > configure the JPEG quantization tables.
> 
> How about having a single control for quantization?
> 
> In MPEG-2/H.264/H.265, we have a single control exposed as a structure,
> which contains the tables for both luma and chroma. In the case of JPEG,
> it's not that big a deal, but for advanced video formats, it would be
> too much hassle to have one control per table.
> 
> In order to keep the interface consistent, I think it'd be best to merge
> both matrices into a single control.
> 
> What do you think?
> 

I think it makes a lot of sense. I don't see the benefit in having luma
and chroma separated, and consistency is good.

I guess the more consistent solution would be to expose a compound
control, similar to the video quantization one.

struct v4l2_ctrl_jpeg_quantization {
       __u8    luma_quantization_matrix[64];
       __u8    chroma_quantization_matrix[64];
};

Thanks!
Eze
