Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:32803 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752209AbaKCOni (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Nov 2014 09:43:38 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 06D012A0376
	for <linux-media@vger.kernel.org>; Mon,  3 Nov 2014 15:43:33 +0100 (CET)
Message-ID: <54579494.3000803@xs4all.nl>
Date: Mon, 03 Nov 2014 15:43:32 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT FIXES FOR v3.18] vivid: default to single planar device instances
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'd like to get this in for 3.18 since it changes the behavior of the multiplanar
module option.

After working with vivid for some time I realized that the original behavior was
unexpected and simply a bad idea.

Regards,

	Hans

The following changes since commit 082417d10fafe7be835d143ade7114b5ce26cb50:

  [media] cx231xx: remove direct register PWR_CTL_EN modification that switches port3 (2014-11-01 08:59:06 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git vivid-for-3.18

for you to fetch changes up to 6217c9a8fa0e2a89424626a696ff719246d255e7:

  vivid: default to single planar device instances (2014-11-03 11:42:09 +0100)

----------------------------------------------------------------
Hans Verkuil (1):
      vivid: default to single planar device instances

 Documentation/video4linux/vivid.txt       | 12 +++++-------
 drivers/media/platform/vivid/vivid-core.c | 11 +++--------
 2 files changed, 8 insertions(+), 15 deletions(-)
