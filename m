Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:45365 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751488AbcHOIKV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2016 04:10:21 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id B6F62180831
	for <linux-media@vger.kernel.org>; Mon, 15 Aug 2016 10:10:15 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] media-types.rst: fix typo
Message-ID: <7c8136e1-b309-b217-d6c1-ad2fc9992724@xs4all.nl>
Date: Mon, 15 Aug 2016 10:10:15 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix copy-and-paste error: the radio devices are /dev/radio, not /dev/vbi.

Signed-off-by: Hans Verkuil <<hans.verkuil@cisco.com>
---
diff --git a/Documentation/media/uapi/mediactl/media-types.rst b/Documentation/media/uapi/mediactl/media-types.rst
index 0265edc..a0f737a 100644
--- a/Documentation/media/uapi/mediactl/media-types.rst
+++ b/Documentation/media/uapi/mediactl/media-types.rst
@@ -405,7 +405,7 @@ Types and flags used to represent the media graph elements

        -  Device node interface for radio (V4L)

-       -  typically, /dev/vbi?
+       -  typically, /dev/radio?

     -  .. row 9

