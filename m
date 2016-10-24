Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:41433 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1757281AbcJXL1g (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Oct 2016 07:27:36 -0400
Message-ID: <1477308450.29543.9.camel@mtksdaap41>
Subject: Re: [PATCH 4/4] mtk-mdp: fix compilation warnings if !DEBUG
From: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
        "Mauro Carvalho Chehab" <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
Date: Mon, 24 Oct 2016 19:27:30 +0800
In-Reply-To: <5a24855fda4d91a58f119c2d70177017e06fc6f0.1477058332.git.mchehab@s-opensource.com>
References: <cd14afdb178cf490e257368bc899c7a0c690d140.1477058332.git.mchehab@s-opensource.com>
         <5a24855fda4d91a58f119c2d70177017e06fc6f0.1477058332.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2016-10-21 at 11:59 -0200, Mauro Carvalho Chehab wrote:
> The mtk_mdp_dbg() is empty if !DEBUG. This causes the following
> warnings:
> 
> 	drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c: In function ‘mtk_mdp_try_fmt_mplane’:
> 	drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c:231:52: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]
> 	        org_w, org_h, pix_mp->width, pix_mp->height);
>                                                     ^
> 	drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c: In function ‘mtk_mdp_m2m_start_streaming’:
> 	drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c:414:21: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]
> 	        ctx->id, ret);
> 	                     ^
> 
> With could actually make the code to do something wrong. So,
> add an empty block to make it be parsed ok.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/platform/mtk-mdp/mtk_mdp_core.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_core.h b/drivers/media/platform/mtk-mdp/mtk_mdp_core.h
> index 2e979f97d1df..848569d4ab90 100644
> --- a/drivers/media/platform/mtk-mdp/mtk_mdp_core.h
> +++ b/drivers/media/platform/mtk-mdp/mtk_mdp_core.h
> @@ -250,7 +250,7 @@ extern int mtk_mdp_dbg_level;
>  
>  #else
>  
> -#define mtk_mdp_dbg(level, fmt, args...)
> +#define mtk_mdp_dbg(level, fmt, args...) {}
>  

Acked-by: Minghsiu Tsai <minghsiu.tsai@mediatek.com>


> #define mtk_mdp_err(fmt, args...)
>  #define mtk_mdp_dbg_enter()
>  #define mtk_mdp_dbg_leave()




