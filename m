Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:39644 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933286AbbEOKby (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 May 2015 06:31:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/2] DocBook/media: fix syntax error
Date: Fri, 15 May 2015 12:31:36 +0200
Message-Id: <1431685897-11153-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Missing varlistentry tags.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/vidioc-qbuf.xml | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-qbuf.xml b/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
index 6cfc53b..8b98a0e 100644
--- a/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
@@ -186,13 +186,15 @@ In that case the application should be able to safely reuse the buffer and
 continue streaming.
 	</para>
 	</listitem>
+      </varlistentry>
+      <varlistentry>
 	<term><errorcode>EPIPE</errorcode></term>
 	<listitem>
 	  <para><constant>VIDIOC_DQBUF</constant> returns this on an empty
 capture queue for mem2mem codecs if a buffer with the
 <constant>V4L2_BUF_FLAG_LAST</constant> was already dequeued and no new buffers
 are expected to become available.
-	</para>
+	  </para>
 	</listitem>
       </varlistentry>
     </variablelist>
-- 
2.1.4

