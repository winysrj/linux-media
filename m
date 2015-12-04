Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34440 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbbLDMqb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Dec 2015 07:46:31 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 2/4] WHENCE: use https://linuxtv.org for LinuxTV URLs
Date: Fri,  4 Dec 2015 10:46:21 -0200
Message-Id: <e9a73f67222e49579154d3b8cb3ae71aa7898d94.1449232861.git.mchehab@osg.samsung.com>
In-Reply-To: <a825eaec8d62f2679880fc1679622da9d77820a9.1449232861.git.mchehab@osg.samsung.com>
References: <a825eaec8d62f2679880fc1679622da9d77820a9.1449232861.git.mchehab@osg.samsung.com>
In-Reply-To: <a825eaec8d62f2679880fc1679622da9d77820a9.1449232861.git.mchehab@osg.samsung.com>
References: <a825eaec8d62f2679880fc1679622da9d77820a9.1449232861.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While https was always supported on linuxtv.org, only in
Dec 3 2015 the website is using valid certificates.

As we're planning to drop pure http support on some
future, change the http://linuxtv.org references at firmware/WHENCE
file to point to https://linuxtv.org instead.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 firmware/WHENCE | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/firmware/WHENCE b/firmware/WHENCE
index 0c4d96dee9b6..de6f22e008f1 100644
--- a/firmware/WHENCE
+++ b/firmware/WHENCE
@@ -677,7 +677,7 @@ File: av7110/bootcode.bin
 
 Licence: GPLv2 or later
 
-ARM assembly source code available at http://www.linuxtv.org/downloads/firmware/Boot.S
+ARM assembly source code available at https://linuxtv.org/downloads/firmware/Boot.S
 
 --------------------------------------------------------------------------
 
-- 
2.5.0


