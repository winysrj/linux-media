Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:4463 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751680AbdGZKd7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Jul 2017 06:33:59 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC: <linux-media@vger.kernel.org>,
        Gregor Jasny <gjasny@googlemail.com>,
        Christophe Priouzeau <christophe.priouzeau@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>
Subject: [PATCH v1] Build libv4lconvert helper support only when fork() is available.
Date: Wed, 26 Jul 2017 12:33:35 +0200
Message-ID: <1501065216-1636-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Build libv4lconvert helper support only when fork() is available.
This fix the build issue reported here:
http://lists.buildroot.org/pipermail/buildroot/2017-July/197571.html

Patch made by Thomas Petazzoni:
http://lists.buildroot.org/pipermail/buildroot/2017-July/199093.html

Hugues Fruchet (1):
  Build libv4lconvert helper support only when fork() is available

 configure.ac                      | 3 +++
 lib/libv4lconvert/Makefile.am     | 7 ++++++-
 lib/libv4lconvert/libv4lconvert.c | 6 ++++++
 3 files changed, 15 insertions(+), 1 deletion(-)

-- 
1.9.1
