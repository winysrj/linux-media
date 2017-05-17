Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:57939 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751676AbdEQIDn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 May 2017 04:03:43 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC: <linux-media@vger.kernel.org>,
        Gregor Jasny <gjasny@googlemail.com>,
        Christophe Priouzeau <christophe.priouzeau@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Subject: [PATCH v1 5/5] configure.ac: fix build of v4l-utils on uclinux
Date: Wed, 17 May 2017 10:03:12 +0200
Message-ID: <1495008192-21202-6-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1495008192-21202-1-git-send-email-hugues.fruchet@st.com>
References: <1495008192-21202-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Build of v4-utils is conditional to "linux_os=yes" which was
not set in case of uclinux, fix this.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 26dc18d..1af7408 100644
--- a/configure.ac
+++ b/configure.ac
@@ -150,7 +150,7 @@ AC_HEADER_MAJOR
 
 # Check host os
 case "$host_os" in
-  linux*)
+  *linux*)
     linux_os="yes"
     ;;
   *freebsd*)
-- 
1.9.1
