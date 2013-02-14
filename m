Return-path: <linux-media-owner@vger.kernel.org>
Received: from racoon.tvdr.de ([188.40.50.18]:50948 "EHLO racoon.tvdr.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755632Ab3BNNMj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Feb 2013 08:12:39 -0500
Received: from dolphin.tvdr.de (dolphin.tvdr.de [192.168.100.2])
	by racoon.tvdr.de (8.14.5/8.14.5) with ESMTP id r1EDCb60025518
	for <linux-media@vger.kernel.org>; Thu, 14 Feb 2013 14:12:37 +0100
Received: from [192.168.100.11] (falcon.tvdr.de [192.168.100.11])
	by dolphin.tvdr.de (8.14.4/8.14.4) with ESMTP id r1EDCVXg017551
	for <linux-media@vger.kernel.org>; Thu, 14 Feb 2013 14:12:31 +0100
Message-ID: <511CE2BF.8020905@tvdr.de>
Date: Thu, 14 Feb 2013 14:12:31 +0100
From: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: DVB: EOPNOTSUPP vs. ENOTTY in ioctl(FE_READ_UNCORRECTED_BLOCKS)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In VDR I use an ioctl() call with FE_READ_UNCORRECTED_BLOCKS on a device (using stb0899).
After this call I check 'errno' for EOPNOTSUPP to determine whether this
device supports this call. This used to work just fine, until a few months
ago I noticed that my devices using stb0899 didn't display their signal
quality in VDR's OSD any more. After further investigation I found that
ioctl(FE_READ_UNCORRECTED_BLOCKS) no longer returns EOPNOTSUPP, but rather
ENOTTY. And since I stop getting the signal quality in case any unknown
errno value appears, this broke my signal quality query function.

Is there a reason why this has been changed?

Should a caller check against both EOPNOTSUPP *and* ENOTTY?

I searched through linux/drivers/media and found that both values are
used (EOPNOTSUPP 57 times and ENOTTY 71 times in the version I have in use).
While ENOTTY seems to apply here (at least from its description, not from
its name)

ENOTTY      "Inappropriate ioctl for device" (originally "Not a typewriter")

and I can see why this would be a reason for changing this, EOPNOTSUPP doesn't
really seem to apply, since there is, I assume, no "socket"
involved here:

EOPNOTSUPP  "Operation not supported on socket"

The value I would actually expect to be used in case an operation is
not supported by a device is

ENOTSUP     "Operation not supported"

Interestingly the driver source uses ENOTSUPP (note the double 'P') 8 times,
but that name is not defined according to man errno(3).

So the bottom line is that there appears to be some confusion as to which errno
value to return in case an operation is not supported.
Maybe all these return values should be set to ENOTSUP (with a single 'P' at the end)?

Klaus
