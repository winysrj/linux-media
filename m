Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57536 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750839AbcIIIls (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Sep 2016 04:41:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        kernel-janitors@vger.kernel.org,
        Fabien Dessenne <fabien.dessenne@st.com>,
        linux-samsung-soc@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Kamil Debski <kamil@wypas.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Benoit Parrot <bparrot@ti.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Hyun Kwon <hyun.kwon@xilinx.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        =?ISO-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] [media] platform: constify vb2_ops structures
Date: Fri, 09 Sep 2016 11:42:19 +0300
Message-ID: <1520635.43zSurJaks@avalon>
In-Reply-To: <1473379150-17315-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1473379150-17315-1-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Julia,

Thank you for the patch.

On Friday 09 Sep 2016 01:59:10 Julia Lawall wrote:
> Check for vb2_ops structures that are only stored in the ops field of a
> vb2_queue structure.  That field is declared const, so vb2_ops structures
> that have this property can be declared as const also.
> 
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @r disable optional_qualifier@
> identifier i;
> position p;
> @@
> static struct vb2_ops i@p = { ... };
> 
> @ok@
> identifier r.i;
> struct vb2_queue e;
> position p;
> @@
> e.ops = &i@p;
> 
> @bad@
> position p != {r.p,ok.p};
> identifier r.i;
> struct vb2_ops e;
> @@
> e@i@p
> 
> @depends on !bad disable optional_qualifier@
> identifier r.i;
> @@
> static
> +const
>  struct vb2_ops i = { ... };
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

For the drivers below,

>  drivers/media/platform/m2m-deinterlace.c                 |    2 +-
>  drivers/media/platform/rcar-vin/rcar-dma.c               |    2 +-
>  drivers/media/platform/rcar_jpu.c                        |    2 +-
>  drivers/media/platform/sh_vou.c                          |    2 +-
>  drivers/media/platform/soc_camera/atmel-isi.c            |    2 +-
>  drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c |    2 +-
>  drivers/media/platform/vim2m.c                           |    2 +-
>  drivers/media/platform/xilinx/xilinx-dma.c               |    2 +-

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

For

>  drivers/media/platform/soc_camera/rcar_vin.c             |    2 +-

you can also add my

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

tag, but the driver will be scheduled for removal very soon.

-- 
Regards,

Laurent Pinchart

