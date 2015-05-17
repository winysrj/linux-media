Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55997 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbbEQCPU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 16 May 2015 22:15:20 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] DocBook: fix vidioc-qbuf.xml doc validation
Date: Sun, 17 May 2015 05:14:34 +0300
Message-Id: <1431828874-8108-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

element varlistentry: validity error : Element varlistentry content
does not follow the DTD, expecting (term+ , listitem), got (term
listitem term listitem )

commit 8cee396bfa77ce3a2e5fe48f597206c1cd547f9c
[media] DocBook media: document codec draining flow
breaks document validation. Fix it.

Cc: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 Documentation/DocBook/media/v4l/vidioc-qbuf.xml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/vidioc-qbuf.xml b/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
index 6cfc53b..f5cef97 100644
--- a/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
@@ -186,6 +186,8 @@ In that case the application should be able to safely reuse the buffer and
 continue streaming.
 	</para>
 	</listitem>
+      </varlistentry>
+      <varlistentry>
 	<term><errorcode>EPIPE</errorcode></term>
 	<listitem>
 	  <para><constant>VIDIOC_DQBUF</constant> returns this on an empty
-- 
http://palosaari.fi/

