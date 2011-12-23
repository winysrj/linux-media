Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:42861 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757155Ab1LWN37 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Dec 2011 08:29:59 -0500
Message-ID: <4EF48250.5090305@linuxtv.org>
Date: Fri, 23 Dec 2011 14:29:52 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media <linux-media@vger.kernel.org>,
	Patrick Boettcher <pboettcher@kernellabs.com>
Subject: [RFC] remove dtv_property_dump et al
References: <4EF3A171.3030906@iki.fi>
In-Reply-To: <4EF3A171.3030906@iki.fi>
Content-Type: multipart/mixed;
 boundary="------------010106030101010405060703"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010106030101010405060703
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 22.12.2011 22:30, Antti Palosaari wrote:
> Rename DMB-TH to DTMB.
> 
> Add few new values for existing parameters.
> 
> Add two new parameters, interleaving and carrier.
> DTMB supports interleavers: 240 and 720.
> DTMB supports carriers: 1 and 3780.
> 
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  drivers/media/dvb/dvb-core/dvb_frontend.c |   19 ++++++++++++++++++-
>  drivers/media/dvb/dvb-core/dvb_frontend.h |    3 +++
>  include/linux/dvb/frontend.h              |   13 +++++++++++--
>  include/linux/dvb/version.h               |    2 +-
>  4 files changed, 33 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c
> b/drivers/media/dvb/dvb-core/dvb_frontend.c
> index 821b225..ec2cbae 100644
> --- a/drivers/media/dvb/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
> @@ -924,6 +924,8 @@ static struct dtv_cmds_h dtv_cmds[DTV_MAX_COMMAND +
> 1] = {
>      _DTV_CMD(DTV_CODE_RATE_LP, 1, 0),
>      _DTV_CMD(DTV_GUARD_INTERVAL, 1, 0),
>      _DTV_CMD(DTV_TRANSMISSION_MODE, 1, 0),
> +    _DTV_CMD(DTV_CARRIER, 1, 0),
> +    _DTV_CMD(DTV_INTERLEAVING, 1, 0),
> 
>      _DTV_CMD(DTV_ISDBT_PARTIAL_RECEPTION, 1, 0),
>      _DTV_CMD(DTV_ISDBT_SOUND_BROADCASTING, 1, 0),
> @@ -974,6 +976,8 @@ static struct dtv_cmds_h dtv_cmds[DTV_MAX_COMMAND +
> 1] = {
>      _DTV_CMD(DTV_GUARD_INTERVAL, 0, 0),
>      _DTV_CMD(DTV_TRANSMISSION_MODE, 0, 0),
>      _DTV_CMD(DTV_HIERARCHY, 0, 0),
> +    _DTV_CMD(DTV_CARRIER, 0, 0),
> +    _DTV_CMD(DTV_INTERLEAVING, 0, 0),
> 
>      _DTV_CMD(DTV_ENUM_DELSYS, 0, 0),
>  };

Adding this twice is wrong.

Almost every time new commands were added in the recent past, either the
command was not added to this table at all or the command was added more
than once. How about removing this array instead? It's only purpose is
to output ioctl parameters, which can be done with strace as well.

Actually, I have two patches queued doing that (see attachments). They
are based on 3.0.

Regards,
Andreas

--------------010106030101010405060703
Content-Type: text/x-patch;
 name="0001-RFC-DVB-remove-dtv_property_dump.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-RFC-DVB-remove-dtv_property_dump.patch"

>From 0f9294ce272a853bb0f4513bbd07048938c78db2 Mon Sep 17 00:00:00 2001
From: Andreas Oberritter <obi@linuxtv.org>
Date: Tue, 13 Sep 2011 11:48:14 +0000
Subject: [PATCH 1/2] [RFC] DVB: remove dtv_property_dump()

- dtv_property_dump is the only user of struct dtv_cmds_h,
  which mistakenly got exported to userspace.

- It is used to print ioctl parameters, if debugging is enabled.
  The array used to print parameters contains both unused ("set")
  and invalid entries, i.e. DTV_CODE_RATE_HP and others are
  defined twice.

- When a new DTV command gets added, it's a common mistake to
  forget to add it to this array.

- It's possible to use strace instead or to write a simple
  LD_PRELOADable library.

Signed-off-by: Andreas Oberritter <obi@linuxtv.org>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |  116 -----------------------------
 include/linux/dvb/frontend.h              |   11 ---
 2 files changed, 0 insertions(+), 127 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 521b695..8274a6d 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -895,119 +895,6 @@ static int dvb_frontend_clear_cache(struct dvb_frontend *fe)
 	return 0;
 }
 
-#define _DTV_CMD(n, s, b) \
-[n] = { \
-	.name = #n, \
-	.cmd  = n, \
-	.set  = s,\
-	.buffer = b \
-}
-
-static struct dtv_cmds_h dtv_cmds[DTV_MAX_COMMAND + 1] = {
-	_DTV_CMD(DTV_TUNE, 1, 0),
-	_DTV_CMD(DTV_CLEAR, 1, 0),
-
-	/* Set */
-	_DTV_CMD(DTV_FREQUENCY, 1, 0),
-	_DTV_CMD(DTV_BANDWIDTH_HZ, 1, 0),
-	_DTV_CMD(DTV_MODULATION, 1, 0),
-	_DTV_CMD(DTV_INVERSION, 1, 0),
-	_DTV_CMD(DTV_DISEQC_MASTER, 1, 1),
-	_DTV_CMD(DTV_SYMBOL_RATE, 1, 0),
-	_DTV_CMD(DTV_INNER_FEC, 1, 0),
-	_DTV_CMD(DTV_VOLTAGE, 1, 0),
-	_DTV_CMD(DTV_TONE, 1, 0),
-	_DTV_CMD(DTV_PILOT, 1, 0),
-	_DTV_CMD(DTV_ROLLOFF, 1, 0),
-	_DTV_CMD(DTV_DELIVERY_SYSTEM, 1, 0),
-	_DTV_CMD(DTV_HIERARCHY, 1, 0),
-	_DTV_CMD(DTV_CODE_RATE_HP, 1, 0),
-	_DTV_CMD(DTV_CODE_RATE_LP, 1, 0),
-	_DTV_CMD(DTV_GUARD_INTERVAL, 1, 0),
-	_DTV_CMD(DTV_TRANSMISSION_MODE, 1, 0),
-
-	_DTV_CMD(DTV_ISDBT_PARTIAL_RECEPTION, 1, 0),
-	_DTV_CMD(DTV_ISDBT_SOUND_BROADCASTING, 1, 0),
-	_DTV_CMD(DTV_ISDBT_SB_SUBCHANNEL_ID, 1, 0),
-	_DTV_CMD(DTV_ISDBT_SB_SEGMENT_IDX, 1, 0),
-	_DTV_CMD(DTV_ISDBT_SB_SEGMENT_COUNT, 1, 0),
-	_DTV_CMD(DTV_ISDBT_LAYER_ENABLED, 1, 0),
-	_DTV_CMD(DTV_ISDBT_LAYERA_FEC, 1, 0),
-	_DTV_CMD(DTV_ISDBT_LAYERA_MODULATION, 1, 0),
-	_DTV_CMD(DTV_ISDBT_LAYERA_SEGMENT_COUNT, 1, 0),
-	_DTV_CMD(DTV_ISDBT_LAYERA_TIME_INTERLEAVING, 1, 0),
-	_DTV_CMD(DTV_ISDBT_LAYERB_FEC, 1, 0),
-	_DTV_CMD(DTV_ISDBT_LAYERB_MODULATION, 1, 0),
-	_DTV_CMD(DTV_ISDBT_LAYERB_SEGMENT_COUNT, 1, 0),
-	_DTV_CMD(DTV_ISDBT_LAYERB_TIME_INTERLEAVING, 1, 0),
-	_DTV_CMD(DTV_ISDBT_LAYERC_FEC, 1, 0),
-	_DTV_CMD(DTV_ISDBT_LAYERC_MODULATION, 1, 0),
-	_DTV_CMD(DTV_ISDBT_LAYERC_SEGMENT_COUNT, 1, 0),
-	_DTV_CMD(DTV_ISDBT_LAYERC_TIME_INTERLEAVING, 1, 0),
-
-	_DTV_CMD(DTV_ISDBT_PARTIAL_RECEPTION, 0, 0),
-	_DTV_CMD(DTV_ISDBT_SOUND_BROADCASTING, 0, 0),
-	_DTV_CMD(DTV_ISDBT_SB_SUBCHANNEL_ID, 0, 0),
-	_DTV_CMD(DTV_ISDBT_SB_SEGMENT_IDX, 0, 0),
-	_DTV_CMD(DTV_ISDBT_SB_SEGMENT_COUNT, 0, 0),
-	_DTV_CMD(DTV_ISDBT_LAYER_ENABLED, 0, 0),
-	_DTV_CMD(DTV_ISDBT_LAYERA_FEC, 0, 0),
-	_DTV_CMD(DTV_ISDBT_LAYERA_MODULATION, 0, 0),
-	_DTV_CMD(DTV_ISDBT_LAYERA_SEGMENT_COUNT, 0, 0),
-	_DTV_CMD(DTV_ISDBT_LAYERA_TIME_INTERLEAVING, 0, 0),
-	_DTV_CMD(DTV_ISDBT_LAYERB_FEC, 0, 0),
-	_DTV_CMD(DTV_ISDBT_LAYERB_MODULATION, 0, 0),
-	_DTV_CMD(DTV_ISDBT_LAYERB_SEGMENT_COUNT, 0, 0),
-	_DTV_CMD(DTV_ISDBT_LAYERB_TIME_INTERLEAVING, 0, 0),
-	_DTV_CMD(DTV_ISDBT_LAYERC_FEC, 0, 0),
-	_DTV_CMD(DTV_ISDBT_LAYERC_MODULATION, 0, 0),
-	_DTV_CMD(DTV_ISDBT_LAYERC_SEGMENT_COUNT, 0, 0),
-	_DTV_CMD(DTV_ISDBT_LAYERC_TIME_INTERLEAVING, 0, 0),
-
-	_DTV_CMD(DTV_ISDBS_TS_ID, 1, 0),
-	_DTV_CMD(DTV_DVBT2_PLP_ID, 1, 0),
-
-	/* Get */
-	_DTV_CMD(DTV_DISEQC_SLAVE_REPLY, 0, 1),
-	_DTV_CMD(DTV_API_VERSION, 0, 0),
-	_DTV_CMD(DTV_CODE_RATE_HP, 0, 0),
-	_DTV_CMD(DTV_CODE_RATE_LP, 0, 0),
-	_DTV_CMD(DTV_GUARD_INTERVAL, 0, 0),
-	_DTV_CMD(DTV_TRANSMISSION_MODE, 0, 0),
-	_DTV_CMD(DTV_HIERARCHY, 0, 0),
-};
-
-static void dtv_property_dump(struct dtv_property *tvp)
-{
-	int i;
-
-	if (tvp->cmd <= 0 || tvp->cmd > DTV_MAX_COMMAND) {
-		printk(KERN_WARNING "%s: tvp.cmd = 0x%08x undefined\n",
-			__func__, tvp->cmd);
-		return;
-	}
-
-	dprintk("%s() tvp.cmd    = 0x%08x (%s)\n"
-		,__func__
-		,tvp->cmd
-		,dtv_cmds[ tvp->cmd ].name);
-
-	if(dtv_cmds[ tvp->cmd ].buffer) {
-
-		dprintk("%s() tvp.u.buffer.len = 0x%02x\n"
-			,__func__
-			,tvp->u.buffer.len);
-
-		for(i = 0; i < tvp->u.buffer.len; i++)
-			dprintk("%s() tvp.u.buffer.data[0x%02x] = 0x%02x\n"
-				,__func__
-				,i
-				,tvp->u.buffer.data[i]);
-
-	} else
-		dprintk("%s() tvp.u.data = 0x%08x\n", __func__, tvp->u.data);
-}
-
 static int is_legacy_delivery_system(fe_delivery_system_t s)
 {
 	if((s == SYS_UNDEFINED) || (s == SYS_DVBC_ANNEX_AC) ||
@@ -1353,8 +1240,6 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
 			return r;
 	}
 
-	dtv_property_dump(tvp);
-
 	return 0;
 }
 
