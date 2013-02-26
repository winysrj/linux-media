Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4310 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275Ab3BZRfy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Feb 2013 12:35:54 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Pete Eberlein <pete@sensoray.com>
Subject: s2255: v4l2 compliance fixes
Date: Tue, 26 Feb 2013 18:35:35 +0100
Message-Id: <1361900146-32759-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series fixes v4l2-compliance issues in the Sensoray s2255drv
driver and makes it run on a big endian system. It has been tested with
a s2255 unit generously supplied by Sensoray (thanks!).

The only changes since the previous RFC patches are the addition of
patches 10 and 11.

If there are no comments, then I'll post a pull request for 3.10 on
Friday.

As usual with these patch series, I did not update the driver to the
vb2 framework. That's something for the future.

Regards,

        Hans

