Return-path: <mchehab@pedra>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3119 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756407Ab0I3Ocj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Sep 2010 10:32:39 -0400
Received: from webmail.xs4all.nl (dovemail6.xs4all.nl [194.109.26.8])
	by smtp-vbr13.xs4all.nl (8.13.8/8.13.8) with ESMTP id o8UEWbCM025889
	for <linux-media@vger.kernel.org>; Thu, 30 Sep 2010 16:32:38 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Message-ID: <4f06d6c22359c65faa965a4924a06d0d.squirrel@webmail.xs4all.nl>
Date: Thu, 30 Sep 2010 16:32:38 +0200
Subject: [GIT PATCHES FOR 2.6.37] fix long-standing tm6000 compile warning
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The following changes since commit e847bbbf9273533c15c6e8aab204ba62c238cf42:
  Hans Verkuil (1):
        V4L/DVB: v4l2-common: Move v4l2_find_nearest_format from
videodev2.h to v4l2-common.h

are available in the git repository at:

  ssh://linuxtv.org/git/hverkuil/v4l-dvb.git fixes

Hans Verkuil (1):
      tm6000-core.c: fix compile warning

 drivers/staging/tm6000/tm6000-core.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco

