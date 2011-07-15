Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27668 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765Ab1GOESf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2011 00:18:35 -0400
Message-ID: <4E1FBF93.6040702@redhat.com>
Date: Fri, 15 Jul 2011 01:18:27 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Oliver Endriss <o.endriss@gmx.de>,
	Ralph Metzler <rjkm@metzlerbros.de>
Subject: Re: [PATCH 0/5] Driver support for cards based on Digital Devices
 bridge (ddbridge)
References: <201107032321.46092@orion.escape-edv.de> <201107040124.04924@orion.escape-edv.de> <4E1106B0.7030102@redhat.com> <201107150145.29547@orion.escape-edv.de>
In-Reply-To: <201107150145.29547@orion.escape-edv.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 14-07-2011 20:45, Oliver Endriss escreveu:
> - DVB-T tuning does not work anymore.

The enclosed patch should fix the issue. It were due to a wrong goto error
replacements that happened at the changeset that were fixing the error
propagation logic. Sorry for that.

Please test.

Cheers,
Mauro.

[media] drxk: Fix a bug at some switches that broke DVB-T
    
The error propagation changeset c23bf4402 broke the DVB-T
code, as it wrongly replaced some break with goto error.
Fix the broken logic.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index a0e2ff5..217796d 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -3451,13 +3451,13 @@ static int DVBTCtrlSetEchoThreshold(struct drxk_state *state,
 		data |= ((echoThres->threshold <<
 			OFDM_SC_RA_RAM_ECHO_THRES_2K__B)
 			& (OFDM_SC_RA_RAM_ECHO_THRES_2K__M));
-		goto error;
+		break;
 	case DRX_FFTMODE_8K:
 		data &= ~OFDM_SC_RA_RAM_ECHO_THRES_8K__M;
 		data |= ((echoThres->threshold <<
 			OFDM_SC_RA_RAM_ECHO_THRES_8K__B)
 			& (OFDM_SC_RA_RAM_ECHO_THRES_8K__M));
-		goto error;
+		break;
 	default:
 		return -EINVAL;
 		goto error;
@@ -3825,10 +3825,10 @@ static int SetDVBT(struct drxk_state *state, u16 IntermediateFreqkHz,
 		/* fall through , try first guess DRX_FFTMODE_8K */
 	case TRANSMISSION_MODE_8K:
 		transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_MODE_8K;
-		goto error;
+		break;
 	case TRANSMISSION_MODE_2K:
 		transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_MODE_2K;
-		goto error;
+		break;
 	}
 
 	/* guard */
@@ -3839,16 +3839,16 @@ static int SetDVBT(struct drxk_state *state, u16 IntermediateFreqkHz,
 		/* fall through , try first guess DRX_GUARD_1DIV4 */
 	case GUARD_INTERVAL_1_4:
 		transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_GUARD_4;
-		goto error;
+		break;
 	case GUARD_INTERVAL_1_32:
 		transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_GUARD_32;
-		goto error;
+		break;
 	case GUARD_INTERVAL_1_16:
 		transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_GUARD_16;
-		goto error;
+		break;
 	case GUARD_INTERVAL_1_8:
 		transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_GUARD_8;
-		goto error;
+		break;
 	}
 
 	/* hierarchy */


