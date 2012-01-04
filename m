Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:43474 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751467Ab2ADSqf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jan 2012 13:46:35 -0500
From: Oliver Endriss <o.endriss@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] drxk: Fix regression introduced by commit '[media] Remove Annex A/C selection via roll-off factor'
Date: Wed, 4 Jan 2012 19:45:58 +0100
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201201041945.58852@orion.escape-edv.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix regression introduced by commit '[media] Remove Annex A/C selection via roll-off factor'
As a result of this commit, DVB-T tuning did not work anymore.

Signed-off-by: Oliver Endriss <o.endriss@gmx.de>

diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index 36e1c82..13f22a1 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -6235,6 +6235,8 @@ static int drxk_set_parameters(struct dvb_frontend *fe)
 	case SYS_DVBC_ANNEX_C:
 		state->m_itut_annex_c = true;
 		break;
+	case SYS_DVBT:
+		break;
 	default:
 		return -EINVAL;
 	}

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
