Return-path: <mchehab@pedra>
Received: from brigitte.telenet-ops.be ([195.130.137.66]:48038 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662Ab1GDAGx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Jul 2011 20:06:53 -0400
Subject: Re: [PATCH 5/5] cxd2099: Update Kconfig description (ddbridge
 support)
From: Walter Van Eetvelt <walter@van.eetvelt.be>
To: Oliver Endriss <o.endriss@gmx.de>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
In-Reply-To: <201107032327.52762@orion.escape-edv.de>
References: <201107032321.46092@orion.escape-edv.de>
	 <201107032327.52762@orion.escape-edv.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Jul 2011 02:06:51 +0200
Message-ID: <1309738011.3666.33.camel@Zonnebloem.ZONNEWIND.VL>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Oliver Endriss schreef op Sun 03-07-2011 om 23:27 [+0200]:
> Update Kconfig description (ddbridge with cxd2099)
> 
> Signed-off-by: Oliver Endriss <o.endriss@gmx.de>
> ---
>  drivers/staging/cxd2099/Kconfig |   11 ++++++-----
>  1 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/cxd2099/Kconfig b/drivers/staging/cxd2099/Kconfig
> index 9d638c3..b48aefd 100644
> --- a/drivers/staging/cxd2099/Kconfig
> +++ b/drivers/staging/cxd2099/Kconfig
> @@ -1,9 +1,10 @@
>  config DVB_CXD2099
> -        tristate "CXD2099AR Common Interface driver"
> -        depends on DVB_CORE && PCI && I2C && DVB_NGENE
> -        ---help---
> -          Support for the CI module found on cineS2 DVB-S2, supported by
> -	  the Micronas PCIe device driver (ngene).
> +	tristate "CXD2099AR Common Interface driver"
> +	depends on DVB_CORE && PCI && I2C
> +	---help---
> +	  Support for the CI module found on cards based on
> +	  - Micronas ngene PCIe bridge: cineS2 etc.
> +	  - Digital Devices PCIe bridge: Octopus series
>  
>  	  For now, data is passed through '/dev/dvb/adapterX/sec0':
>  	    - Encrypted data must be written to 'sec0'.
Hi Oliver,
=> can you explain a bit more on "data is passed through
'/dev/dvb/adapterX/sec0':"

How is the idea behind the setup?

Is each adapter having its own sec0?  

Walter



