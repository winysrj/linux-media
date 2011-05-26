Return-path: <mchehab@pedra>
Received: from ffm.saftware.de ([83.141.3.46]:58465 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756760Ab1EZLRE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 May 2011 07:17:04 -0400
Message-ID: <4DDE36AB.2070202@linuxtv.org>
Date: Thu, 26 May 2011 13:16:59 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Steven Toth <stoth@kernellabs.com>,
	Lucas De Marchi <lucas.demarchi@profusion.mobi>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] DVB: dvb_frontend: off by one in dtv_property_dump()
References: <20110526084452.GB14591@shale.localdomain>
In-Reply-To: <20110526084452.GB14591@shale.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Dan,

On 05/26/2011 10:44 AM, Dan Carpenter wrote:
> If the tvp->cmd == DTV_MAX_COMMAND then we read past the end of the
> array.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
> index 9827804..607e293 100644
> --- a/drivers/media/dvb/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
> @@ -981,7 +981,7 @@ static void dtv_property_dump(struct dtv_property *tvp)
>  {
>  	int i;
>  
> -	if (tvp->cmd <= 0 || tvp->cmd > DTV_MAX_COMMAND) {
> +	if (tvp->cmd <= 0 || tvp->cmd >= DTV_MAX_COMMAND) {
>  		printk(KERN_WARNING "%s: tvp.cmd = 0x%08x undefined\n",
>  			__func__, tvp->cmd);
>  		return;

thanks for spotting this, but this fixes the wrong end. This does not need to
be applied to kernels older than 2.6.40.

>From 6d8588a4546fd4df717ca61450f99fb9c1b13a5f Mon Sep 17 00:00:00 2001
From: Andreas Oberritter <obi@linuxtv.org>
Date: Thu, 26 May 2011 10:54:14 +0000
Subject: [PATCH] DVB: dvb_frontend: fix dtv_property_dump for DTV_DVBT2_PLP_ID

- Add missing entry to array "dtv_cmds".
- Set array size to DTV_MAX_COMMAND + 1 to avoid future off-by-ones.

Signed-off-by: Andreas Oberritter <obi@linuxtv.org>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 9827804..bed7bfe 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -904,7 +904,7 @@ static int dvb_frontend_clear_cache(struct dvb_frontend *fe)
 	.buffer = b \
 }
 
-static struct dtv_cmds_h dtv_cmds[] = {
+static struct dtv_cmds_h dtv_cmds[DTV_MAX_COMMAND + 1] = {
 	_DTV_CMD(DTV_TUNE, 1, 0),
 	_DTV_CMD(DTV_CLEAR, 1, 0),
 
@@ -966,6 +966,7 @@ static struct dtv_cmds_h dtv_cmds[] = {
 	_DTV_CMD(DTV_ISDBT_LAYERC_TIME_INTERLEAVING, 0, 0),
 
 	_DTV_CMD(DTV_ISDBS_TS_ID, 1, 0),
+	_DTV_CMD(DTV_DVBT2_PLP_ID, 1, 0),
 
 	/* Get */
 	_DTV_CMD(DTV_DISEQC_SLAVE_REPLY, 0, 1),
-- 
1.7.2.5

