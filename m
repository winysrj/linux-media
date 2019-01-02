Return-Path: <SRS0=KeAI=PK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51233C43387
	for <linux-media@archiver.kernel.org>; Wed,  2 Jan 2019 16:04:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EE80218DE
	for <linux-media@archiver.kernel.org>; Wed,  2 Jan 2019 16:04:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GTyZiTrS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729511AbfABQED (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 2 Jan 2019 11:04:03 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:37466 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729435AbfABQED (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 2 Jan 2019 11:04:03 -0500
Received: by mail-ed1-f67.google.com with SMTP id h15so26589669edb.4
        for <linux-media@vger.kernel.org>; Wed, 02 Jan 2019 08:04:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m2c8fwL0G+Me11MPhmHD37DGIgl96Fg4lfTF6SWegGI=;
        b=GTyZiTrShFrWuC13hjSpPhg4PRei3hF1UdwLdXXUXnrOYqifFzfooLyjJpk9wDwl8G
         XAxhJ8COjsG2pbM0YT6MoFcw+KtCKs6A6kJLoaO1+49kIyzpgWpNTMkdntDXGncLlu65
         VC/2mffUa7yYm8t1rANtK5Ja/SOiXsRSFDdfVejdJR/EOw9T84dOoOijgNN2xC+Zm7aq
         vEBycAotQp0lsUy2pPHSWFLOVCNiCqvO1GNvQ5jLD3K3kro0mfPq3b/6y/sgvchtH2en
         t2XSqgd4DWkaoyo/Y3QlgnqY+7hxTx1mzegsU+mpAp+R+3aNtYTbZelrbgWGgQPzN9be
         hGtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m2c8fwL0G+Me11MPhmHD37DGIgl96Fg4lfTF6SWegGI=;
        b=lMlMs7eDr1coKLf0kfw1FtyE6mVTH02CNM8FDRmirLo+PtNFR7OFo/lSE2Le2pyn+5
         DjeW2UmcRG7GIE6ySGAe9v1A5t4eCRn5a4G/25Yo7mk+HsYHAOy10UaYQfpPQXjKlU1O
         gDcGSBIYi5kLHCPl1lETb7dqo641uIdVVW6g6cE5/f5pLXiZyYaSnte3SjPKa2ESWvlq
         No4Kf58mx6HThcplM8DuUrlDL+epkpt51aZliOE0f0O4+2i3iDni4wTYh1sTQtR2P272
         B/iJvU5A/JeQ64S/JW0jfpl8hMXIPe+o75Z9O7dnaSeh5ZyTlXNWgV0LgPcMT30lSm+6
         8IOQ==
X-Gm-Message-State: AJcUuke1hdHN0wBkNaQPvJyfABD3hBjJUmJirkA8rcl96VHtSbNCK5N+
        oPkI3h/+3KGdzvz67aPtUxEyeo1s
X-Google-Smtp-Source: ALg8bN6Jtet6Bz6oTRkv8QwZYOAPYvZi44Ic7kqT5ziScFiE4+sj17kpNBf6d/wXIp2Y+4OUjIek+Q==
X-Received: by 2002:a17:906:3da2:: with SMTP id y2-v6mr1895432ejh.160.1546445040290;
        Wed, 02 Jan 2019 08:04:00 -0800 (PST)
Received: from localhost.localdomain (195.145.107.92.dynamic.wline.res.cust.swisscom.ch. [92.107.145.195])
        by smtp.gmail.com with ESMTPSA id l18sm21291593edq.87.2019.01.02.08.03.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Jan 2019 08:03:59 -0800 (PST)
From:   =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     abassetta@tiscali.it,
        =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 1/3] libdvbv5: do not adjust DVB time daylight saving
Date:   Wed,  2 Jan 2019 17:03:12 +0100
Message-Id: <20190102160314.7451-1-neolynx@gmail.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Sets tm_isdst to -1. This makes dvb_time available
outside of EIT parsing, and struct tm to reflect the
actual values received from DVB.

Also fixes indentation.

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/libdvbv5/tables/eit.c | 49 +++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 25 deletions(-)

diff --git a/lib/libdvbv5/tables/eit.c b/lib/libdvbv5/tables/eit.c
index a6ba566a..40db637a 100644
--- a/lib/libdvbv5/tables/eit.c
+++ b/lib/libdvbv5/tables/eit.c
@@ -156,33 +156,32 @@ void dvb_table_eit_print(struct dvb_v5_fe_parms *parms, struct dvb_table_eit *ei
 
 void dvb_time(const uint8_t data[5], struct tm *tm)
 {
-  /* ETSI EN 300 468 V1.4.1 */
-  int year, month, day, hour, min, sec;
-  int k = 0;
-  uint16_t mjd;
-
-  mjd   = *(uint16_t *) data;
-  hour  = dvb_bcd(data[2]);
-  min   = dvb_bcd(data[3]);
-  sec   = dvb_bcd(data[4]);
-  year  = ((mjd - 15078.2) / 365.25);
-  month = ((mjd - 14956.1 - (int) (year * 365.25)) / 30.6001);
-  day   = mjd - 14956 - (int) (year * 365.25) - (int) (month * 30.6001);
-  if (month == 14 || month == 15) k = 1;
-  year += k;
-  month = month - 1 - k * 12;
-
-  tm->tm_sec   = sec;
-  tm->tm_min   = min;
-  tm->tm_hour  = hour;
-  tm->tm_mday  = day;
-  tm->tm_mon   = month - 1;
-  tm->tm_year  = year;
-  tm->tm_isdst = 1; /* dst in effect, do not adjust */
-  mktime( tm );
+	/* ETSI EN 300 468 V1.4.1 */
+	int year, month, day, hour, min, sec;
+	int k = 0;
+	uint16_t mjd;
+
+	mjd   = *(uint16_t *) data;
+	hour  = dvb_bcd(data[2]);
+	min   = dvb_bcd(data[3]);
+	sec   = dvb_bcd(data[4]);
+	year  = ((mjd - 15078.2) / 365.25);
+	month = ((mjd - 14956.1 - (int) (year * 365.25)) / 30.6001);
+	day   = mjd - 14956 - (int) (year * 365.25) - (int) (month * 30.6001);
+	if (month == 14 || month == 15) k = 1;
+	year += k;
+	month = month - 1 - k * 12;
+
+	tm->tm_sec   = sec;
+	tm->tm_min   = min;
+	tm->tm_hour  = hour;
+	tm->tm_mday  = day;
+	tm->tm_mon   = month - 1;
+	tm->tm_year  = year;
+	tm->tm_isdst = -1; /* do not adjust */
+	mktime( tm );
 }
 
-
 const char *dvb_eit_running_status_name[8] = {
 	[0] = "Undefined",
 	[1] = "Not running",
-- 
2.17.1

