Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:50932
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752857AbdICCfK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 2 Sep 2017 22:35:10 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Sean Young <sean@mess.org>
Subject: [PATCH 06/12] media: rc-sysfs-nodes.rst: better use literals
Date: Sat,  2 Sep 2017 23:34:58 -0300
Message-Id: <1c7141e8a4191f298d648cd16993ca9b7b36abdc.1504405125.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504405124.git.mchehab@s-opensource.com>
References: <cover.1504405124.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504405124.git.mchehab@s-opensource.com>
References: <cover.1504405124.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A literal box provides a better visual when pdf and html output
is generated for things like the output of a sysfs devnode.
It alsod matches other conventions used within the media book.

So, use it.

While here, use literals for protocol names.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/rc/rc-sysfs-nodes.rst | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/media/uapi/rc/rc-sysfs-nodes.rst b/Documentation/media/uapi/rc/rc-sysfs-nodes.rst
index 3476ae29708f..2d01358d5504 100644
--- a/Documentation/media/uapi/rc/rc-sysfs-nodes.rst
+++ b/Documentation/media/uapi/rc/rc-sysfs-nodes.rst
@@ -34,9 +34,9 @@ receiver device where N is the number of the receiver.
 /sys/class/rc/rcN/protocols
 ===========================
 
-Reading this file returns a list of available protocols, something like:
+Reading this file returns a list of available protocols, something like::
 
-``rc5 [rc6] nec jvc [sony]``
+	rc5 [rc6] nec jvc [sony]
 
 Enabled protocols are shown in [] brackets.
 
@@ -90,11 +90,11 @@ This value may be reset to 0 if the current protocol is altered.
 ==================================
 
 Reading this file returns a list of available protocols to use for the
-wakeup filter, something like:
+wakeup filter, something like::
 
-``rc-5 nec nec-x rc-6-0 rc-6-6a-24 [rc-6-6a-32] rc-6-mce``
+	rc-5 nec nec-x rc-6-0 rc-6-6a-24 [rc-6-6a-32] rc-6-mce
 
-Note that protocol variants are listed, so "nec", "sony", "rc-5", "rc-6"
+Note that protocol variants are listed, so ``nec``, ``sony``, ``rc-5``, ``rc-6``
 have their different bit length encodings listed if available.
 
 Note that all protocol variants are listed.
-- 
2.13.5
