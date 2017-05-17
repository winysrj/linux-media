Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:43196 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753558AbdEQIDl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 May 2017 04:03:41 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC: <linux-media@vger.kernel.org>,
        Gregor Jasny <gjasny@googlemail.com>,
        Christophe Priouzeau <christophe.priouzeau@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Subject: [PATCH v1 2/5] configure.ac: revisit v4l2-ctl/compliance using libv4l variable naming
Date: Wed, 17 May 2017 10:03:09 +0200
Message-ID: <1495008192-21202-3-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1495008192-21202-1-git-send-email-hugues.fruchet@st.com>
References: <1495008192-21202-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

USE_V4L2_CTL and USE_V4L2_COMPLIANCE are used to trig the fact that
v4l2-ctl and v4l2-compliance are using libv4l2, change namings to not
confuse with overall v4l2-ctl/compliance utilities building.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 configure.ac | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/configure.ac b/configure.ac
index e8b86a5..0ce5082 100644
--- a/configure.ac
+++ b/configure.ac
@@ -471,8 +471,8 @@ AM_COND_IF([WITH_QV4L2], [USE_QV4L2="yes"], [USE_QV4L2="no"])
 AM_COND_IF([WITH_V4L_PLUGINS], [USE_V4L_PLUGINS="yes"], [USE_V4L_PLUGINS="no"])
 AM_COND_IF([WITH_V4L_WRAPPERS], [USE_V4L_WRAPPERS="yes"], [USE_V4L_WRAPPERS="no"])
 AM_COND_IF([WITH_GCONV], [USE_GCONV="yes"], [USE_GCONV="no"])
-AM_COND_IF([WITH_V4L2_CTL_LIBV4L], [USE_V4L2_CTL="yes"], [USE_V4L2_CTL="no"])
-AM_COND_IF([WITH_V4L2_COMPLIANCE_LIBV4L], [USE_V4L2_COMPLIANCE="yes"], [USE_V4L2_COMPLIANCE="no"])
+AM_COND_IF([WITH_V4L2_CTL_LIBV4L], [USE_V4L2_CTL_LIBV4L="yes"], [USE_V4L2_CTL_LIBV4L="no"])
+AM_COND_IF([WITH_V4L2_COMPLIANCE_LIBV4L], [USE_V4L2_COMPLIANCE_LIBV4L="yes"], [USE_V4L2_COMPLIANCE_LIBV4L="no"])
 AS_IF([test "x$alsa_pkgconfig" = "xtrue"], [USE_ALSA="yes"], [USE_ALSA="no"])
 
 AC_OUTPUT
@@ -507,6 +507,6 @@ compile time options summary
     dvbv5-daemon               : $USE_DVBV5_REMOTE
     v4lutils                   : $USE_V4LUTILS
     qv4l2                      : $USE_QV4L2
-    v4l2-ctl uses libv4l       : $USE_V4L2_CTL
-    v4l2-compliance uses libv4l: $USE_V4L2_COMPLIANCE
+    v4l2-ctl uses libv4l       : $USE_V4L2_CTL_LIBV4L
+    v4l2-compliance uses libv4l: $USE_V4L2_COMPLIANCE_LIBV4L
 EOF
-- 
1.9.1
