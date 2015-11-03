Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:44586 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755339AbbKCU6p (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Nov 2015 15:58:45 -0500
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: [v4l-utils 0/5] Misc build fixes
Date: Tue,  3 Nov 2015 21:58:35 +0100
Message-Id: <1446584320-25016-1-git-send-email-thomas.petazzoni@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Here is a small set of fixes against v4l-utils that we have
accumulated in the Buildroot project to fix a number of build
issues. Those build issues are related to linking with the musl C
library, or do linking with the libintl library when the gettext
functions are not provided by the C library (which is what happens the
uClibc C library is used).

Thanks,

Thomas

Peter Seiderer (1):
  dvb/keytable: fix missing libintl linking

Thomas Petazzoni (4):
  libv4lsyscall-priv.h: Use off_t instead of __off_t
  utils: Properly use ENABLE_NLS for locale related code
  utils/v4l2-compliance: Include <fcntl.h> instead of <sys/fcntl.h>
  libv4lsyscall-priv.h: Only define SYS_mmap2 if needed

 lib/libv4l1/v4l1compat.c               |  3 +--
 lib/libv4l2/v4l2convert.c              |  5 ++---
 lib/libv4lconvert/libv4lsyscall-priv.h | 13 +++++--------
 utils/dvb/Makefile.am                  |  8 ++++----
 utils/dvb/dvb-fe-tool.c                |  2 ++
 utils/dvb/dvb-format-convert.c         |  2 ++
 utils/dvb/dvbv5-scan.c                 |  2 ++
 utils/dvb/dvbv5-zap.c                  |  2 ++
 utils/keytable/Makefile.am             |  1 +
 utils/keytable/keytable.c              |  2 ++
 utils/v4l2-compliance/v4l-helpers.h    |  2 +-
 11 files changed, 24 insertions(+), 18 deletions(-)

-- 
2.6.2

