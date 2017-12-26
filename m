Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:43562 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751083AbdLZQ0T (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Dec 2017 11:26:19 -0500
Received: by mail-lf0-f67.google.com with SMTP id o26so25787259lfc.10
        for <linux-media@vger.kernel.org>; Tue, 26 Dec 2017 08:26:18 -0800 (PST)
Subject: Re: [PATCH] vsp1: fix video output on R8A77970
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <20171225212127.024131449@cogentembedded.com>
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <76e32f00-fe4d-7827-7a52-1f948d46dae9@cogentembedded.com>
Date: Tue, 26 Dec 2017 19:26:15 +0300
MIME-Version: 1.0
In-Reply-To: <20171225212127.024131449@cogentembedded.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

On 12/26/2017 12:21 AM, Sergei Shtylyov wrote:

> Laurent has added support for the VSP2-D found on R-Car V3M (R8A77970) but
> the video output that VSP2-D sends to DU has a greenish garbage-like line
> repeated every 8 or so screen rows.  It turns out that V3M has a teeny LIF
> register (at least it's documented!) that you need to set to some kind of
> a magic value for the LIF to work correctly...
> 
> Based on the original (and large) patch by  Daisuke Matsushita
> <daisuke.matsushita.ns@hitachi.com>.
> 
> Fixes: d455b45f8393 ("v4l: vsp1: Add support for new VSP2-BS, VSP2-DL and VSP2-D instances")
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> 
> ---
> This patch is against the 'media_tree.git' repo's 'master' branch.
> 
>  drivers/media/platform/vsp1/vsp1_lif.c  |    8 ++++++++
>  drivers/media/platform/vsp1/vsp1_regs.h |    5 +++++
>  2 files changed, 13 insertions(+)
> 
> Index: media_tree/drivers/media/platform/vsp1/vsp1_lif.c
> ===================================================================
> --- media_tree.orig/drivers/media/platform/vsp1/vsp1_lif.c
> +++ media_tree/drivers/media/platform/vsp1/vsp1_lif.c
> @@ -155,6 +155,14 @@ static void lif_configure(struct vsp1_en
>  			(obth << VI6_LIF_CTRL_OBTH_SHIFT) |
>  			(format->code == 0 ? VI6_LIF_CTRL_CFMT : 0) |
>  			VI6_LIF_CTRL_REQSEL | VI6_LIF_CTRL_LIF_EN);
> +

    I remember I was going to add a comment here but apparently forgot to do 
it yesterday... Will repost.

> +	if ((entity->vsp1->version &
> +	    (VI6_IP_VERSION_MODEL_MASK | VI6_IP_VERSION_SOC_MASK)) ==
> +	    (VI6_IP_VERSION_MODEL_VSPD_V3 | VI6_IP_VERSION_SOC_V3M)) {
> +		vsp1_lif_write(lif, dl, VI6_LIF_LBA,
> +			       VI6_LIF_LBA_LBA0 |
> +			       (1536 << VI6_LIF_LBA_LBA1_SHIFT));
> +	}
>  }
[...]

MBR, Sergei
