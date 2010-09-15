Return-path: <mchehab@pedra>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4771 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab0IOHXw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Sep 2010 03:23:52 -0400
Received: from tschai.localnet (186.84-48-119.nextgentel.com [84.48.119.186])
	(authenticated bits=0)
	by smtp-vbr6.xs4all.nl (8.13.8/8.13.8) with ESMTP id o8F7No1T070828
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 15 Sep 2010 09:23:51 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.37] V4L documentation fixes
Date: Wed, 15 Sep 2010 09:23:50 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201009150923.50132.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The following changes since commit 57fef3eb74a04716a8dd18af0ac510ec4f71bc05:
  Richard Zidlicky (1):
        V4L/DVB: dvb: fix smscore_getbuffer() logic

are available in the git repository at:

  ssh://linuxtv.org/git/hverkuil/v4l-dvb.git misc2

Hans Verkuil (6):
      V4L Doc: removed duplicate link
      V4L Doc: fix DocBook syntax errors.
      V4L Doc: document V4L2_CAP_RDS_OUTPUT capability.
      V4L Doc: clarify the V4L spec.
      V4L Doc: correct the documentation for VIDIOC_QUERYMENU.
      V4L Doc: rewrite the Device Naming section

 Documentation/DocBook/v4l/common.xml               |  197 +++++---------------
 Documentation/DocBook/v4l/controls.xml             |    3 -
 Documentation/DocBook/v4l/pixfmt-packed-rgb.xml    |    2 +-
 Documentation/DocBook/v4l/pixfmt.xml               |    4 +-
 Documentation/DocBook/v4l/vidioc-g-dv-preset.xml   |    3 +-
 Documentation/DocBook/v4l/vidioc-g-dv-timings.xml  |    3 +-
 .../DocBook/v4l/vidioc-query-dv-preset.xml         |    2 +-
 Documentation/DocBook/v4l/vidioc-querycap.xml      |    7 +-
 Documentation/DocBook/v4l/vidioc-queryctrl.xml     |   18 ++-
 9 files changed, 73 insertions(+), 166 deletions(-)
-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
