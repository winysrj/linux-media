Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3688 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab3AaKZn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jan 2013 05:25:43 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Huang Shijie <shijie8@gmail.com>
Subject: [RFC PATCH 00/18] tlg2300: various v4l2-compliance fixes
Date: Thu, 31 Jan 2013 11:25:18 +0100
Message-Id: <1359627936-14918-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Last year I worked on this driver to improve it and fix v4l2-compliance
issues.

It required a lot of effort to even find a USB stick with this chipset
(telegent no longer exists) and unfortunately at some point I managed
to break the USB stick, so I am no longer able to work on it.

This patch series represents that part of the work I've done that has
been tested. I have additional patches in my tlg2300-wip branch:

http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/tlg2300-wip

but since I am no longer certain at what point in those remaining patches
things broke down I've decided not to post them for upstreaming. If I or
someone else ever manages to get a working tlg2300 that code might be used
for further work.

Huang Shijie, are you still able to act as maintainer? If not, then I can
put my name in. The MAINTAINER status should probably move to 'Odd Fixes'
as well.

Regards,

	Hans

