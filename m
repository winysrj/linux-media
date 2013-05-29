Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:14934 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965860Ab3E2M2H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 08:28:07 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MNK00IL57V57J40@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 29 May 2013 13:28:04 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Philipp Zabel' <p.zabel@pengutronix.de>,
	linux-media@vger.kernel.org
Cc: 'Mauro Carvalho Chehab' <mchehab@redhat.com>,
	'Javier Martin' <javier.martin@vista-silicon.com>,
	'Pawel Osciak' <pawel@osciak.com>,
	'John Sheu' <sheu@google.com>
References: <1369124189-590-1-git-send-email-p.zabel@pengutronix.de>
In-reply-to: <1369124189-590-1-git-send-email-p.zabel@pengutronix.de>
Subject: RE: [PATCH 1/2] [media] v4l2-mem2mem: add v4l2_m2m_create_bufs helper
Date: Wed, 29 May 2013 14:28:00 +0200
Message-id: <021601ce5c67$f5920f20$e0b62d60$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Thanks for the patch. May I ask you to use use checkpath next time
and keep whitespaces tidy? This time I fixed it (spaces changed to a tab).

Checkpatch:
------------------------------
ERROR: code indent should use tabs where possible
#41: FILE: drivers/media/v4l2-core/v4l2-mem2mem.c:384:
+        return vb2_create_bufs(vq, create);$

WARNING: please, no spaces at the start of a line
#41: FILE: drivers/media/v4l2-core/v4l2-mem2mem.c:384:
+        return vb2_create_bufs(vq, create);$

total: 1 errors, 1 warnings, 28 lines checked

Fix:
------------------------------
diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c
b/drivers/media/v4l2-core/v4l2-mem2mem.c
index 674e5a0..a756170 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -381,7 +381,7 @@ int v4l2_m2m_create_bufs(struct file *file, struct
v4l2_m2m_ctx *m2m_ctx,
        struct vb2_queue *vq;
 
        vq = v4l2_m2m_get_vq(m2m_ctx, create->format.type);
-        return vb2_create_bufs(vq, create);
+       return vb2_create_bufs(vq, create);
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_create_bufs);


Best wishes,
-- 
Kamil Debski
Linux Kernel Developer
Samsung R&D Institute Poland


> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Philipp Zabel
> Sent: Tuesday, May 21, 2013 10:16 AM
> To: linux-media@vger.kernel.org
> Cc: Mauro Carvalho Chehab; Javier Martin; Pawel Osciak; John Sheu;
> Philipp Zabel
> Subject: [PATCH 1/2] [media] v4l2-mem2mem: add v4l2_m2m_create_bufs
> helper
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/v4l2-core/v4l2-mem2mem.c | 14 ++++++++++++++
>  include/media/v4l2-mem2mem.h           |  2 ++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c
> b/drivers/media/v4l2-core/v4l2-mem2mem.c
> index 66f599f..357efa4 100644
> --- a/drivers/media/v4l2-core/v4l2-mem2mem.c
> +++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
> @@ -372,6 +372,20 @@ int v4l2_m2m_dqbuf(struct file *file, struct
> v4l2_m2m_ctx *m2m_ctx,  EXPORT_SYMBOL_GPL(v4l2_m2m_dqbuf);
> 
>  /**
> + * v4l2_m2m_create_bufs() - create a source or destination buffer,
> +depending
> + * on the type
> + */
> +int v4l2_m2m_create_bufs(struct file *file, struct v4l2_m2m_ctx
> *m2m_ctx,
> +			 struct v4l2_create_buffers *create) {
> +	struct vb2_queue *vq;
> +
> +	vq = v4l2_m2m_get_vq(m2m_ctx, create->format.type);
> +        return vb2_create_bufs(vq, create); }
> +EXPORT_SYMBOL_GPL(v4l2_m2m_create_bufs);
> +
> +/**
>   * v4l2_m2m_expbuf() - export a source or destination buffer,
> depending on
>   * the type
>   */
> diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-
> mem2mem.h index d3eef01..0f4555b 100644
> --- a/include/media/v4l2-mem2mem.h
> +++ b/include/media/v4l2-mem2mem.h
> @@ -110,6 +110,8 @@ int v4l2_m2m_qbuf(struct file *file, struct
> v4l2_m2m_ctx *m2m_ctx,
>  		  struct v4l2_buffer *buf);
>  int v4l2_m2m_dqbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
>  		   struct v4l2_buffer *buf);
> +int v4l2_m2m_create_bufs(struct file *file, struct v4l2_m2m_ctx
> *m2m_ctx,
> +			 struct v4l2_create_buffers *create);
> 
>  int v4l2_m2m_expbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
>  		   struct v4l2_exportbuffer *eb);
> --
> 1.8.2.rc2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media"
> in the body of a message to majordomo@vger.kernel.org More majordomo
> info at  http://vger.kernel.org/majordomo-info.html


