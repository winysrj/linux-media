Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41551 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755931Ab3LVVR4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Dec 2013 16:17:56 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC] v4l lockdep error
Date: Sun, 22 Dec 2013 23:17:25 +0200
Message-Id: <1387747046-12677-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I know that patch is a little bit stupid, but at least it seems
to kill that "INFO: possible circular locking dependency detected"
/ DEADLOCK warning reported by lockdep.

Somehow this kind of warnings are very annoying when you don't know
it is a "feature". Like what happens to me; I made my first V4L2
driver and then enabled all kind of Kernel debugs to see if there is
possible issues. And kaboom, that jumped to out. It took really a
some time to figure it is not my module, but coming from v4l core
layers.

Antti Palosaari (1):
  v4l: disable lockdep on vb2_fop_mmap()

 drivers/media/v4l2-core/videobuf2-core.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

-- 
1.8.4.2

