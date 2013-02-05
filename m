Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2927 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459Ab3BEOYa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Feb 2013 09:24:30 -0500
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166])
	(authenticated bits=0)
	by smtp-vbr13.xs4all.nl (8.13.8/8.13.8) with ESMTP id r15EOQ4N027008
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Tue, 5 Feb 2013 15:24:29 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 0EA0611E00AF
	for <linux-media@vger.kernel.org>; Tue,  5 Feb 2013 15:24:26 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.9] v4l2-compliance fixes for radio-miropcm20
Date: Tue, 5 Feb 2013 15:24:25 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201302051524.25825.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These patches upgrade radio-miropcm20 to the latest frameworks. Tested on
actual hardware.

Unchanged from the RFC patches posted a week ago.

Regards,

	Hans

The following changes since commit a32f7d1ad3744914273c6907204c2ab3b5d496a0:

  Merge branch 'v4l_for_linus' into staging/for_v3.9 (2013-01-24 18:49:18 -0200)

are available in the git repository at:


  git://linuxtv.org/hverkuil/media_tree.git miro

for you to fetch changes up to 581ac0cef5a2416ccce014551f75eebeaaf16f5a:

  radio-miropcm20: fix signal and stereo indication. (2013-01-30 15:27:15 +0100)

----------------------------------------------------------------
Hans Verkuil (6):
      radio-miropcm20: fix querycap.
      radio-miropcm20: remove input/audio ioctls
      radio-miropcm20: convert to the control framework.
      radio-miropcm20: add prio and control event support.
      radio-miropcm20: Fix audmode/tuner/frequency handling
      radio-miropcm20: fix signal and stereo indication.

 drivers/media/radio/radio-miropcm20.c |  173 ++++++++++++++++++++++++++++++++++++++++++++-------------------------------------------------------------
 1 file changed, 72 insertions(+), 101 deletions(-)
