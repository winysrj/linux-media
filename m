Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:25064 "EHLO
        aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726056AbeJHTkU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2018 15:40:20 -0400
From: bwinther@cisco.com
To: linux-media@vger.kernel.org
Cc: hans.verkuil@cisco.com,
        =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
Subject: [PATCH 4/4] utils: Add qvidcap to configure status report
Date: Mon,  8 Oct 2018 14:28:47 +0200
Message-Id: <20181008122847.25600-4-bwinther@cisco.com>
In-Reply-To: <20181008122847.25600-1-bwinther@cisco.com>
References: <20181008122847.25600-1-bwinther@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Bård Eirik Winther <bwinther@cisco.com>

Add missing build status flag for qvidcap to the configuration report

Signed-off-by: Bård Eirik Winther <bwinther@cisco.com>
---
 configure.ac | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/configure.ac b/configure.ac
index 2765fbfc..90ef10aa 100644
--- a/configure.ac
+++ b/configure.ac
@@ -518,6 +518,7 @@ AM_COND_IF([WITH_DVBV5_REMOTE], [USE_DVBV5_REMOTE="yes"
 AM_COND_IF([WITH_DYN_LIBV4L], [USE_DYN_LIBV4L="yes"], [USE_DYN_LIBV4L="no"])
 AM_COND_IF([WITH_V4LUTILS], [USE_V4LUTILS="yes"], [USE_V4LUTILS="no"])
 AM_COND_IF([WITH_QV4L2], [USE_QV4L2="yes"], [USE_QV4L2="no"])
+AM_COND_IF([WITH_QVIDCAP], [USE_QVIDCAP="yes"], [USE_QVIDCAP="no"])
 AM_COND_IF([WITH_V4L_PLUGINS], [USE_V4L_PLUGINS="yes"
 				AC_DEFINE([HAVE_V4L_PLUGINS], [1], [V4L plugin support enabled])],
 				[USE_V4L_PLUGINS="no"])
@@ -566,6 +567,7 @@ compile time options summary
     dvbv5-daemon               : $USE_DVBV5_REMOTE
     v4lutils                   : $USE_V4LUTILS
     qv4l2                      : $USE_QV4L2
+    qvidcap                    : $USE_QVIDCAP
     v4l2-ctl uses libv4l       : $USE_V4L2_CTL_LIBV4L
     v4l2-compliance uses libv4l: $USE_V4L2_COMPLIANCE_LIBV4L
 EOF
-- 
2.17.1
