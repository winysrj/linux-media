Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56818 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967228AbeAOMv0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 Jan 2018 07:51:26 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2] vsp1: fix video output on R8A77970
Date: Mon, 15 Jan 2018 14:51:28 +0200
Message-ID: <2210461.kXqmUypRF2@avalon>
In-Reply-To: <20171226211424.870595086@cogentembedded.com>
References: <20171226211424.870595086@cogentembedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergei,

Thank you for the patch.

On Tuesday, 26 December 2017 23:14:12 EET Sergei Shtylyov wrote:
> Laurent has added support for the VSP2-D found on R-Car V3M (R8A77970) but

I'm not sure there's a need to state my name in the commit message.

> the video  output that VSP2-D sends to DU has a greenish garbage-like line

Why does the text in your patches (commit message, comments, ...) sometime 
have double spaces between words ?

> repeated every 8 or so screen rows.

Is it every "8 or so" rows, or exactly every 8 rows ?

> It turns out that V3M has a teeny LIF register (at least it's documented!)
> that you need to set to some kind of a  magic value for the LIF to work
> correctly...
> 
> Based on the original (and large) patch by Daisuke Matsushita
> <daisuke.matsushita.ns@hitachi.com>.

What else is in the big patch ? Is it available somewhere ?

> Fixes: d455b45f8393 ("v4l: vsp1: Add support for new VSP2-BS, VSP2-DL and
> VSP2-D instances")
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> 
> ---
> This patch is against the 'media_tree.git' repo's 'master' branch.
> 
> Changes in version 2:
> - added a  comment before the V3M SoC check;
> - fixed indetation in that check;
> - reformatted  the patch description.
> 
>  drivers/media/platform/vsp1/vsp1_lif.c  |   12 ++++++++++++
>  drivers/media/platform/vsp1/vsp1_regs.h |    5 +++++
>  2 files changed, 17 insertions(+)
> 
> Index: media_tree/drivers/media/platform/vsp1/vsp1_lif.c
> ===================================================================
> --- media_tree.orig/drivers/media/platform/vsp1/vsp1_lif.c
> +++ media_tree/drivers/media/platform/vsp1/vsp1_lif.c
> @@ -155,6 +155,18 @@ static void lif_configure(struct vsp1_en
>  			(obth << VI6_LIF_CTRL_OBTH_SHIFT) |
>  			(format->code == 0 ? VI6_LIF_CTRL_CFMT : 0) |
>  			VI6_LIF_CTRL_REQSEL | VI6_LIF_CTRL_LIF_EN);
> +
> +	/*
> +	 * R-Car V3M has the buffer attribute register you absolutely need
> +	 * to write kinda magic value to  for the LIF to work correctly...
> +	 */

I'm not sure about the "kinda" magic value. 1536 is very likely a buffer size. 
How about the following text ?

	/*
	 * On V3M the LBA register has to be set to a non-default value to
	 * guarantee proper operation (otherwise artifacts may appear on the
	 * output). The value required by the datasheet is not documented but
	 * is likely a buffer size or threshold.
	 */

The commit message should also be updated to feel a bit less magic.

> +	if ((entity->vsp1->version &
> +	     (VI6_IP_VERSION_MODEL_MASK | VI6_IP_VERSION_SOC_MASK)) ==
> +	    (VI6_IP_VERSION_MODEL_VSPD_V3 | VI6_IP_VERSION_SOC_V3M)) {
> +		vsp1_lif_write(lif, dl, VI6_LIF_LBA,
> +			       VI6_LIF_LBA_LBA0 |
> +			       (1536 << VI6_LIF_LBA_LBA1_SHIFT));
> +	}
>  }

The datasheet documents the register as being present on both V3M and M3-W 
(and the test I've just run on H3 shows that the register is present there as 
well). Should we program it on M3-W or leave it to the default value that 
should be what is recommended by the datasheet for that SoC ?

>  static const struct vsp1_entity_operations lif_entity_ops = {
> Index: media_tree/drivers/media/platform/vsp1/vsp1_regs.h
> ===================================================================
> --- media_tree.orig/drivers/media/platform/vsp1/vsp1_regs.h
> +++ media_tree/drivers/media/platform/vsp1/vsp1_regs.h
> @@ -693,6 +693,11 @@
>  #define VI6_LIF_CSBTH_LBTH_MASK		(0x7ff << 0)
>  #define VI6_LIF_CSBTH_LBTH_SHIFT	0
> 
> +#define VI6_LIF_LBA			0x3b0c
> +#define VI6_LIF_LBA_LBA0		(1 << 31)
> +#define VI6_LIF_LBA_LBA1_MASK		(0xfff << 16)
> +#define VI6_LIF_LBA_LBA1_SHIFT		16
> +
>  /* ------------------------------------------------------------------------
>   * Security Control Registers
>   */

-- 
Regards,

Laurent Pinchart
