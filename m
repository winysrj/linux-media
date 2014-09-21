Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4578 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaIUJRE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Sep 2014 05:17:04 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209])
	(authenticated bits=0)
	by smtp-vbr11.xs4all.nl (8.13.8/8.13.8) with ESMTP id s8L9H0UP094333
	for <linux-media@vger.kernel.org>; Sun, 21 Sep 2014 11:17:02 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 0D0F52A002F
	for <linux-media@vger.kernel.org>; Sun, 21 Sep 2014 11:16:55 +0200 (CEST)
Message-ID: <541E9786.8050701@xs4all.nl>
Date: Sun, 21 Sep 2014 11:16:54 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.17] Various bug/regression fixes for 3.17
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This collects my set of 3.17 patches, including the vb2 poll regression fix.

I have also included the poll documentation fixes here, but if you prefer to
add those to 3.18 instead, then that's fine by me.

Besides this pull request for 3.17 I have two other pull requests for 3.17 as
well that have not yet been merged:

https://patchwork.linuxtv.org/patch/25162/
https://patchwork.linuxtv.org/patch/25824/

And this cx18 fix for 3.17 is currently in your fixes branch, but not yet
upstream: https://patchwork.linuxtv.org/patch/25572/

Regards,

	Hans

The following changes since commit f5281fc81e9a0a3e80b78720c5ae2ed06da3bfae:

  [media] vpif: Fix compilation with allmodconfig (2014-09-09 18:08:08 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.17k

for you to fetch changes up to cd36be2ddfd6ff0ff823546caa03fb9a05dae54a:

  DocBook media: improve the poll() documentation (2014-09-21 11:00:12 +0200)

----------------------------------------------------------------
Hans Verkuil (6):
      adv7604: fix inverted condition
      cx24123: fix kernel oops due to missing parent pointer
      cx2341x: fix kernel oops
      vb2: fix VBI/poll regression
      DocBook media: fix the poll() 'no QBUF' documentation
      DocBook media: improve the poll() documentation

 Documentation/DocBook/media/v4l/func-poll.xml | 35 +++++++++++++++++++++++++++++------
 drivers/media/common/cx2341x.c                |  1 +
 drivers/media/dvb-frontends/cx24123.c         |  1 +
 drivers/media/i2c/adv7604.c                   |  2 +-
 drivers/media/v4l2-core/videobuf2-core.c      | 17 ++++++++++++++---
 include/media/videobuf2-core.h                |  4 ++++
 6 files changed, 50 insertions(+), 10 deletions(-)
