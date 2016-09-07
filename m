Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:49919 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757055AbcIGKsr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Sep 2016 06:48:47 -0400
Received: from [10.47.79.81] (unknown [173.38.220.42])
        by tschai.lan (Postfix) with ESMTPSA id 7257F18597A
        for <linux-media@vger.kernel.org>; Wed,  7 Sep 2016 12:48:42 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCHv2] v4l-drivers/fourcc.rst: fix typo
To: linux-media@vger.kernel.org
Message-ID: <eb8731b6-a61a-5a9a-31c0-6146a9d39f12@xs4all.nl>
Date: Wed, 7 Sep 2016 12:48:41 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Linux4Linux -> Video4Linux

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
--
v1 had one diff too many :-)
---
diff --git a/Documentation/media/v4l-drivers/fourcc.rst 
b/Documentation/media/v4l-drivers/fourcc.rst
index f7c8cef..9c82106 100644
--- a/Documentation/media/v4l-drivers/fourcc.rst
+++ b/Documentation/media/v4l-drivers/fourcc.rst
@@ -1,4 +1,4 @@
-Guidelines for Linux4Linux pixel format 4CCs
+Guidelines for Video4Linux pixel format 4CCs
  ============================================

  Guidelines for Video4Linux 4CC codes defined using v4l2_fourcc() are
