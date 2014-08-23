Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:36619 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbaHWQnH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Aug 2014 12:43:07 -0400
Received: by mail-we0-f177.google.com with SMTP id w62so11750471wes.36
        for <linux-media@vger.kernel.org>; Sat, 23 Aug 2014 09:43:06 -0700 (PDT)
From: Gregor Jasny <gjasny@googlemail.com>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, Gregor Jasny <gjasny@googlemail.com>
Subject: [PATCH 3/5] libdvbv5: Hide unused and unexposed cnr_to_qual_s tables
Date: Sat, 23 Aug 2014 18:42:41 +0200
Message-Id: <1408812163-18309-4-git-send-email-gjasny@googlemail.com>
In-Reply-To: <1408812163-18309-1-git-send-email-gjasny@googlemail.com>
References: <1408812163-18309-1-git-send-email-gjasny@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Gregor Jasny <gjasny@googlemail.com>
---
 lib/libdvbv5/dvb-fe.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/libdvbv5/dvb-fe.c b/lib/libdvbv5/dvb-fe.c
index 013edd6..6471f68 100644
--- a/lib/libdvbv5/dvb-fe.c
+++ b/lib/libdvbv5/dvb-fe.c
@@ -944,7 +944,7 @@ struct cnr_to_qual_s dvb_s2_cnr_2_qual[] = {
  * Minimum values from ARIB STD-B21 for DVB_QUAL_OK.
  * As ARIB doesn't define a max value, assume +2dB for DVB_QUAL_GOOD
  */
-struct cnr_to_qual_s isdb_t_cnr_2_qual[] = {
+static struct cnr_to_qual_s isdb_t_cnr_2_qual[] = {
 	{  DQPSK, FEC_1_2,  6.2,  8.2},
 	{  DQPSK, FEC_2_3,  7.7,  9.7},
 	{  DQPSK, FEC_3_4,  8.7, 10.7},
@@ -974,7 +974,7 @@ struct cnr_to_qual_s isdb_t_cnr_2_qual[] = {
  * Values obtained from table A.1 of ETSI EN 300 744 v1.6.1
  * OK corresponds to Ricean fading; Good to Rayleigh fading
  */
-struct cnr_to_qual_s dvb_t_cnr_2_qual[] = {
+static struct cnr_to_qual_s dvb_t_cnr_2_qual[] = {
 	{   QPSK, FEC_1_2,  4.1,  5.9},
 	{   QPSK, FEC_2_3,  6.1,  9.6},
 	{   QPSK, FEC_3_4,  7.2, 12.4},
-- 
2.1.0