@@ -1365,7 +1250,6 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 	int r = 0;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
-	dtv_property_dump(tvp);
 
 	/* Allow the frontend to validate incoming properties */
 	if (fe->ops.set_property) {
diff --git a/include/linux/dvb/frontend.h b/include/linux/dvb/frontend.h
index 1b1094c..81f813d 100644
--- a/include/linux/dvb/frontend.h
+++ b/include/linux/dvb/frontend.h
@@ -352,17 +352,6 @@ typedef enum fe_delivery_system {
 	SYS_TURBO,
 } fe_delivery_system_t;
 
-struct dtv_cmds_h {
-	char	*name;		/* A display name for debugging purposes */
-
-	__u32	cmd;		/* A unique ID */
-
-	/* Flags */
-	__u32	set:1;		/* Either a set or get property */
-	__u32	buffer:1;	/* Does this property use the buffer? */
-	__u32	reserved:30;	/* Align */
-};
-
 struct dtv_property {
 	__u32 cmd;
 	__u32 reserved[3];
-- 
1.7.2.5


--------------010106030101010405060703
Content-Type: text/x-patch;
 name="0002-RFC-DVB-remove-unused-DTV_MAX_COMMAND-from-frontend..patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-RFC-DVB-remove-unused-DTV_MAX_COMMAND-from-frontend..pa";
 filename*1="tch"

>From bd707ac783dae5ea958f8480fce84bb89c28535f Mon Sep 17 00:00:00 2001
From: Andreas Oberritter <obi@linuxtv.org>
Date: Tue, 13 Sep 2011 14:13:24 +0000
Subject: [PATCH 2/2] [RFC] DVB: remove unused DTV_MAX_COMMAND from frontend.h

- This value was exported to userspace but serves no purpose.

Signed-off-by: Andreas Oberritter <obi@linuxtv.org>
---
 include/linux/dvb/frontend.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/linux/dvb/frontend.h b/include/linux/dvb/frontend.h
index 81f813d..37a4d38 100644
--- a/include/linux/dvb/frontend.h
+++ b/include/linux/dvb/frontend.h
@@ -316,8 +316,6 @@ struct dvb_frontend_event {
 
 #define DTV_DVBT2_PLP_ID	43
 
-#define DTV_MAX_COMMAND				DTV_DVBT2_PLP_ID
-
 typedef enum fe_pilot {
 	PILOT_ON,
 	PILOT_OFF,
-- 
1.7.2.5


--------------010106030101010405060703--
