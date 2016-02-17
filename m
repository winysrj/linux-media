Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f177.google.com ([209.85.160.177]:33166 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161065AbcBQQRi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Feb 2016 11:17:38 -0500
Received: by mail-yk0-f177.google.com with SMTP id z13so8710944ykd.0
        for <linux-media@vger.kernel.org>; Wed, 17 Feb 2016 08:17:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1455705787-25856-1-git-send-email-jung.zhao@rock-chips.com>
References: <1455705673-25484-1-git-send-email-jung.zhao@rock-chips.com>
	<1455705787-25856-1-git-send-email-jung.zhao@rock-chips.com>
Date: Wed, 17 Feb 2016 08:17:37 -0800
Message-ID: <CAD=FV=UStodcwk6w7=x2iDizq0uVPuHSr9W8XbWDnLmrKAhQdA@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] media: vcodec: rockchip: Add Rockchip VP8 decoder driver
From: Doug Anderson <dianders@chromium.org>
To: Jung Zhao <jung.zhao@rock-chips.com>
Cc: Tomasz Figa <tfiga@chromium.org>,
	Pawel Osciak <posciak@chromium.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	"open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Wed, Feb 17, 2016 at 2:43 AM, Jung Zhao <jung.zhao@rock-chips.com> wrote:
> +       dma_set_attr(DMA_ATTR_NO_KERNEL_MAPPING, &attrs_novm);
> +       vpu->alloc_ctx = vb2_dma_contig_init_ctx_attrs(&pdev->dev,
> +                                                      &attrs_novm);
> +       if (IS_ERR(vpu->alloc_ctx)) {
> +               ret = PTR_ERR(vpu->alloc_ctx);
> +               goto err_dma_contig;
> +       }
> +
> +       vpu->alloc_ctx_vm = vb2_dma_contig_init_ctx(&pdev->dev);
> +       if (IS_ERR(vpu->alloc_ctx_vm)) {
> +               ret = PTR_ERR(vpu->alloc_ctx_vm);
> +               goto err_dma_contig_vm;
> +       }

I'm not qualified to review this whole driver, so just adding my $0.02...

Could you please fold
<https://chromium-review.googlesource.com/322336> into your patch
submission?  All of the necessary patches have landed in RMK's tree
upstream and are currently present in linuxnext.

Thanks!

-Doug
