Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:53831 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756538AbcCDK7w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Mar 2016 05:59:52 -0500
Received: from [192.168.1.137] (marune.xs4all.nl [80.101.105.217])
	by tschai.lan (Postfix) with ESMTPSA id E40401809C5
	for <linux-media@vger.kernel.org>; Fri,  4 Mar 2016 11:59:46 +0100 (CET)
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.5] v4l2 core fixes/enhancements
Message-ID: <56D96AA2.4010107@xs4all.nl>
Date: Fri, 4 Mar 2016 11:59:46 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The first two patches fix a bug in the core cropcap handling. I found this
while reviewing the upcoming r-car vin driver.

The last three patches add core support for the device_caps. Having this in
place gives the core a lot more knowledge about the capabilities of v4l2
device nodes. I plan to eventually convert all drivers to use this. But the
first step is to get the core support in place.

One other reason for doing this is that it makes it possible to test if a
v4l2 entity has I/O support. See patch https://patchwork.linuxtv.org/patch/33275/
for that (not included in this pull request since nobody needs it yet).

Regards,

	Hans

The following changes since commit 1913722808e79ded46b3bd9ab5de5657faecc8d9:

  [media] staging/media: add missing TODO files (2016-03-03 18:29:14 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.6g

for you to fetch changes up to 2383d1694e0fe1400bcdf4ec37f5a0a48fe4c372:

  vivid: set device_caps in video_device. (2016-03-04 11:49:28 +0100)

----------------------------------------------------------------
Hans Verkuil (5):
      v4l2-ioctl: simplify code
      v4l2-ioctl: improve cropcap handling
      v4l2: add device_caps to struct video_device
      v4l2-pci-skeleton.c: fill in device_caps in video_device
      vivid: set device_caps in video_device.

 Documentation/video4linux/v4l2-pci-skeleton.c |  5 ++---
 drivers/media/platform/vivid/vivid-core.c     | 22 +++++++---------------
 drivers/media/v4l2-core/v4l2-ioctl.c          | 74 ++++++++++++++++++++++++++++++++++++++++++++++++--------------------------
 include/media/v4l2-dev.h                      |  3 +++
 4 files changed, 60 insertions(+), 44 deletions(-)
