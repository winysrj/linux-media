Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2292 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbaHTW7s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Aug 2014 18:59:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 25/29] stv0367: fix sparse warnings
Date: Thu, 21 Aug 2014 00:59:24 +0200
Message-Id: <1408575568-20562-26-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
References: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/dvb-frontends/stv0367.c:557:5: warning: symbol 'stv0367cab_RF_LookUp1' was not declared. Should it be static?
drivers/media/dvb-frontends/stv0367.c:569:5: warning: symbol 'stv0367cab_RF_LookUp2' was not declared. Should it be static?

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/dvb-frontends/stv0367.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0367.c b/drivers/media/dvb-frontends/stv0367.c
index 59b6e66..7645772 100644
--- a/drivers/media/dvb-frontends/stv0367.c
+++ b/drivers/media/dvb-frontends/stv0367.c
@@ -554,7 +554,7 @@ static struct st_register def0367ter[STV0367TER_NBREGS] = {
 #define RF_LOOKUP_TABLE_SIZE  31
 #define RF_LOOKUP_TABLE2_SIZE 16
 /* RF Level (for RF AGC->AGC1) Lookup Table, depends on the board and tuner.*/
-s32 stv0367cab_RF_LookUp1[RF_LOOKUP_TABLE_SIZE][RF_LOOKUP_TABLE_SIZE] = {
+static const s32 stv0367cab_RF_LookUp1[RF_LOOKUP_TABLE_SIZE][RF_LOOKUP_TABLE_SIZE] = {
 	{/*AGC1*/
 		48, 50, 51, 53, 54, 56, 57, 58, 60, 61, 62, 63,
 		64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75,
@@ -566,7 +566,7 @@ s32 stv0367cab_RF_LookUp1[RF_LOOKUP_TABLE_SIZE][RF_LOOKUP_TABLE_SIZE] = {
 	}
 };
 /* RF Level (for IF AGC->AGC2) Lookup Table, depends on the board and tuner.*/
-s32 stv0367cab_RF_LookUp2[RF_LOOKUP_TABLE2_SIZE][RF_LOOKUP_TABLE2_SIZE] = {
+static const s32 stv0367cab_RF_LookUp2[RF_LOOKUP_TABLE2_SIZE][RF_LOOKUP_TABLE2_SIZE] = {
 	{/*AGC2*/
 		28, 29, 31, 32, 34, 35, 36, 37,
 		38, 39, 40, 41, 42, 43, 44, 45,
-- 
2.1.0.rc1

