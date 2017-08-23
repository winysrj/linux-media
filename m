Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:41826
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753594AbdHWI5D (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 04:57:03 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH v2 2/4] media: dev-sliced-vbi.rst: fix verbatim font size on a table
Date: Wed, 23 Aug 2017 05:56:55 -0300
Message-Id: <ae97b2cc4bcc2f712c934b8f7762164d77eb4db7.1503477995.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1503477995.git.mchehab@s-opensource.com>
References: <cover.1503477995.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1503477995.git.mchehab@s-opensource.com>
References: <cover.1503477995.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sphinx 1.6, verbatim font is always \small. That causes a
problem inside Sliced VBI services table, as it is too big for the
box.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/dev-sliced-vbi.rst | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/media/uapi/v4l/dev-sliced-vbi.rst b/Documentation/media/uapi/v4l/dev-sliced-vbi.rst
index 23e079787270..a6c6f74455fe 100644
--- a/Documentation/media/uapi/v4l/dev-sliced-vbi.rst
+++ b/Documentation/media/uapi/v4l/dev-sliced-vbi.rst
@@ -214,7 +214,9 @@ Sliced VBI services
 -------------------
 
 .. raw:: latex
+
     \footnotesize
+    \fvset{fontsize=\footnotesize}
 
 .. tabularcolumns:: |p{4.1cm}|p{1.1cm}|p{2.4cm}|p{2.0cm}|p{7.3cm}|
 
@@ -270,6 +272,7 @@ Sliced VBI services
 
 .. raw:: latex
 
+    \fvset{fontsize=\small}
     \normalsize
 
 
-- 
2.13.3
