Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:58975 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751143AbdBBPAR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 2 Feb 2017 10:00:17 -0500
From: Hugues Fruchet <hugues.fruchet@st.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <kernel@stlinux.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Subject: [PATCH v7 04/10] [media] MAINTAINERS: add st-delta driver
Date: Thu, 2 Feb 2017 15:59:47 +0100
Message-ID: <1486047593-18581-5-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1486047593-18581-1-git-send-email-hugues.fruchet@st.com>
References: <1486047593-18581-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add entry for the STMicroelectronics DELTA driver.

Acked-by: Peter Griffin <peter.griffin@linaro.org>
Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index cfff2c9..38cc652 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2429,6 +2429,14 @@ W:	https://linuxtv.org
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

