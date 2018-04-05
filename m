Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:62600 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751038AbeDEK7L (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Apr 2018 06:59:11 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: tfiga@google.com, hverkuil@xs4all.nl
Subject: [v4l-utils RFC 0/6] Mediatext test program for request API tests
Date: Thu,  5 Apr 2018 13:58:13 +0300
Message-Id: <1522925899-14073-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

Here's a refreshed RFC set to add the mediatext test program. It is well
suited for testing requests, as it can work with multiple devices
simultaneously as well as is easy to control through a bash script.

Only buffers are supported with requests, controls are not yet; still
adding support for controls wouldn't be much of work. I'm posting this as
RFC as the API coverage isn't great. What works now (as in this test
program) is requests with vim2m --- two bash scripts are included in the
last patch for that. The request API set v9 requires some adjusting, I
haven't tested v10 yet.

I'd say this is much closer being a meaningful part of v4l-utils, assuming
more test programs are seen to fit there.

Comments would be welcome.

Sakari Ailus (6):
  Linux kernel header update
  Make v4l-utils compile with request-related changes
  libmediactl: Add open, close and fd to public API
  mediatext: Extract list of V4L2 pixel format strings and 4cc codes
  mediatext: Add library
  mediatext: Add vivid tests

 include/linux/cec-funcs.h                    |  300 ++--
 include/linux/cec.h                          |   40 +-
 include/linux/media.h                        |    8 +
 include/linux/v4l2-dv-timings.h              |  979 ++++++++++++
 include/linux/videodev2.h                    |   14 +-
 lib/libv4l2/libv4l2.c                        |    4 +-
 libmediatext.pc.in                           |   10 +
 utils/media-ctl/Makefile.am                  |   18 +-
 utils/media-ctl/libmediactl.c                |    9 +-
 utils/media-ctl/libmediatext.pc.in           |   10 +
 utils/media-ctl/mediactl.h                   |    4 +
 utils/media-ctl/mediatext-test.c             |  127 ++
 utils/media-ctl/mediatext.c                  | 2176 ++++++++++++++++++++++++++
 utils/media-ctl/mediatext.h                  |   33 +
 utils/media-ctl/tests/test-vivid-mc.bash     |   86 +
 utils/media-ctl/tests/test-vivid.bash        |   59 +
 utils/v4l2-compliance/v4l2-test-buffers.cpp  |    2 +-
 utils/v4l2-compliance/v4l2-test-controls.cpp |    4 -
 18 files changed, 3699 insertions(+), 184 deletions(-)
 create mode 100644 include/linux/v4l2-dv-timings.h
 create mode 100644 libmediatext.pc.in
 create mode 100644 utils/media-ctl/libmediatext.pc.in
 create mode 100644 utils/media-ctl/mediatext-test.c
 create mode 100644 utils/media-ctl/mediatext.c
 create mode 100644 utils/media-ctl/mediatext.h
 create mode 100755 utils/media-ctl/tests/test-vivid-mc.bash
 create mode 100755 utils/media-ctl/tests/test-vivid.bash

-- 
2.7.4
