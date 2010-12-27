Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:26369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753599Ab0L0QZa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Dec 2010 11:25:30 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oBRGPT3Z027503
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 27 Dec 2010 11:25:30 -0500
Received: from gaivota (vpn-11-243.rdu.redhat.com [10.11.11.243])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id oBRGNDpE028091
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 27 Dec 2010 11:25:25 -0500
Date: Mon, 27 Dec 2010 14:22:44 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 6/8] [media] stv090x: Fix some compilation warnings
Message-ID: <20101227142244.74827c59@gaivota>
In-Reply-To: <cover.1293466891.git.mchehab@redhat.com>
References: <cover.1293466891.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

A few typos at the driver are causing the following warnings:

drivers/media/dvb/frontends/stv090x.c: In function ‘stv090x_start_search’:
drivers/media/dvb/frontends/stv090x.c:1486:27: warning: comparison between ‘enum stv090x_search’ and ‘enum stv090x_delsys’
drivers/media/dvb/frontends/stv090x.c:1487:24: warning: comparison between ‘enum stv090x_search’ and ‘enum stv090x_delsys’
drivers/media/dvb/frontends/stv090x.c: In function ‘stv090x_optimize_track’:
drivers/media/dvb/frontends/stv090x.c:2943:2: warning: case value ‘4’ not in enumerated type ‘enum stv090x_delsys’

The first two are due to the lack of using the delsys types
	STV090x_DVBS1/STV090x_DSS
instead of
	STV090x_SEARCH_DVBS1/STV090x_SEARCH_DSS

The second one is due to the usage of STV090x_UNKNOWN (enum stv090x_modulation)
instead of STV090x_ERROR (enum stv090x_delsys).

Cc: Manu Abraham <abraham.manu@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/frontends/stv090x.c b/drivers/media/dvb/frontends/stv090x.c
index 425e7a4..4e0fc2c 100644
--- a/drivers/media/dvb/frontends/stv090x.c
+++ b/drivers/media/dvb/frontends/stv090x.c
@@ -1483,8 +1483,8 @@ static int stv090x_start_search(struct stv090x_state *state)
 		if (STV090x_WRITE_DEMOD(state, FFECFG, 0x41) < 0)
 			goto err;
 
-		if ((state->search_mode == STV090x_DVBS1)	||
-			(state->search_mode == STV090x_DSS)	||
+		if ((state->search_mode == STV090x_SEARCH_DVBS1)	||
+			(state->search_mode == STV090x_SEARCH_DSS)	||
 			(state->search_mode == STV090x_SEARCH_AUTO)) {
 
 			if (STV090x_WRITE_DEMOD(state, VITSCALE, 0x82) < 0)
@@ -2940,7 +2940,7 @@ static int stv090x_optimize_track(struct stv090x_state *state)
 		STV090x_WRITE_DEMOD(state, ERRCTRL1, 0x67); /* PER */
 		break;
 
-	case STV090x_UNKNOWN:
+	case STV090x_ERROR:
 	default:
 		reg = STV090x_READ_DEMOD(state, DMDCFGMD);
 		STV090x_SETFIELD_Px(reg, DVBS1_ENABLE_FIELD, 1);
-- 
1.7.3.4


