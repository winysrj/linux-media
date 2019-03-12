Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18462C43381
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 15:29:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E03FA2147C
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 15:29:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbfCLP35 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 11:29:57 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:44855 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbfCLP35 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 11:29:57 -0400
X-Originating-IP: 90.88.22.102
Received: from aptenodytes (aaubervilliers-681-1-80-102.w90-88.abo.wanadoo.fr [90.88.22.102])
        (Authenticated sender: paul.kocialkowski@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id D05C14000F;
        Tue, 12 Mar 2019 15:29:54 +0000 (UTC)
Message-ID: <84cdb4b2d228caa4545ff736639f9dd25b79dfc2.camel@bootlin.com>
Subject: Re: [PATCH v5 02/23] videodev2.h: add V4L2_BUF_CAP_REQUIRES_REQUESTS
From:   Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To:     Dafna Hirschfeld <dafna3@gmail.com>, linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Date:   Tue, 12 Mar 2019 16:29:54 +0100
In-Reply-To: <20190306211343.15302-3-dafna3@gmail.com>
References: <20190306211343.15302-1-dafna3@gmail.com>
         <20190306211343.15302-3-dafna3@gmail.com>
Organization: Bootlin
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

On Wed, 2019-03-06 at 13:13 -0800, Dafna Hirschfeld wrote:
> From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> 
> Add capability to indicate that requests are required instead of
> merely supported.
> 
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

Cheers,

Paul

> ---
>  Documentation/media/uapi/v4l/vidioc-reqbufs.rst | 4 ++++
>  include/uapi/linux/videodev2.h                  | 1 +
>  2 files changed, 5 insertions(+)
> 
> diff --git a/Documentation/media/uapi/v4l/vidioc-reqbufs.rst b/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
> index d7faef10e39b..d42a3d9a7db3 100644
> --- a/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
> +++ b/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
> @@ -125,6 +125,7 @@ aborting or finishing any DMA in progress, an implicit
>  .. _V4L2-BUF-CAP-SUPPORTS-DMABUF:
>  .. _V4L2-BUF-CAP-SUPPORTS-REQUESTS:
>  .. _V4L2-BUF-CAP-SUPPORTS-ORPHANED-BUFS:
> +.. _V4L2-BUF-CAP-REQUIRES-REQUESTS:
>  
>  .. cssclass:: longtable
>  
> @@ -150,6 +151,9 @@ aborting or finishing any DMA in progress, an implicit
>        - The kernel allows calling :ref:`VIDIOC_REQBUFS` while buffers are still
>          mapped or exported via DMABUF. These orphaned buffers will be freed
>          when they are unmapped or when the exported DMABUF fds are closed.
> +    * - ``V4L2_BUF_CAP_REQUIRES_REQUESTS``
> +      - 0x00000020
> +      - This buffer type requires the use of :ref:`requests <media-request-api>`.
>  
>  Return Value
>  ============
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 1db220da3bcc..97e6a6a968ba 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -895,6 +895,7 @@ struct v4l2_requestbuffers {
>  #define V4L2_BUF_CAP_SUPPORTS_DMABUF	(1 << 2)
>  #define V4L2_BUF_CAP_SUPPORTS_REQUESTS	(1 << 3)
>  #define V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS (1 << 4)
> +#define V4L2_BUF_CAP_REQUIRES_REQUESTS	(1 << 5)
>  
>  /**
>   * struct v4l2_plane - plane info for multi-planar buffers
-- 
Paul Kocialkowski, Bootlin
Embedded Linux and kernel engineering
https://bootlin.com

