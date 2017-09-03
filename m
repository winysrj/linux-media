Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:50958
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752874AbdICCfM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 2 Sep 2017 22:35:12 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 10/12] media: v4l2-event.rst: adjust table to fit on PDF output
Date: Sat,  2 Sep 2017 23:35:02 -0300
Message-Id: <2e0f571faa8da2e579152e6440724165d74fdb59.1504405125.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504405124.git.mchehab@s-opensource.com>
References: <cover.1504405124.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504405124.git.mchehab@s-opensource.com>
References: <cover.1504405124.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The tables there don't quite fit on PDF output.

Adjust it by adding a tabularcolumns macro.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/v4l2-event.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/media/kapi/v4l2-event.rst b/Documentation/media/kapi/v4l2-event.rst
index 9a5e31546ae3..9938d21ef4d1 100644
--- a/Documentation/media/kapi/v4l2-event.rst
+++ b/Documentation/media/kapi/v4l2-event.rst
@@ -67,6 +67,8 @@ type).
 
 The ops argument allows the driver to specify a number of callbacks:
 
+.. tabularcolumns:: |p{1.5cm}|p{16.0cm}|
+
 ======== ==============================================================
 Callback Description
 ======== ==============================================================
-- 
2.13.5
