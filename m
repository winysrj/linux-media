Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:37067 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751632AbdBASW7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Feb 2017 13:22:59 -0500
Received: by mail-wm0-f43.google.com with SMTP id v77so49855833wmv.0
        for <linux-media@vger.kernel.org>; Wed, 01 Feb 2017 10:22:58 -0800 (PST)
Date: Wed, 1 Feb 2017 18:22:38 +0000
From: Peter Griffin <peter.griffin@linaro.org>
To: Hugues Fruchet <hugues.fruchet@st.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        kernel@stlinux.com,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: Re: [STLinux Kernel] [PATCH v6 04/10] [media] MAINTAINERS: add
 st-delta driver
Message-ID: <20170201182238.GF31988@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1485965011-17388-1-git-send-email-hugues.fruchet@st.com>
 <1485965011-17388-5-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1485965011-17388-5-git-send-email-hugues.fruchet@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hugues,

On Wed, 01 Feb 2017, Hugues Fruchet wrote:

> Add entry for the STMicroelectronics DELTA driver.
> 
> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> ---
>  MAINTAINERS | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index cfff2c9..38cc652 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2429,6 +2429,14 @@ W:	https://linuxtv.org
>  S:	Supported
>  F:	drivers/media/platform/sti/bdisp
>  
> +DELTA ST MEDIA DRIVER
> +M:	Hugues Fruchet <hugues.fruchet@st.com>
> +L:	linux-media@vger.kernel.org

Would be useful to also include kernel@stlinux.com mailing list.

Apart from that:

Acked-by: Peter Griffin <peter.griffin@linaro.org>

> +T:	git git://linuxtv.org/media_tree.git
> +W:	https://linuxtv.org
> +S:	Supported
> +F:	drivers/media/platform/sti/delta
> +
>  BEFS FILE SYSTEM
>  M:	Luis de Bethencourt <luisbg@osg.samsung.com>
>  M:	Salah Triki <salah.triki@gmail.com>
