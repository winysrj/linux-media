Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:48348
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752244AbdIATh6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Sep 2017 15:37:58 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 08/14] media: dvb-frontend-parameters.rst: fix the name of a struct
Date: Fri,  1 Sep 2017 16:37:44 -0300
Message-Id: <9045640536a77c3aa055e8e7cd6fd4f14fe81982.1504293108.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504293108.git.mchehab@s-opensource.com>
References: <cover.1504293108.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504293108.git.mchehab@s-opensource.com>
References: <cover.1504293108.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The struct that contains an union of DVB parameters is
called dvb_frontend_parameters (and not FrontendParameters).

Fix it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/dvb/dvb-frontend-parameters.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/media/uapi/dvb/dvb-frontend-parameters.rst b/Documentation/media/uapi/dvb/dvb-frontend-parameters.rst
index 899fd5c3545e..b152166f8fa7 100644
--- a/Documentation/media/uapi/dvb/dvb-frontend-parameters.rst
+++ b/Documentation/media/uapi/dvb/dvb-frontend-parameters.rst
@@ -24,7 +24,7 @@ instead, in order to be able to support the newer System Delivery like
 DVB-S2, DVB-T2, DVB-C2, ISDB, etc.
 
 All kinds of parameters are combined as a union in the
-FrontendParameters structure:
+``dvb_frontend_parameters`` structure:
 
 
 .. code-block:: c
-- 
2.13.5
