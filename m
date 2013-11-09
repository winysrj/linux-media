Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qe0-f42.google.com ([209.85.128.42]:63116 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756775Ab3KIV6O (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Nov 2013 16:58:14 -0500
Received: by mail-qe0-f42.google.com with SMTP id gc15so3323833qeb.1
        for <linux-media@vger.kernel.org>; Sat, 09 Nov 2013 13:58:13 -0800 (PST)
Date: Sat, 9 Nov 2013 16:58:10 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Subject: [GIT PULL] git://linuxtv.org/mkrufky/dvb fixes
Message-ID: <20131109165810.108e67b3@vujade>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit
80f93c7b0f4599ffbdac8d964ecd1162b8b618b9:

  [media] media: st-rc: Add ST remote control driver (2013-10-31
  08:20:08 -0200)

are available in the git repository at:

  git://linuxtv.org/mkrufky/dvb fixes

for you to fetch changes up to 714fd7f9e8465eda25cce038c642d75a1d84106d:

  cxd2820r_c: fix if_ctl calculation (2013-11-09 16:45:57 -0500)

----------------------------------------------------------------
Alexey Khoroshilov (1):
      dvb_demux: fix deadlock in dmx_section_feed_release_filter()

Evgeny Plehov (1):
      cxd2820r_c: fix if_ctl calculation

Felipe Pena (1):
      technisat-usb2: fix typo in variable name

Michael Krufky (1):
      dvb_demux: clean up whitespace in comments from previous patch
(trivial)

 drivers/media/dvb-core/dvb_demux.c         | 7 ++++++-
 drivers/media/dvb-frontends/cxd2820r_c.c   | 2 +-
 drivers/media/usb/dvb-usb/technisat-usb2.c | 2 +-
 3 files changed, 8 insertions(+), 3 deletions(-)
