Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:38603 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752121AbbCPLsD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2015 07:48:03 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id B1C522A0080
	for <linux-media@vger.kernel.org>; Mon, 16 Mar 2015 12:47:53 +0100 (CET)
Message-ID: <5506C2E9.1080008@xs4all.nl>
Date: Mon, 16 Mar 2015 12:47:53 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v4.1] sur40 driver and two small DocBook fixes
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds video capture support to the sur40 input driver.

To quote the author:

"The SUR40 is a quite peculiar touchscreen device which does
on-board image processing to provide touch data, but also allows to
retrieve the raw video image. Unfortunately, it's a single USB device
with two endpoints for the different data types, so everything (input &
video) needs to be squeezed into one driver."

Regards,

	Hans

The following changes since commit 3d945be05ac1e806af075e9315bc1b3409adae2b:

  [media] mn88473: simplify bandwidth registers setting code (2015-03-03 13:09:12 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.1m

for you to fetch changes up to 69dc25b1cd764181a6b8c5b16b753ab645b3d55b:

  add raw video stream support for Samsung SUR40 (2015-03-16 12:43:10 +0100)

----------------------------------------------------------------
Florian Echtler (1):
      add raw video stream support for Samsung SUR40

Hans Verkuil (2):
      DocBook media: fix VIDIOC_CROPCAP type description
      DocBook media: fix awkward language in VIDIOC_QUERYCAP

 Documentation/DocBook/media/v4l/vidioc-cropcap.xml     |   9 +-
 Documentation/DocBook/media/v4l/vidioc-g-crop.xml      |   5 +
 Documentation/DocBook/media/v4l/vidioc-g-selection.xml |   4 +-
 Documentation/DocBook/media/v4l/vidioc-querycap.xml    |   8 +-
 drivers/input/touchscreen/Kconfig                      |   2 +
 drivers/input/touchscreen/sur40.c                      | 429 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 6 files changed, 436 insertions(+), 21 deletions(-)
