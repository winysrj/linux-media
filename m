Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:43763 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752009AbcHLInI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Aug 2016 04:43:08 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id E607E1800A9
	for <linux-media@vger.kernel.org>; Fri, 12 Aug 2016 10:43:02 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.8] cec fixes and updates
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <38db9040-a08e-823d-5b9e-57c7e3a63790@xs4all.nl>
Date: Fri, 12 Aug 2016 10:43:02 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This is a final set of fixes/updates for the cec framework for 4.8.

It fixes some dubious locking code, two typos in cec-funcs.h, a missing reply
for the Record On/Off messages, improves the documentation, adds a TODO line
and adds a flag to explicitly allow fallback to Unregistered.

That last patch changes the default behavior, so I would like to get that in
for 4.8 rather than waiting for 4.9.

The cec-compliance test we've been working on is nearly done and I hope to
merge that in v4l-utils by Monday. This means we have 99% coverage (only some
CDC HEC tests are missing since that's rarely used). These patches fix some
remaining problems that we've found.

I hope to fix the remaining items from the TODO list for 4.9 so that the
framework can be mainlined soon.

Regards,

	Hans

The following changes since commit b6aa39228966e0d3f0bc3306be1892f87792903a:

  Merge tag 'v4.8-rc1' into patchwork (2016-08-08 07:30:25 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git ceclock

for you to fetch changes up to 8c1704784461c79b2bbc8f3a6b8a65e4c1e42422:

  cec: add item to TODO (2016-08-12 09:52:10 +0200)

----------------------------------------------------------------
Hans Verkuil (7):
      cec: rename cec_devnode fhs_lock to just lock
      cec: improve locking
      cec-funcs.h: fix typo: && should be &
      cec-funcs.h: add reply argument for Record On/Off
      cec: improve dqevent documentation
      cec: add CEC_LOG_ADDRS_FL_ALLOW_UNREG_FALLBACK flag
      cec: add item to TODO

 Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst | 21 ++++++++++++++++++++-
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst          |  8 ++++++--
 drivers/staging/media/cec/TODO                            |  1 +
 drivers/staging/media/cec/cec-adap.c                      | 15 +++++++++------
 drivers/staging/media/cec/cec-api.c                       | 10 +++++-----
 drivers/staging/media/cec/cec-core.c                      | 27 +++++++++++++++------------
 include/linux/cec-funcs.h                                 |  9 ++++++---
 include/linux/cec.h                                       |  5 ++++-
 include/media/cec.h                                       |  2 +-
 9 files changed, 67 insertions(+), 31 deletions(-)
