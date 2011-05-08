Return-path: <mchehab@gaivota>
Received: from ffm.saftware.de ([83.141.3.46]:51431 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617Ab1EHWK4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 May 2011 18:10:56 -0400
Message-ID: <4DC714EC.2060606@linuxtv.org>
Date: Mon, 09 May 2011 00:10:52 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Steve Kerrison <steve@stevekerrison.com>
CC: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v2 2/5] drxd: Fix warning caused by new entries in an
 enum
References: <4DC6BF28.8070006@redhat.com> <1304882240-23044-3-git-send-email-steve@stevekerrison.com>
In-Reply-To: <1304882240-23044-3-git-send-email-steve@stevekerrison.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On 05/08/2011 09:17 PM, Steve Kerrison wrote:
> Additional bandwidth modes have been added in frontend.h
> drxd_hard.c had no default case so the compiler was warning about
> a non-exhausive switch statement.
> 
> This has been fixed by making the default behaviour the same as
> BANDWIDTH_AUTO, with the addition of a printk to notify if this
> ever happens.
> 
> Signed-off-by: Steve Kerrison <steve@stevekerrison.com>
> ---
>  drivers/media/dvb/frontends/drxd_hard.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/dvb/frontends/drxd_hard.c b/drivers/media/dvb/frontends/drxd_hard.c
> index 30a78af..b3b0704 100644
> --- a/drivers/media/dvb/frontends/drxd_hard.c
> +++ b/drivers/media/dvb/frontends/drxd_hard.c
> @@ -2325,6 +2325,10 @@ static int DRX_Start(struct drxd_state *state, s32 off)
>  		   InitEC and ResetEC
>  		   functions */
>  		switch (p->bandwidth) {
> +		default:
> +			printk(KERN_INFO "drxd: Unsupported bandwidth mode %u, reverting to default\n",
> +				p->bandwidth);
> +			/* Fall back to auto */

I'd prefer returning -EINVAL for unsupported parameters.

>  		case BANDWIDTH_AUTO:
>  		case BANDWIDTH_8_MHZ:
>  			/* (64/7)*(8/8)*1000000 */

I already had a patch for this, but forgot to submit it together with the frontend.h bits.

>From 73d630b57f584d7e35cac5e27149cbc564aedde2 Mon Sep 17 00:00:00 2001
From: Andreas Oberritter <obi@linuxtv.org>
Date: Fri, 8 Apr 2011 16:39:20 +0000
Subject: [PATCH 2/2] DVB: drxd_hard: handle new bandwidths by returning -EINVAL

Signed-off-by: Andreas Oberritter <obi@linuxtv.org>
---
 drivers/media/dvb/frontends/drxd_hard.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/frontends/drxd_hard.c b/drivers/media/dvb/frontends/drxd_hard.c
index 30a78af..53319f4 100644
--- a/drivers/media/dvb/frontends/drxd_hard.c
+++ b/drivers/media/dvb/frontends/drxd_hard.c
@@ -2348,6 +2348,9 @@ static int DRX_Start(struct drxd_state *state, s32 off)
 			status = Write16(state,
 					 FE_AG_REG_IND_DEL__A, 71, 0x0000);
 			break;
+		default:
+			status = -EINVAL;
+			break;
 		}
 		status = status;
 		if (status < 0)
-- 
1.7.2.5

Btw., "status = status;" looks odd.
