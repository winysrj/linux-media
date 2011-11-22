Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3740 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab1KVKMF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Nov 2011 05:12:05 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.3] Documentation fixes
Date: Tue, 22 Nov 2011 11:11:59 +0100
Cc: "Hiremath, Vaibhav" <hvaibhav@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201111221111.59441.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are a few documentation fixes based on discussions during the Prague
workshop.

Regards,

	Hans

The following changes since commit 6fd7dba026f17076ac4bd63a3590f993c1f5c2c6:

  [media] get_dvb_firmware: add support for HVR-930C firmware (2011-11-21 10:38:39 -0200)

are available in the git repository at:
  git://linuxtv.org/hverkuil/media_tree.git spec

Hans Verkuil (4):
      V4L spec: fix typo and missing CAP_RDS documentation.
      V4L2 Spec: clarify usage of V4L2_FBUF_FLAG_PRIMARY.
      v4l2 framework doc: clarify locking.
      V4L2 spec: fix the description of V4L2_FBUF_CAP_SRC_CHROMAKEY.

 Documentation/DocBook/media/v4l/dev-rds.xml        |    8 ++++----
 Documentation/DocBook/media/v4l/vidioc-g-fbuf.xml  |   14 ++++++++------
 Documentation/DocBook/media/v4l/vidioc-g-tuner.xml |   10 ++++++++++
 Documentation/video4linux/v4l2-framework.txt       |   11 +++++++++++
 4 files changed, 33 insertions(+), 10 deletions(-)
