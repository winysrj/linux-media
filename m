Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3272 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529AbaBQJ6w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Feb 2014 04:58:52 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, ismael.luceno@corp.bluecherry.net,
	pete@sensoray.com, sakari.ailus@iki.fi
Subject: [REVIEWv3 PATCH 00/35] Add support for complex controls, use in solo/go7007
Date: Mon, 17 Feb 2014 10:57:15 +0100
Message-Id: <1392631070-41868-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds support for complex controls (aka 'Properties') to
the control framework and uses them in the go7007 and solo6x10 drivers.
It is the first part of a larger patch series that adds support for configuration
stores and support for 'Multiple Selections'.

This patch series is identical to the REVIEWv2 series:

http://www.spinics.net/lists/linux-media/msg72748.html

except that patches 35-40 have been folded into the main series (except for patch
40 which is added as a new patch since it is a standalone bug fix).

If there are no more objections, then I am going to make a pull request for this
in one week time.

I will post a pull request based on this series today as well.

Regards,

	Hans

