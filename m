Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:44922
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751693AbdHaXrI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 19:47:08 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 02/15] media: dvb/intro: update references for TV standards
Date: Thu, 31 Aug 2017 20:46:49 -0300
Message-Id: <48d1f5611b7f4537e0208798763f92f6b2be18c0.1504222628.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504222628.git.mchehab@s-opensource.com>
References: <cover.1504222628.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504222628.git.mchehab@s-opensource.com>
References: <cover.1504222628.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The references there are only for DVB. Add missing references for
ATSC and ISDB standards.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/dvb/intro.rst | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/Documentation/media/uapi/dvb/intro.rst b/Documentation/media/uapi/dvb/intro.rst
index de432ffcba50..991643d3b461 100644
--- a/Documentation/media/uapi/dvb/intro.rst
+++ b/Documentation/media/uapi/dvb/intro.rst
@@ -18,10 +18,13 @@ part I of the MPEG2 specification ISO/IEC 13818 (aka ITU-T H.222), i.e
 you should know what a program/transport stream (PS/TS) is and what is
 meant by a packetized elementary stream (PES) or an I-frame.
 
-Various DVB standards documents are available from http://www.dvb.org
-and/or http://www.etsi.org.
+Various Digital TV standards documents are available for download at:
 
-It is also necessary to know how to access unix/linux devices and how to
+- European standards (DVB): http://www.dvb.org and/or http://www.etsi.org.
+- American standards (ATSC): https://www.atsc.org/standards/
+- Japanese standards (ISDB): http://www.dibeg.org/
+
+It is also necessary to know how to access Linux devices and how to
 use ioctl calls. This also includes the knowledge of C or C++.
 
 
-- 
2.13.5
