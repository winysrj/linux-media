Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758879Ab2HJW3c (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Aug 2012 18:29:32 -0400
Message-ID: <50258B49.8010504@redhat.com>
Date: Fri, 10 Aug 2012 19:29:29 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: CrazyCat <crazycat69@yandex.ru>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH]Omicom S2 PCI support
References: <1128921342302008@web25h.yandex.ru>
In-Reply-To: <1128921342302008@web25h.yandex.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 14-07-2012 18:40, CrazyCat escreveu:
> Support for yet another SAA7146-based budget card (very similar to TT S2-1600, but use LNBH23 instead ISL6423).
> diff --git a/drivers/media/dvb/ttpci/budget.c b/drivers/media/dvb/ttpci/budget.c

...
WARNING: Prefer pr_err(... to printk(KERN_ERR, ...
#86: FILE: drivers/media/dvb/ttpci/budget.c:735:
+					printk(KERN_ERR "%s: No STV6110(A) Silicon Tuner found!\n", __func__);

ERROR: Missing Signed-off-by: line(s)

total: 2 errors, 21 warnings, 85 lines checked

Again, missing to check it against checkpatch and to add your SOB.

Regards,
Mauro

> index b21bcce..1774c53 100644
> --- a/drivers/media/dvb/ttpci/budget.c
> +++ b/drivers/media/dvb/ttpci/budget.c
> @@ -50,6 +50,8 @@
>  #include "stv6110x.h"
>  #include "stv090x.h"
>  #include "isl6423.h"
> +#include "lnbh24.h"
> +
>  
>  static int diseqc_method;
>  module_param(diseqc_method, int, 0444);
> @@ -679,6 +681,63 @@ static void frontend_init(struct budget *budget)
>  			}
>  		}
>  		break;
> +
> +	case 0x1020: { /* Omicom S2 */
> +			struct stv6110x_devctl *ctl;
> +			saa7146_setgpio(budget->dev, 2, SAA7146_GPIO_OUTLO);
> +			msleep(50);
> +			saa7146_setgpio(budget->dev, 2, SAA7146_GPIO_OUTHI);
> +			msleep(250);
> +
> +			budget->dvb_frontend = dvb_attach(stv090x_attach,
> +							  &tt1600_stv090x_config,
> +							  &budget->i2c_adap,
> +							  STV090x_DEMODULATOR_0);
> +
> +			if (budget->dvb_frontend) {
> +				printk(KERN_INFO "budget: Omicom S2 detected\n");
> +
> +				ctl = dvb_attach(stv6110x_attach,
> +						 budget->dvb_frontend,
> +						 &tt1600_stv6110x_config,
> +						 &budget->i2c_adap);
> +
> +				if (ctl) {
> +					tt1600_stv090x_config.tuner_init	  = ctl->tuner_init;
> +					tt1600_stv090x_config.tuner_sleep	  = ctl->tuner_sleep;
> +					tt1600_stv090x_config.tuner_set_mode	  = ctl->tuner_set_mode;
> +					tt1600_stv090x_config.tuner_set_frequency = ctl->tuner_set_frequency;
> +					tt1600_stv090x_config.tuner_get_frequency = ctl->tuner_get_frequency;
> +					tt1600_stv090x_config.tuner_set_bandwidth = ctl->tuner_set_bandwidth;
> +					tt1600_stv090x_config.tuner_get_bandwidth = ctl->tuner_get_bandwidth;
> +					tt1600_stv090x_config.tuner_set_bbgain	  = ctl->tuner_set_bbgain;
> +					tt1600_stv090x_config.tuner_get_bbgain	  = ctl->tuner_get_bbgain;
> +					tt1600_stv090x_config.tuner_set_refclk	  = ctl->tuner_set_refclk;
> +					tt1600_stv090x_config.tuner_get_status	  = ctl->tuner_get_status;
> +
> +					/* call the init function once to initialize
> +					   tuner's clock output divider and demod's
> +					   master clock */
> +					if (budget->dvb_frontend->ops.init)
> +						budget->dvb_frontend->ops.init(budget->dvb_frontend);
> +
> +					if (dvb_attach(lnbh24_attach,
> +							budget->dvb_frontend,
> +							&budget->i2c_adap,
> +							LNBH24_PCL | LNBH24_TTX,
> +							LNBH24_TEN, 0x14>>1) == NULL)
> +					{
> +						printk(KERN_ERR
> +						"No LNBH24 found!\n");
> +						goto error_out;
> +					}
> +				} else {
> +					printk(KERN_ERR "%s: No STV6110(A) Silicon Tuner found!\n", __func__);
> +					goto error_out;
> +				}
> +			}
> +		}
> +		break;
>  	}
>  
>  	if (budget->dvb_frontend == NULL) {
> @@ -759,6 +818,7 @@ MAKE_BUDGET_INFO(fsacs0, "Fujitsu Siemens Activy Budget-S PCI (rev GR/grundig fr
>  MAKE_BUDGET_INFO(fsacs1, "Fujitsu Siemens Activy Budget-S PCI (rev AL/alps frontend)", BUDGET_FS_ACTIVY);
>  MAKE_BUDGET_INFO(fsact,	 "Fujitsu Siemens Activy Budget-T PCI (rev GR/Grundig frontend)", BUDGET_FS_ACTIVY);
>  MAKE_BUDGET_INFO(fsact1, "Fujitsu Siemens Activy Budget-T PCI (rev AL/ALPS TDHD1-204A)", BUDGET_FS_ACTIVY);
> +MAKE_BUDGET_INFO(omicom, "Omicom S2 PCI", BUDGET_TT);
>  
>  static struct pci_device_id pci_tbl[] = {
>  	MAKE_EXTENSION_PCI(ttbs,  0x13c2, 0x1003),
> @@ -772,6 +832,7 @@ static struct pci_device_id pci_tbl[] = {
>  	MAKE_EXTENSION_PCI(fsacs0,0x1131, 0x4f61),
>  	MAKE_EXTENSION_PCI(fsact1, 0x1131, 0x5f60),
>  	MAKE_EXTENSION_PCI(fsact, 0x1131, 0x5f61),
> +	MAKE_EXTENSION_PCI(omicom, 0x14c4, 0x1020),
>  	{
>  		.vendor    = 0,
>  	}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

