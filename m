Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:54138 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751307AbeD1S66 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Apr 2018 14:58:58 -0400
Subject: Re: [PATCH v2 7/8] v4l: vsp1: Integrate DISCOM in display pipeline
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: linux-renesas-soc@vger.kernel.org
References: <20180422223430.16407-1-laurent.pinchart+renesas@ideasonboard.com>
 <20180422223430.16407-8-laurent.pinchart+renesas@ideasonboard.com>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <759b7675-d0d5-4a31-0949-2affd4019f77@ideasonboard.com>
Date: Sat, 28 Apr 2018 19:58:53 +0100
MIME-Version: 1.0
In-Reply-To: <20180422223430.16407-8-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="aPAVEkRzjzRusHsseSKns7WAW7c7aDkQV"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--aPAVEkRzjzRusHsseSKns7WAW7c7aDkQV
Content-Type: multipart/mixed; boundary="RIfJVez3AIWgD0DkQq8RRXIU6WodBxz4h";
 protected-headers="v1"
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: linux-renesas-soc@vger.kernel.org
Message-ID: <759b7675-d0d5-4a31-0949-2affd4019f77@ideasonboard.com>
Subject: Re: [PATCH v2 7/8] v4l: vsp1: Integrate DISCOM in display pipeline
References: <20180422223430.16407-1-laurent.pinchart+renesas@ideasonboard.com>
 <20180422223430.16407-8-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20180422223430.16407-8-laurent.pinchart+renesas@ideasonboard.com>

--RIfJVez3AIWgD0DkQq8RRXIU6WodBxz4h
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

Hi Laurent,

On 22/04/18 23:34, Laurent Pinchart wrote:
> The DISCOM is used to compute CRCs on display frames. Integrate it in
> the display pipeline at the output of the blending unit to process
> output frames.
>=20
> Computing CRCs on input frames is possible by positioning the DISCOM at=

> a different point in the pipeline. This use case isn't supported at the=

> moment and could be implemented by extending the API between the VSP1
> and DU drivers if needed.
>=20
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.=
com>

