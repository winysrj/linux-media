Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2887 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583Ab2IGN3d (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Sep 2012 09:29:33 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [RFCv2 API PATCH 00/28] Full series of API fixes from the 2012 Media Workshop
Date: Fri,  7 Sep 2012 15:29:00 +0200
Message-Id: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This is the full patch series containing API fixes as discussed during the
2012 Media Workshop.

Regarding the 'make ioctl const' patches: I've only done the easy ones in
this patch series. The remaining write-only ioctls are used much more widely,
so changing those will happen later.

The last few patches that enhance the core code with more stringent tests
against what ioctls can be called for which types of device node will need
reviewing. I have tested it exhaustively with ivtv (which is one of the
most complex drivers, and the only one that has exotic devices like VBI
out).

To use v4l2-compliance with ivtv I also needed to make a few other fixes
elsewhere. The tree with both this patch series and the addition ivtv fixes
can be found here:

http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/ivtv

I have also tested this patch series (actually a slightly older version)
with em28xx. That driver needed a lot of changes to get it to pass the
v4l2-compliance tests. Those can be found here:

http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/em28xx

Comments are welcome.

Regards,

	Hans

