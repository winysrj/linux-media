Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:48729 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757066Ab2EVJZe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 May 2012 05:25:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>,
	Vaibhav Hiremath <hvaibhav@ti.com>,
	Archit Taneja <archit@ti.com>
Subject: Warning in omap_vout.c
Date: Tue, 22 May 2012 11:24:45 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201205221124.45834.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(Repost, this time without using HTML. My mailer switches to HTML once in a while
for no reason. Very annoying.)

The daily build has this warning:

v4l-dvb-git/drivers/media/video/omap/omap_vout.c: In function ‘omapvid_init’:
v4l-dvb-git/drivers/media/video/omap/omap_vout.c:381:17: warning: ‘mode’ may be used uninitialized in this function [-Wuninitialized]
v4l-dvb-git/drivers/media/video/omap/omap_vout.c:331:23: note: ‘mode’ was declared here

Can someone check this?

The problem is that video_mode_to_dss_mode() has a 'case 0:' that never sets
the mode. I suspect that the case 0 can be removed so that it goes to the
default case.

Can someone verify this?

Regards,

        Hans
