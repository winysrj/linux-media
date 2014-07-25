Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4229 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbaGYHUe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 03:20:34 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr4.xs4all.nl (8.13.8/8.13.8) with ESMTP id s6P7KSBS026960
	for <linux-media@vger.kernel.org>; Fri, 25 Jul 2014 09:20:32 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id A1A202A037E
	for <linux-media@vger.kernel.org>; Fri, 25 Jul 2014 09:20:27 +0200 (CEST)
Message-ID: <53D2053B.1080802@xs4all.nl>
Date: Fri, 25 Jul 2014 09:20:27 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.17] Two code fixes, two doc fixes
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Two vb2 patches: one fixes outdated comments, one fixes a poll bug w.r.t. output
streams (found while adding output streaming support to qv4l2).

One v4l2-ctrls enhancement: simplify how controls are set from within the kernel
and add a function to set a string controls.

One DocBook clarification how data_offset works.

Regards,

	Hans

The following changes since commit 488046c237f3b78f91046d45662b318cd2415f64:

  [media] rc: Fix compilation of st_rc and sunxi-cir (2014-07-23 23:04:17 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.17f

for you to fetch changes up to 2c10f031e7bf44c22660deb2bf9d0c0be1bf8491:

  vb2: fix vb2_poll for output streams (2014-07-25 09:12:12 +0200)

----------------------------------------------------------------
Hans Verkuil (4):
      Docbook/media: improve data_offset/bytesused documentation
      v4l2-ctrls: add support for setting string controls
      vb2: fix videobuf2-core.h comments
      vb2: fix vb2_poll for output streams

 Documentation/DocBook/media/v4l/io.xml   |  7 ++++++-
 drivers/media/v4l2-core/v4l2-ctrls.c     | 47 ++++++++++++++++++++---------------------------
 drivers/media/v4l2-core/videobuf2-core.c |  7 +++++++
 include/media/v4l2-ctrls.h               | 24 ++++++++++++++++++++++++
 include/media/videobuf2-core.h           | 16 ++++++++++------
 5 files changed, 67 insertions(+), 34 deletions(-)
