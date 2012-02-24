Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1630 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab2BXMPt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Feb 2012 07:15:49 -0500
Received: from alastor.dyndns.org (215.80-203-102.nextgentel.com [80.203.102.215])
	(authenticated bits=0)
	by smtp-vbr12.xs4all.nl (8.13.8/8.13.8) with ESMTP id q1OCFk0T091312
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Fri, 24 Feb 2012 13:15:47 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from durdane.localnet (64-103-25-233.cisco.com [64.103.25.233])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 8A7AA35E0005
	for <linux-media@vger.kernel.org>; Fri, 24 Feb 2012 13:15:40 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH] Fix small DocBook typo
Date: Fri, 24 Feb 2012 13:15:39 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201202241315.39298.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Here is a small patch which fixes a DocBook mistake in the decoder_cmd
documentation.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml b/Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml
index 466fe27..74b87f6 100644
--- a/Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml
@@ -118,7 +118,7 @@ this command, drivers and applications must set this field to zero.</entry>
 	  <row>
             <entry></entry>
             <entry></entry>
-	    <entry>__u32</entry>
+	    <entry>__s32</entry>
 	    <entry><structfield>speed</structfield></entry>
             <entry>Playback speed and direction. The playback speed is defined as
 <structfield>speed</structfield>/1000 of the normal speed. So 1000 is normal playback.
