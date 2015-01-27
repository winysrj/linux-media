Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:41654 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbbA0Nc4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jan 2015 08:32:56 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NIU008508HMJK50@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 27 Jan 2015 13:36:58 +0000 (GMT)
Message-id: <54C79385.2050702@samsung.com>
Date: Tue, 27 Jan 2015 14:32:53 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: setting volatile v4l2-control
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While testing the LED / flash API integration patches
I noticed that the v4l2-controls marked as volatile with
V4L2_CTRL_FLAG_VOLATILE flag behave differently than I would
expect.

Let's consider following use case:

There is a volatile V4L2_CID_FLASH_INTENSITY v4l2 control with
following constraints:

min: 1
max: 100
step: 1
def: 1

1. Set the V4L2_CID_FLASH_INTENSITY control to 100.
	- as a result s_ctrl op is called
2. Set flash_brightness LED sysfs attribute to 10.
3. Set the V4L2_CID_FLASH_INTENSITY control to 100.
	- s_ctrl op isn't called

This way we are unable to write a new value to the device, despite
that the related setting was changed from the LED subsystem level.

I would expect that if a control is marked volatile, then
the v4l2-control framework should by default call g_volatile_ctrl
op before set and not try to use the cached value.

Is there some vital reason for not doing this?

-- 
Best Regards,
Jacek Anaszewski
