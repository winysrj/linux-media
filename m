Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:49287 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab1I1UUj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Sep 2011 16:20:39 -0400
Date: Wed, 28 Sep 2011 23:20:35 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, pawel@osciak.com,
	mchehab@infradead.org, m.szyprowski@samsung.com
Subject: Re: [PATCH 1/1] v4l: Add note on buffer locking to memory and DMA
 mapping to PREPARE_BUF
Message-ID: <20110928202035.GE6180@valkosipuli.localdomain>
References: <Pine.LNX.4.64.1109010904300.21309@axis700.grange>
 <1314875336-21811-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314875336-21811-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

What's your opinion on this? I was intended to complement the PREPARE_BUF
documentation.

On Thu, Sep 01, 2011 at 02:08:56PM +0300, Sakari Ailus wrote:
> Add note to documentation of VIDIOC_PREPARE_BUF that the preparation done by
> the IOCTL may include locking buffers to system memory and creating DMA
> mappings for them.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  .../DocBook/media/v4l/vidioc-prepare-buf.xml       |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml b/Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml
> index 509e752..7177c2f 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml
> @@ -52,9 +52,11 @@
>  <constant>VIDIOC_PREPARE_BUF</constant> ioctl to pass ownership of the buffer
>  to the driver before actually enqueuing it, using the
>  <constant>VIDIOC_QBUF</constant> ioctl, and to prepare it for future I/O.
> -Such preparations may include cache invalidation or cleaning. Performing them
> -in advance saves time during the actual I/O. In case such cache operations are
> -not required, the application can use one of
> +Such preparations may include locking the buffer to system memory and
> +creating DMA mapping for it (on the first time
> +<constant>VIDIOC_PREPARE_BUF</constant> is called), cache invalidation or
> +cleaning. Performing them in advance saves time during the actual I/O. In
> +case such cache operations are not required, the application can use one of
>  <constant>V4L2_BUF_FLAG_NO_CACHE_INVALIDATE</constant> and
>  <constant>V4L2_BUF_FLAG_NO_CACHE_CLEAN</constant> flags to skip the respective
>  step.</para>
> -- 
> 1.7.2.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
