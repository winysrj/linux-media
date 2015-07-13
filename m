Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:52772 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395AbbGMVvX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jul 2015 17:51:23 -0400
Message-ID: <55A432D1.9060008@osg.samsung.com>
Date: Mon, 13 Jul 2015 15:51:13 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
MIME-Version: 1.0
To: "Mauro Carvalho Chehab (m.chehab@samsung.com)" <m.chehab@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
CC: Shuah Khan <shuahkh@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Media Controller - graph_mutex
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All,

ALSA has to make media_entity_pipeline_start() call in irq
path. I am seeing warnings that the graph_mutex is unsafe irq
lock as expected. We have to update MC start/stop pipeline
to be irq safe for ALSA. Maybe there are other MC interfaces
that need to be irq safe, but I haven't seen any problems with
my limited testing.

So as per options, graph_mutex could be changed to a spinlock.
It looks like drivers hold this lock and it isn't abstracted to
MC API. Unfortunate, this would require changes to drivers that
directly hold the lock for graph walks if this mutex is changed
to spinlock.

e.g: drivers/media/platform/exynos4-is/fimc-isp-video.c

Changes aren't complex, just that the scope isn't limited
to MC API.

Other ideas??

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
