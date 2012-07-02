Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1610 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab2GBOPt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2012 10:15:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	halli manjunatha <hallimanju@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [RFC PATCH 0/6] Add frequency band information
Date: Mon,  2 Jul 2012 16:15:06 +0200
Message-Id: <1341238512-17504-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This patch series adds support for the new VIDIOC_ENUM_FREQ_BANDS ioctl that
tells userspace if a tuner supports multiple frequency bands.

This API is based on earlier attempts:

http://www.spinics.net/lists/linux-media/msg48391.html
http://www.spinics.net/lists/linux-media/msg48435.html

And an irc discussion:

http://linuxtv.org/irc/v4l/index.php?date=2012-06-26

This irc discussion also talked about adding rangelow/high to the v4l2_hw_freq_seek
struct, but I decided not to do that. The hwseek additions are independent to this
patch series, and I think it is best if Hans de Goede does that part so that that
API change can be made together with a driver that actually uses it.

In order to show how the new ioctl is used, this patch series adds support for it
to the very, very old radio-cadet driver.

Comments are welcome!

Regards,

	Hans

PS: Mauro, I haven't been able to work on the radio profile yet, so that's not
included.

