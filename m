Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1052 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab3AXHvY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jan 2013 02:51:24 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [REVIEW PATCH 0/3] Control header fix and convert tvaudio/mt9v011 to the controlfw
Date: Thu, 24 Jan 2013 08:51:13 +0100
Message-Id: <1359013876-12443-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The first patch moves the DV control IDs to their proper place in
v4l2-controls.h. I suspect the patch splitting off the control IDs to
a separate header and adding the new DV controls crossed one another.

The other two patches convert tvaudio and mt9v011 to the controls
framework: this is needed to make em28xx work correctly for devices
using those subdev drivers. Without this the controls defined in those
drivers won't show up.

Regards,

	Hans

