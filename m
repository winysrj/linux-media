Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.zhaw.ch ([160.85.104.51]:60616 "EHLO mx2.zhaw.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755146AbZLWNAR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Dec 2009 08:00:17 -0500
From: Tobias Klauser <tklauser@distanz.ch>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, Tobias Klauser <tklauser@distanz.ch>
Subject: [PATCH 1/3] [V4L/DVB] rj54n1cb0: Storage class should be before const qualifier
Date: Wed, 23 Dec 2009 13:53:12 +0100
Message-Id: <1261572794-8369-1-git-send-email-tklauser@distanz.ch>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The C99 specification states in section 6.11.5:

The placement of a storage-class specifier other than at the beginning
of the declaration specifiers in a declaration is an obsolescent
feature.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 drivers/media/video/rj54n1cb0c.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/rj54n1cb0c.c b/drivers/media/video/rj54n1cb0c.c
index 7e42989..900c60a 100644
--- a/drivers/media/video/rj54n1cb0c.c
+++ b/drivers/media/video/rj54n1cb0c.c
@@ -165,7 +165,7 @@ struct rj54n1_reg_val {
 	u8 val;
 };
 
-const static struct rj54n1_reg_val bank_4[] = {
+static const struct rj54n1_reg_val bank_4[] = {
 	{0x417, 0},
 	{0x42c, 0},
 	{0x42d, 0xf0},
@@ -186,7 +186,7 @@ const static struct rj54n1_reg_val bank_4[] = {
 	{0x4fe, 2},
 };
 
-const static struct rj54n1_reg_val bank_5[] = {
+static const struct rj54n1_reg_val bank_5[] = {
 	{0x514, 0},
 	{0x516, 0},
 	{0x518, 0},
@@ -207,7 +207,7 @@ const static struct rj54n1_reg_val bank_5[] = {
 	{0x5fe, 2},
 };
 
-const static struct rj54n1_reg_val bank_7[] = {
+static const struct rj54n1_reg_val bank_7[] = {
 	{0x70a, 0},
 	{0x714, 0xff},
 	{0x715, 0xff},
@@ -215,7 +215,7 @@ const static struct rj54n1_reg_val bank_7[] = {
 	{0x7FE, 2},
 };
 
-const static struct rj54n1_reg_val bank_8[] = {
+static const struct rj54n1_reg_val bank_8[] = {
 	{0x800, 0x00},
 	{0x801, 0x01},
 	{0x802, 0x61},
@@ -403,12 +403,12 @@ const static struct rj54n1_reg_val bank_8[] = {
 	{0x8FE, 2},
 };
 
-const static struct rj54n1_reg_val bank_10[] = {
+static const struct rj54n1_reg_val bank_10[] = {
 	{0x10bf, 0x69}
 };
 
 /* Clock dividers - these are default register values, divider = register + 1 */
-const static struct rj54n1_clock_div clk_div = {
+static const struct rj54n1_clock_div clk_div = {
 	.ratio_tg	= 3 /* default: 5 */,
 	.ratio_t	= 4 /* default: 1 */,
 	.ratio_r	= 4 /* default: 0 */,
-- 
1.6.3.3

