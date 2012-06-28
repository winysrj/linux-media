Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4948 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344Ab2F1Gss (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jun 2012 02:48:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 24/33] Spec: document CREATE_BUFS behavior if count == 0.
Date: Thu, 28 Jun 2012 08:48:18 +0200
Message-Id: <d047dd0c9a7c85c5da27839aca37158a6769a1eb.1340865818.git.hans.verkuil@cisco.com>
In-Reply-To: <1340866107-4188-1-git-send-email-hverkuil@xs4all.nl>
References: <1340866107-4188-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <d97434d2319fb8dbea360404f9343c680b5b196e.1340865818.git.hans.verkuil@cisco.com>
References: <d97434d2319fb8dbea360404f9343c680b5b196e.1340865818.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/vidioc-create-bufs.xml |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml b/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
index a2474ec..5e73b1c 100644
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

