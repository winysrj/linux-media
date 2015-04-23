Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:47727 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751770AbbDWGjY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Apr 2015 02:39:24 -0400
Message-ID: <55389381.8060204@xs4all.nl>
Date: Thu, 23 Apr 2015 08:38:57 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: "Mats Randgaard (matrandg)" <matrandg@cisco.com>
Subject: [PATCH] DocBook/media: Improve G_EDID specification
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When using VIDIOC_G_EDID there is a special case where start_blocks and
blocks are both set to 0. In that case the driver just has to set blocks to
the total number of available blocks and return 0.

Even though the drivers do this right and v4l2-compliance tests for it, it
turned out not to be documented in the spec. Fix this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Mats Randgaard <matrandg@cisco.com>

diff --git a/Documentation/DocBook/media/v4l/vidioc-g-edid.xml b/Documentation/DocBook/media/v4l/vidioc-g-edid.xml
index 6df40db..e44340c 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-edid.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-edid.xml
@@ -82,6 +82,13 @@
     <para>If blocks have to be retrieved from the sink, then this call will block until they
     have been read.</para>
 
+    <para>If <structfield>start_block</structfield> and <structfield>blocks</structfield> are
+    both set to 0 when <constant>VIDIOC_G_EDID</constant> is called, then the driver will
+    set <structfield>blocks</structfield> to the total number of available EDID blocks
+    and it will return 0 without copying any data. This is an easy way to discover how many
+    EDID blocks there are. Note that if there are no EDID blocks available at all, then
+    the driver will set <structfield>blocks</structfield> to 0 and it returns 0.</para>
+
     <para>To set the EDID blocks of a receiver the application has to fill in the <structfield>pad</structfield>,
     <structfield>blocks</structfield> and <structfield>edid</structfield> fields and set
     <structfield>start_block</structfield> to 0. It is not possible to set part of an EDID,
