Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:53203 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756308AbdLONfI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 08:35:08 -0500
Subject: Re: [PATCH v10 2/4] MAINTAINERS: Add entry for Synopsys DesignWare
 HDMI drivers
To: Jose Abreu <Jose.Abreu@synopsys.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1513013948.git.joabreu@synopsys.com>
 <8d468c10f1a66986b087a664e619dac339bad247.1513013948.git.joabreu@synopsys.com>
Cc: Joao Pinto <Joao.Pinto@synopsys.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <d1eae8b9-a3f1-5c6c-3c2c-119f55d4f38b@xs4all.nl>
Date: Fri, 15 Dec 2017 14:35:06 +0100
MIME-Version: 1.0
In-Reply-To: <8d468c10f1a66986b087a664e619dac339bad247.1513013948.git.joabreu@synopsys.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/12/17 18:41, Jose Abreu wrote:
> Add an entry for Synopsys DesignWare HDMI Receivers drivers
> and phys.
> 
> Signed-off-by: Jose Abreu <joabreu@synopsys.com>
> Cc: Joao Pinto <jpinto@synopsys.com>

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans



> ---
>  MAINTAINERS | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7a52a66..a1675bc 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -13108,6 +13108,13 @@ L:	netdev@vger.kernel.org
>  S:	Supported
>  F:	drivers/net/ethernet/synopsys/
>  
> +SYNOPSYS DESIGNWARE HDMI RECEIVERS AND PHY DRIVERS
> +M:	Jose Abreu <joabreu@synopsys.com>
> +L:	linux-media@vger.kernel.org
> +S:	Maintained
> +F:	drivers/media/platform/dwc/*
> +F:	include/media/dwc/*
> +
>  SYNOPSYS DESIGNWARE I2C DRIVER
>  M:	Jarkko Nikula <jarkko.nikula@linux.intel.com>
>  R:	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
