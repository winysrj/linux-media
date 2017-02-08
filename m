Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:43673
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932242AbdBHNSk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Feb 2017 08:18:40 -0500
Date: Wed, 8 Feb 2017 10:22:59 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hugues Fruchet <hugues.fruchet@st.com>
Cc: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>,
        <kernel@stlinux.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Subject: Re: [PATCH v1 3/3] [media] st-delta: add mpeg2 support
Message-ID: <20170208102259.1d5dcb8b@vento.lan>
In-Reply-To: <1485773849-23945-4-git-send-email-hugues.fruchet@st.com>
References: <1485773849-23945-1-git-send-email-hugues.fruchet@st.com>
        <1485773849-23945-4-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 30 Jan 2017 11:57:29 +0100
Hugues Fruchet <hugues.fruchet@st.com> escreveu:

> Adds support of DELTA MPEG-2 video decoder back-end,
> implemented by calling MPEG2_TRANSFORMER0 firmware
> using RPMSG IPC communication layer.
> MPEG-2 decoder back-end is a stateless decoder which
> require specific parsing metadata in access unit
> in order to complete decoding.
> 
> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> ---
>  drivers/media/platform/Kconfig                     |    6 +
>  drivers/media/platform/sti/delta/Makefile          |    3 +
>  drivers/media/platform/sti/delta/delta-cfg.h       |    5 +
>  drivers/media/platform/sti/delta/delta-mpeg2-dec.c | 1392 ++++++++++++++++++++
>  drivers/media/platform/sti/delta/delta-mpeg2-fw.h  |  415 ++++++
>  drivers/media/platform/sti/delta/delta-v4l2.c      |    4 +
>  6 files changed, 1825 insertions(+)
>  create mode 100644 drivers/media/platform/sti/delta/delta-mpeg2-dec.c
>  create mode 100644 drivers/media/platform/sti/delta/delta-mpeg2-fw.h
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 9e71a7b..0472939 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -323,6 +323,12 @@ config VIDEO_STI_DELTA_MJPEG
>  	help
>  		Enables DELTA MJPEG hardware support.
>  
> +config VIDEO_STI_DELTA_MPEG2
> +	bool "STMicroelectronics DELTA MPEG2/MPEG1 support"
> +	default y
> +	help
> +		Enables DELTA MPEG2 hardware support.
> +
>  endif # VIDEO_STI_DELTA

This patch needs to be rebased, as you need to adjust the dependencies
on VIDEO_STI_DELTA_DRIVER for it to depend also on this driver.

Regards,
Mauro


Thanks,
Mauro
