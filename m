Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:41253 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751261AbdAaQcX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 11:32:23 -0500
From: Hugues Fruchet <hugues.fruchet@st.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <kernel@stlinux.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Subject: [PATCH v5 04/10] [media] MAINTAINERS: add st-delta driver
Date: Tue, 31 Jan 2017 17:30:27 +0100
Message-ID: <1485880233-666-5-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1485880233-666-1-git-send-email-hugues.fruchet@st.com>
References: <1485880233-666-1-git-send-email-hugues.fruchet@st.com>
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

