Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f67.google.com ([209.85.161.67]:33408 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725199AbeH2GzK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Aug 2018 02:55:10 -0400
Received: by mail-yw1-f67.google.com with SMTP id x67-v6so1462823ywg.0
        for <linux-media@vger.kernel.org>; Tue, 28 Aug 2018 20:00:32 -0700 (PDT)
Received: from mail-yb0-f169.google.com (mail-yb0-f169.google.com. [209.85.213.169])
        by smtp.gmail.com with ESMTPSA id w80-v6sm1256834ywd.55.2018.08.28.20.00.30
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Aug 2018 20:00:30 -0700 (PDT)
Received: by mail-yb0-f169.google.com with SMTP id z12-v6so1458022ybg.9
        for <linux-media@vger.kernel.org>; Tue, 28 Aug 2018 20:00:30 -0700 (PDT)
MIME-Version: 1.0
References: <20180822165937.8700-1-ezequiel@collabora.com> <20180822165937.8700-7-ezequiel@collabora.com>
 <3a92082b201776bfed0f68facc30577cb7d2a5c1.camel@bootlin.com> <d55bf57ed63ba82524af1dcae3201a513cec9f48.camel@collabora.com>
In-Reply-To: <d55bf57ed63ba82524af1dcae3201a513cec9f48.camel@collabora.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 29 Aug 2018 12:00:18 +0900
Message-ID: <CAAFQd5Dx87Mmx4kpUGeK1E=FZ4B5OgpVvadAFYOM+D-8-ACXKQ@mail.gmail.com>
Subject: Re: [PATCH v3 6/7] media: Add controls for JPEG quantization tables
To: Ezequiel Garcia <ezequiel@collabora.com>
Cc: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree@vger.kernel.org,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, myy@miouyouyou.fr,
        Shunqian Zheng <zhengsq@rock-chips.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 29, 2018 at 11:50 AM Ezequiel Garcia <ezequiel@collabora.com> wrote:
>
> On Mon, 2018-08-27 at 09:47 +0200, Paul Kocialkowski wrote:
> > Hi,
> >
> > On Wed, 2018-08-22 at 13:59 -0300, Ezequiel Garcia wrote:
> > > From: Shunqian Zheng <zhengsq@rock-chips.com>
> > >
> > > Add V4L2_CID_JPEG_LUMA/CHROMA_QUANTIZATION controls to allow userspace
> > > configure the JPEG quantization tables.
> >
> > How about having a single control for quantization?
> >
> > In MPEG-2/H.264/H.265, we have a single control exposed as a structure,
> > which contains the tables for both luma and chroma. In the case of JPEG,
> > it's not that big a deal, but for advanced video formats, it would be
> > too much hassle to have one control per table.
> >
> > In order to keep the interface consistent, I think it'd be best to merge
> > both matrices into a single control.
> >
> > What do you think?
> >
>
> I think it makes a lot of sense. I don't see the benefit in having luma
> and chroma separated, and consistency is good.
>
> I guess the more consistent solution would be to expose a compound
> control, similar to the video quantization one.
>
> struct v4l2_ctrl_jpeg_quantization {
>        __u8    luma_quantization_matrix[64];
>        __u8    chroma_quantization_matrix[64];
> };

Makes sense indeed. It also lets us avoid the hassle of setting
.min/.max/.dims and other array control stuff, since everything is
already defined by the C struct itself.

Best regards,
Tomasz
