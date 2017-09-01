Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:48348
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752295AbdIATh7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Sep 2017 15:37:59 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 09/14] media: dvbapi.rst: add an entry to DVB revision history
Date: Fri,  1 Sep 2017 16:37:45 -0300
Message-Id: <4ef49f905843b6b12eede18b30d96998fe946859.1504293108.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504293108.git.mchehab@s-opensource.com>
References: <cover.1504293108.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504293108.git.mchehab@s-opensource.com>
References: <cover.1504293108.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several missing items at the API history. Yet,
as we're doing a significant change there, add a new entry.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/dvb/dvbapi.rst | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/Documentation/media/uapi/dvb/dvbapi.rst b/Documentation/media/uapi/dvb/dvbapi.rst
index 268bf69db281..7d26e98e5a41 100644
--- a/Documentation/media/uapi/dvb/dvbapi.rst
+++ b/Documentation/media/uapi/dvb/dvbapi.rst
@@ -66,12 +66,17 @@ Authors:
 
 **Copyright** |copy| 2002-2003 : Convergence GmbH
 
-**Copyright** |copy| 2009-2016 : Mauro Carvalho Chehab
+**Copyright** |copy| 2009-2017 : Mauro Carvalho Chehab
 
 ****************
 Revision History
 ****************
 
+:revision: 2.2.0 / 2017-09-01 (*mcc*)
+
+Most gaps between the uAPI document and the Kernel implementation
+got fixed for the non-legacy API.
+
 :revision: 2.1.0 / 2015-05-29 (*mcc*)
 
 DocBook improvements and cleanups, in order to document the system calls
-- 
2.13.5
