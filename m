Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:57113 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaLRRdk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Dec 2014 12:33:40 -0500
Received: by mail-la0-f46.google.com with SMTP id q1so1432001lam.33
        for <linux-media@vger.kernel.org>; Thu, 18 Dec 2014 09:33:38 -0800 (PST)
Message-ID: <54930FF0.4010409@cogentembedded.com>
Date: Thu, 18 Dec 2014 20:33:36 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Ben Hutchings <ben.hutchings@codethink.co.uk>,
	linux-media@vger.kernel.org
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-kernel@codethink.co.uk,
	William Towle <william.towle@codethink.co.uk>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC PATCH 5/5] media: rcar_vin: move buffer management to .stop_streaming
 handler
References: <1418914070.22813.13.camel@xylophone.i.decadent.org.uk> <1418914215.22813.18.camel@xylophone.i.decadent.org.uk>
In-Reply-To: <1418914215.22813.18.camel@xylophone.i.decadent.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 12/18/2014 05:50 PM, Ben Hutchings wrote:

> From: William Towle <william.towle@codethink.co.uk>

> Move the buffer state test in the .buf_cleanup handler into
> .stop_streaming so that a) the vb2_queue API is not subverted, and
> b) tracking of active-state buffers via priv->queue_buf[] is handled
> as early as is possible

> Signed-off-by: William Towle <william.towle@codethink.co.uk>
> ---
>   drivers/media/platform/soc_camera/rcar_vin.c |   36 ++++++++++----------------
>   1 file changed, 14 insertions(+), 22 deletions(-)

> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index 20dbedf..bf60074 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
[...]
> @@ -533,8 +513,20 @@ static void rcar_vin_stop_streaming(struct vb2_queue *vq)
>   	rcar_vin_wait_stop_streaming(priv);
>
>   	for (i = 0; i < vq->num_buffers; ++i)
> -		if (vq->bufs[i]->state == VB2_BUF_STATE_ACTIVE)
> +		if (vq->bufs[i]->state == VB2_BUF_STATE_ACTIVE) {
> +			int j;
> +
> +			/*  Is this a buffer we have told the
> +			 *  hardware about? Update the associated
> +			 *  list, if so
> +			 */
> +			for (j = 0; j < MAX_BUFFER_NUM; j++) {
> +				if (priv->queue_buf[j] == vq->bufs[i]) {
> +					priv->queue_buf[j] = NULL;
> +				}

    Don't need {} here.

> +			}
>   			vb2_buffer_done(vq->bufs[i], VB2_BUF_STATE_ERROR);
> +		}

WBR, Sergei

