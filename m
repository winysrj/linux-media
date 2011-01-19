Return-path: <mchehab@pedra>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3085 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556Ab1ASHj3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jan 2011 02:39:29 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: video_device -> v4l2_devnode rename
Date: Wed, 19 Jan 2011 08:39:15 +0100
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201101190839.15175.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

I saw that 2.6.38-rc1 was released. I also noticed that not all the patches
that are in the for_2.6.38-rc1 branch are in 2.6.38-rc1.

We want to rename video_device to v4l2_devnode. So let me know when I can
finalize my patches and, most importantly, against which branch.

My current tree:

http://git.linuxtv.org/hverkuil/media_tree.git?a=shortlog;h=refs/heads/devnode2

tracks for_2.6.38-rc1 and should apply cleanly at the moment.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
