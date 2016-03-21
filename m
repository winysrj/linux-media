Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:33061 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754647AbcCULlf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2016 07:41:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Krzysztof Halasa <khalasa@piap.pl>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 4/4] tw686x-kh: add audio support to the TODO list
Date: Mon, 21 Mar 2016 12:41:21 +0100
Message-Id: <1458560481-16200-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1458560481-16200-1-git-send-email-hverkuil@xs4all.nl>
References: <1458560481-16200-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The mainline tw686x driver also supports audio, that's missing here
as well.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/tw686x-kh/TODO | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/tw686x-kh/TODO b/drivers/staging/media/tw686x-kh/TODO
index f226e80..480a495 100644
--- a/drivers/staging/media/tw686x-kh/TODO
+++ b/drivers/staging/media/tw686x-kh/TODO
@@ -1,3 +1,6 @@
-TODO: implement V4L2_FIELD_INTERLACED* mode(s).
+TODO:
+
+- implement V4L2_FIELD_INTERLACED* mode(s).
+- add audio support
 
 Please Cc: patches to Krzysztof Halasa <khalasa@piap.pl>.
-- 
2.7.0

