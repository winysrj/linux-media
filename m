Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:47341 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485AbaGCPNL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Jul 2014 11:13:11 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N85000TG69WCS00@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 03 Jul 2014 16:13:08 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'ayaka' <ayaka@soulik.info>, linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, jtp.park@samsung.com,
	m.chehab@samsung.com
References: <53AC2ACA.7080106@soulik.info>
In-reply-to: <53AC2ACA.7080106@soulik.info>
Subject: RE: [PATCH] s5p-mfc: encoder could free buffers
Date: Thu, 03 Jul 2014 17:13:10 +0200
Message-id: <0bc901cf96d1$4dabf500$e903df00$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ayaka,

Thank you for your patch, however I see some things that need to be
corrected.

> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of ayaka
> Sent: Thursday, June 26, 2014 4:15 PM
> To: linux-media@vger.kernel.org
> Cc: kyungmin.park@samsung.com; jtp.park@samsung.com;
> m.chehab@samsung.com
> Subject: [PATCH] s5p-mfc: encoder could free buffers
> 
> [PATCH] s5p-mfc: encoder could free buffers

The above line is not necessary.

> 
> The patch is necessary or the buffers could be freeed but it would

Typo - should be "freed"

> break the state of encoder in s5p-mfc. It is also need by some
> application which would detect the buffer allocation way, like
> gstreamer.

I would rephrase the whole commit message. Maybe something along the lines
"Add handling of buffer freeing reqbufs request to the encoder of s5p-mfc."

> ---
> drivers/media/platform/s5p-mfc/s5p_mfc_enc.c | 8 ++++++++
> 1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> index d26b248..1a7518f 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> @@ -1166,6 +1166,10 @@ static int vidioc_reqbufs(struct file *file,
> void *priv, mfc_err("error in vb2_reqbufs() for E(D)\n"); return ret; }
> + if (reqbufs->count == 0) {
> + mfc_debug(2, "Freeing buffers\n");
> + return ret;
> + }

Indentation is wrong here, please correct.
Also, I think you should set ctx->capture_state to QUEUE_FREE.

> ctx->capture_state = QUEUE_BUFS_REQUESTED;
> 
> ret = s5p_mfc_hw_call(ctx->dev->mfc_ops,
> @@ -1200,6 +1204,10 @@ static int vidioc_reqbufs(struct file *file,
> void *priv, mfc_err("error in vb2_reqbufs() for E(S)\n"); return ret; }
> + if (reqbufs->count == 0) {
> + mfc_debug(2, "Freeing buffers\n");
> + return ret;
> + }

Indentation is wrong here, please correct.
Also, I think you should set ctx->capture_state to QUEUE_FREE.

> ctx->output_state = QUEUE_BUFS_REQUESTED;
> } else {
> mfc_err("invalid buf type\n");

In addition to the above, for capture this patch will not work. The
following
check will prevent buffers from being freed:

if (ctx->capture_state != QUEUE_FREE) {
         mfc_err("invalid capture state: %d\n",
                                         ctx->capture_state);
         return -EINVAL;
 }

Also, you should provide a proper Signed-off-by with your full name and
email
address. Did you use git send-email to send this patch?

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland


