Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4220 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab2HCOVh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Aug 2012 10:21:37 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr1.xs4all.nl (8.13.8/8.13.8) with ESMTP id q73ELYGS096954
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Fri, 3 Aug 2012 16:21:36 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.186])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 8444746A0181
	for <linux-media@vger.kernel.org>; Fri,  3 Aug 2012 16:21:32 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.6] One DocBook fix and a few si470x v4l2-compliance fixes
Date: Fri, 3 Aug 2012 16:21:33 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201208031621.33976.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Two trivial fixes for 3.6.

Regards,

	Hans

The following changes since commit 24ed693da0cefede7382d498dd5e9a83f0a21c38:

  [media] DVB: dib0700, remove double \n's from log (2012-07-31 00:36:03 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git sifixes

for you to fetch changes up to f4b0bd3f7230c3be81a410a25487baddda6417b6:

  si470x: v4l2-compliance fixes. (2012-08-03 16:16:59 +0200)

----------------------------------------------------------------
Hans Verkuil (2):
      DocBook: Remove a spurious character.
      si470x: v4l2-compliance fixes.

 Documentation/DocBook/media/v4l/vidioc-g-tuner.xml |    2 +-
 drivers/media/radio/si470x/radio-si470x-common.c   |    3 +++
 drivers/media/radio/si470x/radio-si470x-i2c.c      |    5 +++--
 drivers/media/radio/si470x/radio-si470x-usb.c      |    2 +-
 4 files changed, 8 insertions(+), 4 deletions(-)
