Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:18872 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1757275AbcJXLuB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Oct 2016 07:50:01 -0400
Message-ID: <1477309795.29543.23.camel@mtksdaap41>
Subject: Re: [PATCH 3/4] mtk_mdp_m2m: remove an unused struct
From: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
        "Mauro Carvalho Chehab" <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
Date: Mon, 24 Oct 2016 19:49:55 +0800
In-Reply-To: <624b0ea4550b90318ec2293d80b1caa5bafd2a35.1477058332.git.mchehab@s-opensource.com>
References: <cd14afdb178cf490e257368bc899c7a0c690d140.1477058332.git.mchehab@s-opensource.com>
         <624b0ea4550b90318ec2293d80b1caa5bafd2a35.1477058332.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2016-10-21 at 11:59 -0200, Mauro Carvalho Chehab wrote:
> drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c:48:33: warning: ‘mtk_mdp_size_align’ defined but not used [-Wunused-variable]
>  static struct mtk_mdp_pix_align mtk_mdp_size_align = {
>                                  ^~~~~~~~~~~~~~~~~~
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c b/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
> index 065502757133..33124a6c9951 100644
> --- a/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
> +++ b/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
> @@ -45,13 +45,6 @@ struct mtk_mdp_pix_limit {
>  	u16 target_rot_en_h;
>  };
>  
> -static struct mtk_mdp_pix_align mtk_mdp_size_align = {
> -	.org_w			= 16,
> -	.org_h			= 16,
> -	.target_w		= 2,
> -	.target_h		= 2,
> -};
> -

Hi Mauro,

The structure is used for the format V4L2_PIX_FMT_MT21C which is added
in the later patch.
"[media] media: mtk-mdp: support pixelformat V4L2_PIX_FMT_MT21C"

I just know checkpatch should be run patch by patch, so this warning
message will be generated without the MT21C patch.

I found all mtk-mdp patches have been merged in media tree, so is this
patch still needed?

If yes, remove 'mtk_mdp_size_align' in this patch, and re-added it in
the MT21C patch. 


minghsiu

>  static const struct mtk_mdp_fmt mtk_mdp_formats[] = {
>  	{
>  		.pixelformat	= V4L2_PIX_FMT_NV12M,


