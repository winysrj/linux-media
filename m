Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4300 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934818Ab3DHK7X (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Apr 2013 06:59:23 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Janne Grunau <j@jannau.net>
Subject: [REVIEW PATCH 00/12] hdpvr: driver overhaul
Date: Mon,  8 Apr 2013 12:58:29 +0200
Message-Id: <1365418721-23859-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series updates the hdpvr driver to the latest v4l2 frameworks
(except, as usual, vb2).

It has been tested with my hdpvr and a HDTV signal generator and it looks
pretty good. I did discover that you need the latest firmware to have the
hdpvr handle input and format switches correctly. I had major problems with
the old firmware that was on my box when I started testing.

This series is very similar to:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg60040.html

but adds support for g/s_std when in legacy mode to stay compatible with
what MythTV and gstreamer expects.

Janne, there is no entry for this driver in the MAINTAINERS file. Are you
still maintainer for this driver? If so, can you make a MAINTAINERS entry
for this driver? If I don't hear back from you, then I'll make myself the
'Odd Fixes' maintainer.

Regards,

        Hans

