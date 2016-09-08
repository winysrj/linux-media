Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56887 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938546AbcIHVhu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 17:37:50 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>,
        linux-doc@vger.kernel.org
Subject: [PATCH 10/15] [media] conf_nitpick.py: ignore C domain data used on vb2
Date: Thu,  8 Sep 2016 18:37:36 -0300
Message-Id: <c193d2bdac1f50afb97374100cea066e52dcf7d3.1473370390.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473370390.git.mchehab@s-opensource.com>
References: <cover.1473370390.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473370390.git.mchehab@s-opensource.com>
References: <cover.1473370390.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ignore external C domain structs and functions used by VB2
header.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/conf_nitpick.py | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/media/conf_nitpick.py b/Documentation/media/conf_nitpick.py
index f71bb947eb15..480d548af670 100644
--- a/Documentation/media/conf_nitpick.py
+++ b/Documentation/media/conf_nitpick.py
@@ -40,6 +40,8 @@ nitpick_ignore = [
     ("c:func", "struct fd_set"),
     ("c:func", "struct pollfd"),
     ("c:func", "usb_make_path"),
+    ("c:func", "wait_finish"),
+    ("c:func", "wait_prepare"),
     ("c:func", "write"),
 
     ("c:type", "atomic_t"),
@@ -67,6 +69,7 @@ nitpick_ignore = [
     ("c:type", "off_t"),
     ("c:type", "pci_dev"),
     ("c:type", "pdvbdev"),
+    ("c:type", "poll_table"),
     ("c:type", "platform_device"),
     ("c:type", "pollfd"),
     ("c:type", "poll_table_struct"),
@@ -98,6 +101,7 @@ nitpick_ignore = [
     ("c:type", "usb_interface"),
     ("c:type", "v4l2_std_id"),
     ("c:type", "video_system_t"),
+    ("c:type", "vm_area_struct"),
 
     # Opaque structures
 
-- 
2.7.4


