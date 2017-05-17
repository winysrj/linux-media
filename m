Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:43188 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753010AbdEQIDj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 May 2017 04:03:39 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC: <linux-media@vger.kernel.org>,
        Gregor Jasny <gjasny@googlemail.com>,
        Christophe Priouzeau <christophe.priouzeau@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Subject: [PATCH v1 1/5] configure.ac: fix wrong summary if --disable-v4l2-ctl-stream-to
Date: Wed, 17 May 2017 10:03:08 +0200
Message-ID: <1495008192-21202-2-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1495008192-21202-1-git-send-email-hugues.fruchet@st.com>
References: <1495008192-21202-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If --disable-v4l2-ctl-stream-to option is set, summary shows:
v4l2-ctl uses libv4l       : no
due to USE_V4L2_CTL set to "no", fix this.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 configure.ac | 1 -
 1 file changed, 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 36b0c71..e8b86a5 100644
--- a/configure.ac
+++ b/configure.ac
@@ -472,7 +472,6 @@ AM_COND_IF([WITH_V4L_PLUGINS], [USE_V4L_PLUGINS="yes"], [USE_V4L_PLUGINS="no"])
 AM_COND_IF([WITH_V4L_WRAPPERS], [USE_V4L_WRAPPERS="yes"], [USE_V4L_WRAPPERS="no"])
 AM_COND_IF([WITH_GCONV], [USE_GCONV="yes"], [USE_GCONV="no"])
 AM_COND_IF([WITH_V4L2_CTL_LIBV4L], [USE_V4L2_CTL="yes"], [USE_V4L2_CTL="no"])
-AM_COND_IF([WITH_V4L2_CTL_STREAM_TO], [USE_V4L2_CTL="yes"], [USE_V4L2_CTL="no"])
 AM_COND_IF([WITH_V4L2_COMPLIANCE_LIBV4L], [USE_V4L2_COMPLIANCE="yes"], [USE_V4L2_COMPLIANCE="no"])
 AS_IF([test "x$alsa_pkgconfig" = "xtrue"], [USE_ALSA="yes"], [USE_ALSA="no"])
 
-- 
1.9.1
