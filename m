Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:39516 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768AbaJFAQa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Oct 2014 20:16:30 -0400
Date: Sun, 5 Oct 2014 21:16:25 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: "=?UTF-8?B?0JHRg9C00Lgg0KDQvtC80LDQvdGC0L4s?= AreMa Inc"
	<info@are.ma>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] Kconfig: cosmetic improvement
Message-ID: <20141005211625.69225896@recife.lan>
In-Reply-To: <766263dfa0c03ad90e912828fdd7e0cb391e5ae1.1412530212.git.knightrider@are.ma>
References: <766263dfa0c03ad90e912828fdd7e0cb391e5ae1.1412530212.git.knightrider@are.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 06 Oct 2014 02:37:34 +0900
"Буди Романто, AreMa Inc" <info@are.ma> escreveu:

> PT1 & PT3 are wrongly categorized, fix it
> Add comment that PT3 needs FE & tuners
> 
> This patch can be applied immediately
> 
> Signed-off-by: Буди Романто, AreMa Inc <knightrider@are.ma>
> ---
>  drivers/media/dvb-frontends/Kconfig | 4 ++--
>  drivers/media/pci/pt3/Kconfig       | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
> index 5a13454..0c59825 100644
> --- a/drivers/media/dvb-frontends/Kconfig
> +++ b/drivers/media/dvb-frontends/Kconfig
> @@ -621,7 +621,7 @@ config DVB_S5H1411
>  	  An ATSC 8VSB and QAM64/256 tuner module. Say Y when you want
>  	  to support this frontend.
>  
> -comment "ISDB-T (terrestrial) frontends"
> +comment "ISDB-S (satellite) & ISDB-T (terrestrial) frontends"

Hmm... it is actually better to add another comment, just before
config DVB_TC90522.

>  	depends on DVB_CORE
>  
>  config DVB_S921
> @@ -653,7 +653,7 @@ config DVB_TC90522
>  	depends on DVB_CORE && I2C
>  	default m if !MEDIA_SUBDRV_AUTOSELECT
>  	help
> -	  A Toshiba TC90522 2xISDB-T + 2xISDB-S demodulator.
> +	  Toshiba TC90522 2xISDB-S 8PSK + 2xISDB-T OFDM demodulator.
>  	  Say Y when you want to support this frontend.

OK.

>  
>  comment "Digital terrestrial only tuners/PLL"
> diff --git a/drivers/media/pci/pt3/Kconfig b/drivers/media/pci/pt3/Kconfig
> index 16c208a..f7b7210 100644
> --- a/drivers/media/pci/pt3/Kconfig
> +++ b/drivers/media/pci/pt3/Kconfig
> @@ -6,5 +6,5 @@ config DVB_PT3
>  	select MEDIA_TUNER_MXL301RF if MEDIA_SUBDRV_AUTOSELECT
>  	help
>  	  Support for Earthsoft PT3 PCIe cards.
> -
> +	  You need to enable frontend (TC90522) & tuners (QM1D1C0042, MXL301RF)

Please, don't add this. Ok, on this driver this is pretty straightforward,
but, for some bridges like em28xx, there are actually lots of tuners and
frontends that are needed.

So, the way we do is to use MEDIA_SUBDRV_AUTOSELECT. This will auto-select
everything that it is needed for a given device.

>  	  Say Y or M if you own such a device and want to use it.

Regards,
Mauro
