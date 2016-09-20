Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:49362 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753483AbcITOeR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Sep 2016 10:34:17 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <kernel@stlinux.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Subject: [PATCH v1 3/9] [media] MAINTAINERS: add st-delta driver
Date: Tue, 20 Sep 2016 16:33:34 +0200
Message-ID: <1474382020-17588-4-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1474382020-17588-1-git-send-email-hugues.fruchet@st.com>
References: <1474382020-17588-1-git-send-email-hugues.fruchet@st.com>
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
index db814a8..fae934b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2363,6 +2363,14 @@ W:	https://linuxtv.org
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

