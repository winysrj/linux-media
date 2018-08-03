Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:51424 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727276AbeHCN45 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Aug 2018 09:56:57 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran@ksquared.org.uk>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: Re: [PATCH v6 02/11] media: vsp1: use kernel __packed for structures
Date: Fri, 03 Aug 2018 15:01:36 +0300
Message-ID: <17427131.RaMUGdxzod@avalon>
In-Reply-To: <3f7e17bc411842379495b3bd3e96a367582f8d65.1533295631.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.7e4241408f077710d96e0cc06e039d1022fb0c8c.1533295631.git-series.kieran.bingham+renesas@ideasonboard.com> <3f7e17bc411842379495b3bd3e96a367582f8d65.1533295631.git-series.kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Friday, 3 August 2018 14:37:21 EEST Kieran Bingham wrote:
> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> The kernel provides a __packed definition to abstract away from the
> compiler specific attributes tag.
> 
> Convert all packed structures in VSP1 to use it.
> 
> The GCC documentation [0] describes this attribute as "the structure or
> union is placed to minimize the memory required".
> 
> The Keil compiler documentation at [1] warns that the use of this
> attribute can cause a performance penalty in the event that the compiler
> can not deduce the allignment of each field.
> 
> Careful examination of the object code generated both with and without
> this attribute shows that these structures are accessed identically and
> are not affected by any performance penalty. The structures are
> correctly aligned and padded to match the needs of the hardware already.
> 
> This patch does not serve to make a decision as to the use of the
> attribute, but purely to clean up the code to use the kernel defined
> abstraction as per [2].
> 
> [0]
> https://gcc.gnu.org/onlinedocs/gcc/Common-Type-Attributes.html#index-packed
> -type-attribute [1]
> http://www.keil.com/support/man/docs/armcc/armcc_chr1359124230195.htm [2]
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/inc
> lude/linux/compiler-gcc.h?h=v4.16-rc5#n92
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
> 
> This patch had some lengthy discussion about the use of the packed
> attribute. In the end, after discussing further with Laurent, we decided
> that as no performance impact occurs on the VSP1 driver (object code
> generated is identical), and that as this attribute clearly marks
> structures which are read by the VSP1, we can just keep it.
> 
> This patch neither adds, nor removes the attribute - but purely adapts
> to using the linux macro as defined at [2] to ensure that compiler
> specifics are abstracted out. And in particular I feel that __packed is
> cleaner than __attribute__((__packed__))
> 
> v2:
>  - Remove attributes entirely
> 
> v6:
>  - Re-added the attributes (back to v1 of this patch)
> 
>  drivers/media/platform/vsp1/vsp1_dl.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_dl.c
> b/drivers/media/platform/vsp1/vsp1_dl.c index 10a24bde2299..e4aae334f047
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_dl.c
> +++ b/drivers/media/platform/vsp1/vsp1_dl.c
> @@ -25,19 +25,19 @@
>  struct vsp1_dl_header_list {
>  	u32 num_bytes;
>  	u32 addr;
> -} __attribute__((__packed__));
> +} __packed;
> 
>  struct vsp1_dl_header {
>  	u32 num_lists;
>  	struct vsp1_dl_header_list lists[8];
>  	u32 next_header;
>  	u32 flags;
> -} __attribute__((__packed__));
> +} __packed;
> 
>  struct vsp1_dl_entry {
>  	u32 addr;
>  	u32 data;
> -} __attribute__((__packed__));
> +} __packed;
> 
>  /**
>   * struct vsp1_dl_body - Display list body


-- 
Regards,

Laurent Pinchart
