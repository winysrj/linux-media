Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52014 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1757479AbcLPN4b (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Dec 2016 08:56:31 -0500
Date: Fri, 16 Dec 2016 15:56:27 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        kernel@stlinux.com,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>,
        Hugues Fruchet <hugues.fruchet@st.com>
Subject: Re: [PATCH v1] [media] v4l2-common: fix aligned value calculation
Message-ID: <20161216135626.GK16630@valkosipuli.retiisi.org.uk>
References: <1481895135-11055-1-git-send-email-jean-christophe.trotin@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1481895135-11055-1-git-send-email-jean-christophe.trotin@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean-Christophe,

On Fri, Dec 16, 2016 at 02:32:15PM +0100, Jean-Christophe Trotin wrote:
> Correct the calculation of the rounding to nearest aligned value in
> the clamp_align() function. For example, clamp_align(1277, 1, 9600, 2)
> returns 1276, while it should return 1280.

Why should the function return 1280 instead of 1276, which is closer to
1277?

> 
> Signed-off-by: Jean-Christophe Trotin <jean-christophe.trotin@st.com>
> ---
>  drivers/media/v4l2-core/v4l2-common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
> index 57cfe26a..2970ce7 100644
> --- a/drivers/media/v4l2-core/v4l2-common.c
> +++ b/drivers/media/v4l2-core/v4l2-common.c
> @@ -315,7 +315,7 @@ static unsigned int clamp_align(unsigned int x, unsigned int min,
>  
>  	/* Round to nearest aligned value */
>  	if (align)
> -		x = (x + (1 << (align - 1))) & mask;
> +		x = (x + ((1 << align) - 1)) & mask;
>  
>  	return x;
>  }

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
