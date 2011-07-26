Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58835 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab1GZOrW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jul 2011 10:47:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [ANN] Agenda for the Cambourne meeting
Date: Tue, 26 Jul 2011 16:47:18 +0200
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Tuukka Toivonen <tuukka.toivonen@intel.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201107261647.19235.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Agenda for V4L2 brainstorm meeting in Cambourne, August 1-5 2011
----------------------------------------------------------------

The next V4L2 brainstorming meeting will take place in Cambourne, UK on August 
1-5 2011. The meeting will be colocated with the Linaro Sprint.

*Reminder*: this is not a summit meeting, conclusions will need to be 
discussed and approved on the mailing list.

The schedule will be slightly different compared to our previous meetings. To 
avoid overlaps with the Linaro Graphics Summit, the V4L2 brainstorming 
sessions will be held on Monday morning, Tuesday morning, Wednesday morning, 
Thursday all day and Friday morning.

As the number of topics to be discussed isn't too large, we will spend the 
first morning to go through all the agenda points and make sure everyone 
understands the problems. If time permits, we will start discussing smaller 
issues. Those who have a vested interest in an agenda item should be prepared 
to explain their take on it and if necessary have a presentation ready. 
Presentations should not take more than half an hour.

On Tuesday, Wednesday and Thursday we will discuss issues in details and try 
to come up with solutions.

On Friday morning we will translate all agenda items into actions.

This approach worked well in the past and it ensures that we end up with
something concrete.

*Attendees*

Cisco Systems Norway:
  Hans Verkuil (Chair) <hverkuil@xs4all.nl>

Ideas On Board:
  Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Intel:
  Tuukka Toivonen <tuukka.toivonen@intel.com>

Nokia:
  Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>

Samsung Poland R&D Center:
  Sylwester Nawrocki <s.nawrocki@samsung.com>
  Tomasz Stanislawski <t.stanislaws@samsung.com>

*Agenda*

To minimize wasted time, please make sure you refresh your memory on every 
topic by (re-)reading RFCs mentioned below.

1) Pipeline configuration, cropping and scaling. This topic has already been
   discussed during the Warsaw meeting in March 2011, but requires more
   brainstorming. (Everyone)

   http://www.mail-archive.com/linux-media@vger.kernel.org/msg26630.html
   http://www.mail-archive.com/linux-media@vger.kernel.org/msg27956.html
   http://www.mail-archive.com/linux-media@vger.kernel.org/msg28490.html
   http://www.mail-archive.com/linux-media@vger.kernel.org/msg34410.html

   Sub-topics that needs to be discussed include

   - Sensor blanking/pixel-clock/frame-rate settings (including enumeration
     and/or discovery)

   - Sub-subdevs and/or subdev hierarchy (Sakari)

   - Binning on sensors (Sakari)

2) Per-frame configuration. This topic has already been discussed during the
   Warsaw meeting in MArch 2011, but requires more brainstorming. (Everyone)

   - Synchronising parameters (e.g. exposure time and gain) on given
     frames. Some sensors support this on hardware. There are many use cases
     which benefit from this, for example this one:

     http://fcam.garage.maemo.org/

   - Frame metadata. It is important for the control algorithms (exposure,
     white balance, for example), to know which sensor settings have been
     used to expose a given frame. Many sensors do support this. Do we want
     to parse this in the kernel or does it belong to user space? The
     metadata formats are mostly sensor dependent.

3) Fast buffer allocation and mapping. (Tuukka)

   http://www.mail-archive.com/linux-media@vger.kernel.org/msg34661.html
   (possibly related)

   Tuukka, could you please elaborate a bit on what you would like to discuss
   exactly ?

4) Media devices, V4L2 subdevs and Linux device model. (Sakari)

     http://www.mail-archive.com/linux-media@vger.kernel.org/msg21831.html
     http://www.mail-archive.com/linux-media@vger.kernel.org/msg34294.html


The first item is the biggest one. We should discuss it on Tuesday morning, 
and continue discussions if time permits on Thursday afternoon. Wednesday 
morning will be spent discussing item 2. Item 3 will be pushed to Thursday 
morning, as it will likely be influenced by the result of the Linaro Graphics 
Summit. Item 4 should follow and be extended to Thursday afternoon.

If time permits other small items can be discussed on Thursday. Please list 
any other topic you would like to address during the meeting in response to 
this e-mail, with links to related documentation and/or RFCs if applicable.

-- 
Regards,

Laurent Pinchart
