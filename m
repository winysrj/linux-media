Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:48103
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932600AbcHVPth (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Aug 2016 11:49:37 -0400
Date: Mon, 22 Aug 2016 12:49:30 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sumit Semwal <sumit.semwal@linaro.org>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-doc@vger.kernel.org,
        corbet@lwn.net, linux-kernel@vger.kernel.org,
        markus.heiser@darmarit.de, jani.nikula@linux.intel.com
Subject: Re: [PATCH v2 2/2] Documentation/sphinx: link dma-buf rsts
Message-ID: <20160822124930.02dbbafc@vento.lan>
In-Reply-To: <1471878705-3963-3-git-send-email-sumit.semwal@linaro.org>
References: <1471878705-3963-1-git-send-email-sumit.semwal@linaro.org>
        <1471878705-3963-3-git-send-email-sumit.semwal@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 22 Aug 2016 20:41:45 +0530
Sumit Semwal <sumit.semwal@linaro.org> escreveu:

> Include dma-buf sphinx documentation into top level index.
> 
> Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
> ---
>  Documentation/index.rst | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/index.rst b/Documentation/index.rst
> index e0fc72963e87..8d05070122c2 100644
> --- a/Documentation/index.rst
> +++ b/Documentation/index.rst
> @@ -14,6 +14,8 @@ Contents:
>     :maxdepth: 2
>  
>     kernel-documentation
> +   dma-buf/intro
> +   dma-buf/guide
>     media/media_uapi
>     media/media_kapi
>     media/dvb-drivers/index

IMHO, the best would be, instead, to add an index with a toctree
with both intro and guide, and add dma-buf/index instead.

We did that for media too (patches not merged upstream yet), together
with a patchset that will allow building just a subset of the books.

Regards,
Mauro

PS.: That's the content of our index.rst file, at
Documentation/media/index.rst:

Linux Media Subsystem Documentation
===================================

Contents:

.. toctree::
   :maxdepth: 2

   media_uapi
   media_kapi
   dvb-drivers/index
   v4l-drivers/index

.. only::  subproject

   Indices
   =======

   * :ref:`genindex`


Thanks,
Mauro
