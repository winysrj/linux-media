Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:37781 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751320AbeCLQdl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Mar 2018 12:33:41 -0400
Date: Mon, 12 Mar 2018 17:30:45 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/11] media: vsp1: Provide support for extended command
 pools
Message-ID: <20180312163045.GE12967@w540>
References: <cover.50cd35ac550b4477f13fb4f3fbd3ffb6bcccfc8a.1520632434.git-series.kieran.bingham+renesas@ideasonboard.com>
 <02dcefdd58c734623b9caf2513316380feb9f993.1520632434.git-series.kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="SWTRyWv/ijrBap1m"
Content-Disposition: inline
In-Reply-To: <02dcefdd58c734623b9caf2513316380feb9f993.1520632434.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--SWTRyWv/ijrBap1m
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Kieran,
    just one small thing I noticed below...

On Fri, Mar 09, 2018 at 10:04:07PM +0000, Kieran Bingham wrote:
> VSPD and VSP-DL devices can provide extended display lists supporting
> extended command display list objects.
>
> These extended commands require their own dma memory areas for a header
> and body specific to the command type.
>
> Implement a command pool to allocate all necessary memory in a single
> DMA allocation to reduce pressure on the TLB, and provide convenvient
> re-usable command objects for the entities to utilise.
>
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> ---
>  drivers/media/platform/vsp1/vsp1_dl.c | 189 +++++++++++++++++++++++++++-
>  drivers/media/platform/vsp1/vsp1_dl.h |   3 +-
>  2 files changed, 192 insertions(+)
>
> diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
> index 36440a2a2c8b..6d17b8bfa21c 100644
> --- a/drivers/media/platform/vsp1/vsp1_dl.c
> +++ b/drivers/media/platform/vsp1/vsp1_dl.c
> @@ -121,6 +121,30 @@ struct vsp1_dl_body_pool {
>  };
>
>  /**
> + * struct vsp1_cmd_pool - display list body pool
> + * @dma: DMA address of the entries
> + * @size: size of the full DMA memory pool in bytes
> + * @mem: CPU memory pointer for the pool
> + * @bodies: Array of DLB structures for the pool
> + * @free: List of free DLB entries
> + * @lock: Protects the pool and free list
> + * @vsp1: the VSP1 device
> + */
> +struct vsp1_dl_cmd_pool {
> +	/* DMA allocation */
> +	dma_addr_t dma;
> +	size_t size;
> +	void *mem;
> +
> +	struct vsp1_dl_ext_cmd *cmds;
> +	struct list_head free;
> +
> +	spinlock_t lock;
> +
> +	struct vsp1_device *vsp1;
> +};
> +
> +/**
>   * struct vsp1_dl_list - Display list
>   * @list: entry in the display list manager lists
>   * @dlm: the display list manager
> @@ -176,6 +200,7 @@ struct vsp1_dl_manager {
>  	struct vsp1_dl_list *pending;
>
>  	struct vsp1_dl_body_pool *pool;
> +	struct vsp1_dl_cmd_pool *autfld_cmds;
>  };
>
>  /* -----------------------------------------------------------------------------
> @@ -339,6 +364,139 @@ void vsp1_dl_body_write(struct vsp1_dl_body *dlb, u32 reg, u32 data)
>  }
>
>  /* -----------------------------------------------------------------------------
> + * Display List Extended Command Management
> + */
> +
> +enum vsp1_extcmd_type {
> +	VSP1_EXTCMD_AUTODISP,
> +	VSP1_EXTCMD_AUTOFLD,
> +};
> +
> +struct vsp1_extended_command_info {
> +	u16 opcode;
> +	size_t body_size;
> +} vsp1_extended_commands[] = {
> +	[VSP1_EXTCMD_AUTODISP] = { 0x02, 96 },
> +	[VSP1_EXTCMD_AUTOFLD]  = { 0x03, 160 },
> +};

How about making this one static and const, since it does not get
modified?

Thanks
   j

--SWTRyWv/ijrBap1m
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJapqs1AAoJEHI0Bo8WoVY8eOYQAIoBKwpSJUZE6EWSOsqOJf3v
ofU5P1hmKqXG3HKbY8iYJlYaoKm/26XSsmtzk1suu+0iUGO0yt/4qwGQR8zr3l/U
40ADoaB6w1Ofrz9Rur2cR8nQMevyxnMTle6w1ptmoiE4Ztor28J/Nvp96m9hsNQ6
Yv1jYgbIHh2NHkDK2kG8YD4NDDmt02li7bdCLDOEHvfnvkZoznV2EJg5shczYwU0
PEMwfaFly5TQaWHocP7Oo3mS3vhSLenRAutap5HyDUm0Ne5u18DnLEibsnoeGXvJ
7or5jphSij0nhkqhzadUevMaP+wmVpJ8mz+GAVgSRYCaPEhOcH7L9cJ9uCfuxPMa
dOJ4PyUvAp+VquO+gMrCbfVCbzgO5ynGEYOMGomtTX02E7wOOwAfeRFo7I6vQaWK
CRYdaUP8paY4/ypmr8wt+nyGWL9SZeBGcNVA6dS85tSZqlu/vJY1vufHwFlJYvds
EO5I0YCBnXNkv9NjjDjaUg07ZDamObiiXt38oMrfSMOtCNhLONeq4h7dGN2x0Fzz
gERpS9yMWXRNDqfWFrlALz6Nz8a3ogCUvQng4shPkRCQ4CUmMjKR3F0rdRLEY+2X
sCr6Zpjv3U3rMtbQrFh3tjOv2zO862CIfNpLlH2OrDe3iw2dmi88GlJGkGGqv97/
IlToYUJNcopWwAhUoVqk
=SoGE
-----END PGP SIGNATURE-----

--SWTRyWv/ijrBap1m--
