Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42740 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbbLLNlB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Dec 2015 08:41:01 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 4/6] [media] Docbook: media-types.xml: update the existing tables
Date: Sat, 12 Dec 2015 11:40:43 -0200
Message-Id: <483c00a917fedc142a80eaf8689c4fbb3ca6c962.1449927561.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1449927561.git.mchehab@osg.samsung.com>
References: <cover.1449927561.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1449927561.git.mchehab@osg.samsung.com>
References: <cover.1449927561.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There were some changes on the media types that were not reflected
on the types tables. Update them to reflect the upstream changes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 Documentation/DocBook/media/v4l/media-types.xml | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/media-types.xml b/Documentation/DocBook/media/v4l/media-types.xml
index 0c5c9c034586..4a6038301e06 100644
--- a/Documentation/DocBook/media/v4l/media-types.xml
+++ b/Documentation/DocBook/media/v4l/media-types.xml
@@ -33,7 +33,7 @@
 	    <entry>Digital TV demodulator entity.</entry>
 	  </row>
 	  <row>
-	    <entry><constant>MEDIA_ENT_F_MPEG_TS_DEMUX</constant></entry>
+	    <entry><constant>MEDIA_ENT_F_TS_DEMUX</constant></entry>
 	    <entry>MPEG Transport stream demux entity. Could be implemented on hardware or in Kernelspace by the Linux DVB subsystem.</entry>
 	  </row>
 	  <row>
@@ -101,6 +101,10 @@
 	    <entry>Default entity for its type. Used to discover the default
 	    audio, VBI and video devices, the default camera sensor, ...</entry>
 	  </row>
+	  <row>
+	    <entry><constant>MEDIA_ENT_FL_CONNECTOR</constant></entry>
+	    <entry>The entity represents a data conector</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
@@ -159,6 +163,15 @@
 	    <entry>The link enabled state can be modified during streaming. This
 	    flag is set by drivers and is read-only for applications.</entry>
 	  </row>
+	  <row>
+	    <entry><constant>MEDIA_LNK_FL_LINK_TYPE</constant></entry>
+	    <entry><para>This is a bitmask that defines the type of the link.
+		   Currently, two types of links are supported:</para>
+	    <para><constant>MEDIA_LNK_FL_DATA_LINK</constant>
+	    if the link is between two pads</para>
+	    <para><constant>MEDIA_LNK_FL_INTERFACE_LINK</constant>
+	    if the link is between an interface and an entity</para></entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
-- 
2.5.0


