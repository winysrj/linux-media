Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4394 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880Ab3BEO13 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Feb 2013 09:27:29 -0500
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166])
	(authenticated bits=0)
	by smtp-vbr7.xs4all.nl (8.13.8/8.13.8) with ESMTP id r15EROf5030587
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Tue, 5 Feb 2013 15:27:27 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 363B211E00AF
	for <linux-media@vger.kernel.org>; Tue,  5 Feb 2013 15:27:24 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.9] v4l2-compliance fixes for c-qcam
Date: Tue, 5 Feb 2013 15:27:24 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201302051527.24170.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These patches fix various compliance issues for c-qcam.
Tested on more-or-less (mostly less) working actual hardware.

Unchanged from the RFC patches posted a week ago.

Regards,

        HansThe following changes since commit a32f7d1ad3744914273c6907204c2ab3b5d496a0:

  Merge branch 'v4l_for_linus' into staging/for_v3.9 (2013-01-24 18:49:18 -0200)

are available in the git repository at:


  git://linuxtv.org/hverkuil/media_tree.git cqcam

for you to fetch changes up to 8cfa5c3bb7b52fa29608bc6372a7015dcc6eadf6:

  c-qcam: add enum_framesizes support. (2013-01-30 18:52:13 +0100)

----------------------------------------------------------------
Hans Verkuil (2):
      c-qcam: fix v4l2-compliance issues.
      c-qcam: add enum_framesizes support.

 drivers/media/parport/c-qcam.c |   34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)
