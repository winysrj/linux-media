Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:63263 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbZKVVwf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Nov 2009 16:52:35 -0500
Message-ID: <4B09B2A5.6070302@freemail.hu>
Date: Sun, 22 Nov 2009 22:52:37 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Olivier Grenie <Olivier.Grenie@dibcom.fr>,
	Patrick Boettcher <pboettcher@dibcom.fr>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] dib8000: merge two conditionals
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Merge two ifs: the condition is the same. The second if
uses the ncoeff which is initialized in the first if.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -r bc16afd1e7a4 linux/drivers/media/dvb/frontends/dib8000.c
--- a/linux/drivers/media/dvb/frontends/dib8000.c	Sat Nov 21 12:01:36 2009 +0100
+++ b/linux/drivers/media/dvb/frontends/dib8000.c	Sun Nov 22 22:40:31 2009 +0100
@@ -1402,10 +1402,9 @@
 			}
 			break;
 		}
-	}
-	if (state->fe.dtv_property_cache.isdbt_sb_mode == 1)
 		for (i = 0; i < 8; i++)
 			dib8000_write_word(state, 343 + i, ncoeff[i]);
+	}

 	// P_small_coef_ext_enable=ISDB-Tsb, P_small_narrow_band=ISDB-Tsb, P_small_last_seg=13, P_small_offset_num_car=5
 	dib8000_write_word(state, 351,
