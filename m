Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4614 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755780Ab3BEOqq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Feb 2013 09:46:46 -0500
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr15.xs4all.nl (8.13.8/8.13.8) with ESMTP id r15EkhVH099114
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Tue, 5 Feb 2013 15:46:45 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 5380A11E00AF
	for <linux-media@vger.kernel.org>; Tue,  5 Feb 2013 15:46:43 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.9] v4l2-compliance fixes for tm6000
Date: Tue, 5 Feb 2013 15:46:43 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201302051546.43085.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These patches fix various v4l2-compliance issues for the tm6000.

Tested with my tm6000.

Unchanged from the RFC patches posted a few days ago.

Regards,

	Hans


The following changes since commit a32f7d1ad3744914273c6907204c2ab3b5d496a0:

  Merge branch 'v4l_for_linus' into staging/for_v3.9 (2013-01-24 18:49:18 -0200)

are available in the git repository at:


  git://linuxtv.org/hverkuil/media_tree.git tm6000

for you to fetch changes up to 800c8f9e30561618d47540698cc79bd3d3470ff2:

  tm6000: fix G/TRY_FMT. (2013-02-01 13:08:46 +0100)

----------------------------------------------------------------
Hans Verkuil (6):
      tm6000: fix querycap and input/tuner compliance issues.
      tm6000: convert to the control framework.
      tm6000: add support for control events and prio handling.
      tm6000: set colorspace field.
      tm6000: add poll op for radio device node.
      tm6000: fix G/TRY_FMT.

 drivers/media/usb/tm6000/tm6000-video.c |  422 +++++++++++++++++++++++++++++++------------------------------------------------------------------------
 drivers/media/usb/tm6000/tm6000.h       |    5 ++
 2 files changed, 130 insertions(+), 297 deletions(-)
