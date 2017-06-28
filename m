Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f170.google.com ([209.85.216.170]:33887 "EHLO
        mail-qt0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751693AbdF1A3L (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Jun 2017 20:29:11 -0400
MIME-Version: 1.0
In-Reply-To: <CAAFQd5BHAiTq9f4nvwFiy5DzZ0Jep9d4K0saAkoxzaK86a8GJg@mail.gmail.com>
References: <1498488673-27900-1-git-send-email-jacob-chen@iotwrt.com> <CAAFQd5BHAiTq9f4nvwFiy5DzZ0Jep9d4K0saAkoxzaK86a8GJg@mail.gmail.com>
From: Jacob Chen <jacobchen110@gmail.com>
Date: Wed, 28 Jun 2017 08:29:09 +0800
Message-ID: <CAFLEztT7urS_VAJ5h3dUgyCyJwfeAFezwcAr8QpRHAEEbsGSWQ@mail.gmail.com>
Subject: Re: [PATCH 1/5] [media] rockchip/rga: v4l2 m2m support
To: Tomasz Figa <tfiga@chromium.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

2017-06-27 16:39 GMT+08:00 Tomasz Figa <tfiga@chromium.org>:
> Hi Jacob,
>
> Please see my comments inline.
>
> On Mon, Jun 26, 2017 at 11:51 PM, Jacob Chen <jacob-chen@iotwrt.com> wrote:
>> Rockchip RGA is a separate 2D raster graphic acceleration unit. It
>> accelerates 2D graphics operations, such as point/line drawing, image
>> scaling, rotation, BitBLT, alpha blending and image blur/sharpness.
> [snip]
>> +static int rga_buf_init(struct vb2_buffer *vb)
>> +{
>> +       struct rga_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
>> +       struct rockchip_rga *rga = ctx->rga;
>> +       struct sg_table *sgt;
>> +       struct scatterlist *sgl;
>> +       unsigned int *pages;
>> +       struct rga_buf *buf;
>> +       unsigned int address, len, i, p;
>> +       unsigned int mapped_size = 0;
>> +
>> +       /* Create local MMU table for RGA */
>> +       sgt = vb2_plane_cookie(vb, 0);
>> +
>> +       /*
>> +        * Alloc (2^3 * 4K) = 32K byte for storing pages, those space could
>> +        * cover 32K * 4K = 128M ram address.
>
> Unless I'm missing something, there is 1024 32-bit values in one 4K
> page, which can point to 4 MB of memory. The code allocates 8 of them,
> which in total allows at most 32 MB per buffer.
>
>> +        */
>> +       pages = (unsigned int *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 3);
>
> This is rather unfortunate and you should expect failures here on
> actively used systems with uptime longer than few hours. Changing this
> to dma_alloc_coherent() and enabling CMA _might_ give you a bit better
> success rate, but...
>

I decide to alloc a page pool when driver probe and get page from that poll.

> Normally, this kind of (scatter-gather capable) hardware would allow
> some kind of linking of separate pages, e.g. last entry in the page
> would point to the next page, or something like that. Doesn't this RGA
> block have something similar?
>
> Best regards,
> Tomasz
