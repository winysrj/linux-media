Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:57976
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751552AbdHSKrs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 Aug 2017 06:47:48 -0400
Date: Sat, 19 Aug 2017 07:47:38 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [PATCH v2 2/2] docs-rst: media: Document broken frame handling
 in stream stop for CSI-2
Message-ID: <20170819074738.2036ff36@vento.lan>
In-Reply-To: <1502886018-31488-3-git-send-email-sakari.ailus@linux.intel.com>
References: <1502886018-31488-1-git-send-email-sakari.ailus@linux.intel.com>
        <1502886018-31488-3-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 16 Aug 2017 15:20:18 +0300
Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:

> Some CSI-2 transmitters will finish an ongoing frame whereas others will
> not. Document that receiver drivers should not assume a particular
> behaviour but to work in both cases.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  Documentation/media/kapi/csi2.rst | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/Documentation/media/kapi/csi2.rst b/Documentation/media/kapi/csi2.rst
> index e33fcb9..0560100 100644
> --- a/Documentation/media/kapi/csi2.rst
> +++ b/Documentation/media/kapi/csi2.rst
> @@ -51,6 +51,16 @@ not active. Some transmitters do this automatically but some have to
>  be explicitly programmed to do so, and some are unable to do so
>  altogether due to hardware constraints.
>  
> +Stopping the transmitter
> +^^^^^^^^^^^^^^^^^^^^^^^^
> +
> +A transmitter stops sending the stream of images as a result of
> +calling the ``.s_stream()`` callback. Some transmitters may stop the
> +stream at a frame boundary whereas others stop immediately,
> +effectively leaving the current frame unfinished. The receiver driver
> +should not make assumptions either way, but function properly in both
> +cases.
> +
>  Receiver drivers
>  ----------------
>  

Reviewed-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Thanks,
Mauro
