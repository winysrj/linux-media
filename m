Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:53425
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751918AbdHZKHa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 06:07:30 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 4/6] media: frontend.rst: mention MMT at the documentation
Date: Sat, 26 Aug 2017 07:07:12 -0300
Message-Id: <489d6432cd6cbb5d7280187396ddf61854f5db22.1503742025.git.mchehab@s-opensource.com>
In-Reply-To: <5874bbbb1ab7e717699fd09be97559776ad19fc5.1503742025.git.mchehab@s-opensource.com>
References: <5874bbbb1ab7e717699fd09be97559776ad19fc5.1503742025.git.mchehab@s-opensource.com>
In-Reply-To: <5874bbbb1ab7e717699fd09be97559776ad19fc5.1503742025.git.mchehab@s-opensource.com>
References: <5874bbbb1ab7e717699fd09be97559776ad19fc5.1503742025.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ATSC 3.0 uses MPEG Media Transport, with is not currently
supported. Yet, we'll need to implement it sooner or later.
So, mention about it at the specs.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/dvb/frontend.rst | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/Documentation/media/uapi/dvb/frontend.rst b/Documentation/media/uapi/dvb/frontend.rst
index 0bfade2b72cf..40adcd0da2dc 100644
--- a/Documentation/media/uapi/dvb/frontend.rst
+++ b/Documentation/media/uapi/dvb/frontend.rst
@@ -33,9 +33,8 @@ Data types and ioctl definitions can be accessed by including
 
 .. note::
 
-   Transmission via the internet (DVB-IP) is not yet handled by this
-   API but a future extension is possible.
-
+   Transmission via the internet (DVB-IP) and MMT (MPEG Media Transport)
+   is not yet handled by this API but a future extension is possible.
 
 .. [#f1]
 
-- 
2.13.3
