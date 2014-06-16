Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4903 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426AbaFPIOM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jun 2014 04:14:12 -0400
Received: from tschai.lan (173-38-208-170.cisco.com [173.38.208.170])
	(authenticated bits=0)
	by smtp-vbr15.xs4all.nl (8.13.8/8.13.8) with ESMTP id s5G8E8tj095905
	for <linux-media@vger.kernel.org>; Mon, 16 Jun 2014 10:14:10 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id A361A2A1FCC
	for <linux-media@vger.kernel.org>; Mon, 16 Jun 2014 10:13:55 +0200 (CEST)
Message-ID: <539EA743.8070103@xs4all.nl>
Date: Mon, 16 Jun 2014 10:13:55 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] DocBook media: fix small typo
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

know -> known

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/io.xml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
index a086a5d..8c4ee74 100644
--- a/Documentation/DocBook/media/v4l/io.xml
+++ b/Documentation/DocBook/media/v4l/io.xml
@@ -1066,7 +1066,7 @@ state, in the application domain so to say.</entry>
 	  <entry>Drivers set or clear this flag when calling the
 <constant>VIDIOC_DQBUF</constant> ioctl. It may be set by video
 capture devices when the buffer contains a compressed image which is a
-key frame (or field), &ie; can be decompressed on its own. Also know as
+key frame (or field), &ie; can be decompressed on its own. Also known as
 an I-frame.  Applications can set this bit when <structfield>type</structfield>
 refers to an output stream.</entry>
 	  </row>
-- 
2.0.0

