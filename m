Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:58497 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733Ab3H3M3i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Aug 2013 08:29:38 -0400
Received: by mail-ea0-f175.google.com with SMTP id m14so873163eaj.20
        for <linux-media@vger.kernel.org>; Fri, 30 Aug 2013 05:29:37 -0700 (PDT)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, m.chehab@samsung.com,
	hans.verkuil@cisco.com
Cc: Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH 0/4] fix compilation issues with GCC < 4.4.6
Date: Fri, 30 Aug 2013 14:29:21 +0200
Message-Id: <1377865765-25203-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With GCC 4.4.3 (Ubuntu 10.04) the compilation of the new adv7842 driver
fails with this error:

CC [M]  adv7842.o
adv7842.c:549: error: unknown field 'bt' specified in initializer
adv7842.c:550: error: field name not in record or union initializer
adv7842.c:550: error: (near initialization for 'adv7842_timings_cap_analog.reserved')
adv7842.c:551: error: field name not in record or union initializer
adv7842.c:551: error: (near initialization for 'adv7842_timings_cap_analog.reserved')
adv7842.c:552: error: field name not in record or union initializer
adv7842.c:552: error: (near initialization for 'adv7842_timings_cap_analog.reserved')
adv7842.c:553: error: field name not in record or union initializer
adv7842.c:553: error: (near initialization for 'adv7842_timings_cap_analog.reserved')
adv7842.c:553: warning: excess elements in array initializer
...

This is caused by the old GCC version (as explained in file v4l2-dv-timings.h).
The proposed fix uses the V4L2_INIT_BT_TIMINGS macro defined there.
Please note that we need to init the reserved space as well, as otherwise GCC
will fail with another error:

CC [M]  adv7842.o
adv7842.c:549: error: field name not in record or union initializer
adv7842.c:549: error: (near initialization for 'adv7842_timings_cap_analog.reserved')
adv7842.c:549: warning: braces around scalar initializer
adv7842.c:549: warning: (near initialization for 'adv7842_timings_cap_analog.reserved[0]')
...

A proper comment was added as a remainder.

The same issue applies to other drivers too: ths8200, adv7511, ad9389b.
The present patch series fixes all of them.

Best regards,
Gianluca

Gianluca Gennari (4):
  adv7842: fix compilation with GCC < 4.4.6
  adv7511: fix compilation with GCC < 4.4.6
  ad9389b: fix compilation with GCC < 4.4.6
  ths8200: fix compilation with GCC < 4.4.6

 drivers/media/i2c/ad9389b.c | 15 ++++++---------
 drivers/media/i2c/adv7511.c | 16 +++++++---------
 drivers/media/i2c/adv7842.c | 30 ++++++++++++------------------
 drivers/media/i2c/ths8200.c | 12 ++++--------
 4 files changed, 29 insertions(+), 44 deletions(-)

-- 
1.8.4

