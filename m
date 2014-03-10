Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2637 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbaCJMpY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 08:45:24 -0400
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr13.xs4all.nl (8.13.8/8.13.8) with ESMTP id s2ACjKSM007929
	for <linux-media@vger.kernel.org>; Mon, 10 Mar 2014 13:45:22 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id EC91D2A1889
	for <linux-media@vger.kernel.org>; Mon, 10 Mar 2014 13:45:19 +0100 (CET)
Message-ID: <531DB3DF.6000301@xs4all.nl>
Date: Mon, 10 Mar 2014 13:45:19 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.14] Three fixes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Three small fixes for 3.14:

- while working on the EDID changes Laurent discovered that the ioctl numbers
  specified in v4l2-compat-ioctl32 were wrong and have been from the beginning.
  Fix that. NOTE: this patch was also included with the 3.15 EDID pull request
  I posted today.

- The v4l2-dv-timings module was missing the module name, description and license.
  Because of the missing license any driver that loads that module will taint the
  kernel. Definitely not what I intended.

- Fix a saa7134 suspend bug: https://bugzilla.kernel.org/show_bug.cgi?id=69581

Regards,

	Hans

The following changes since commit bfd0306462fdbc5e0a8c6999aef9dde0f9745399:

  [media] v4l: Document timestamp buffer flag behaviour (2014-03-05 16:48:28 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.14f

for you to fetch changes up to b500d6a1664622cb7ba6ad27a1bc2bbce1022587:

  saa7134: fix WARN_ON during resume. (2014-03-07 12:11:19 +0100)

----------------------------------------------------------------
Hans Verkuil (3):
      v4l2-compat-ioctl32: fix wrong VIDIOC_SUBDEV_G/S_EDID32 support.
      v4l2-dv-timings: add module name, description, license.
      saa7134: fix WARN_ON during resume.

 drivers/media/pci/saa7134/saa7134-cards.c     | 4 ++--
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 4 ++--
 drivers/media/v4l2-core/v4l2-dv-timings.c     | 4 ++++
 3 files changed, 8 insertions(+), 4 deletions(-)
