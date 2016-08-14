Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:51489 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752904AbcHNKHN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Aug 2016 06:07:13 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 4A3F0180AA9
	for <linux-media@vger.kernel.org>; Sun, 14 Aug 2016 12:07:08 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.8] fixes and updates (mostly cec-related)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <d3c89ce0-d96b-ff3f-44c1-1d907bad3473@xs4all.nl>
Date: Sun, 14 Aug 2016 12:07:08 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

These are (regression) fixes for 4.8, mostly related to the cec framework.

It fixes some dubious locking code, two typos in cec-funcs.h, a missing reply
for the Record On/Off messages, improves the documentation, adds a TODO line,
adds a flag to explicitly allow fallback to Unregistered and prevents
broadcast messages from being processed when they should be ignored.

The CEC_LOG_ADDRS_FL_ALLOW_UNREG_FALLBACK patch changes the default behavior,
so I would like to get that in for 4.8 rather than waiting for 4.9.

The cec-compliance test we've been working on is nearly done and I hope to
merge that in v4l-utils by Monday. This means we have 99% coverage (only some
CDC HEC tests are missing since that's rarely used). These patches fix some
remaining problems that we've found.

I hope to fix the remaining items from the TODO list for 4.9 so that the
framework can be mainlined soon.

There are three other patches: the mediatek patch adds a missing HAS_DMA
dependency to shut the kbuild robot up, and there are two fixes for the pulse8-cec
driver. Many thanks to Pulse-Eight for providing me with the information
necessary for these two patches.

Regards,

	Hans

Note: this supersedes my previous "cec fixes and updates" pull request.

The following changes since commit b6aa39228966e0d3f0bc3306be1892f87792903a:

  Merge tag 'v4.8-rc1' into patchwork (2016-08-08 07:30:25 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.8a

for you to fetch changes up to 68373dd7572958e5b8ada02845899577b2c9772d:

  pulse8-cec: fix error handling (2016-08-14 12:06:08 +0200)

----------------------------------------------------------------
Hans Verkuil (11):
      cec: rename cec_devnode fhs_lock to just lock
      cec: improve locking
      cec-funcs.h: fix typo: && should be &
      cec-funcs.h: add reply argument for Record On/Off
      cec: improve dqevent documentation
      cec: add CEC_LOG_ADDRS_FL_ALLOW_UNREG_FALLBACK flag
      cec: add item to TODO
      cec: ignore messages when log_addr_mask == 0
      mtk-vcodec: add HAS_DMA dependency
      pulse8-cec: set correct Signal Free Time
      pulse8-cec: fix error handling

 Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst | 21 ++++++++++++++++++++-
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst          |  8 ++++++--
 drivers/media/platform/Kconfig                            |  2 +-
 drivers/staging/media/cec/TODO                            |  1 +
 drivers/staging/media/cec/cec-adap.c                      | 18 ++++++++++++------
 drivers/staging/media/cec/cec-api.c                       | 10 +++++-----
 drivers/staging/media/cec/cec-core.c                      | 27 +++++++++++++++------------
 drivers/staging/media/pulse8-cec/pulse8-cec.c             | 10 +++++-----
 include/linux/cec-funcs.h                                 |  9 ++++++---
 include/linux/cec.h                                       |  5 ++++-
 include/media/cec.h                                       |  2 +-
 11 files changed, 76 insertions(+), 37 deletions(-)
