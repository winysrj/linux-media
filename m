Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:52030 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932245AbcDYMZC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2016 08:25:02 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
	linux-input@vger.kernel.org, lars@opdenkamp.eu,
	linux@arm.linux.org.uk, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv15 05/15] cec/TODO: add TODO file so we know why this is still in staging
Date: Mon, 25 Apr 2016 14:24:32 +0200
Message-Id: <1461587082-48041-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1461587082-48041-1-git-send-email-hverkuil@xs4all.nl>
References: <1461587082-48041-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Explain why cec.c is still in staging.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/cec/TODO | 13 +++++++++++++
 1 file changed, 13 insertions(+)
 create mode 100644 drivers/staging/media/cec/TODO

diff --git a/drivers/staging/media/cec/TODO b/drivers/staging/media/cec/TODO
new file mode 100644
index 0000000..c0751ef
--- /dev/null
+++ b/drivers/staging/media/cec/TODO
@@ -0,0 +1,13 @@
+The reason why cec.c is still in staging is that I would like
+to have a bit more confidence in the uABI. The kABI is fine,
+no problem there, but I would like to let the public API mature
+a bit.
+
+Once I'm confident that I didn't miss anything then the cec.c source
+can move to drivers/media and the linux/cec.h and linux/cec-funcs.h
+headers can move to uapi/linux and added to uapi/linux/Kbuild to make
+them public.
+
+Hopefully this will happen later in 2016.
+
+Hans Verkuil <hans.verkuil@cisco.com>
-- 
2.8.1

