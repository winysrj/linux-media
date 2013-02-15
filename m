Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2239 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593Ab3BOJTE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Feb 2013 04:19:04 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Pete Eberlein <pete@sensoray.com>
Subject: [RFC PATCH 0/9] s2255: v4l2 compliance fixes
Date: Fri, 15 Feb 2013 10:18:45 +0100
Message-Id: <1360919934-25552-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series fixes v4l2-compliance issues in the Sensoray s2255drv
driver. It has been tested with a s2255 unit generously supplied by
Sensoray (thanks!).

This is the first version of this patch series. I need to do a few
more tests and check the driver on my big-endian box, but I expect
any changes to be quite minor.

As usual with these patch series, I did not update the driver to the
vb2 framework. That's something for the future.

Regards,

	Hans

