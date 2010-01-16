Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:57275 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab0APQfn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jan 2010 11:35:43 -0500
Message-ID: <4B51EAD8.70805@freemail.hu>
Date: Sat, 16 Jan 2010 17:35:36 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: "Igor M. Liplianin" <liplianin@netup.ru>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] stv0900: make local functions static
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

The functions stv0900_sw_algo() and stv0900_set_dvbs1_track_car_loop() are only used
locally so mark them static.

This will remove the following sparse warnings (see "make C=1"):
 * symbol 'stv0900_sw_algo' was not declared. Should it be static?
 * symbol 'stv0900_set_dvbs1_track_car_loop' was not declared. Should it be static?

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -r 5bcdcc072b6d linux/drivers/media/dvb/frontends/stv0900_sw.c
--- a/linux/drivers/media/dvb/frontends/stv0900_sw.c	Sat Jan 16 07:25:43 2010 +0100
+++ b/linux/drivers/media/dvb/frontends/stv0900_sw.c	Sat Jan 16 17:34:44 2010 +0100
@@ -193,7 +193,7 @@
 	return lock;
 }

-int stv0900_sw_algo(struct stv0900_internal *intp,
+static int stv0900_sw_algo(struct stv0900_internal *intp,
 				enum fe_stv0900_demod_num demod)
 {
 	int	lock = FALSE,
@@ -795,7 +795,7 @@
 	return prate;
 }

-void stv0900_set_dvbs1_track_car_loop(struct stv0900_internal *intp,
+static void stv0900_set_dvbs1_track_car_loop(struct stv0900_internal *intp,
 					enum fe_stv0900_demod_num demod,
 					u32 srate)
 {

