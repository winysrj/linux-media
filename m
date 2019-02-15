Return-Path: <SRS0=2oy6=QW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE557C43381
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 16:27:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B9F220643
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 16:27:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ndufresne-ca.20150623.gappssmtp.com header.i=@ndufresne-ca.20150623.gappssmtp.com header.b="UrltjL2k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbfBOQ1Y (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 15 Feb 2019 11:27:24 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:42451 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbfBOQ1Y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Feb 2019 11:27:24 -0500
Received: by mail-qk1-f193.google.com with SMTP id y140so6011421qkb.9
        for <linux-media@vger.kernel.org>; Fri, 15 Feb 2019 08:27:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version;
        bh=WmFw3QdLQY3TP/dl5luBcYUSlly/XoicBv+DaahtqdA=;
        b=UrltjL2kdMlAw69zHbGeBSd1O9uzPePynyqA7Mn0pxyzFoETDQo1QXcKEa4TI2qgfO
         KpVaqAY0pf5vzrujp906w0qZ94Q+VUzwRzhNK3UJZYicpogL4XAXm+LmIcqm5m/LOQP2
         dR7CRPmiFJ83NswBy7NeHLWuUPluka0zi/gHiFS1vC/uvoVjpOY2CADdpxXTFyTDy4iI
         fuzHHnFXLdMGPwsOQksE3XNFWmGaU1OliJppG32bxluzjWXaUJFcmB2gnqUUqdv38vuE
         yd4KlVVSTeUAIXgBRdAZrbHlyTQjK/x0IYBTZfdXRmQfAbZtZowmyLov0/NGi15hEQQs
         hBHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version;
        bh=WmFw3QdLQY3TP/dl5luBcYUSlly/XoicBv+DaahtqdA=;
        b=Wag7NMvyR/yjvyX55/my2s0jRegUAMY3iLKfMwWYL9VO53AIk2DqBT0dpIq5Ht3yvq
         0GI5Vw+VKpUBZ2jjHUbjmGPo+EheXFYiieFPdKcK37fNmajGidJN0iisUknIFy3RNJJD
         TFBH5BC5tOn/k+ub62rsiGAJFMCnFEFSZKfnRg52NV6olnqtR3NLWNOQVvA5b27mS0S6
         Be96MRPCC7OntII3MTLte0wojmDXj+WL9EdG9/Y5+ACV8Ie9fKoW6f9UIVQDUmbZ7NuL
         8YT1TcyehO33S0gQ19MUfjE+u4tHiDdygS3ER/EARXhfKw/cmYc6JJBIQiVLT/W2DMeH
         ++Cw==
X-Gm-Message-State: AHQUAuZLHujJym6Mo/LLLxnZCBs7WvPw6kuFjgDTSc1gVGMmPD7ig2Bq
        SU9B1wwoiTw/Mh0WTJRSn0x9OQ==
X-Google-Smtp-Source: AHgI3IbyAhR0aZWENKU5M4ym/aWLjIsH5rc2bOloR/iO60y/3/dNrtl10W5hQQTdJPL0UEB3gYXlOA==
X-Received: by 2002:a37:e40f:: with SMTP id y15mr7621524qkf.230.1550248041831;
        Fri, 15 Feb 2019 08:27:21 -0800 (PST)
Received: from tpx230-nicolas.collaboramtl (modemcable154.55-37-24.static.videotron.ca. [24.37.55.154])
        by smtp.gmail.com with ESMTPSA id o42sm3472885qtc.90.2019.02.15.08.27.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 15 Feb 2019 08:27:21 -0800 (PST)
Message-ID: <40093e3ebce5bbb4763c845d3b1746bf8021582f.camel@ndufresne.ca>
Subject: Re: [PATCH 10/10] venus: dec: make decoder compliant with stateful
 codec API
From:   Nicolas Dufresne <nicolas@ndufresne.ca>
To:     Hans Verkuil <hverkuil@xs4all.nl>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        linux-media@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Malathi Gottam <mgottam@codeaurora.org>
Date:   Fri, 15 Feb 2019 11:27:19 -0500
In-Reply-To: <60b3efff-31c1-bc04-8af9-deebb8bc013a@xs4all.nl>
References: <20190117162008.25217-1-stanimir.varbanov@linaro.org>
         <20190117162008.25217-11-stanimir.varbanov@linaro.org>
         <60b3efff-31c1-bc04-8af9-deebb8bc013a@xs4all.nl>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-5ha/0lTbNrqVP2kPsybM"
User-Agent: Evolution 3.30.4 (3.30.4-1.fc29) 
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--=-5ha/0lTbNrqVP2kPsybM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le vendredi 15 f=C3=A9vrier 2019 =C3=A0 14:44 +0100, Hans Verkuil a =C3=A9c=
rit :
> Hi Stanimir,
>=20
> I never paid much attention to this patch series since others were busy
> discussing it and I had a lot of other things on my plate, but then I hea=
rd
> that this patch made G_FMT blocking.
>=20
> That's a no-go. Apparently s5p-mfc does that as well, and that's against
> the V4L2 spec as well (clearly I never realized that at the time).
>=20
> So, just to make it unambiguous:
>=20
> Nacked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Careful if you pull out this code from S5P MFC though, since you'll
break userspace and we don't like when kernel do that. As we discussed,
Philipp in CODA came up with a clever workaround, so if one have the
idea of touching MFC, please make sure to do so correctly.

