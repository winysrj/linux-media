Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:17925 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbZH0JEy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Aug 2009 05:04:54 -0400
From: "Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>
To: linux-media@vger.kernel.org
Subject: Units in V4L2 controls
Date: Thu, 27 Aug 2009 12:04:35 +0300
Cc: sailus@maxwell.research.nokia.com,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	saaguirre@ti.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908271204.35950.tuukka.o.toivonen@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, quoting V4L2 spec:

http://v4l2spec.bytesex.org/spec/r13317.htm
"__s32  step
[...]
Generally drivers should not scale hardware control values. It may be 
necessary for example when the name or id imply a particular unit and the 
hardware actually accepts only multiples of said unit. If so, drivers must 
take care values are properly rounded when scaling, such that errors will
not accumulate on repeated read-write cycles."

I'm wondering what that "particular unit" means. Is it OK to name
V4L2_CID_EXPOSURE to "Exposure time [us]" and then use microseconds
for exposure time, even if HW supports only image row granularity
(rolling shutter)? If not, how should the driver report to user
program the actual exposure time (necessary eg. for 50 Hz/60 Hz
flicker elimination).

What about flash timeout, we have here a circuit which supports
only 50, 100, 200, 400, etc. milliseconds. I report "step" to be
50 ms and then round the user setting to the closest value available.
User program could query the actual value used with VIDIOC_G_CTRL.

The same problem holds for other controls, at least we'd like to
use exposure value (EV) units for gain, etc.

- Tuukka

