Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:2875 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896Ab2EDNaq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 May 2012 09:30:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Joonyoung Shim <jy0922.shim@samsung.com>,
	Tobias Lorenz <tobias.lorenz@gmx.net>
Subject: [RFC PATCH 0/4] si470x: clean up and use latest frameworks
Date: Fri,  4 May 2012 15:30:28 +0200
Message-Id: <1336138232-17528-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series updates the si470x driver so that it uses the latest
frameworks and passes the v4l2-compliance test tool.

It also removes usb autosuspend and the stop/start of the radio in the
release/open fops. It was very, very confusing that 'arecord -D ... | aplay'
didn't work unless you keep the radio0 node open (for no good reason other
then ensuring that the radio is started).

So the radio_start/stop code has been moved from open/release to
resume/suspend where it is used when you suspend the device. Note that
this change is for the USB version only, I did not touch the suspend/resume
code in the i2c version.

I've tested it all with my ADS InstantFM device.

