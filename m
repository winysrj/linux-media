Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:45301 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752831Ab0CYMjW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Mar 2010 08:39:22 -0400
From: Oliver Endriss <o.endriss@gmx.de>
To: =?iso-8859-1?q?Bj=F8rn_Mork?= <bjorn@mork.no>
Subject: Re: [PATCH v2 for v4l-dvb master] V4L/DVB: budget: Oops: "BUG: unable to handle kernel NULL pointer dereference"
Date: Thu, 25 Mar 2010 13:38:44 +0100
Cc: linux-media@vger.kernel.org
References: <1269428277-6709-1-git-send-email-bjorn@mork.no> <1269436658-20370-1-git-send-email-bjorn@mork.no> <1269437415-21761-1-git-send-email-bjorn@mork.no>
In-Reply-To: <1269437415-21761-1-git-send-email-bjorn@mork.no>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201003251338.45693@orion.escape-edv.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Bjørn Mork wrote:
> Never call dvb_frontend_detach if we failed to attach a frontend. This fixes
> the following oops:
> 
> [    8.172997] DVB: registering new adapter (TT-Budget S2-1600 PCI)
> [    8.209018] adapter has MAC addr = 00:d0:5c:cc:a7:29
> [    8.328665] Intel ICH 0000:00:1f.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
> [    8.328753] Intel ICH 0000:00:1f.5: setting latency timer to 64
> [    8.562047] DVB: Unable to find symbol stv090x_attach()
> [    8.562117] BUG: unable to handle kernel NULL pointer dereference at 000000ac
> [    8.562239] IP: [<e08b04a3>] dvb_frontend_detach+0x4/0x67 [dvb_core]
> 
> Ref http://bugs.debian.org/575207
> 
> Also clean up if we are unable to register the tuner and LNB drivers
> 
> Signed-off-by: Bjørn Mork <bjorn@mork.no>
> Reported-by: Fladischer Michael <FladischerMichael@fladi.at>
> ---
> This version should apply to to git://linuxtv.org/v4l-dvb.git master on
> top of commit 30b8f0787e51a3ab0c447e0e3bf4aadc7caf9ffd. 
> 
> It is otherwise identical to the v2 patch for the upstream and stable
> kernel repositories.
> 
> 
>  drivers/media/dvb/ttpci/budget.c |   56 ++++++++++++++++++++-----------------
>  1 files changed, 30 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/media/dvb/ttpci/budget.c b/drivers/media/dvb/ttpci/budget.c
> index fccb6ad..918679e 100644
> --- a/drivers/media/dvb/ttpci/budget.c
> +++ b/drivers/media/dvb/ttpci/budget.c
> @@ -628,32 +628,36 @@ static void frontend_init(struct budget *budget)
>  						 &tt1600_stv6110x_config,
>  						 &budget->i2c_adap);
>  
> -				tt1600_stv090x_config.tuner_init	  = ctl->tuner_init;
> -				tt1600_stv090x_config.tuner_sleep	  = ctl->tuner_sleep;
> -				tt1600_stv090x_config.tuner_set_mode	  = ctl->tuner_set_mode;
> -				tt1600_stv090x_config.tuner_set_frequency = ctl->tuner_set_frequency;
> -				tt1600_stv090x_config.tuner_get_frequency = ctl->tuner_get_frequency;
> -				tt1600_stv090x_config.tuner_set_bandwidth = ctl->tuner_set_bandwidth;
> -				tt1600_stv090x_config.tuner_get_bandwidth = ctl->tuner_get_bandwidth;
> -				tt1600_stv090x_config.tuner_set_bbgain	  = ctl->tuner_set_bbgain;
> -				tt1600_stv090x_config.tuner_get_bbgain	  = ctl->tuner_get_bbgain;
> -				tt1600_stv090x_config.tuner_set_refclk	  = ctl->tuner_set_refclk;
> -				tt1600_stv090x_config.tuner_get_status	  = ctl->tuner_get_status;
> -
> -				/* call the init function once to initialize
> -				   tuner's clock output divider and demod's
> -				   master clock */
> -				if (budget->dvb_frontend->ops.init)
> -					budget->dvb_frontend->ops.init(budget->dvb_frontend);
> -
> -				dvb_attach(isl6423_attach,
> -					budget->dvb_frontend,
> -					&budget->i2c_adap,
> -					&tt1600_isl6423_config);
> -
> -			} else {
> -				dvb_frontend_detach(budget->dvb_frontend);
> -				budget->dvb_frontend = NULL;
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
> +					if (dvb_attach(isl6423_attach,
> +						       budget->dvb_frontend,
> +						       &budget->i2c_adap,
> +						       &tt1600_isl6423_config) == NULL) {
> +						printk("%s: No Intersil ISL6423 found!\n", __func__);
> +						goto error_out;
> +					}
> +				} else {
> +					printk("%s: No STV6110(A) Silicon Tuner found!\n", __func__);
> +					goto error_out;
> +				}
>  			}
>  		}
>  		break;


Looks fine.

Acked-by: Oliver Endriss <o.endriss@gmx.de>

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
