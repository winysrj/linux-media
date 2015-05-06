Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:43315 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752654AbbEFGf5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 6 May 2015 02:35:57 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id DA4B02A0097
	for <linux-media@vger.kernel.org>; Wed,  6 May 2015 08:35:43 +0200 (CEST)
Message-ID: <5549B63F.7020009@xs4all.nl>
Date: Wed, 06 May 2015 08:35:43 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] DocBook/media: fix querycap error code
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The most likely error you will get when calling VIDIOC_QUERYCAP for a
device node that does not support it is ENOTTY, not EINVAL.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/vidioc-querycap.xml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-querycap.xml b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
index 20fda75..131abca 100644
--- a/Documentation/DocBook/media/v4l/vidioc-querycap.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
@@ -54,7 +54,7 @@ kernel devices compatible with this specification and to obtain
 information about driver and hardware capabilities. The ioctl takes a
 pointer to a &v4l2-capability; which is filled by the driver. When the
 driver is not compatible with this specification the ioctl returns an
-&EINVAL;.</para>
+error, most likely the &ENOTTY;.</para>
 
     <table pgwide="1" frame="none" id="v4l2-capability">
       <title>struct <structname>v4l2_capability</structname></title>
-- 
2.1.4

