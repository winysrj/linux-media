Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46944
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752059AbdIANY6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Sep 2017 09:24:58 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v2 17/27] media: net.rst: Fix the level of a section of the net chapter
Date: Fri,  1 Sep 2017 10:24:39 -0300
Message-Id: <197faa52b051efbd7ecf207b4a8a4729afe7fb49.1504272067.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504272067.git.mchehab@s-opensource.com>
References: <cover.1504272067.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504272067.git.mchehab@s-opensource.com>
References: <cover.1504272067.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to a mistake, the DVB net chapter was actually broken
into two different chapters. Fix it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/dvb/net.rst | 1 -
 1 file changed, 1 deletion(-)

diff --git a/Documentation/media/uapi/dvb/net.rst b/Documentation/media/uapi/dvb/net.rst
index eca42dd53261..00ae5df0c321 100644
--- a/Documentation/media/uapi/dvb/net.rst
+++ b/Documentation/media/uapi/dvb/net.rst
@@ -28,7 +28,6 @@ header.
 
 .. _net_fcalls:
 
-######################
 DVB net Function Calls
 ######################
 
-- 
2.13.5
