Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:44019 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752130AbeB0IrB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Feb 2018 03:47:01 -0500
Message-ID: <1519721219.3402.8.camel@pengutronix.de>
Subject: Re: [PATCH 3/3] media: imx: Don't initialize vars that won't be used
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Date: Tue, 27 Feb 2018 09:46:59 +0100
In-Reply-To: <52e17089d1850774d2ef583cdef2b060b84fca8c.1519652405.git.mchehab@s-opensource.com>
References: <00d9da502565e97fcca3805eec98db6df3594ec0.1519652405.git.mchehab@s-opensource.com>
         <52e17089d1850774d2ef583cdef2b060b84fca8c.1519652405.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2018-02-26 at 08:40 -0500, Mauro Carvalho Chehab wrote:
> As reported by gcc:
> 
>   + drivers/staging/media/imx/imx-media-csi.c: warning: variable 'input_fi' set but not used [-Wunused-but-set-variable]:  => 671:33
>   + drivers/staging/media/imx/imx-media-csi.c: warning: variable 'pinctrl' set but not used [-Wunused-but-set-variable]:  => 1742:18
> 
> input_fi is not used, so just remove it.
> 
> However, pinctrl should be used, as it devm_pinctrl_get_select_default()
> is declared with attribute warn_unused_result. What's missing there
> is an error handling code, in case it fails. Add it.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp
