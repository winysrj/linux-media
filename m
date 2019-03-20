Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20DBFC43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 10:11:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2BB321850
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 10:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553076681;
	bh=qWaDW24vapElULwdAlz3sfpRwulJuA4lDrbLem1SSOA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=jCTECy7Xdj+ZM2Rs4BPdwq8pbDMo0EaRbP5I/Ao1bNle8MKGbh8GM94xh5os/kbo+
	 P5tKm34XB3eDip827HPvxjnPx+haqu1DLKGDisUMMXcemhTQQHf/E/d6RZMvn8yFi5
	 5slg+gkR+i03rBAOVpND/su0WLfM1Z4YavrUF/90=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726123AbfCTKLU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 06:11:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:51192 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbfCTKLU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 06:11:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=GFOih9juPhfZXrVSj4Z15cMfpz/3w/mlZfXSMNE+h/8=; b=Dm2ziswursh7JtAAoVwyzkHxVO
        JikiqAyd11hVI/fiC+7vMNCoL9kAEutjYjxFXd2OKhvPT0KQjwO0YWb1lg4TyDp7kzS2buhPezURN
        DRDrPY6Nli3Rx26mkFXfS3IWq+N6y6M8x+UkQTxRvAFsqvalY1u8D2hk6Puu0NWrkPTuygySl3wRy
        K+xbgQUHRARghEnf8GhUmhdmA/DofYB+kgHfexkeuRNqGpkbQVona00SSQuexbjVl43VAsBu+SeZn
        mpcZqiymk0gCbYOAfzlBBkgo0l1o9j32EmeytnukBYNq3DbA1/zUWnNFOFNtEQ0neTWCn+jgQp538
        d4H2syXA==;
Received: from [179.95.24.146] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1h6YBp-0000w4-G0; Wed, 20 Mar 2019 10:11:18 +0000
Date:   Wed, 20 Mar 2019 07:11:12 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Dafna Hirschfeld <dafna3@gmail.com>
Cc:     linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        helen.koike@collabora.com, Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: Re: [PATCH v5 02/23] videodev2.h: add
 V4L2_BUF_CAP_REQUIRES_REQUESTS
Message-ID: <20190320071112.4ed71c54@coco.lan>
In-Reply-To: <20190306211343.15302-3-dafna3@gmail.com>
References: <20190306211343.15302-1-dafna3@gmail.com>
        <20190306211343.15302-3-dafna3@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Wed,  6 Mar 2019 13:13:22 -0800
Dafna Hirschfeld <dafna3@gmail.com> escreveu:

> From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> 
> Add capability to indicate that requests are required instead of
> merely supported.

Not sure if I liked this patch, and for sure it lacks a lot of documentation:

First of all, the patch description doesn't help. For example, it doesn't
explain or mention any use case example that would require (instead of
merely support) a request.

> 
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
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

And the documentation here is really poor, as it doesn't explain what's
the API and drivers expected behavior with regards to this flag.

I mean, if, on a new driver, requests are mandatory, what happens if a
non-request-API aware application tries to use it? 

Another thing that concerns me a lot is that people might want to add it
to existing drivers. Well, if an application was written before the
addition of this driver, and request API become mandatory, such app
will stop working, if it doesn't use request API.

At very least, it should be mentioned somewhere that existing drivers
should never set this flag, as this would break it for existing
userspace apps.

Still, I would prefer to not have to add something like that.


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



Thanks,
Mauro
