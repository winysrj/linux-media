Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:44942
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751901AbdHaXrK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 19:47:10 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 15/15] media: net.rst: Fix the level of a section of the net chapter
Date: Thu, 31 Aug 2017 20:47:02 -0300
Message-Id: <ba8bd5563f4069d6bc59cd675dd09ec795c70b2f.1504222628.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504222628.git.mchehab@s-opensource.com>
References: <cover.1504222628.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504222628.git.mchehab@s-opensource.com>
References: <cover.1504222628.git.mchehab@s-opensource.com>
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
