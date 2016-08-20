Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:41548 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751824AbcHTK5w (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 20 Aug 2016 06:57:52 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by tschai.lan (Postfix) with ESMTPSA id 8C0BD1800DD
        for <linux-media@vger.kernel.org>; Sat, 20 Aug 2016 12:57:47 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.8] Fixes and updates (mostly cec-related) (v4)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <ab7e5515-034c-f711-a3f1-8629e360e001@xs4all.nl>
Date: Sat, 20 Aug 2016 12:57:47 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

These are (regression) fixes for 4.8, mostly related to the cec framework.

It fixes some dubious locking code, two typos in cec-funcs.h, a missing reply
for the Record On/Off messages, improves the documentation, adds a TODO line,
adds a flag to explicitly allow fallback to Unregistered, ensures unclaimed
LAs are set to INVALID, prevents broadcast messages from being processed
when they should be ignored, add a IEEE ID check when locating in physical
address location in the EDID and add three missing wrappers for vendor-specific
messages.

The CEC_LOG_ADDRS_FL_ALLOW_UNREG_FALLBACK patch changes the default behavior,
so I would like to get that in for 4.8 rather than waiting for 4.9.

The cec-compliance test we've been working on is done and merged in v4l-utils.
This means we have 99% coverage (only some CDC HEC tests are missing since
that's rarely used). These patches fix some remaining problems that we've found
while working on this test.

I hope to fix the remaining items from the TODO list for 4.9 so that the
framework can be mainlined soon.

There are three other patches: the mediatek patch adds a missing HAS_DMA
dependency to shut the kbuild robot up, and there are two fixes for the pulse8-cec
driver. Many thanks to Pulse-Eight for providing me with the information
necessary for these two patches.

Regards,

	Hans

v4: add cec-funcs.h: add missing vendor-specific messages
v3: add cec-edid: check for IEEE identifier
v2: fixing a bug in the "cec: add CEC_LOG_ADDRS_FL_ALLOW_UNREG_FALLBACK flag"
patch and adding "cec: set unclaimed addresses to CEC_LOG_ADDR_INVALID".


The following changes since commit b6aa39228966e0d3f0bc3306be1892f87792903a:

  Merge tag 'v4.8-rc1' into patchwork (2016-08-08 07:30:25 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.8a

for you to fetch changes up to 2f70c1614eb6e03efeb85371f7fc451b2cfe2c6f:

  cec-funcs.h: add missing vendor-specific messages (2016-08-20 12:54:38 +0200)

----------------------------------------------------------------
Hans Verkuil (14):
      cec: rename cec_devnode fhs_lock to just lock
      cec: improve locking
      cec-funcs.h: fix typo: && should be &
      cec-funcs.h: add reply argument for Record On/Off
      cec: improve dqevent documentation
      cec: add CEC_LOG_ADDRS_FL_ALLOW_UNREG_FALLBACK flag
      cec: set unclaimed addresses to CEC_LOG_ADDR_INVALID
      cec: add item to TODO
      cec: ignore messages when log_addr_mask == 0
      mtk-vcodec: add HAS_DMA dependency
      pulse8-cec: set correct Signal Free Time
      pulse8-cec: fix error handling
      cec-edid: check for IEEE identifier
      cec-funcs.h: add missing vendor-specific messages

 Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst | 21 +++++++++++-
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst          |  8 +++--
 drivers/media/cec-edid.c                                  |  5 ++-
 drivers/media/platform/Kconfig                            |  2 +-
 drivers/staging/media/cec/TODO                            |  1 +
 drivers/staging/media/cec/cec-adap.c                      | 23 +++++++++----
 drivers/staging/media/cec/cec-api.c                       | 10 +++---
 drivers/staging/media/cec/cec-core.c                      | 27 ++++++++-------
 drivers/staging/media/pulse8-cec/pulse8-cec.c             | 10 +++---
 include/linux/cec-funcs.h                                 | 78 +++++++++++++++++++++++++++++++++++++++++--
 include/linux/cec.h                                       |  5 ++-
 include/media/cec.h                                       |  2 +-
 12 files changed, 154 insertions(+), 38 deletions(-)
