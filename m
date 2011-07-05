Return-path: <mchehab@pedra>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2474 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab1GEKZA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jul 2011 06:25:00 -0400
Received: from tschai.localnet (64-103-25-233.cisco.com [64.103.25.233])
	(authenticated bits=0)
	by smtp-vbr14.xs4all.nl (8.13.8/8.13.8) with ESMTP id p65AOwmq095034
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 5 Jul 2011 12:24:59 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PATCHES FOR 3.1] Various fixes: v4l2-ctrls.c, vivi and DocBook
Date: Tue, 5 Jul 2011 12:24:58 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201107051224.58886.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Some small stuff: a fix for a copy-and-paste error introduced in v4l2-ctrls.c,
a fix for a missing event, a DocBook typo fix and the vivi sleep-in-atomic
context fix that I posted earlier as a separate patch.

Regards,

	Hans

The following changes since commit df6aabbeb2b8799d97f3886fc994c318bc6a6843:

  [media] v4l2-ctrls.c: add support for V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK (2011-07-01 20:54:51 -0300)

are available in the git repository at:
  ssh://linuxtv.org/git/hverkuil/media_tree.git fixes

Hans Verkuil (4):
      v4l2-ctrls.c: copy-and-paste error: user_to_new -> new_to_user
      v4l2-ctrls: always send an event if a control changed implicitly
      DocBook: fix typo: vl42_plane_pix_format -> v4l2_plane_pix_format
      vivi: Fix sleep-in-atomic-context

 Documentation/DocBook/media/v4l/pixfmt.xml |    2 +-
 drivers/media/video/v4l2-ctrls.c           |    9 +++++++--
 drivers/media/video/vivi.c                 |    6 +++---
 3 files changed, 11 insertions(+), 6 deletions(-)
