Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:45713 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752260AbaKCPjP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Nov 2014 10:39:15 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 41B702A0376
	for <linux-media@vger.kernel.org>; Mon,  3 Nov 2014 16:39:10 +0100 (CET)
Message-ID: <5457A19E.6060103@xs4all.nl>
Date: Mon, 03 Nov 2014 16:39:10 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.19] Two patches
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit e5f3d00c243177f4d7a0e86d17b7eaefd4a0c908:

  [media] cxusb: TS mode setting for TT CT2-4400 (2014-11-03 12:26:56 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.19d

for you to fetch changes up to 4a8ac3bdaec3b76745b7fe6a7387290e2743349a:

  DocBook media: Clarify V4L2_FIELD_ANY for drivers (2014-11-03 15:59:04 +0100)

----------------------------------------------------------------
Johann Klammer (1):
      saa7146: turn bothersome error into a debug message

Simon Farnsworth (1):
      DocBook media: Clarify V4L2_FIELD_ANY for drivers

 Documentation/DocBook/media/v4l/io.xml      | 5 ++++-
 drivers/media/common/saa7146/saa7146_core.c | 2 +-
 2 files changed, 5 insertions(+), 2 deletions(-)
