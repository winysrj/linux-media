Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:45808 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751350AbeCNRVj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Mar 2018 13:21:39 -0400
Subject: Re: [PATCH v3] media: staging/imx: fill vb2_v4l2_buffer sequence
 entry
To: Peter Seiderer <ps.report@gmx.net>, linux-media@vger.kernel.org
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <20180314165139.5356-1-ps.report@gmx.net>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <7f723320-f1cf-a769-dd32-d48c49b041e1@gmail.com>
Date: Wed, 14 Mar 2018 10:21:31 -0700
MIME-Version: 1.0
In-Reply-To: <20180314165139.5356-1-ps.report@gmx.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Peter,


On 03/14/2018 09:51 AM, Peter Seiderer wrote:
> Enables gstreamer v4l2src lost frame detection, e.g:
>
>    0:00:08.685185668  348  0x54f520 WARN  v4l2src gstv4l2src.c:970:gst_v4l2src_create:<v4l2src0> lost frames detected: count = 141 - ts: 0:00:08.330177332
>
> Signed-off-by: Peter Seiderer <ps.report@gmx.net>
> ---
> Changes in v2:
>    - fill vb2_v4l2_buffer sequence entry in imx-ic-prpencvf too
>      (suggested by Steve Longerbeam)
>
> Changes in v3:
>    - add changelog (suggested by Greg Kroah-Hartman, Fabio Estevam
>      and Dan Carpenter) and patch history
>    - use u32 (instead of __u32) (suggested by Dan Carpenter)
>    - let sequence counter start with zero,

There's no need to initialize (unsigned) priv->frame_sequence to -1. Just
increment it _after_ the "if (done) {...}" block instead of before.

Steve

>   keeping v4l2-compliance
>      testing happy (needs additional setting of field to a valid
>      value, patch will follow soon)
> ---
>   drivers/staging/media/imx/imx-ic-prpencvf.c | 5 +++++
>   drivers/staging/media/imx/imx-media-csi.c   | 5 +++++
>   2 files changed, 10 insertions(+)
>
> diff --git a/drivers/staging/media/imx/imx-ic-prpencvf.c b/drivers/staging/media/imx/imx-ic-prpencvf.c
> index ae453fd422f0..274683d2d4ba 100644
> --- a/drivers/staging/media/imx/imx-ic-prpencvf.c
> +++ b/drivers/staging/media/imx/imx-ic-prpencvf.c
> @@ -103,6 +103,7 @@ struct prp_priv {
>   	int nfb4eof_irq;
>   
>   	int stream_count;
> +	u32 frame_sequence; /* frame sequence counter */
>   	bool last_eof;  /* waiting for last EOF at stream off */
>   	bool nfb4eof;    /* NFB4EOF encountered during streaming */
>   	struct completion last_eof_comp;
> @@ -208,8 +209,11 @@ static void prp_vb2_buf_done(struct prp_priv *priv, struct ipuv3_channel *ch)
>   	struct vb2_buffer *vb;
>   	dma_addr_t phys;
>   
> +	priv->frame_sequence++;
> +
>   	done = priv->active_vb2_buf[priv->ipu_buf_num];
>   	if (done) {
> +		done->vbuf.sequence = priv->frame_sequence;
>   		vb = &done->vbuf.vb2_buf;
>   		vb->timestamp = ktime_get_ns();
>   		vb2_buffer_done(vb, priv->nfb4eof ?
> @@ -637,6 +641,7 @@ static int prp_start(struct prp_priv *priv)
>   
>   	/* init EOF completion waitq */
>   	init_completion(&priv->last_eof_comp);
> +	priv->frame_sequence = -1;
>   	priv->last_eof = false;
>   	priv->nfb4eof = false;
>   
> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
> index 5a195f80a24d..161a92946a86 100644
> --- a/drivers/staging/media/imx/imx-media-csi.c
> +++ b/drivers/staging/media/imx/imx-media-csi.c
> @@ -111,6 +111,7 @@ struct csi_priv {
>   	struct v4l2_ctrl_handler ctrl_hdlr;
>   
>   	int stream_count; /* streaming counter */
> +	u32 frame_sequence; /* frame sequence counter */
>   	bool last_eof;   /* waiting for last EOF at stream off */
>   	bool nfb4eof;    /* NFB4EOF encountered during streaming */
>   	struct completion last_eof_comp;
> @@ -234,8 +235,11 @@ static void csi_vb2_buf_done(struct csi_priv *priv)
>   	struct vb2_buffer *vb;
>   	dma_addr_t phys;
>   
> +	priv->frame_sequence++;
> +
>   	done = priv->active_vb2_buf[priv->ipu_buf_num];
>   	if (done) {
> +		done->vbuf.sequence = priv->frame_sequence;
>   		vb = &done->vbuf.vb2_buf;
>   		vb->timestamp = ktime_get_ns();
>   		vb2_buffer_done(vb, priv->nfb4eof ?
> @@ -543,6 +547,7 @@ static int csi_idmac_start(struct csi_priv *priv)
>   
>   	/* init EOF completion waitq */
>   	init_completion(&priv->last_eof_comp);
> +	priv->frame_sequence = -1;
>   	priv->last_eof = false;
>   	priv->nfb4eof = false;
>   
