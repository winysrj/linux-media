Return-path: <linux-media-owner@vger.kernel.org>
Received: from claranet-outbound-smtp06.uk.clara.net ([195.8.89.39]:42331 "EHLO
	claranet-outbound-smtp06.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752959AbZIBTfY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Sep 2009 15:35:24 -0400
Message-ID: <4A9E9E08.7090104@onelan.com>
Date: Wed, 02 Sep 2009 17:32:08 +0100
From: Simon Farnsworth <simon.farnsworth@onelan.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: j.w.r.degoede@hhs.nl
Subject: libv4l2 and the Hauppauge HVR1600 (cx18 driver) not working well
 together
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I'm in the process of reworking Xine's input_v4l to use libv4l2, so that
  it gets the benefit of all the work done on modern cards and webcams,
and I've hit a stumbling block.

I have a Hauppauge HVR1600 for NTSC and ATSC support, and it appears to
simply not work with libv4l2, due to lack of mmap support. My code works
adequately (modulo a nice pile of bugs) with a HVR1110r3, so it appears
to be driver level.

Which is the better route to handling this; adding code to input_v4l to
use libv4lconvert when mmap isn't available, or converting the cx18
driver to use mmap?

If it's a case of converting the cx18 driver, how would I go about doing
that? I have no experience of the driver, so I'm not sure what I'd have
to do - noting that if I break the existing read() support, other users
will get upset.

-- 
Advice appreciated,

Simon Farnsworth

