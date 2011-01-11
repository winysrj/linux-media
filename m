Return-path: <mchehab@pedra>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:1486 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502Ab1AKU62 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jan 2011 15:58:28 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.38] v4l2-device: fix 'use-after-freed' oops
Date: Tue, 11 Jan 2011 21:58:11 +0100
Cc: Daniel Drake <dsd@laptop.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201101112158.11756.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

Another fix for 2.6.38.

Thanks to Daniel Drake for reporting this and no thanks to me for having missed
his original bug report in October last year.

Regards,

	Hans

The following changes since commit 04c3fafd933379fbc8b1fa55ea9b65281af416f7:
  Hans Verkuil (1):
        [media] vivi: convert to the control framework and add test controls

are available in the git repository at:

  ssh://linuxtv.org/git/hverkuil/media_tree.git v4l2-unreg-fix

Hans Verkuil (1):
      v4l2-device: fix 'use-after-freed' oops

 drivers/media/video/v4l2-device.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)
-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
