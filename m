Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3.mail.gandi.net ([217.70.178.223]:35339 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932394AbeCMTmf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 15:42:35 -0400
Date: Mon, 12 Mar 2018 14:55:13 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Niklas =?utf-8?Q?S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com
Subject: Re: [PATCH 2/3] rcar-vin: allocate a scratch buffer at stream start
Message-ID: <20180312135513.GB12967@w540>
References: <20180310000953.25366-1-niklas.soderlund+renesas@ragnatech.se>
 <20180310000953.25366-3-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="LpQ9ahxlCli8rRTG"
Content-Disposition: inline
In-Reply-To: <20180310000953.25366-3-niklas.soderlund+renesas@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--LpQ9ahxlCli8rRTG
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Niklas,

On Sat, Mar 10, 2018 at 01:09:52AM +0100, Niklas S=C3=B6derlund wrote:
> Before starting capturing allocate a scratch buffer which can be used by
> the driver to give to the hardware if no buffers are available from
> userspace. The buffer is not used in this patch but prepares for future
> refactoring where the scratch buffer can be used to avoid the need to
> fallback on single capture mode if userspace don't queue buffers as fast
> as the VIN driver consumes them.
>
> Signed-off-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatech.=
se>
> ---
>  drivers/media/platform/rcar-vin/rcar-dma.c | 19 +++++++++++++++++++
>  drivers/media/platform/rcar-vin/rcar-vin.h |  4 ++++
>  2 files changed, 23 insertions(+)
>
> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/p=
latform/rcar-vin/rcar-dma.c
> index b4be75d5009080f7..8ea73cdc9a720abe 100644
> --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> @@ -1070,6 +1070,17 @@ static int rvin_start_streaming(struct vb2_queue *=
vq, unsigned int count)
>  	unsigned long flags;
>  	int ret;
>
> +	/* Allocate scratch buffer. */
> +	vin->scratch =3D dma_alloc_coherent(vin->dev, vin->format.sizeimage,
> +					  &vin->scratch_phys, GFP_KERNEL);
> +	if (!vin->scratch) {
> +		spin_lock_irqsave(&vin->qlock, flags);
> +		return_all_buffers(vin, VB2_BUF_STATE_QUEUED);
> +		spin_unlock_irqrestore(&vin->qlock, flags);
> +		vin_err(vin, "Failed to allocate scratch buffer\n");
> +		return -ENOMEM;
> +	}
> +
>  	sd =3D vin_to_source(vin);
>  	v4l2_subdev_call(sd, video, s_stream, 1);
>
> @@ -1085,6 +1096,10 @@ static int rvin_start_streaming(struct vb2_queue *=
vq, unsigned int count)
>
>  	spin_unlock_irqrestore(&vin->qlock, flags);
>
> +	if (ret)
> +		dma_free_coherent(vin->dev, vin->format.sizeimage, vin->scratch,
> +				  vin->scratch_phys);
> +
>  	return ret;
>  }
>
> @@ -1135,6 +1150,10 @@ static void rvin_stop_streaming(struct vb2_queue *=
vq)
>
>  	/* disable interrupts */
>  	rvin_disable_interrupts(vin);
> +
> +	/* Free scratch buffer. */
> +	dma_free_coherent(vin->dev, vin->format.sizeimage, vin->scratch,
> +			  vin->scratch_phys);
>  }
>
>  static const struct vb2_ops rvin_qops =3D {
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/p=
latform/rcar-vin/rcar-vin.h
> index 5382078143fb3869..11a981d707c7ca47 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -102,6 +102,8 @@ struct rvin_graph_entity {
>   *
>   * @lock:		protects @queue
>   * @queue:		vb2 buffers queue
> + * @scratch:		cpu address for scratch buffer
> + * @scratch_phys:	pysical address of the scratch buffer

Nitpicking: physical

Thanks
   j

>   *
>   * @qlock:		protects @queue_buf, @buf_list, @continuous, @sequence
>   *			@state
> @@ -130,6 +132,8 @@ struct rvin_dev {
>
>  	struct mutex lock;
>  	struct vb2_queue queue;
> +	void *scratch;
> +	dma_addr_t scratch_phys;
>
>  	spinlock_t qlock;
>  	struct vb2_v4l2_buffer *queue_buf[HW_BUFFER_NUM];
> --
> 2.16.2
>

--LpQ9ahxlCli8rRTG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJapobBAAoJEHI0Bo8WoVY8tl8P/122gpN1fv+J3QEC2/CwdVrN
TFvZL6qJgn5dgY+JmCy3nY5D9SsWcM2Jv+L0W1KjLkSwyhLsaQeBoAMGXZ4iY4gb
8HDnFiEZeyar3/1mxA31uGKyAfnXDcQTIypg6EsAlxLOiVrhonJfSfpy2qTO3Jvw
tWFlU2RKwu0qomB49AzNlg/gPftkUdXm+/u/dO0QogAXl7r+WyOYGhG4L2jQ364x
JG5y4VFUOSabsJMmisupaIb/FbQSYbm3ACnpuhI5Samo4vTS4P08fOib3JRVGAOw
96Hp+KXy/atIrtS3Lo6+tCzNPFR2dydqfRVZKwkeh/THR1mPumdoRduxYYSNmDEE
9RFY/SYhCbZy9Ihj8PHSVi9ezjq+z21mu9KzAHFQksX9QbfiqgLVydeRZO+3X/a4
0m3U3Oxu5Dnv4mPsHi9mUqRXPNckLOVaAkQt2YuLziOmMHZQQdcYRtUb6g+QQfaQ
fVFAtr/2aOL7VirfLNkYQRGn/wEaFpiZ51H0VSJWEapSJ6P+GnGz/tGlpcYTSBVu
vTgWFmy52hI47HXRVbH3qst2jImQTvQL8izwkuA0rSnOVwoHGEvVLXD28GR/gNM2
kZrpZN6o5omk7vqnBw0gHqDoDuO/9KpeHBKBNbFE57w7Jl2sw/R8m4i4Vr1uwSfJ
tBhzL17Ibd6LUztaG/Ft
=blpB
-----END PGP SIGNATURE-----

--LpQ9ahxlCli8rRTG--
