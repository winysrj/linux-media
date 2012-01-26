Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483Ab2AZQgm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jan 2012 11:36:42 -0500
Message-ID: <4F218114.7080300@redhat.com>
Date: Thu, 26 Jan 2012 14:36:36 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: pdickeybeta@gmail.com
CC: linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [PATCH 0/2] Import PCTV-80e Drivers from Devin Heitmueller's
 Repository
References: <1327131291-5174-1-git-send-email-pdickeybeta@gmail.com>
In-Reply-To: <1327131291-5174-1-git-send-email-pdickeybeta@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 21-01-2012 05:34, pdickeybeta@gmail.com escreveu:
> From: Patrick Dickey <pdickeybeta@gmail.com>
> 
> This series of patches will import the drx39xxj(drx39xyj) drivers from Devin
> Heitmueller's HG Repository for the Pinnacle PCTV-80e USB Tuner.
> 
> Patrick Dickey (2):
>   import-pctv-80e-from-devin-heitmueller-hg-repository
>     Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>    
>     Signed-off-by: Patrick Dickey <pdickeybeta@gmail.com>
>   import-pctv-80e-from-devin-heitmueller-hg-repository
>     Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>    
>     Signed-off-by: Patrick Dickey <pdickeybeta@gmail.com>

Patch 0 never arrived. Is there a place where I could get it?
If the patch is from some Devin's tree, maybe I can just get it there.

> 
>  Documentation/video4linux/CARDLIST.em28xx          |    1 +
>  .../staging/media/dvb/frontends/drx39xyj/Kconfig   |    7 +
>  .../staging/media/dvb/frontends/drx39xyj/Makefile  |    3 +
>  .../media/dvb/frontends/drx39xyj/bsp_host.h        |   80 +
>  .../staging/media/dvb/frontends/drx39xyj/bsp_i2c.h |  217 +
>  .../media/dvb/frontends/drx39xyj/bsp_tuner.h       |  215 +
>  .../media/dvb/frontends/drx39xyj/bsp_types.h       |  229 +
>  .../media/dvb/frontends/drx39xyj/drx39xxj.c        |  457 +
>  .../media/dvb/frontends/drx39xyj/drx39xxj.h        |   40 +
>  .../media/dvb/frontends/drx39xyj/drx39xxj_dummy.c  |  134 +
>  .../media/dvb/frontends/drx39xyj/drx_dap_fasi.c    |  675 +
>  .../media/dvb/frontends/drx39xyj/drx_dap_fasi.h    |  268 +
>  .../media/dvb/frontends/drx39xyj/drx_driver.c      | 1600 ++
>  .../media/dvb/frontends/drx39xyj/drx_driver.h      | 2588 +++
>  .../dvb/frontends/drx39xyj/drx_driver_version.h    |   82 +
>  .../staging/media/dvb/frontends/drx39xyj/drxj.c    |16758 ++++++++++++++++++++
>  .../staging/media/dvb/frontends/drx39xyj/drxj.h    |  730 +
>  .../media/dvb/frontends/drx39xyj/drxj_map.h        |15359 ++++++++++++++++++
>  .../staging/media/dvb/frontends/drx39xyj/drxj_mc.h | 3939 +++++
>  .../media/dvb/frontends/drx39xyj/drxj_mc_vsb.h     |  744 +
>  .../media/dvb/frontends/drx39xyj/drxj_mc_vsbqam.h  | 1437 ++
>  .../media/dvb/frontends/drx39xyj/drxj_options.h    |   65 +
>  22 files changed, 45628 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/staging/media/dvb/frontends/drx39xyj/Kconfig
>  create mode 100644 drivers/staging/media/dvb/frontends/drx39xyj/Makefile
>  create mode 100644 drivers/staging/media/dvb/frontends/drx39xyj/bsp_host.h
>  create mode 100644 drivers/staging/media/dvb/frontends/drx39xyj/bsp_i2c.h
>  create mode 100644 drivers/staging/media/dvb/frontends/drx39xyj/bsp_tuner.h
>  create mode 100644 drivers/staging/media/dvb/frontends/drx39xyj/bsp_types.h
>  create mode 100644 drivers/staging/media/dvb/frontends/drx39xyj/drx39xxj.c
>  create mode 100644 drivers/staging/media/dvb/frontends/drx39xyj/drx39xxj.h
>  create mode 100644 drivers/staging/media/dvb/frontends/drx39xyj/drx39xxj_dummy.c
>  create mode 100644 drivers/staging/media/dvb/frontends/drx39xyj/drx_dap_fasi.c
>  create mode 100644 drivers/staging/media/dvb/frontends/drx39xyj/drx_dap_fasi.h
>  create mode 100644 drivers/staging/media/dvb/frontends/drx39xyj/drx_driver.c
>  create mode 100644 drivers/staging/media/dvb/frontends/drx39xyj/drx_driver.h
>  create mode 100644 drivers/staging/media/dvb/frontends/drx39xyj/drx_driver_version.h
>  create mode 100644 drivers/staging/media/dvb/frontends/drx39xyj/drxj.c
>  create mode 100644 drivers/staging/media/dvb/frontends/drx39xyj/drxj.h
>  create mode 100644 drivers/staging/media/dvb/frontends/drx39xyj/drxj_map.h
>  create mode 100644 drivers/staging/media/dvb/frontends/drx39xyj/drxj_mc.h
>  create mode 100644 drivers/staging/media/dvb/frontends/drx39xyj/drxj_mc_vsb.h
>  create mode 100644 drivers/staging/media/dvb/frontends/drx39xyj/drxj_mc_vsbqam.h
>  create mode 100644 drivers/staging/media/dvb/frontends/drx39xyj/drxj_options.h
> 