>=20
> Now, I plan to work on adding stateful codec checks to v4l2-compliance.
> I had hoped to do some of that already, but didn't manage to find time
> this week. I hope to have something decent in 2-3 weeks from now.
>=20
> So I would wait with making this driver compliant until I have written
> the tests.
>=20
> Initially I'll test this with vicodec, but the next phase would be to
> make it work with e.g. a venus codec. I might contact you for help
> when I start work on that.
>=20
> Regards,
>=20
> 	Hans
>=20
> On 1/17/19 5:20 PM, Stanimir Varbanov wrote:
> > This refactored code for start/stop streaming vb2 operations and
> > adds a state machine handling similar to the one in stateful codec
> > API documentation. One major change is that now the HFI session is
> > started on STREAMON(OUTPUT) and stopped on REQBUF(OUTPUT,count=3D0),
> > during that time streamoff(cap,out) just flush buffers but doesn't
> > stop the session. The other major change is that now the capture
> > and output queues are completely separated.
> >=20
> > Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> > ---
> >  drivers/media/platform/qcom/venus/core.h    |  20 +-
> >  drivers/media/platform/qcom/venus/helpers.c |  23 +-
> >  drivers/media/platform/qcom/venus/helpers.h |   5 +
> >  drivers/media/platform/qcom/venus/vdec.c    | 449 ++++++++++++++++----
> >  4 files changed, 389 insertions(+), 108 deletions(-)
> >=20
> > diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/p=
latform/qcom/venus/core.h
> > index 79c7e816c706..5a133c203455 100644
> > --- a/drivers/media/platform/qcom/venus/core.h
> > +++ b/drivers/media/platform/qcom/venus/core.h
> > @@ -218,6 +218,15 @@ struct venus_buffer {
> > =20
> >  #define to_venus_buffer(ptr)	container_of(ptr, struct venus_buffer, vb=
)
> > =20
> > +#define DEC_STATE_UNINIT		0
> > +#define DEC_STATE_INIT			1
> > +#define DEC_STATE_CAPTURE_SETUP		2
> > +#define DEC_STATE_STOPPED		3
> > +#define DEC_STATE_SEEK			4
> > +#define DEC_STATE_DRAIN			5
> > +#define DEC_STATE_DECODING		6
> > +#define DEC_STATE_DRC			7
> > +
> >  /**
> >   * struct venus_inst - holds per instance paramerters
> >   *
> > @@ -241,6 +250,10 @@ struct venus_buffer {
> >   * @colorspace:	current color space
> >   * @quantization:	current quantization
> >   * @xfer_func:	current xfer function
> > + * @codec_state:	current codec API state (see DEC/ENC_STATE_)
> > + * @reconf_wait:	wait queue for resolution change event
> > + * @ten_bits:		does new stream is 10bits depth
> > + * @buf_count:		used to count number number of buffers (reqbuf(0))
> >   * @fps:		holds current FPS
> >   * @timeperframe:	holds current time per frame structure
> >   * @fmt_out:	a reference to output format structure
> > @@ -255,8 +268,6 @@ struct venus_buffer {
> >   * @opb_buftype:	output picture buffer type
> >   * @opb_fmt:		output picture buffer raw format
> >   * @reconfig:	a flag raised by decoder when the stream resolution chan=
ged
> > - * @reconfig_width:	holds the new width
> > - * @reconfig_height:	holds the new height
> >   * @hfi_codec:		current codec for this instance in HFI space
> >   * @sequence_cap:	a sequence counter for capture queue
> >   * @sequence_out:	a sequence counter for output queue
> > @@ -296,6 +307,9 @@ struct venus_inst {
> >  	u8 ycbcr_enc;
> >  	u8 quantization;
> >  	u8 xfer_func;
> > +	unsigned int codec_state;
> > +	wait_queue_head_t reconf_wait;
> > +	int buf_count;
> >  	u64 fps;
> >  	struct v4l2_fract timeperframe;
> >  	const struct venus_format *fmt_out;
> > @@ -310,8 +324,6 @@ struct venus_inst {
> >  	u32 opb_buftype;
> >  	u32 opb_fmt;
> >  	bool reconfig;
> > -	u32 reconfig_width;
> > -	u32 reconfig_height;
> >  	u32 hfi_codec;
> >  	u32 sequence_cap;
> >  	u32 sequence_out;
> > diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/medi=
a/platform/qcom/venus/helpers.c
> > index 637ce7b82d94..25d8cceccae4 100644
> > --- a/drivers/media/platform/qcom/venus/helpers.c
> > +++ b/drivers/media/platform/qcom/venus/helpers.c
> > @@ -1030,16 +1030,15 @@ void venus_helper_vb2_buf_queue(struct vb2_buff=
er *vb)
> > =20
> >  	v4l2_m2m_buf_queue(m2m_ctx, vbuf);
> > =20
> > -	if (!(inst->streamon_out & inst->streamon_cap))
> > -		goto unlock;
> > -
> > -	ret =3D is_buf_refed(inst, vbuf);
> > -	if (ret)
> > -		goto unlock;
> > +	if (IS_OUT(vb->vb2_queue, inst) || IS_CAP(vb->vb2_queue, inst)) {
> > +		ret =3D is_buf_refed(inst, vbuf);
> > +		if (ret)
> > +			goto unlock;
> > =20
> > -	ret =3D session_process_buf(inst, vbuf);
> > -	if (ret)
> > -		return_buf_error(inst, vbuf);
> > +		ret =3D session_process_buf(inst, vbuf);
> > +		if (ret)
> > +			return_buf_error(inst, vbuf);
> > +	}
> > =20
> >  unlock:
> >  	mutex_unlock(&inst->lock);
> > @@ -1155,14 +1154,8 @@ int venus_helper_vb2_start_streaming(struct venu=
s_inst *inst)
> >  	if (ret)
> >  		goto err_unload_res;
> > =20
> > -	ret =3D venus_helper_queue_dpb_bufs(inst);
> > -	if (ret)
> > -		goto err_session_stop;
> > -
> >  	return 0;
> > =20
> > -err_session_stop:
> > -	hfi_session_stop(inst);
> >  err_unload_res:
> >  	hfi_session_unload_res(inst);
> >  err_unreg_bufs:
> > diff --git a/drivers/media/platform/qcom/venus/helpers.h b/drivers/medi=
a/platform/qcom/venus/helpers.h
> > index 2ec1c1a8b416..3b46139b5ee1 100644
> > --- a/drivers/media/platform/qcom/venus/helpers.h
> > +++ b/drivers/media/platform/qcom/venus/helpers.h
> > @@ -17,6 +17,11 @@
> > =20
> >  #include <media/videobuf2-v4l2.h>
> > =20
> > +#define IS_OUT(q, inst) (inst->streamon_out &&	\
> > +		q->type =3D=3D V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> > +#define IS_CAP(q, inst) (inst->streamon_cap &&	\
> > +		q->type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> > +
> >  struct venus_inst;
> >  struct venus_core;
> > =20
> > diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/p=
latform/qcom/venus/vdec.c
> > index 7a9370df7515..306e0f7d3337 100644
> > --- a/drivers/media/platform/qcom/venus/vdec.c
> > +++ b/drivers/media/platform/qcom/venus/vdec.c
> > @@ -201,28 +201,18 @@ static int vdec_g_fmt(struct file *file, void *fh=
, struct v4l2_format *f)
> >  	struct venus_inst *inst =3D to_inst(file);
> >  	const struct venus_format *fmt =3D NULL;
> >  	struct v4l2_pix_format_mplane *pixmp =3D &f->fmt.pix_mp;
> > +	int ret;
> > =20
> >  	if (f->type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> >  		fmt =3D inst->fmt_cap;
> >  	else if (f->type =3D=3D V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> >  		fmt =3D inst->fmt_out;
> > =20
> > -	if (inst->reconfig) {
> > -		struct v4l2_format format =3D {};
> > -
> > -		inst->out_width =3D inst->reconfig_width;
> > -		inst->out_height =3D inst->reconfig_height;
> > -		inst->reconfig =3D false;
> > -
> > -		format.type =3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> > -		format.fmt.pix_mp.pixelformat =3D inst->fmt_cap->pixfmt;
> > -		format.fmt.pix_mp.width =3D inst->out_width;
> > -		format.fmt.pix_mp.height =3D inst->out_height;
> > -
> > -		vdec_try_fmt_common(inst, &format);
> > -
> > -		inst->width =3D format.fmt.pix_mp.width;
> > -		inst->height =3D format.fmt.pix_mp.height;
> > +	if (f->type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> > +		ret =3D wait_event_timeout(inst->reconf_wait, inst->reconfig,
> > +					 msecs_to_jiffies(100));
> > +		if (!ret)
> > +			return -EINVAL;
> >  	}
> > =20
> >  	pixmp->pixelformat =3D fmt->pixfmt;
> > @@ -457,6 +447,10 @@ vdec_try_decoder_cmd(struct file *file, void *fh, =
struct v4l2_decoder_cmd *cmd)
> >  		if (cmd->flags & V4L2_DEC_CMD_STOP_TO_BLACK)
> >  			return -EINVAL;
> >  		break;
> > +	case V4L2_DEC_CMD_START:
> > +		if (cmd->flags & V4L2_DEC_CMD_START_MUTE_AUDIO)
> > +			return -EINVAL;
> > +		break;
> >  	default:
> >  		return -EINVAL;
> >  	}
> > @@ -477,18 +471,23 @@ vdec_decoder_cmd(struct file *file, void *fh, str=
uct v4l2_decoder_cmd *cmd)
> > =20
> >  	mutex_lock(&inst->lock);
> > =20
> > -	/*
> > -	 * Implement V4L2_DEC_CMD_STOP by enqueue an empty buffer on decoder
> > -	 * input to signal EOS.
> > -	 */
> > -	if (!(inst->streamon_out & inst->streamon_cap))
> > -		goto unlock;
> > +	if (cmd->cmd =3D=3D V4L2_DEC_CMD_STOP) {
> > +		/*
> > +		 * Implement V4L2_DEC_CMD_STOP by enqueue an empty buffer on
> > +		 * decoder input to signal EOS.
> > +		 */
> > +		if (!(inst->streamon_out & inst->streamon_cap))
> > +			goto unlock;
> > =20
> > -	fdata.buffer_type =3D HFI_BUFFER_INPUT;
> > -	fdata.flags |=3D HFI_BUFFERFLAG_EOS;
> > -	fdata.device_addr =3D 0xdeadbeef;
> > +		fdata.buffer_type =3D HFI_BUFFER_INPUT;
> > +		fdata.flags |=3D HFI_BUFFERFLAG_EOS;
> > +		fdata.device_addr =3D 0xdeadb000;
> > =20
> > -	ret =3D hfi_session_process_buf(inst, &fdata);
> > +		ret =3D hfi_session_process_buf(inst, &fdata);
> > +
> > +		if (!ret && inst->codec_state =3D=3D DEC_STATE_DECODING)
> > +			inst->codec_state =3D DEC_STATE_DRAIN;
> > +	}
> > =20
> >  unlock:
> >  	mutex_unlock(&inst->lock);
> > @@ -649,20 +648,18 @@ static int vdec_output_conf(struct venus_inst *in=
st)
> >  	return 0;
> >  }
> > =20
> > -static int vdec_init_session(struct venus_inst *inst)
> > +static int vdec_session_init(struct venus_inst *inst)
> >  {
> >  	int ret;
> > =20
> >  	ret =3D hfi_session_init(inst, inst->fmt_out->pixfmt);
> > -	if (ret)
> > +	if (ret =3D=3D -EINVAL)
> > +		return 0;
> > +	else if (ret)
> >  		return ret;
> > =20
> > -	ret =3D venus_helper_set_input_resolution(inst, inst->out_width,
> > -						inst->out_height);
> > -	if (ret)
> > -		goto deinit;
> > -
> > -	ret =3D venus_helper_set_color_format(inst, inst->fmt_cap->pixfmt);
> > +	ret =3D venus_helper_set_input_resolution(inst, frame_width_min(inst)=
,
> > +						frame_height_min(inst));
> >  	if (ret)
> >  		goto deinit;
> > =20
> > @@ -681,26 +678,19 @@ static int vdec_num_buffers(struct venus_inst *in=
st, unsigned int *in_num,
> > =20
> >  	*in_num =3D *out_num =3D 0;
> > =20
> > -	ret =3D vdec_init_session(inst);
> > -	if (ret)
> > -		return ret;
> > -
> >  	ret =3D venus_helper_get_bufreq(inst, HFI_BUFFER_INPUT, &bufreq);
> >  	if (ret)
> > -		goto deinit;
> > +		return ret;
> > =20
> >  	*in_num =3D HFI_BUFREQ_COUNT_MIN(&bufreq, ver);
> > =20
> >  	ret =3D venus_helper_get_bufreq(inst, HFI_BUFFER_OUTPUT, &bufreq);
> >  	if (ret)
> > -		goto deinit;
> > +		return ret;
> > =20
> >  	*out_num =3D HFI_BUFREQ_COUNT_MIN(&bufreq, ver);
> > =20
> > -deinit:
> > -	hfi_session_deinit(inst);
> > -
> > -	return ret;
> > +	return 0;
> >  }
> > =20
> >  static int vdec_queue_setup(struct vb2_queue *q,
> > @@ -733,6 +723,10 @@ static int vdec_queue_setup(struct vb2_queue *q,
> >  		return 0;
> >  	}
> > =20
> > +	ret =3D vdec_session_init(inst);
> > +	if (ret)
> > +		return ret;
> > +
> >  	ret =3D vdec_num_buffers(inst, &in_num, &out_num);
> >  	if (ret)
> >  		return ret;
> > @@ -758,6 +752,11 @@ static int vdec_queue_setup(struct vb2_queue *q,
> >  		inst->output_buf_size =3D sizes[0];
> >  		*num_buffers =3D max(*num_buffers, out_num);
> >  		inst->num_output_bufs =3D *num_buffers;
> > +
> > +		mutex_lock(&inst->lock);
> > +		if (inst->codec_state =3D=3D DEC_STATE_CAPTURE_SETUP)
> > +			inst->codec_state =3D DEC_STATE_STOPPED;
> > +		mutex_unlock(&inst->lock);
> >  		break;
> >  	default:
> >  		ret =3D -EINVAL;
> > @@ -794,80 +793,298 @@ static int vdec_verify_conf(struct venus_inst *i=
nst)
> >  	return 0;
> >  }
> > =20
> > -static int vdec_start_streaming(struct vb2_queue *q, unsigned int coun=
t)
> > +static int vdec_start_capture(struct venus_inst *inst)
> >  {
> > -	struct venus_inst *inst =3D vb2_get_drv_priv(q);
> >  	int ret;
> > =20
> > -	mutex_lock(&inst->lock);
> > +	if (!inst->streamon_out)
> > +		return -EINVAL;
> > =20
> > -	if (q->type =3D=3D V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> > -		inst->streamon_out =3D 1;
> > -	else
> > -		inst->streamon_cap =3D 1;
> > +	if (inst->codec_state =3D=3D DEC_STATE_DECODING) {
> > +		if (inst->reconfig)
> > +			goto reconfigure;
> > =20
> > -	if (!(inst->streamon_out & inst->streamon_cap)) {
> > -		mutex_unlock(&inst->lock);
> > +		venus_helper_queue_dpb_bufs(inst);
> > +		venus_helper_process_initial_cap_bufs(inst);
> > +		inst->streamon_cap =3D 1;
> >  		return 0;
> >  	}
> > =20
> > -	venus_helper_init_instance(inst);
> > +	if (inst->codec_state !=3D DEC_STATE_STOPPED)
> > +		return -EINVAL;
> > =20
> > -	inst->reconfig =3D false;
> > -	inst->sequence_cap =3D 0;
> > -	inst->sequence_out =3D 0;
> > +reconfigure:
> > +	ret =3D hfi_session_flush(inst, HFI_FLUSH_OUTPUT);
> > +	if (ret)
> > +		return ret;
> > =20
> > -	ret =3D vdec_init_session(inst);
> > +	ret =3D vdec_output_conf(inst);
> >  	if (ret)
> > -		goto bufs_done;
> > +		return ret;
> > +
> > +	ret =3D venus_helper_set_num_bufs(inst, inst->num_input_bufs,
> > +					VB2_MAX_FRAME, VB2_MAX_FRAME);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret =3D venus_helper_intbufs_realloc(inst);
> > +	if (ret)
> > +		goto err;
> > +
> > +	ret =3D venus_helper_alloc_dpb_bufs(inst);
> > +	if (ret)
> > +		goto err;
> > +
> > +	ret =3D venus_helper_queue_dpb_bufs(inst);
> > +	if (ret)
> > +		goto free_dpb_bufs;
> > +
> > +	ret =3D venus_helper_process_initial_cap_bufs(inst);
> > +	if (ret)
> > +		goto free_dpb_bufs;
> > +
> > +	venus_helper_load_scale_clocks(inst->core);
> > +
> > +	ret =3D hfi_session_continue(inst);
> > +	if (ret)
> > +		goto free_dpb_bufs;
> > +
> > +	inst->codec_state =3D DEC_STATE_DECODING;
> > +
> > +	inst->streamon_cap =3D 1;
> > +	inst->sequence_cap =3D 0;
> > +	inst->reconfig =3D false;
> > +
> > +	return 0;
> > +
> > +free_dpb_bufs:
> > +	venus_helper_free_dpb_bufs(inst);
> > +err:
> > +	return ret;
> > +}
> > +
> > +static int vdec_start_output(struct venus_inst *inst)
> > +{
> > +	int ret;
> > +
> > +	if (inst->codec_state =3D=3D DEC_STATE_SEEK) {
> > +		ret =3D venus_helper_process_initial_out_bufs(inst);
> > +		inst->codec_state =3D DEC_STATE_DECODING;
> > +		goto done;
> > +	}
> > +
> > +	if (inst->codec_state =3D=3D DEC_STATE_INIT ||
> > +	    inst->codec_state =3D=3D DEC_STATE_CAPTURE_SETUP) {
> > +		ret =3D venus_helper_process_initial_out_bufs(inst);
> > +		goto done;
> > +	}
> > +
> > +	if (inst->codec_state !=3D DEC_STATE_UNINIT)
> > +		return -EINVAL;
> > +
> > +	venus_helper_init_instance(inst);
> > +	inst->sequence_out =3D 0;
> > +	inst->reconfig =3D false;
> > =20
> >  	ret =3D vdec_set_properties(inst);
> >  	if (ret)
> > -		goto deinit_sess;
> > +		return ret;
> > =20
> >  	ret =3D vdec_output_conf(inst);
> >  	if (ret)
> > -		goto deinit_sess;
> > +		return ret;
> > =20
> >  	ret =3D vdec_verify_conf(inst);
> >  	if (ret)
> > -		goto deinit_sess;
> > +		return ret;
> > =20
> >  	ret =3D venus_helper_set_num_bufs(inst, inst->num_input_bufs,
> >  					VB2_MAX_FRAME, VB2_MAX_FRAME);
> >  	if (ret)
> > -		goto deinit_sess;
> > +		return ret;
> > =20
> > -	ret =3D venus_helper_alloc_dpb_bufs(inst);
> > +	ret =3D venus_helper_vb2_start_streaming(inst);
> >  	if (ret)
> > -		goto deinit_sess;
> > +		return ret;
> > =20
> > -	ret =3D venus_helper_vb2_start_streaming(inst);
> > +	ret =3D venus_helper_process_initial_out_bufs(inst);
> >  	if (ret)
> > -		goto deinit_sess;
> > +		return ret;
> > =20
> > -	mutex_unlock(&inst->lock);
> > +	inst->codec_state =3D DEC_STATE_INIT;
> > +
> > +done:
> > +	inst->streamon_out =3D 1;
> > +	return ret;
> > +}
> > +
> > +static int vdec_start_streaming(struct vb2_queue *q, unsigned int coun=
t)
> > +{
> > +	struct venus_inst *inst =3D vb2_get_drv_priv(q);
> > +	int ret;
> > +
> > +	mutex_lock(&inst->lock);
> > +
> > +	if (q->type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> > +		ret =3D vdec_start_capture(inst);
> > +	else
> > +		ret =3D vdec_start_output(inst);
> > =20
> > +	if (ret)
> > +		goto error;
> > +
> > +	mutex_unlock(&inst->lock);
> >  	return 0;
> > =20
> > -deinit_sess:
> > -	hfi_session_deinit(inst);
> > -bufs_done:
> > +error:
> >  	venus_helper_buffers_done(inst, VB2_BUF_STATE_QUEUED);
> > +	mutex_unlock(&inst->lock);
> > +	return ret;
> > +}
> > +
> > +static void vdec_dst_buffers_done(struct venus_inst *inst,
> > +				  enum vb2_buffer_state state)
> > +{
> > +	struct vb2_v4l2_buffer *buf;
> > +
> > +	while ((buf =3D v4l2_m2m_dst_buf_remove(inst->m2m_ctx)))
> > +		v4l2_m2m_buf_done(buf, state);
> > +}
> > +
> > +static int vdec_stop_capture(struct venus_inst *inst)
> > +{
> > +	int ret =3D 0;
> > +
> > +	switch (inst->codec_state) {
> > +	case DEC_STATE_DECODING:
> > +		ret =3D hfi_session_flush(inst, HFI_FLUSH_ALL);
> > +		vdec_dst_buffers_done(inst, VB2_BUF_STATE_ERROR);
> > +		inst->codec_state =3D DEC_STATE_STOPPED;
> > +		break;
> > +	case DEC_STATE_DRAIN:
> > +		vdec_dst_buffers_done(inst, VB2_BUF_STATE_ERROR);
> > +		inst->codec_state =3D DEC_STATE_STOPPED;
> > +		break;
> > +	case DEC_STATE_DRC:
> > +		ret =3D hfi_session_flush(inst, HFI_FLUSH_OUTPUT);
> > +		vdec_dst_buffers_done(inst, VB2_BUF_STATE_ERROR);
> > +		inst->codec_state =3D DEC_STATE_CAPTURE_SETUP;
> > +		INIT_LIST_HEAD(&inst->registeredbufs);
> > +		venus_helper_free_dpb_bufs(inst);
> > +		break;
> > +	default:
> > +		return 0;
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> > +static int vdec_stop_output(struct venus_inst *inst)
> > +{
> > +	int ret =3D 0;
> > +
> > +	switch (inst->codec_state) {
> > +	case DEC_STATE_DECODING:
> > +	case DEC_STATE_DRAIN:
> > +	case DEC_STATE_STOPPED:
> > +		ret =3D hfi_session_flush(inst, HFI_FLUSH_ALL);
> > +		inst->codec_state =3D DEC_STATE_SEEK;
> > +		break;
> > +	case DEC_STATE_INIT:
> > +	case DEC_STATE_CAPTURE_SETUP:
> > +		ret =3D hfi_session_flush(inst, HFI_FLUSH_INPUT);
> > +		break;
> > +	default:
> > +		break;
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> > +static void vdec_stop_streaming(struct vb2_queue *q)
> > +{
> > +	struct venus_inst *inst =3D vb2_get_drv_priv(q);
> > +	int ret =3D -EINVAL;
> > +
> > +	mutex_lock(&inst->lock);
> > +
> > +	if (IS_CAP(q, inst))
> > +		ret =3D vdec_stop_capture(inst);
> > +	else if (IS_OUT(q, inst))
> > +		ret =3D vdec_stop_output(inst);
> > +
> > +	venus_helper_buffers_done(inst, VB2_BUF_STATE_ERROR);
> > +
> > +	if (ret)
> > +		goto unlock;
> > +
> >  	if (q->type =3D=3D V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> >  		inst->streamon_out =3D 0;
> >  	else
> >  		inst->streamon_cap =3D 0;
> > +
> > +unlock:
> >  	mutex_unlock(&inst->lock);
> > -	return ret;
> > +}
> > +
> > +static void vdec_session_release(struct venus_inst *inst)
> > +{
> > +	struct venus_core *core =3D inst->core;
> > +	int ret, abort =3D 0;
> > +
> > +	mutex_lock(&inst->lock);
> > +
> > +	inst->codec_state =3D DEC_STATE_UNINIT;
> > +
> > +	ret =3D hfi_session_stop(inst);
> > +	abort =3D (ret && ret !=3D -EINVAL) ? 1 : 0;
> > +	ret =3D hfi_session_unload_res(inst);
> > +	abort =3D (ret && ret !=3D -EINVAL) ? 1 : 0;
> > +	ret =3D venus_helper_unregister_bufs(inst);
> > +	abort =3D (ret && ret !=3D -EINVAL) ? 1 : 0;
> > +	ret =3D venus_helper_intbufs_free(inst);
> > +	abort =3D (ret && ret !=3D -EINVAL) ? 1 : 0;
> > +	ret =3D hfi_session_deinit(inst);
> > +	abort =3D (ret && ret !=3D -EINVAL) ? 1 : 0;
> > +
> > +	if (inst->session_error || core->sys_error)
> > +		abort =3D 1;
> > +
> > +	if (abort)
> > +		hfi_session_abort(inst);
> > +
> > +	venus_helper_free_dpb_bufs(inst);
> > +	venus_helper_load_scale_clocks(core);
> > +	INIT_LIST_HEAD(&inst->registeredbufs);
> > +
> > +	mutex_unlock(&inst->lock);
> > +}
> > +
> > +static int vdec_buf_init(struct vb2_buffer *vb)
> > +{
> > +	struct venus_inst *inst =3D vb2_get_drv_priv(vb->vb2_queue);
> > +
> > +	inst->buf_count++;
> > +
> > +	return venus_helper_vb2_buf_init(vb);
> > +}
> > +
> > +static void vdec_buf_cleanup(struct vb2_buffer *vb)
> > +{
> > +	struct venus_inst *inst =3D vb2_get_drv_priv(vb->vb2_queue);
> > +
> > +	inst->buf_count--;
> > +	if (!inst->buf_count)
> > +		vdec_session_release(inst);
> >  }
> > =20
> >  static const struct vb2_ops vdec_vb2_ops =3D {
> >  	.queue_setup =3D vdec_queue_setup,
> > -	.buf_init =3D venus_helper_vb2_buf_init,
> > +	.buf_init =3D vdec_buf_init,
> > +	.buf_cleanup =3D vdec_buf_cleanup,
> >  	.buf_prepare =3D venus_helper_vb2_buf_prepare,
> >  	.start_streaming =3D vdec_start_streaming,
> > -	.stop_streaming =3D venus_helper_vb2_stop_streaming,
> > +	.stop_streaming =3D vdec_stop_streaming,
> >  	.buf_queue =3D venus_helper_vb2_buf_queue,
> >  };
> > =20
> > @@ -891,6 +1108,7 @@ static void vdec_buf_done(struct venus_inst *inst,=
 unsigned int buf_type,
> > =20
> >  	vbuf->flags =3D flags;
> >  	vbuf->field =3D V4L2_FIELD_NONE;
> > +	vb =3D &vbuf->vb2_buf;
> > =20
> >  	if (type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> >  		vb =3D &vbuf->vb2_buf;
> > @@ -903,6 +1121,9 @@ static void vdec_buf_done(struct venus_inst *inst,=
 unsigned int buf_type,
> >  			const struct v4l2_event ev =3D { .type =3D V4L2_EVENT_EOS };
> > =20
> >  			v4l2_event_queue_fh(&inst->fh, &ev);
> > +
> > +			if (inst->codec_state =3D=3D DEC_STATE_DRAIN)
> > +				inst->codec_state =3D DEC_STATE_STOPPED;
> >  		}
> >  	} else {
> >  		vbuf->sequence =3D inst->sequence_out++;
> > @@ -914,17 +1135,69 @@ static void vdec_buf_done(struct venus_inst *ins=
t, unsigned int buf_type,
> >  	if (hfi_flags & HFI_BUFFERFLAG_DATACORRUPT)
> >  		state =3D VB2_BUF_STATE_ERROR;
> > =20
> > +	if (hfi_flags & HFI_BUFFERFLAG_DROP_FRAME) {
> > +		state =3D VB2_BUF_STATE_ERROR;
> > +		vb2_set_plane_payload(vb, 0, 0);
> > +		vb->timestamp =3D 0;
> > +	}
> > +
> >  	v4l2_m2m_buf_done(vbuf, state);
> >  }
> > =20
> > +static void vdec_event_change(struct venus_inst *inst,
> > +			      struct hfi_event_data *ev_data, bool sufficient)
> > +{
> > +	static const struct v4l2_event ev =3D {
> > +		.type =3D V4L2_EVENT_SOURCE_CHANGE,
> > +		.u.src_change.changes =3D V4L2_EVENT_SRC_CH_RESOLUTION };
> > +	struct device *dev =3D inst->core->dev_dec;
> > +	struct v4l2_format format =3D {};
> > +
> > +	mutex_lock(&inst->lock);
> > +
> > +	format.type =3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> > +	format.fmt.pix_mp.pixelformat =3D inst->fmt_cap->pixfmt;
> > +	format.fmt.pix_mp.width =3D ev_data->width;
> > +	format.fmt.pix_mp.height =3D ev_data->height;
> > +
> > +	vdec_try_fmt_common(inst, &format);
> > +
> > +	inst->width =3D format.fmt.pix_mp.width;
> > +	inst->height =3D format.fmt.pix_mp.height;
> > +
> > +	inst->out_width =3D ev_data->width;
> > +	inst->out_height =3D ev_data->height;
> > +
> > +	dev_dbg(dev, "event %s sufficient resources (%ux%u)\n",
> > +		sufficient ? "" : "not", ev_data->width, ev_data->height);
> > +
> > +	if (sufficient) {
> > +		hfi_session_continue(inst);
> > +	} else {
> > +		switch (inst->codec_state) {
> > +		case DEC_STATE_INIT:
> > +			inst->codec_state =3D DEC_STATE_CAPTURE_SETUP;
> > +			break;
> > +		case DEC_STATE_DECODING:
> > +			inst->codec_state =3D DEC_STATE_DRC;
> > +			break;
> > +		default:
> > +			break;
> > +		}
> > +	}
> > +
> > +	inst->reconfig =3D true;
> > +	v4l2_event_queue_fh(&inst->fh, &ev);
> > +	wake_up(&inst->reconf_wait);
> > +
> > +	mutex_unlock(&inst->lock);
> > +}
> > +
> >  static void vdec_event_notify(struct venus_inst *inst, u32 event,
> >  			      struct hfi_event_data *data)
> >  {
> >  	struct venus_core *core =3D inst->core;
> >  	struct device *dev =3D core->dev_dec;
> > -	static const struct v4l2_event ev =3D {
> > -		.type =3D V4L2_EVENT_SOURCE_CHANGE,
> > -		.u.src_change.changes =3D V4L2_EVENT_SRC_CH_RESOLUTION };
> > =20
> >  	switch (event) {
> >  	case EVT_SESSION_ERROR:
> > @@ -934,18 +1207,10 @@ static void vdec_event_notify(struct venus_inst =
*inst, u32 event,
> >  	case EVT_SYS_EVENT_CHANGE:
> >  		switch (data->event_type) {
> >  		case HFI_EVENT_DATA_SEQUENCE_CHANGED_SUFFICIENT_BUF_RESOURCES:
> > -			hfi_session_continue(inst);
> > -			dev_dbg(dev, "event sufficient resources\n");
> > +			vdec_event_change(inst, data, true);
> >  			break;
> >  		case HFI_EVENT_DATA_SEQUENCE_CHANGED_INSUFFICIENT_BUF_RESOURCES:
> > -			inst->reconfig_height =3D data->height;
> > -			inst->reconfig_width =3D data->width;
> > -			inst->reconfig =3D true;
> > -
> > -			v4l2_event_queue_fh(&inst->fh, &ev);
> > -
> > -			dev_dbg(dev, "event not sufficient resources (%ux%u)\n",
> > -				data->width, data->height);
> > +			vdec_event_change(inst, data, false);
> >  			break;
> >  		case HFI_EVENT_RELEASE_BUFFER_REFERENCE:
> >  			venus_helper_release_buf_ref(inst, data->tag);
> > @@ -978,8 +1243,12 @@ static void vdec_inst_init(struct venus_inst *ins=
t)
> >  	inst->hfi_codec =3D HFI_VIDEO_CODEC_H264;
> >  }
> > =20
> > +static void vdec_m2m_device_run(void *priv)
> > +{
> > +}
> > +
> >  static const struct v4l2_m2m_ops vdec_m2m_ops =3D {
> > -	.device_run =3D venus_helper_m2m_device_run,
> > +	.device_run =3D vdec_m2m_device_run,
> >  	.job_abort =3D venus_helper_m2m_job_abort,
> >  };
> > =20
> > @@ -1041,7 +1310,9 @@ static int vdec_open(struct file *file)
> >  	inst->core =3D core;
> >  	inst->session_type =3D VIDC_SESSION_TYPE_DEC;
> >  	inst->num_output_bufs =3D 1;
> > -
> > +	inst->codec_state =3D DEC_STATE_UNINIT;
> > +	inst->buf_count =3D 0;
> > +	init_waitqueue_head(&inst->reconf_wait);
> >  	venus_helper_init_instance(inst);
> > =20
> >  	ret =3D pm_runtime_get_sync(core->dev_dec);
> >=20

--=-5ha/0lTbNrqVP2kPsybM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCXGboZwAKCRBxUwItrAao
HBSMAJ4nabnn/BEwdpZWK4TzuPm+rOsEnwCeLNiz/jU8LbNJ/owv4V3TSwolIaw=
=m1v+
-----END PGP SIGNATURE-----

--=-5ha/0lTbNrqVP2kPsybM--

