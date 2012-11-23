Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4253 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab2KWNKi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 08:10:38 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Michael Hunold <michael@mihu.de>
Subject: [PATCH 0/2] Taking over saa7146 maintainership from Michael Hunold
Date: Fri, 23 Nov 2012 14:10:29 +0100
Message-Id: <1353676231-5684-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since I have enough saa7146-type cards to test almost all saa7146-based drivers
(except for budget cards with analog input. If anyone has a spare, please
contact me) and I have doing a fair amount of work for saa7146 over the years,
Michael and I decided that I should replace Michael as maintainer of the
saa7146-based V4L2 drivers and the core saa7146 code.

These patches change the saa7146 maintainer and add three new entries for
the i2c drivers used in the saa7146 mxb driver.

Many thanks to Michael for maintaining this driver all those years!

Regards,

	Hans

