Return-path: <mchehab@pedra>
Received: from mail1.matrix-vision.com ([78.47.19.71]:35427 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180Ab1AUIrA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jan 2011 03:47:00 -0500
Message-ID: <4D394675.90304@matrix-vision.de>
Date: Fri, 21 Jan 2011 09:40:21 +0100
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [RFC] ISP lane shifter support
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi all,

In the OMAP ISP driver, I'm interested in being able to choose between
8-bit and 12-bit formats when I have a 12-bit sensor attached.  At the
moment it looks like it's only possible to define this statically with
data_lane_shift in the board definition.  But with the ISP's lane
shifter, it should be possible for the application to ask for 8-bits
although it has a 12-bit sensor attached.

Has anybody already begun implementing this functionality?

One approach that comes to mind is to create a subdev for the
bridge/lane shifter in front of the CCDC, but this also seems a bit
overkill.  Otherwise, perhaps consider the lane shifter a part of the
CCDC and put the code in there?  Then ccdc_try_format() would have to
check whether the sink pad has a pixel format which is shiftable to the
requested pixel format on the source pad.  A problem with this might be
if there are architectures which have a CCDC but no shifter.

Are there other approaches I'm not considering?  Or problems I'm
overlooking?

Also- it looks like the CCDC now supports writing 12-bit bayer
data to memory.  Is that true?

thanks for your thoughts,
Michael

MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
