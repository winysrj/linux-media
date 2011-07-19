Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:42995 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933Ab1GSNhx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2011 09:37:53 -0400
Received: from maxwell.research.nokia.com (maxwell.research.nokia.com [172.21.50.162])
	by mgw-sa01.nokia.com (Switch-3.4.4/Switch-3.4.3) with ESMTP id p6JDbnCg026800
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 19 Jul 2011 16:37:50 +0300
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by maxwell.research.nokia.com (Postfix) with ESMTP id A1CF537FCDA
	for <linux-media@vger.kernel.org>; Tue, 19 Jul 2011 16:37:49 +0300 (EEST)
Message-ID: <4E2588AD.4070106@maxwell.research.nokia.com>
Date: Tue, 19 Jul 2011 16:37:49 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [RFC 0/3] Frame synchronisation events and support for them in the
 OMAP 3 ISP driver
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

The OMAP 3 ISP driver implements an HS_VS event which is triggered when
the reception of a frame begins. This functionality is very, very likely
not specific to OMAP 3 ISP so it should be standardised.

I have a few patches to do that. Additionally the next expected buffer
sequence number is provided with the event, unlike earlier.

There are a few open questions, however, and this is why I'm sending the
set as RFC.


1) Other frame synchronisation events. The CCDC block in the OMAP 3 ISP
is able to trigger interrupts at two chosen lines of the image. These
naturally can be translated to events. The driver uses both of them
internally at specific points of the frame. Nevertheless, there might be
some use for these in user space. Other hardware might implement a
number of these which wouldn't be used by the driver itself, but I don't
know of that at the moment. On the other hand high resolution timers are
also available in user space, so doing timing based on ISP provided
events is not quite as important as before --- as long as there's one
frame based event produced at a known time, such as V4L2_EVENT_FRAME_START.

Frame end events may be produced as well. This is not exactly the same
as just dequeueing the buffer at video node since the hardware may be
able to produce events even in cases there are no buffers and if the
very hardware block that processes the frame is not outputting it to
memory, handling by further blocks takes more time, and thus delays the
finishing of the buffer from the driver's queue. This is the reason why
the name of the struct related to the event is v4l2_event_frame_sync
rather than v4l2_event_frame_start.

2) Buffer sequence number location in the struct v4l2_event. the patches
create a new structure called v4l2_event_frame_sync which contains just
one field, buffer_sequence. Should buffer_sequence be part of this
struct, or should it be part of v4l2_event directly, as the id field?
Both buffer_sequence and id refer to another rather widely used concept
in V4L2.


Besides this, the first patch in the series moves the documentation of
structs inside v4l2_event to VIDIOC_DQEVENT documentation. I think it
belongs there rather than to VIDIOC_SUBSCRIBE_EVENT, since that's not
where they are being used.

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
