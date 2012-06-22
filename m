Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3388 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761653Ab2FVMVt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jun 2012 08:21:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 25/34] Spec: document CREATE_BUFS behavior if count == 0.
Date: Fri, 22 Jun 2012 14:21:19 +0200
Message-Id: <44d7a0693cc5edf9a2c9e098dda7a294635238df.1340366355.git.hans.verkuil@cisco.com>
In-Reply-To: <1340367688-8722-1-git-send-email-hverkuil@xs4all.nl>
References: <1340367688-8722-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1cee710ae251aa69bed8e563a94b419ed99bc41a.1340366355.git.hans.verkuil@cisco.com>
References: <1cee710ae251aa69bed8e563a94b419ed99bc41a.1340366355.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/vidioc-create-bufs.xml |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml b/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
index 7cf3116..db5ac51 100644
--- a/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
@@ -97,7 +97,13 @@ information.</para>
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>count</structfield></entry>
-	    <entry>The number of buffers requested or granted.</entry>
+	    <entry>The number of buffers requested or granted. If count == 0, then
+	    <constant>VIDIOC_CREATE_BUFS</constant> will set <structfield>index</structfield>
+	    to the current number of created buffers, and it will check the validity of
+	    <structfield>memory</structfield> and <structfield>format.type</structfield>.
+	    If those are invalid -1 is returned and errno is set to &EINVAL;,
+	    otherwise <constant>VIDIOC_CREATE_BUFS</constant> returns 0. It will
+	    never set errno to &EBUSY; in this particular case.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
-- 
1.7.10

