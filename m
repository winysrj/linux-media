Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:43387
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932092AbdBHMUY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Feb 2017 07:20:24 -0500
Date: Wed, 8 Feb 2017 10:19:28 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hugues Fruchet <hugues.fruchet@st.com>
Cc: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>,
        <kernel@stlinux.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Subject: Re: [PATCH v7 09/10] [media] st-delta: add mjpeg support
Message-ID: <20170208101928.4638291e@vento.lan>
In-Reply-To: <1486047593-18581-10-git-send-email-hugues.fruchet@st.com>
References: <1486047593-18581-1-git-send-email-hugues.fruchet@st.com>
        <1486047593-18581-10-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 2 Feb 2017 15:59:52 +0100
Hugues Fruchet <hugues.fruchet@st.com> escreveu:

I applied today this series. There's just a nitpick, that you can change
when you submit a version 2 of the MPEG2 driver. See below:

> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 2e82ec6..20b26ea 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -317,10 +317,20 @@ config VIDEO_STI_DELTA
>  
>  if VIDEO_STI_DELTA
>  
> +config VIDEO_STI_DELTA_MJPEG
> +	bool "STMicroelectronics DELTA MJPEG support"
> +	default y
> +	help
> +		Enables DELTA MJPEG hardware support.
> +
> +		To compile this driver as a module, choose M here:
> +		the module will be called st-delta.
> +
>  config VIDEO_STI_DELTA_DRIVER
>  	tristate
>  	depends on VIDEO_STI_DELTA
> -	default n
> +	depends on VIDEO_STI_DELTA_MJPEG
> +	default VIDEO_STI_DELTA_MJPEG

Just do:
	default y

The build system will do the right thing, as it will evaluate
the dependencies, disabling it if no decoder is selected. That
will avoid needing to change the default line for every new decoder
you add.

>  	select VIDEOBUF2_DMA_CONTIG
>  	select V4L2_MEM2MEM_DEV
>  	select RPMSG


Thanks,
Mauro
