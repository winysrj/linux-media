Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:52618 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756074Ab0CXM12 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Mar 2010 08:27:28 -0400
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: =?iso-8859-1?q?Bj=F8rn_Mork?= <bjorn@mork.no>
Subject: Re: [PATCH] V4L/DVB: budget: Oops: "BUG: unable to handle kernel NULL pointer dereference"
Date: Wed, 24 Mar 2010 13:25:51 +0100
Cc: linux-media@vger.kernel.org, stable@kernel.org,
	575207@bugs.debian.org
References: <1269428277-6709-1-git-send-email-bjorn@mork.no>
In-Reply-To: <1269428277-6709-1-git-send-email-bjorn@mork.no>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201003241325.52864@orion.escape-edv.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Bjørn Mork wrote:
> Never call dvb_frontend_detach if we failed to attach a frontend. This fixes
> the following oops, which will be triggered by a missing stv090x module:
> 
> [    8.172997] DVB: registering new adapter (TT-Budget S2-1600 PCI)
> [    8.209018] adapter has MAC addr = 00:d0:5c:cc:a7:29
> [    8.328665] Intel ICH 0000:00:1f.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
> [    8.328753] Intel ICH 0000:00:1f.5: setting latency timer to 64
> [    8.562047] DVB: Unable to find symbol stv090x_attach()
> [    8.562117] BUG: unable to handle kernel NULL pointer dereference at 000000ac
> [    8.562239] IP: [<e08b04a3>] dvb_frontend_detach+0x4/0x67 [dvb_core]
> ...
> 
> Ref http://bugs.debian.org/575207
> 
> 
> Signed-off-by: Bjørn Mork <bjorn@mork.no>
> Cc: stable@kernel.org
> Cc: 575207@bugs.debian.org
> ---
> This patch should apply cleanly to 2.6.32, 2.6.33, 2.6.34-rc2 and with an 
> offset to git://linuxtv.org/v4l-dvb.git
> 
> Please apply to all of them
> 
> 
>  drivers/media/dvb/ttpci/budget.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/dvb/ttpci/budget.c b/drivers/media/dvb/ttpci/budget.c
> index e48380c..95a463c 100644
> --- a/drivers/media/dvb/ttpci/budget.c
> +++ b/drivers/media/dvb/ttpci/budget.c
> @@ -643,9 +643,6 @@ static void frontend_init(struct budget *budget)
>  					&budget->i2c_adap,
>  					&tt1600_isl6423_config);
>  
> -			} else {
> -				dvb_frontend_detach(budget->dvb_frontend);
> -				budget->dvb_frontend = NULL;
>  			}
>  		}
>  		break;

This patch fixes only one of three possible problems.

Could you please extend your patch in a way
that it will also catch, if
- dvb_attach(stv6110x_attach,...)
- dvb_attach(isl6423_attach,...)
fail?

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
