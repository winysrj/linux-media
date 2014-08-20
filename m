Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2729 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336AbaHTW7s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Aug 2014 18:59:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 18/29] mb86a16/mb86a20s: fix sparse warnings
Date: Thu, 21 Aug 2014 00:59:17 +0200
Message-Id: <1408575568-20562-19-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
References: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/dvb-frontends/mb86a16.c:31:14: warning: symbol 'verbose' was not declared. Should it be static?
drivers/media/dvb-frontends/mb86a20s.c:36:4: warning: symbol 'mb86a20s_subchannel' was not declared. Should it be static?
drivers/media/dvb-frontends/mb86a20s.c:1333:24: warning: symbol 'cnr_qpsk_table' was not declared. Should it be static?

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/dvb-frontends/mb86a16.c  |  2 +-
 drivers/media/dvb-frontends/mb86a20s.c | 14 +++++++-------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb-frontends/mb86a16.c b/drivers/media/dvb-frontends/mb86a16.c
index 9ae40ab..1827c0a 100644
--- a/drivers/media/dvb-frontends/mb86a16.c
+++ b/drivers/media/dvb-frontends/mb86a16.c
@@ -28,7 +28,7 @@
 #include "mb86a16.h"
 #include "mb86a16_priv.h"
 
-unsigned int verbose = 5;
+static unsigned int verbose = 5;
 module_param(verbose, int, 0644);
 
 #define ABS(x)		((x) < 0 ? (-x) : (x))
diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index b931179..e6f165a 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -33,7 +33,7 @@ enum mb86a20s_bandwidth {
 	MB86A20S_3SEG = 3,
 };
 
-u8 mb86a20s_subchannel[] = {
+static u8 mb86a20s_subchannel[] = {
 	0xb0, 0xc0, 0xd0, 0xe0,
 	0xf0, 0x00, 0x10, 0x20,
 };
@@ -1228,7 +1228,7 @@ struct linear_segments {
  * All tables below return a dB/1000 measurement
  */
 
-static struct linear_segments cnr_to_db_table[] = {
+static const struct linear_segments cnr_to_db_table[] = {
 	{ 19648,     0},
 	{ 18187,  1000},
 	{ 16534,  2000},
@@ -1262,7 +1262,7 @@ static struct linear_segments cnr_to_db_table[] = {
 	{   788, 30000},
 };
 
-static struct linear_segments cnr_64qam_table[] = {
+static const struct linear_segments cnr_64qam_table[] = {
 	{ 3922688,     0},
 	{ 3920384,  1000},
 	{ 3902720,  2000},
@@ -1296,7 +1296,7 @@ static struct linear_segments cnr_64qam_table[] = {
 	{  388864, 30000},
 };
 
-static struct linear_segments cnr_16qam_table[] = {
+static const struct linear_segments cnr_16qam_table[] = {
 	{ 5314816,     0},
 	{ 5219072,  1000},
 	{ 5118720,  2000},
@@ -1330,7 +1330,7 @@ static struct linear_segments cnr_16qam_table[] = {
 	{   95744, 30000},
 };
 
-struct linear_segments cnr_qpsk_table[] = {
+static const struct linear_segments cnr_qpsk_table[] = {
 	{ 2834176,     0},
 	{ 2683648,  1000},
 	{ 2536960,  2000},
@@ -1364,7 +1364,7 @@ struct linear_segments cnr_qpsk_table[] = {
 	{   11520, 30000},
 };
 
-static u32 interpolate_value(u32 value, struct linear_segments *segments,
+static u32 interpolate_value(u32 value, const struct linear_segments *segments,
 			     unsigned len)
 {
 	u64 tmp64;
@@ -1448,7 +1448,7 @@ static int mb86a20s_get_blk_error_layer_CNR(struct dvb_frontend *fe)
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	u32 mer, cnr;
 	int rc, val, layer;
-	struct linear_segments *segs;
+	const struct linear_segments *segs;
 	unsigned segs_len;
 
 	dev_dbg(&state->i2c->dev, "%s called.\n", __func__);
-- 
2.1.0.rc1

