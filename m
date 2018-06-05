Return-path: <linux-media-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:39336 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751656AbeFEPUs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Jun 2018 11:20:48 -0400
Subject: Re: [PATCH] media: radio: aimslab: restore RADIO_ISA dependency
To: Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Takashi Iwai <tiwai@suse.de>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20180605113420.1092324-1-arnd@arndb.de>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <ceb6201f-4542-faf2-4956-8e7a4cb13b90@infradead.org>
Date: Tue, 5 Jun 2018 08:20:40 -0700
MIME-Version: 1.0
In-Reply-To: <20180605113420.1092324-1-arnd@arndb.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/05/2018 04:33 AM, Arnd Bergmann wrote:
> The patch that allowed all the ISA drivers to build across architectures
> accidentally removed one 'select' statement, which now causes a rare
> randconfig build failure in case all the other drivers are disabled:
> 
> drivers/media/radio/radio-aimslab.o:(.data+0x0): undefined reference to `radio_isa_match'
> drivers/media/radio/radio-aimslab.o:(.data+0x4): undefined reference to `radio_isa_probe'
> drivers/media/radio/radio-aimslab.o:(.data+0x8): undefined reference to `radio_isa_remove'
> 
> This puts the statement back where it belongs.
> 
> Fixes: 258c524bdaab ("media: radio: allow building ISA drivers with COMPILE_TEST")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/media/radio/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
> index 8fa403c7149e..39b04ad924c0 100644
> --- a/drivers/media/radio/Kconfig
> +++ b/drivers/media/radio/Kconfig
> @@ -257,6 +257,7 @@ config RADIO_RTRACK
>  	tristate "AIMSlab RadioTrack (aka RadioReveal) support"
>  	depends on ISA || COMPILE_TEST
>  	depends on VIDEO_V4L2
> +	select RADIO_ISA
>  	---help---
>  	  Choose Y here if you have one of these FM radio cards, and then fill
>  	  in the port address below.
> 

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Reported-by: Randy Dunlap <rdunlap@infradead.org>
https://marc.info/?l=linux-next&m=152778594005254&w=2


thanks,
-- 
~Randy
