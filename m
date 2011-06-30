Return-path: <mchehab@pedra>
Received: from mail1.matrix-vision.com ([78.47.19.71]:53639 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab1F3IcA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jun 2011 04:32:00 -0400
From: Michael Jones <michael.jones@matrix-vision.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: ISP CCDC freeze-up on STREAMON
Date: Thu, 30 Jun 2011 10:31:52 +0200
Message-Id: <1309422713-18675-1-git-send-email-michael.jones@matrix-vision.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

I'm observing a system freeze-up with the ISP when writing data to memory directly from the ccdc.

Here's the sequence I'm using:

0. apply the patch I'm sending separate in this thread.

1. configure the ISP pipeline for the CCDC to deliver V4L2_PIX_FMT_GREY directly from the sensor to memory.

2. yavta -c10 /dev/video2

The patch is pretty self-explanatory.  It introduces a loop (with ugly indenting to keep the patch simple) with 100 iterations leaving the device open between them. My system usually hangs up within the first 30 iterations.  I've never made it to 100 successfully.  I see the same behavior with user pointers and with mmap, but I don't see it when using data from the previewer.

Can you please try this out with your setup?  Even if you can't get 8-bit gray data from your sensor, hopefully you could observe it with any other format directly from the CCDC.

I'll postpone further discussion until you confirm that you can reproduce the behavior.  As the patch illustrates, it looks like it is hanging up in STREAMON.

-Michael

Michael Jones (1):
  prompt ISP CCDC freeze-up on STREAMON

 yavta.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

-- 
1.7.5.4


MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
