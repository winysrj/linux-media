Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:32782 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118Ab2AQV7c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jan 2012 16:59:32 -0500
Message-ID: <4F15ED39.4070604@mlbassoc.com>
Date: Tue, 17 Jan 2012 14:50:49 -0700
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: OMAP3 ISP & BT656
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have a number of boards with OMAP 3530/3730 that use the
TVP5150AM1 video decoder.  On most of these boards, I can
capture reasonable quality video.  However, I have some (more
than a few which is reason for concern) where the video is
either really bad or even the ISP doesn't seem to recognize
the BT656 data stream.  On the ones that have "bad" video,
the data is all blown out and barely recognizable.

All the boards are running the same kernel (3.0+ with the
YUV patches that Lennart and others proposed late last year).
I've verified that the component registers (ISPCCDC and TVP5150)
match.  I can't see what could be the cause of such radically
variable behaviour.

The one thing I've found is on the boards that don't work
at all, the CCDC_SYN_MODE[FLDSTAT] bit is not toggling, which
in turn causes no data to be pushed through the V4L2 pipeline.

Any ideas what can cause this?  More importantly, what I can
try to fix it?  The really scary thing is that all the boards
in my lab work great, but in the factory (some 6000 miles away),
more than not don't work :-(

Would it be possible to configure the CCDC to capture the
raw BT656 data?  These boards are very small and it's impossible
to get onto the video data lines going into the processor (they
are all hidden within the circuit board).

Any help/ideas gladly accepted.

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
