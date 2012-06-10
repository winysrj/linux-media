Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:4430 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755252Ab2FJK0Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jun 2012 06:26:16 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 25/32] create_bufs: handle count == 0.
Date: Sun, 10 Jun 2012 12:25:47 +0200
Message-Id: <0b5df251d2a54d54ee2810d86b6da0cf7efbe38d.1339321562.git.hans.verkuil@cisco.com>
In-Reply-To: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl>
References: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <ef490f7ebca5b6df91db6b1acfb9928ada3bcd70.1339321562.git.hans.verkuil@cisco.com>
References: <ef490f7ebca5b6df91db6b1acfb9928ada3bcd70.1339321562.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/vidioc-create-bufs.xml |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml b/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
index 765549f..afdba4d 100644
--- a/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
@@ -97,7 +97,13 @@ information.</para>
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>count</structfield></entry>
-	    <entry>The number of buffers requested or granted.</entry>
+	    <entry>The number of buffers requested or granted. If count == 0, then
+	    <constant>VIDIOC_CREATE_BUFS</constant> will set <structfield>index</structfield>
+	    to the starting buffer index, and it will check the validity of
+	    <structfield>memory</structfield> and <structfield>format.type</structfield>.
+	    If those are invalid -1 is returned and errno is set to &EINVAL;,
+	    otherwise <constant>VIDIOC_CREATE_BUFS</constant> returns 0. It will
+	    never set errno to &EBUSY; in this particular case.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
-- 
1.7.10

