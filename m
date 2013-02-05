Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3924 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459Ab3BEO0M (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Feb 2013 09:26:12 -0500
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166])
	(authenticated bits=0)
	by smtp-vbr5.xs4all.nl (8.13.8/8.13.8) with ESMTP id r15EQ7JS098938
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Tue, 5 Feb 2013 15:26:10 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 4A68C11E00AF
	for <linux-media@vger.kernel.org>; Tue,  5 Feb 2013 15:26:07 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.9] v4l2-compliance fixes for bw-qcam
Date: Tue, 5 Feb 2013 15:26:07 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201302051526.07226.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These patches upgrade bw-qcam to vb2 and fix various compliance issues.
Tested on actual hardware.

Unchanged from the RFC patches posted a week ago.

Regards,

        Hans

The following changes since commit a32f7d1ad3744914273c6907204c2ab3b5d496a0:

  Merge branch 'v4l_for_linus' into staging/for_v3.9 (2013-01-24 18:49:18 -0200)

are available in the git repository at:


  git://linuxtv.org/hverkuil/media_tree.git bw-qcam

for you to fetch changes up to ca047286f23c0764a990ae19ce7306e3025ac410:

  videobuf2: don't return POLLERR when only polling for events. (2013-01-30 18:15:00 +0100)

----------------------------------------------------------------
Hans Verkuil (4):
      bw-qcam: zero priv field.
      bw-qcam: convert to videobuf2.
      bw-qcam: remove unnecessary qc_reset and qc_setscanmode calls.
      videobuf2: don't return POLLERR when only polling for events.

 drivers/media/parport/Kconfig            |    1 +
 drivers/media/parport/bw-qcam.c          |  165 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------------
 drivers/media/v4l2-core/videobuf2-core.c |    5 ++++
 3 files changed, 120 insertions(+), 51 deletions(-)
