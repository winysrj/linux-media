Return-path: <mchehab@pedra>
Received: from mail2.matrix-vision.com ([85.214.244.251]:52008 "EHLO
	mail2.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab1FNPuQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2011 11:50:16 -0400
Message-ID: <4DF78335.80109@matrix-vision.de>
Date: Tue, 14 Jun 2011 17:50:13 +0200
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: buffer index when streaming user-ptr buffers
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

In the V4L2 spec, the description for v4l2_buffer.index says "This field
is only used for memory mapping I/O..."

However, in v4l-utils/contrib/capture-example.c, even user-pointer
buffers are indeed given a buf.index before being passed to VIDIOC_QBUF.
 And at least in the OMAP ISP driver, this information is relied upon in
QBUF regardless of V4L2_MEMORY_MMAP/USERPTR.  videobuf-core also uses
v4l2_buffer->index even if b->memory == V4L2_MEMORY_USERPTR.

Is this a bug in the OMAP driver and videobuf-core, and an unnecessary
assignment in capture-example?  Or is the V4L2 spec out of touch/ out of
date?

-Michael

MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
