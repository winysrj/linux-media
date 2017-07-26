Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:37894 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751542AbdGZMvt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Jul 2017 08:51:49 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC: <linux-media@vger.kernel.org>,
        Gregor Jasny <gjasny@googlemail.com>,
        Christophe Priouzeau <christophe.priouzeau@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: [PATCH v2] Build libv4lconvert helper support only when fork() is available.
Date: Wed, 26 Jul 2017 14:51:23 +0200
Message-ID: <1501073484-9193-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Build libv4lconvert helper support only when fork() is available.
This fix the build issue reported here:
http://autobuild.buildroot.net/results/7e8/7e8fbd99a8c091d7bbeedd16066297682bbe29fe/build-end.log

More details on buildroot mailing list here:
http://lists.buildroot.org/pipermail/buildroot/2017-July/199093.html

===========
= history =
===========
version 2:
  - point to http://autobuild.buildroot.org build result
  - revisit Author & Signed-off-by

version 1:
  - Initial submission

Thomas Petazzoni (1):
  Build libv4lconvert helper support only when fork() is available

 configure.ac                      | 3 +++
 lib/libv4lconvert/Makefile.am     | 7 ++++++-
 lib/libv4lconvert/libv4lconvert.c | 6 ++++++
 3 files changed, 15 insertions(+), 1 deletion(-)

-- 
1.9.1