Only a couple of small questions - but nothing to block an RB tag.

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
>  drivers/media/platform/vsp1/vsp1_drm.c | 115 +++++++++++++++++++++++++=
+++++++-
>  drivers/media/platform/vsp1/vsp1_drm.h |  12 ++++
>  2 files changed, 124 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/pla=
tform/vsp1/vsp1_drm.c
> index 5fc31578f9b0..7864b43a90e1 100644
> --- a/drivers/media/platform/vsp1/vsp1_drm.c
> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> @@ -22,6 +22,7 @@
>  #include "vsp1_lif.h"
>  #include "vsp1_pipe.h"
>  #include "vsp1_rwpf.h"
> +#include "vsp1_uif.h"
> =20
>  #define BRX_NAME(e)	(e)->type =3D=3D VSP1_ENTITY_BRU ? "BRU" : "BRS"
> =20
> @@ -35,8 +36,13 @@ static void vsp1_du_pipeline_frame_end(struct vsp1_p=
ipeline *pipe,
>  	struct vsp1_drm_pipeline *drm_pipe =3D to_vsp1_drm_pipeline(pipe);
>  	bool complete =3D completion =3D=3D VSP1_DL_FRAME_END_COMPLETED;
> =20
> -	if (drm_pipe->du_complete)
> -		drm_pipe->du_complete(drm_pipe->du_private, complete, 0);
> +	if (drm_pipe->du_complete) {
> +		struct vsp1_entity *uif =3D drm_pipe->uif;
> +		u32 crc;
> +
> +		crc =3D uif ? vsp1_uif_get_crc(to_uif(&uif->subdev)) : 0;
> +		drm_pipe->du_complete(drm_pipe->du_private, complete, crc);
> +	}
> =20
>  	if (completion & VSP1_DL_FRAME_END_INTERNAL) {
>  		drm_pipe->force_brx_release =3D false;
> @@ -48,10 +54,65 @@ static void vsp1_du_pipeline_frame_end(struct vsp1_=
pipeline *pipe,
>   * Pipeline Configuration
>   */
> =20
> +/*
> + * Insert the UIF in the pipeline between the prev and next entities. =
If no UIF
> + * is available connect the two entities directly.
> + */
> +static int vsp1_du_insert_uif(struct vsp1_device *vsp1,
> +			      struct vsp1_pipeline *pipe,
> +			      struct vsp1_entity *uif,
> +			      struct vsp1_entity *prev, unsigned int prev_pad,
> +			      struct vsp1_entity *next, unsigned int next_pad)
> +{
> +	int ret;
> +
> +	if (uif) {
> +		struct v4l2_subdev_format format;
> +
> +		prev->sink =3D uif;
> +		prev->sink_pad =3D UIF_PAD_SINK;
> +
> +		memset(&format, 0, sizeof(format));
> +		format.which =3D V4L2_SUBDEV_FORMAT_ACTIVE;
> +		format.pad =3D prev_pad;
> +
> +		ret =3D v4l2_subdev_call(&prev->subdev, pad, get_fmt, NULL,
> +				       &format);
> +		if (ret < 0)
> +			return ret;
> +
> +		format.pad =3D UIF_PAD_SINK;
> +
> +		ret =3D v4l2_subdev_call(&uif->subdev, pad, set_fmt, NULL,
> +				       &format);
> +		if (ret < 0)
> +			return ret;
> +
> +		dev_dbg(vsp1->dev, "%s: set format %ux%u (%x) on UIF sink\n",
> +			__func__, format.format.width, format.format.height,
> +			format.format.code);
> +
> +		/*
> +		 * The UIF doesn't mangle the format between its sink and
> +		 * source pads, so there is no need to retrieve the format on
> +		 * its source pad.
> +		 */
> +
> +		uif->sink =3D next;
> +		uif->sink_pad =3D next_pad;
> +	} else {
> +		prev->sink =3D next;
> +		prev->sink_pad =3D next_pad;
> +	}
> +
> +	return 0;
> +}
> +
>  /* Setup one RPF and the connected BRx sink pad. */
>  static int vsp1_du_pipeline_setup_rpf(struct vsp1_device *vsp1,
>  				      struct vsp1_pipeline *pipe,
>  				      struct vsp1_rwpf *rpf,
> +				      struct vsp1_entity *uif,
>  				      unsigned int brx_input)
>  {
>  	struct v4l2_subdev_selection sel;
> @@ -122,6 +183,12 @@ static int vsp1_du_pipeline_setup_rpf(struct vsp1_=
device *vsp1,
>  	if (ret < 0)
>  		return ret;
> =20
> +	/* Insert and configure the UIF if available. */
> +	ret =3D vsp1_du_insert_uif(vsp1, pipe, uif, &rpf->entity, RWPF_PAD_SO=
URCE,
> +				 pipe->brx, brx_input);
> +	if (ret < 0)
> +		return ret;
> +
>  	/* BRx sink, propagate the format from the RPF source. */
>  	format.pad =3D brx_input;
> =20
> @@ -297,7 +364,10 @@ static unsigned int rpf_zpos(struct vsp1_device *v=
sp1, struct vsp1_rwpf *rpf)
>  static int vsp1_du_pipeline_setup_inputs(struct vsp1_device *vsp1,
>  					struct vsp1_pipeline *pipe)
>  {
> +	struct vsp1_drm_pipeline *drm_pipe =3D to_vsp1_drm_pipeline(pipe);
>  	struct vsp1_rwpf *inputs[VSP1_MAX_RPF] =3D { NULL, };
> +	struct vsp1_entity *uif;
> +	bool use_uif =3D false;
>  	struct vsp1_brx *brx;
>  	unsigned int i;
>  	int ret;
> @@ -358,7 +428,11 @@ static int vsp1_du_pipeline_setup_inputs(struct vs=
p1_device *vsp1,
>  		dev_dbg(vsp1->dev, "%s: connecting RPF.%u to %s:%u\n",
>  			__func__, rpf->entity.index, BRX_NAME(pipe->brx), i);
> =20
> -		ret =3D vsp1_du_pipeline_setup_rpf(vsp1, pipe, rpf, i);
> +		uif =3D drm_pipe->crc.source =3D=3D VSP1_DU_CRC_PLANE &&
> +		      drm_pipe->crc.index =3D=3D i ? drm_pipe->uif : NULL;
> +		if (uif)
> +			use_uif =3D true;
> +		ret =3D vsp1_du_pipeline_setup_rpf(vsp1, pipe, rpf, uif, i);
>  		if (ret < 0) {
>  			dev_err(vsp1->dev,
>  				"%s: failed to setup RPF.%u\n",
> @@ -367,6 +441,31 @@ static int vsp1_du_pipeline_setup_inputs(struct vs=
p1_device *vsp1,
>  		}
>  	}
> =20
> +	/* Insert and configure the UIF at the BRx output if available. */
> +	uif =3D drm_pipe->crc.source =3D=3D VSP1_DU_CRC_OUTPUT ? drm_pipe->ui=
f : NULL;
> +	if (uif)
> +		use_uif =3D true;
> +	ret =3D vsp1_du_insert_uif(vsp1, pipe, uif,
> +				 pipe->brx, pipe->brx->source_pad,
> +				 &pipe->output->entity, 0);
> +	if (ret < 0)
> +		dev_err(vsp1->dev, "%s: failed to setup UIF after %s\n",
> +			__func__, BRX_NAME(pipe->brx));
> +
> +	/*
> +	 * If the UIF is not in use schedule it for removal by setting its pi=
pe
> +	 * pointer to NULL, vsp1_du_pipeline_configure() will remove it from =
the
> +	 * hardware pipeline and from the pipeline's list of entities. Otherw=
ise
> +	 * make sure it is present in the pipeline's list of entities if it
> +	 * wasn't already.
> +	 */
> +	if (!use_uif) {

Do we need use_uif here? Wouldn't uif suffice? - Oh - no it wouldn't. A U=
IF at
RPF would get overwritten by the lack of UIF at BRx.

Nothing to see here. Move along...


> +		drm_pipe->uif->pipe =3D NULL;
> +	} else if (!drm_pipe->uif->pipe) {
> +		drm_pipe->uif->pipe =3D pipe;
> +		list_add_tail(&drm_pipe->uif->list_pipe, &pipe->entities);
> +	}
> +
>  	return 0;
>  }
> =20
> @@ -748,6 +847,9 @@ void vsp1_du_atomic_flush(struct device *dev, unsig=
ned int pipe_index,
>  	struct vsp1_drm_pipeline *drm_pipe =3D &vsp1->drm->pipe[pipe_index];
>  	struct vsp1_pipeline *pipe =3D &drm_pipe->pipe;
> =20
> +	drm_pipe->crc.source =3D cfg->crc.source;
> +	drm_pipe->crc.index =3D cfg->crc.index;

I think this could be shortened to

	drm_pipe->crc =3D cfg->crc;

Or is that a GCC extension. Either way, it's just a matter of taste, and =
you
might prefer to be more explicit.


> +
>  	vsp1_du_pipeline_setup_inputs(vsp1, pipe);
>  	vsp1_du_pipeline_configure(pipe);
>  	mutex_unlock(&vsp1->drm->lock);
> @@ -816,6 +918,13 @@ int vsp1_drm_init(struct vsp1_device *vsp1)
> =20
>  		pipe->lif->pipe =3D pipe;
>  		list_add_tail(&pipe->lif->list_pipe, &pipe->entities);
> +
> +		/*
> +		 * CRC computation is initially disabled, don't add the UIF to
> +		 * the pipeline.
> +		 */
> +		if (i < vsp1->info->uif_count)
> +			drm_pipe->uif =3D &vsp1->uif[i]->entity;
>  	}
> =20
>  	/* Disable all RPFs initially. */
> diff --git a/drivers/media/platform/vsp1/vsp1_drm.h b/drivers/media/pla=
tform/vsp1/vsp1_drm.h
> index e5b88b28806c..1e7670955ef0 100644
> --- a/drivers/media/platform/vsp1/vsp1_drm.h
> +++ b/drivers/media/platform/vsp1/vsp1_drm.h
> @@ -13,6 +13,8 @@
>  #include <linux/videodev2.h>
>  #include <linux/wait.h>
> =20
> +#include <media/vsp1.h>
> +
>  #include "vsp1_pipe.h"
> =20
>  /**
> @@ -22,6 +24,9 @@
>   * @height: output display height
>   * @force_brx_release: when set, release the BRx during the next recon=
figuration
>   * @wait_queue: wait queue to wait for BRx release completion
> + * @uif: UIF entity if available for the pipeline
> + * @crc.source: source for CRC calculation
> + * @crc.index: index of the CRC source plane (when crc.source is set t=
o plane)
>   * @du_complete: frame completion callback for the DU driver (optional=
)
>   * @du_private: data to be passed to the du_complete callback
>   */
> @@ -34,6 +39,13 @@ struct vsp1_drm_pipeline {
>  	bool force_brx_release;
>  	wait_queue_head_t wait_queue;
> =20
> +	struct vsp1_entity *uif;
> +
> +	struct {
> +		enum vsp1_du_crc_source source;
> +		unsigned int index;
> +	} crc;

Does this have to be duplicated ? Or can it be included from the API head=
er...


> +
>  	/* Frame synchronisation */
>  	void (*du_complete)(void *data, bool completed, u32 crc);
>  	void *du_private;
>=20


--RIfJVez3AIWgD0DkQq8RRXIU6WodBxz4h--

--aPAVEkRzjzRusHsseSKns7WAW7c7aDkQV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEkC3XmD+9KP3jctR6oR5GchCkYf0FAlrkxG0ACgkQoR5GchCk
Yf25GRAAgNW4ACjanHGRDLCSDlIpuBw2rftm2Sq9u2rAWC7980jRcZJQMbLpuD8O
ePB0uxtsOT/iYUheAyGVoJzfqb5CYpiY0KZDwWWy2En7jRMqC35MI0k/tletmtbh
uOJZajYIepJA2n1vOyCyDZC+grdR3hvnvxKe0OxaMdRFmso/Nn5JyTW3/m/gS6tc
goH2LtkOVop/CyQiCLu8VTZAzmezKz5asEKHhiep76iAxnhPCbjr9G/6atgUoujG
p54PZeSysYXUFWry334GLSsGE6VozJzOzhVtX8utZBeqrB0nBwjYcNKw7bS45bKD
etJ/iAseBlbcf+SlKGWTrAUj+P/JoUNHysswFtbOytfPL34rY4Jny+mjeIeNS+lZ
NOw36AiQqspQWBS5ZAi/cCAAz47jnPQhPFgfrKE0Ycf5n2RMAartUuFPyskJi+YU
9ofhxiLzA88WsnxvBsCLpTvNXITR2++vFf4orcePgH3gK1LlLoIvypKGBF1Hh0NR
xqrp7RUfwF9YD5r/jhRcGiyGiaHiet3aeB+UtrNTyjowmcdiHl/mVO6C3KV9w8DO
DO5sbBgw8Vb17/gm5PqrJUO44pg8jukbdgfVbmrcuTLBzvDk52M7tUTx3pfQdbIJ
Arpb7byz/2mFzR1TRYXfRyK5/WvYGsa6tHnvXhPr8zK5sI6lrRw=
=9TDU
-----END PGP SIGNATURE-----

--aPAVEkRzjzRusHsseSKns7WAW7c7aDkQV--
