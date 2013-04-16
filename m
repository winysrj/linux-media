Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52199 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965533Ab3DPWzQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Apr 2013 18:55:16 -0400
Message-ID: <516DD6AB.5090105@iki.fi>
Date: Wed, 17 Apr 2013 01:54:35 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH v2] [media] it913x: rename its tuner driver to tuner_it913x
References: <1366152567-10191-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366152567-10191-1-git-send-email-mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/17/2013 01:49 AM, Mauro Carvalho Chehab wrote:
> There are three drivers with *it913x name on it, and they all
> belong to the same device:
> 	a tuner, at it913x.c;
> 	a frontend: it913x-fe.c;
> 	a bridge: it913x.c, renamed to dvb_usb_it913x by the
> building system.
>
> This is confusing. Even more confusing are the two .c files with
> the same name under different directories, with different contents
> and different functions. So, prepend the tuner one.
>
> This also breaks the out-of-tree compilation system.
>
> Reported-by: Frederic Fays <frederic.fays@gmail.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Acked-by: Antti Palosaari <crope@iki.fi>
Reviewed-by: Antti Palosaari <crope@iki.fi>


> ---
>
> v2: use -M to make it easier to review
>
>   drivers/media/tuners/Makefile                               | 2 +-
>   drivers/media/tuners/{it913x.c => tuner_it913x.c}           | 2 +-
>   drivers/media/tuners/{it913x.h => tuner_it913x.h}           | 0
>   drivers/media/tuners/{it913x_priv.h => tuner_it913x_priv.h} | 2 +-
>   drivers/media/usb/dvb-usb-v2/af9035.h                       | 2 +-
>   5 files changed, 4 insertions(+), 4 deletions(-)
>   rename drivers/media/tuners/{it913x.c => tuner_it913x.c} (99%)
>   rename drivers/media/tuners/{it913x.h => tuner_it913x.h} (100%)
>   rename drivers/media/tuners/{it913x_priv.h => tuner_it913x_priv.h} (98%)
>
> diff --git a/drivers/media/tuners/Makefile b/drivers/media/tuners/Makefile
> index f136a6d..2ebe4b7 100644
> --- a/drivers/media/tuners/Makefile
> +++ b/drivers/media/tuners/Makefile
> @@ -34,7 +34,7 @@ obj-$(CONFIG_MEDIA_TUNER_TUA9001) += tua9001.o
>   obj-$(CONFIG_MEDIA_TUNER_FC0011) += fc0011.o
>   obj-$(CONFIG_MEDIA_TUNER_FC0012) += fc0012.o
>   obj-$(CONFIG_MEDIA_TUNER_FC0013) += fc0013.o
> -obj-$(CONFIG_MEDIA_TUNER_IT913X) += it913x.o
> +obj-$(CONFIG_MEDIA_TUNER_IT913X) += tuner_it913x.o
>
>   ccflags-y += -I$(srctree)/drivers/media/dvb-core
>   ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
> diff --git a/drivers/media/tuners/it913x.c b/drivers/media/tuners/tuner_it913x.c
> similarity index 99%
> rename from drivers/media/tuners/it913x.c
> rename to drivers/media/tuners/tuner_it913x.c
> index 4d7a247..6f30d7e 100644
> --- a/drivers/media/tuners/it913x.c
> +++ b/drivers/media/tuners/tuner_it913x.c
> @@ -20,7 +20,7 @@
>    *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.=
>    */
>
> -#include "it913x_priv.h"
> +#include "tuner_it913x_priv.h"
>
>   struct it913x_state {
>   	struct i2c_adapter *i2c_adap;
> diff --git a/drivers/media/tuners/it913x.h b/drivers/media/tuners/tuner_it913x.h
> similarity index 100%
> rename from drivers/media/tuners/it913x.h
> rename to drivers/media/tuners/tuner_it913x.h
> diff --git a/drivers/media/tuners/it913x_priv.h b/drivers/media/tuners/tuner_it913x_priv.h
> similarity index 98%
> rename from drivers/media/tuners/it913x_priv.h
> rename to drivers/media/tuners/tuner_it913x_priv.h
> index 00dcf3c..ce65210 100644
> --- a/drivers/media/tuners/it913x_priv.h
> +++ b/drivers/media/tuners/tuner_it913x_priv.h
> @@ -23,7 +23,7 @@
>   #ifndef IT913X_PRIV_H
>   #define IT913X_PRIV_H
>
> -#include "it913x.h"
> +#include "tuner_it913x.h"
>   #include "af9033.h"
>
>   #define PRO_LINK		0x0
> diff --git a/drivers/media/usb/dvb-usb-v2/af9035.h b/drivers/media/usb/dvb-usb-v2/af9035.h
> index 0f42b6c..b5827ca 100644
> --- a/drivers/media/usb/dvb-usb-v2/af9035.h
> +++ b/drivers/media/usb/dvb-usb-v2/af9035.h
> @@ -30,7 +30,7 @@
>   #include "mxl5007t.h"
>   #include "tda18218.h"
>   #include "fc2580.h"
> -#include "it913x.h"
> +#include "tuner_it913x.h"
>
>   struct reg_val {
>   	u32 reg;
>


-- 
http://palosaari.fi/
