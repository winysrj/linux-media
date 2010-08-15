Return-path: <mchehab@pedra>
Received: from cinke.fazekas.hu ([195.199.244.225]:56445 "EHLO
	cinke.fazekas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161Ab0HORaJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Aug 2010 13:30:09 -0400
Received: from localhost (localhost [127.0.0.1])
	by cinke.fazekas.hu (Postfix) with ESMTP id 8640198139
	for <linux-media@vger.kernel.org>; Sun, 15 Aug 2010 14:43:26 +0200 (CEST)
Received: from cinke.fazekas.hu ([127.0.0.1])
	by localhost (cinke.fazekas.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NF4Jw6eCdpTY for <linux-media@vger.kernel.org>;
	Sun, 15 Aug 2010 14:43:26 +0200 (CEST)
Received: from roadrunner.athome (localhost [127.0.0.1])
	by cinke.fazekas.hu (Postfix) with ESMTP id 341542C033
	for <linux-media@vger.kernel.org>; Sun, 15 Aug 2010 14:43:26 +0200 (CEST)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH] update DVB-C scan files for hu-Digikabel
Message-Id: <7c8fa4a65634e5cab19a.1281876184@roadrunner.athome>
Date: Sun, 15 Aug 2010 12:43:04 -0000
From: Marton Balint <cus@fazekas.hu>
To: linux-media@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

# HG changeset patch
# User Marton Balint <cus@fazekas.hu>
# Date 1281875940 -7200
# Node ID 7c8fa4a65634e5cab19ace3a17d15c29e31d07e4
# Parent  16157edcb447ec50184ccb9dcefc8c6c3da88aa5
update DVB-C scan files for hu-Digikabel

Signed-off-by: Marton Balint <cus@fazekas.hu>

diff -r 16157edcb447 -r 7c8fa4a65634 util/scan/dvb-c/hu-Digikabel
--- a/util/scan/dvb-c/hu-Digikabel	Tue Aug 03 13:24:24 2010 +0200
+++ b/util/scan/dvb-c/hu-Digikabel	Sun Aug 15 14:39:00 2010 +0200
@@ -14,11 +14,8 @@
 C 394000000 6900000 NONE QAM256
 C 402000000 6900000 NONE QAM256
 C 410000000 6900000 NONE QAM256
+C 762000000 6900000 NONE QAM256
 C 770000000 6900000 NONE QAM256
 C 778000000 6900000 NONE QAM256
 C 786000000 6900000 NONE QAM256
 C 794000000 6900000 NONE QAM256
-C 834000000 6900000 NONE QAM256
-C 842000000 6900000 NONE QAM256
-C 850000000 6900000 NONE QAM256
-C 858000000 6900000 NONE QAM256
