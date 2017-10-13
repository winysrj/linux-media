Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f177.google.com ([209.85.216.177]:43945 "EHLO
        mail-qt0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751583AbdJMUxt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Oct 2017 16:53:49 -0400
Received: by mail-qt0-f177.google.com with SMTP id j58so10821782qtj.0
        for <linux-media@vger.kernel.org>; Fri, 13 Oct 2017 13:53:49 -0700 (PDT)
Message-ID: <1507928021.6538.38.camel@ndufresne.ca>
Subject: Re: [PATCH] venus: reimplement decoder stop command
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Date: Fri, 13 Oct 2017 16:53:41 -0400
In-Reply-To: <20171013141317.23211-1-stanimir.varbanov@linaro.org>
References: <20171013141317.23211-1-stanimir.varbanov@linaro.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-2dXfSdo0snf/iYA47ukl"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-2dXfSdo0snf/iYA47ukl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks, is the encoder stop command going to be implemented too ?

Le vendredi 13 octobre 2017 =C3=A0 17:13 +0300, Stanimir Varbanov a =C3=A9c=
rit :
> This addresses the wrong behavior of decoder stop command by
> rewriting it. These new implementation enqueue an empty buffer
> on the decoder input buffer queue to signal end-of-stream. The
> client should stop queuing buffers on the V4L2 Output queue
> and continue queuing/dequeuing buffers on Capture queue. This
> process will continue until the client receives a buffer with
> V4L2_BUF_FLAG_LAST flag raised, which means that this is last
> decoded buffer with data.
>=20
> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>

Tested-By: Nicolas Dufresne <nicolas.dufresne@collabora.com>

> ---
>  drivers/media/platform/qcom/venus/core.h    |  2 --
>  drivers/media/platform/qcom/venus/helpers.c |  7 ------
>  drivers/media/platform/qcom/venus/hfi.c     |  1 +
>  drivers/media/platform/qcom/venus/vdec.c    | 34
> +++++++++++++++++++----------
>  4 files changed, 24 insertions(+), 20 deletions(-)
>=20
> diff --git a/drivers/media/platform/qcom/venus/core.h
> b/drivers/media/platform/qcom/venus/core.h
> index cba092bcb76d..a0fe80df0cbd 100644
> --- a/drivers/media/platform/qcom/venus/core.h
> +++ b/drivers/media/platform/qcom/venus/core.h
> @@ -194,7 +194,6 @@ struct venus_buffer {
>   * @fh:	 a holder of v4l file handle structure
>   * @streamon_cap: stream on flag for capture queue
>   * @streamon_out: stream on flag for output queue
> - * @cmd_stop:	a flag to signal encoder/decoder commands
>   * @width:	current capture width
>   * @height:	current capture height
>   * @out_width:	current output width
> @@ -258,7 +257,6 @@ struct venus_inst {
>  	} controls;
>  	struct v4l2_fh fh;
>  	unsigned int streamon_cap, streamon_out;
> -	bool cmd_stop;
>  	u32 width;
>  	u32 height;
>  	u32 out_width;
> diff --git a/drivers/media/platform/qcom/venus/helpers.c
> b/drivers/media/platform/qcom/venus/helpers.c
> index cac429be5609..6a85dd10ecd4 100644
> --- a/drivers/media/platform/qcom/venus/helpers.c
> +++ b/drivers/media/platform/qcom/venus/helpers.c
> @@ -626,13 +626,6 @@ void venus_helper_vb2_buf_queue(struct
> vb2_buffer *vb)
> =20
>  	mutex_lock(&inst->lock);
> =20
> -	if (inst->cmd_stop) {
> -		vbuf->flags |=3D V4L2_BUF_FLAG_LAST;
> -		v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_DONE);
> -		inst->cmd_stop =3D false;
> -		goto unlock;
> -	}
> -
>  	v4l2_m2m_buf_queue(m2m_ctx, vbuf);
> =20
>  	if (!(inst->streamon_out & inst->streamon_cap))
> diff --git a/drivers/media/platform/qcom/venus/hfi.c
> b/drivers/media/platform/qcom/venus/hfi.c
> index c09490876516..ba29fd4d4984 100644
> --- a/drivers/media/platform/qcom/venus/hfi.c
> +++ b/drivers/media/platform/qcom/venus/hfi.c
> @@ -484,6 +484,7 @@ int hfi_session_process_buf(struct venus_inst
> *inst, struct hfi_frame_data *fd)
> =20
>  	return -EINVAL;
>  }
> +EXPORT_SYMBOL_GPL(hfi_session_process_buf);
> =20
>  irqreturn_t hfi_isr_thread(int irq, void *dev_id)
>  {
> diff --git a/drivers/media/platform/qcom/venus/vdec.c
> b/drivers/media/platform/qcom/venus/vdec.c
> index da611a5eb670..c9e9576bb08a 100644
> --- a/drivers/media/platform/qcom/venus/vdec.c
> +++ b/drivers/media/platform/qcom/venus/vdec.c
> @@ -469,8 +469,14 @@ static int vdec_subscribe_event(struct v4l2_fh
> *fh,
>  static int
>  vdec_try_decoder_cmd(struct file *file, void *fh, struct
> v4l2_decoder_cmd *cmd)
>  {
> -	if (cmd->cmd !=3D V4L2_DEC_CMD_STOP)
> +	switch (cmd->cmd) {
> +	case V4L2_DEC_CMD_STOP:
> +		if (cmd->flags & V4L2_DEC_CMD_STOP_TO_BLACK)
> +			return -EINVAL;
> +		break;
> +	default:
>  		return -EINVAL;
> +	}
> =20
>  	return 0;
>  }
> @@ -479,6 +485,7 @@ static int
>  vdec_decoder_cmd(struct file *file, void *fh, struct
> v4l2_decoder_cmd *cmd)
>  {
>  	struct venus_inst *inst =3D to_inst(file);
> +	struct hfi_frame_data fdata =3D {0};
>  	int ret;
> =20
>  	ret =3D vdec_try_decoder_cmd(file, fh, cmd);
> @@ -486,12 +493,23 @@ vdec_decoder_cmd(struct file *file, void *fh,
> struct v4l2_decoder_cmd *cmd)
>  		return ret;
> =20
>  	mutex_lock(&inst->lock);
> -	inst->cmd_stop =3D true;
> -	mutex_unlock(&inst->lock);
> =20
> -	hfi_session_flush(inst);
> +	/*
> +	 * Implement V4L2_DEC_CMD_STOP by enqueue an empty buffer on
> decoder
> +	 * input to signal EOS.
> +	 */
> +	if (!(inst->streamon_out & inst->streamon_cap))
> +		goto unlock;
> +
> +	fdata.buffer_type =3D HFI_BUFFER_INPUT;
> +	fdata.flags |=3D HFI_BUFFERFLAG_EOS;
> +	fdata.device_addr =3D 0xdeadbeef;
> =20
> -	return 0;
> +	ret =3D hfi_session_process_buf(inst, &fdata);
> +
> +unlock:
> +	mutex_unlock(&inst->lock);
> +	return ret;
>  }
> =20
>  static const struct v4l2_ioctl_ops vdec_ioctl_ops =3D {
> @@ -718,7 +736,6 @@ static int vdec_start_streaming(struct vb2_queue
> *q, unsigned int count)
>  	inst->reconfig =3D false;
>  	inst->sequence_cap =3D 0;
>  	inst->sequence_out =3D 0;
> -	inst->cmd_stop =3D false;
> =20
>  	ret =3D vdec_init_session(inst);
>  	if (ret)
> @@ -807,11 +824,6 @@ static void vdec_buf_done(struct venus_inst
> *inst, unsigned int buf_type,
>  		vb->timestamp =3D timestamp_us * NSEC_PER_USEC;
>  		vbuf->sequence =3D inst->sequence_cap++;
> =20
> -		if (inst->cmd_stop) {
> -			vbuf->flags |=3D V4L2_BUF_FLAG_LAST;
> -			inst->cmd_stop =3D false;
> -		}
> -
>  		if (vbuf->flags & V4L2_BUF_FLAG_LAST) {
>  			const struct v4l2_event ev =3D { .type =3D
> V4L2_EVENT_EOS };
> =20
--=-2dXfSdo0snf/iYA47ukl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCWeEn1QAKCRBxUwItrAao
HArWAJ0VdcxQcvQRDLo5sjG3NP30DmFb5ACcDuATODrcjkpbMRlfxaStO6DBuHY=
=3mwI
-----END PGP SIGNATURE-----

--=-2dXfSdo0snf/iYA47ukl--
