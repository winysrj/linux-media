Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:50170 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898Ab2FJTVx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jun 2012 15:21:53 -0400
Received: from [192.168.239.74] (maxwell.research.nokia.com [172.21.199.25])
	by mgw-da02.nokia.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q5AJLktl025866
	for <linux-media@vger.kernel.org>; Sun, 10 Jun 2012 22:21:48 +0300
Message-ID: <4FD4F3C9.5080506@iki.fi>
Date: Sun, 10 Jun 2012 22:21:45 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR 3.5] Correct CREATE_BUFS documentation regression
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This pull req contains just a single patch: fix for CREATE_BUFS
documentation which was broken by "[media] v4l2: use __u32 rather than
enums in ioctl() structs".

This really must make it to 3.5.

The following changes since commit 5472d3f17845c4398c6a510b46855820920c2181:

  [media] mt9m032: Implement V4L2_CID_PIXEL_RATE control (2012-05-24
09:27:24 -0300)

are available in the git repository at:
  ssh://linuxtv.org/git/sailus/media_tree.git media-for-3.5-createbufs-fix

Sakari Ailus (1):
      v4l: Correct create_bufs documentation

 .../DocBook/media/v4l/vidioc-create-bufs.xml       |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

Regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi

