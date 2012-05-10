Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3515 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab2EJFpq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 01:45:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.5] si470x cleanup and framework improvements
Date: Thu, 10 May 2012 07:45:37 +0200
Cc: Tobias Lorenz <tobias.lorenz@gmx.net>,
	Joonyoung Shim <jy0922.shim@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201205100745.37983.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Another bunch of driver improvements, this time for the si470x.

Tested with my si470x USB device.

Regards,

	Hans


The following changes since commit 121b3ddbe4ad17df77cb7284239be0a63d9a66bd:

  [media] media: videobuf2-dma-contig: quiet sparse noise about plain integer as NULL pointer (2012-05-08 14:35:14 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git si2

for you to fetch changes up to e25eeecbb147eef7683b2be2737cbda7daa06e23:

  radio-si470x-usb: remove autosuspend, implement suspend/resume. (2012-05-10 07:43:19 +0200)

----------------------------------------------------------------
Hans Verkuil (4):
      si470x: Clean up, introduce the control framework.
      si470x: add control event support and more v4l2 compliancy fixes.
      radio-si470x-common.c: remove unnecessary kernel log spam.
      radio-si470x-usb: remove autosuspend, implement suspend/resume.

 drivers/media/radio/si470x/radio-si470x-common.c |  305 +++++++++++++++++----------------------------------------------------------------
 drivers/media/radio/si470x/radio-si470x-i2c.c    |   65 +++++-------------
 drivers/media/radio/si470x/radio-si470x-usb.c    |  265 ++++++++++++++++++++++++++++++----------------------------------------
 drivers/media/radio/si470x/radio-si470x.h        |   14 ++--
 4 files changed, 199 insertions(+), 450 deletions(-)
