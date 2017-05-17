Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:51211 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751676AbdEQIDj (ORCPT
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
Subject: [PATCH v1 0/5] v4l-utils build on buildroot with no-MMU devices
Date: Wed, 17 May 2017 10:03:07 +0200
Message-ID: <1495008192-21202-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In order to pass V4L2 compliancy tests on STM32 devices -which are MMU less-,
compliancy utilities -at least v4l2-compliance and cec-compliance- have to be built.
Unfortunately the support of shared libraries (dlopen()) and fork() is a must
have in v4l-utils.
This have been fixed by:
- revisiting --disable-libv4l to --disable-dyn-libv4l; first naming
  suggests that libv4l will not be built which is not the case
  (only the dynamic support of libv4l is disabled in this case)
- for the sake of coherency, configure.ac variables USE_V4L2_CTL & USE_V4L2_COMPLIANCE
  have been changed to USE_V4L2_CTL_LIBV4L & USE_V4L2_COMPLIANCE_LIBV4L
  for the same reason.
- adding an option --disable-libv4l to really not build libv4l
  - libraries which require dlopen() and libv4lconvert which
    require fork(). For the sake of simplicity, the entire lib/ folder
    is not built with this option.
  - The contrib/ folder is also not built in that case because of its dependency
    on libv4l/libv4lconvert libraries.
  - The utility rds-ctl is also not built for the same reason.
  - configure.ac is also fixed to not trig error on dlopen() missing, further
    test on "enable_shared" will automatically disable the build of libv4l
    and items which have libv4l has dependency.
- fix configure.ac to allow build of v4l-utils utilities with uclinux.


This have been tested on buildroot build system with following patch
to let throw build even if no MMU and no shared libraries support
(those patches will be upstreamed on buildroot side):
package/libv4l/Config.in
config BR2_PACKAGE_LIBV4L
	bool "libv4l"
	depends on BR2_TOOLCHAIN_HAS_THREADS
-	depends on BR2_USE_MMU # fork()
-	depends on !BR2_STATIC_LIBS # dlopen()

config BR2_PACKAGE_LIBV4L_UTILS
	bool "v4l-utils tools"
-	depends on BR2_ENABLE_LOCALE


===========
= history =
===========
version 1:
  - Initial submission


Hugues Fruchet (5):
  configure.ac: fix wrong summary if --disable-v4l2-ctl-stream-to
  configure.ac: revisit v4l2-ctl/compliance using libv4l variable naming
  configure.ac: revisit --disable-libv4l to --disable-dyn-libv4l
  configure.ac: add --disable-libv4l option
  configure.ac: fix build of v4l-utils on uclinux

 Makefile.am                       | 11 +++++++++--
 configure.ac                      | 33 +++++++++++++++++++++------------
 lib/libv4l1/Makefile.am           |  2 +-
 lib/libv4l2/Makefile.am           |  2 +-
 lib/libv4l2rds/Makefile.am        |  2 +-
 lib/libv4lconvert/Makefile.am     |  2 +-
 utils/Makefile.am                 |  6 +++++-
 utils/v4l2-compliance/Makefile.am |  4 ++++
 utils/v4l2-ctl/Makefile.am        |  4 ++++
 9 files changed, 47 insertions(+), 19 deletions(-)

-- 
1.9.1
