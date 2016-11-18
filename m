Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:9899 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752630AbcKRL0D (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 06:26:03 -0500
From: Hugues Fruchet <hugues.fruchet@st.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <kernel@stlinux.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Subject: [PATCH v2 04/10] [media] MAINTAINERS: add st-delta driver
Date: Fri, 18 Nov 2016 12:25:30 +0100
Message-ID: <1479468336-26199-5-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1479468336-26199-1-git-send-email-hugues.fruchet@st.com>
References: <1479468336-26199-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add entry for the STMicroelectronics DELTA driver.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7db3f7a..a96dd22 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2394,6 +2394,14 @@ W:	https://linuxtv.org
 S:	Supported
 F:	drivers/media/platform/sti/bdisp
 
+DELTA ST MEDIA DRIVER
+M:	Hugues Fruchet <hugues.fruchet@st.com>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+W:	https://linuxtv.org
+S:	Supported
+F:	drivers/media/platform/sti/delta
+
 BEFS FILE SYSTEM
 M:	Luis de Bethencourt <luisbg@osg.samsung.com>
 M:	Salah Triki <salah.triki@gmail.com>
-- 
1.9.1

