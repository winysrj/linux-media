Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4554 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbaGTUQq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Jul 2014 16:16:46 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr13.xs4all.nl (8.13.8/8.13.8) with ESMTP id s6KKGgrl041741
	for <linux-media@vger.kernel.org>; Sun, 20 Jul 2014 22:16:44 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 5AAC82A0463
	for <linux-media@vger.kernel.org>; Sun, 20 Jul 2014 22:16:41 +0200 (CEST)
Message-ID: <53CC23A9.4020704@xs4all.nl>
Date: Sun, 20 Jul 2014 22:16:41 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] DocBook media typo
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

V4L2_CID_BASE_LASTP1 should be V4L2_CID_LASTP1. This has probably been wrong
since the earliest days of this documentation until I did a copy-and-paste
and found out that V4L2_CID_BASE_LASTP1 doesn't actually exist :-)

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml b/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
index 62163d9..2bd98fd 100644
--- a/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
@@ -76,7 +76,7 @@ structure. The driver fills the rest of the structure or returns an
 <constant>VIDIOC_QUERYCTRL</constant> with successive
 <structfield>id</structfield> values starting from
 <constant>V4L2_CID_BASE</constant> up to and exclusive
-<constant>V4L2_CID_BASE_LASTP1</constant>. Drivers may return
+<constant>V4L2_CID_LASTP1</constant>. Drivers may return
 <errorcode>EINVAL</errorcode> if a control in this range is not
 supported. Further applications can enumerate private controls, which
 are not defined in this specification, by starting at
