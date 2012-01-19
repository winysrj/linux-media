Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59449 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272Ab2ASNo3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jan 2012 08:44:29 -0500
Received: by eaac11 with SMTP id c11so1325485eaa.19
        for <linux-media@vger.kernel.org>; Thu, 19 Jan 2012 05:44:28 -0800 (PST)
From: Gregor Jasny <gjasny@googlemail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Gregor Jasny <gjasny@googlemail.com>
Subject: [PATCH] keytable: Fix copy and paste error for SANYO IR protocol
Date: Thu, 19 Jan 2012 14:42:43 +0100
Message-Id: <1326980563-8194-2-git-send-email-gjasny@googlemail.com>
In-Reply-To: <1326980563-8194-1-git-send-email-gjasny@googlemail.com>
References: <1326980563-8194-1-git-send-email-gjasny@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Gregor Jasny <gjasny@googlemail.com>
---
 utils/keytable/keytable.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/utils/keytable/keytable.c b/utils/keytable/keytable.c
index 93609d2..f03de26 100644
--- a/utils/keytable/keytable.c
+++ b/utils/keytable/keytable.c
@@ -226,7 +226,7 @@ static error_t parse_keyfile(char *fname, char **table)
 						else if (!strcasecmp(p,"sony"))
 							ch_proto |= SONY;
 						else if (!strcasecmp(p,"sanyo"))
-							ch_proto |= SONY;
+							ch_proto |= SANYO;
 						else if (!strcasecmp(p,"other") || !strcasecmp(p,"unknown"))
 							ch_proto |= OTHER;
 						else {
-- 
1.7.8.3

