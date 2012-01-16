Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:4395 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443Ab2APM3y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jan 2012 07:29:54 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: linux-input@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
Subject: [RFC PATCH 0/3] New driver for the Keene USB FM Transmitter
Date: Mon, 16 Jan 2012 13:29:17 +0100
Message-Id: <1326716960-4424-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Here is a V4L2 driver for the Keene USB FM Transmitter:

http://www.amazon.co.uk/Keene-Electronics-USB-FM-Transmitter/dp/B003GCHPDY

It's been very useful to test V4L2 FM radio receivers.

Note that the Keene FM transmitter USB device has the same USB ID as
the Logitech AudioHub Speaker. Since the radio-keene driver needs to
hijack the HID something needed to be done to differentiate the two.

So hid-core was modified to decide this based on the product name.

I have tested that this works with both a Keene device and a Logitech
AudioHub device hooked up at the same time.

Jiri, can you look at the last patch and let me know if it is OK
from a HID point of view?

Regards,

	Hans

