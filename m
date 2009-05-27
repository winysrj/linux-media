Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:43635 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759796AbZE0GS5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 May 2009 02:18:57 -0400
Received: from dflp53.itg.ti.com ([128.247.5.6])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id n4R6IsTd000877
	for <linux-media@vger.kernel.org>; Wed, 27 May 2009 01:18:59 -0500
Received: from tidmzi-ftp.india.ext.ti.com (localhost [127.0.0.1])
	by dflp53.itg.ti.com (8.13.8/8.13.8) with SMTP id n4R6Iqrt009291
	for <linux-media@vger.kernel.org>; Wed, 27 May 2009 01:18:53 -0500 (CDT)
Received: from symphonyindia.ti.com (symphony-ftp [192.168.247.11])
	by tidmzi-ftp.india.ext.ti.com (Postfix) with SMTP id F20093886B
	for <linux-media@vger.kernel.org>; Wed, 27 May 2009 11:46:15 +0530 (IST)
From: Chaithrika U S <chaithrika@ti.com>
To: linux-media@vger.kernel.org
Cc: Chaithrika U S <chaithrika@ti.com>
Subject: v4l: Compile ADV7343 and THS7303 drivers for kernels >= 2.6.26
Date: Wed, 27 May 2009 01:42:44 -0400
Message-Id: <1243402964-8207-1-git-send-email-chaithrika@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Chaithrika U S <chaithrika@ti.com>
---
 v4l/versions.txt |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/v4l/versions.txt b/v4l/versions.txt
index eb206b5..3c57c14 100644
--- a/v4l/versions.txt
+++ b/v4l/versions.txt
@@ -13,6 +13,8 @@ USB_STV06XX
 VIDEO_TVP514X
 # requires id_table and new i2c stuff
 RADIO_TEA5764
+VIDEO_THS7303
+VIDEO_ADV7343
 
 [2.6.25]
 # Requires gpiolib
-- 
1.5.6

