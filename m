Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46920
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750955AbdIANY4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Sep 2017 09:24:56 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v2 21/27] media: ca-reset.rst: add some description to this ioctl
Date: Fri,  1 Sep 2017 10:24:43 -0300
Message-Id: <7b2e0a45a1a7d05569013008e91e9f8f71942900.1504272067.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504272067.git.mchehab@s-opensource.com>
References: <cover.1504272067.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504272067.git.mchehab@s-opensource.com>
References: <cover.1504272067.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While we don't have any documentation for it, based on what's
there at Kaffeine and VDR, it seems that this command should
be issued before start using CA. So, document it as such.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/dvb/ca-reset.rst | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/media/uapi/dvb/ca-reset.rst b/Documentation/media/uapi/dvb/ca-reset.rst
index 477313121a65..a5dd2797a92f 100644
--- a/Documentation/media/uapi/dvb/ca-reset.rst
+++ b/Documentation/media/uapi/dvb/ca-reset.rst
@@ -28,7 +28,8 @@ Arguments
 Description
 -----------
 
-.. note:: This ioctl is undocumented. Documentation is welcome.
+Puts the Conditional Access hardware on its initial state. It should
+be called before start using the CA hardware.
 
 
 Return Value
-- 
2.13.5
