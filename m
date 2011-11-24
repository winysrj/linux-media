Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900Ab1KXLPa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 06:15:30 -0500
Message-ID: <4ECE274D.1050801@redhat.com>
Date: Thu, 24 Nov 2011 09:15:25 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Doron Cohen <doronc@siano-ms.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH v2] Add version number to all siano modules description
 lines.
References: <D945C405928A9949A0F33C69E64A1A3BD8D5D7@s-mail.siano-ms.ent>
In-Reply-To: <D945C405928A9949A0F33C69E64A1A3BD8D5D7@s-mail.siano-ms.ent>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 03-11-2011 09:34, Doron Cohen escreveu:
> 
> 
>>From 595a6726947b032ce355ac0d838f07d937ed7f57 Mon Sep 17 00:00:00 2001
> From: Doron Cohen <lab@Doron-Ubuntu.(none)>
> Date: Thu, 15 Sep 2011 11:38:53 +0300
> Subject: [PATCH 2/2] Add version number to all siano modules description
> line.

Patch looks ok, but it is also line-wrapped.
> 
> Signed-off-by: Doron Cohen <doronc@siano-ms.com>
> ---
>  drivers/media/dvb/siano/smscoreapi.c |    3 ++-
>  drivers/media/dvb/siano/smscoreapi.h |   13 +++++++++++++
>  drivers/media/dvb/siano/smsdvb.c     |    3 ++-
>  drivers/media/dvb/siano/smssdio.c    |    3 ++-
>  drivers/media/dvb/siano/smsspidrv.c  |    3 ++-
>  drivers/media/dvb/siano/smsusb.c     |    3 ++-
>  6 files changed, 23 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/dvb/siano/smscoreapi.c 
> b/drivers/media/dvb/siano/smscoreapi.c
> index c0acacc..dfbc648 100644
> --- a/drivers/media/dvb/siano/smscoreapi.c
> +++ b/drivers/media/dvb/siano/smscoreapi.c
> @@ -1639,6 +1639,7 @@ static void __exit smscore_module_exit(void)
>  module_init(smscore_module_init);
>  module_exit(smscore_module_exit);
>  
> +MODULE_VERSION(VERSION_STRING);
>  MODULE_DESCRIPTION("Siano MDTV Core module");
> -MODULE_AUTHOR("Siano Mobile Silicon, Inc. (uris@siano-ms.com)");
> +MODULE_AUTHOR(MODULE_AUTHOR_STRING);
>  MODULE_LICENSE("GPL");
> diff --git a/drivers/media/dvb/siano/smscoreapi.h 
> b/drivers/media/dvb/siano/smscoreapi.h
> index bd1cafc..aabcad3 100644
> --- a/drivers/media/dvb/siano/smscoreapi.h
> +++ b/drivers/media/dvb/siano/smscoreapi.h
> @@ -35,6 +35,19 @@ along with this program.  If not, see 
> <http://www.gnu.org/licenses/>.
>  
>  #include "smsir.h"
>  
> +
> +#define MAJOR_VERSION 2
> +#define MINOR_VERSION 3
> +#define SUB_VERSION 0
> +
> +#define STRINGIZE2(z) #z
> +#define STRINGIZE(z) STRINGIZE2(z)
> +
> +#define VERSION_STRING "Version: " STRINGIZE(MAJOR_VERSION) "." \
> +STRINGIZE(MINOR_VERSION) "." STRINGIZE(SUB_VERSION)
> +
> +#define MODULE_AUTHOR_STRING "Siano Mobile Silicon, Inc.
> (doronc@siano-ms.com)"
> +
>  #define kmutex_init(_p_) mutex_init(_p_)
>  #define kmutex_lock(_p_) mutex_lock(_p_)
>  #define kmutex_trylock(_p_) mutex_trylock(_p_)
> diff --git a/drivers/media/dvb/siano/smsdvb.c
> b/drivers/media/dvb/siano/smsdvb.c
> index b1f4911..dc0e73f 100644
> --- a/drivers/media/dvb/siano/smsdvb.c
> +++ b/drivers/media/dvb/siano/smsdvb.c
> @@ -953,6 +953,7 @@ static void __exit smsdvb_module_exit(void)
>  module_init(smsdvb_module_init);
>  module_exit(smsdvb_module_exit);
>  
> +MODULE_VERSION(VERSION_STRING);
>  MODULE_DESCRIPTION("SMS DVB subsystem adaptation module");
> -MODULE_AUTHOR("Siano Mobile Silicon, Inc. (uris@siano-ms.com)");
> +MODULE_AUTHOR(MODULE_AUTHOR_STRING);
>  MODULE_LICENSE("GPL");
> diff --git a/drivers/media/dvb/siano/smssdio.c 
> b/drivers/media/dvb/siano/smssdio.c
> index e57d38b..e735949 100644
> --- a/drivers/media/dvb/siano/smssdio.c
> +++ b/drivers/media/dvb/siano/smssdio.c
> @@ -359,6 +359,7 @@ static void __exit smssdio_module_exit(void)
>  module_init(smssdio_module_init);
>  module_exit(smssdio_module_exit);
>  
> +MODULE_VERSION(VERSION_STRING);
>  MODULE_DESCRIPTION("Siano SMS1xxx SDIO driver");
> -MODULE_AUTHOR("Pierre Ossman");
> +MODULE_AUTHOR(MODULE_AUTHOR_STRING);
>  MODULE_LICENSE("GPL");
> diff --git a/drivers/media/dvb/siano/smsspidrv.c 
> b/drivers/media/dvb/siano/smsspidrv.c
> index 4526cb8..c855fa2 100644
> --- a/drivers/media/dvb/siano/smsspidrv.c
> +++ b/drivers/media/dvb/siano/smsspidrv.c
> @@ -467,6 +467,7 @@ static void __exit smsspi_module_exit(void)
>  module_init(smsspi_module_init);
>  module_exit(smsspi_module_exit);
>  
> +MODULE_VERSION(VERSION_STRING);
>  MODULE_DESCRIPTION("Siano MDTV SPI device driver");
> -MODULE_AUTHOR("Siano Mobile Silicon, Inc. (doronc@siano-ms.com)");
> +MODULE_AUTHOR(MODULE_AUTHOR_STRING);
>  MODULE_LICENSE("GPL");
> diff --git a/drivers/media/dvb/siano/smsusb.c
> b/drivers/media/dvb/siano/smsusb.c
> index f8dca55..cc688c5 100644
> --- a/drivers/media/dvb/siano/smsusb.c
> +++ b/drivers/media/dvb/siano/smsusb.c
> @@ -573,6 +573,7 @@ static void __exit smsusb_module_exit(void)
>  module_init(smsusb_module_init);
>  module_exit(smsusb_module_exit);
>  
> +MODULE_VERSION(VERSION_STRING);
>  MODULE_DESCRIPTION("Driver for the Siano SMS1xxx USB dongle");
> -MODULE_AUTHOR("Siano Mobile Silicon, INC. (uris@siano-ms.com)");
> +MODULE_AUTHOR(MODULE_AUTHOR_STRING);
>  MODULE_LICENSE("GPL");

