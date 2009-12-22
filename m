Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:49163 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552AbZLVQnN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Dec 2009 11:43:13 -0500
Message-ID: <4B30F713.8070004@maxwell.research.nokia.com>
Date: Tue, 22 Dec 2009 18:42:59 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"Ivan T. Ivanov" <iivanov@mm-sol.com>,
	Guru Raj <gururaj.nagendra@intel.com>
Subject: [RFC v2 0/7] V4L2 file handles and event interface
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Here's the second version of the V4L2 file handle and event interface 
patchset. Still RFC since I'd like to get more feedback on it.

The first patch adds the V4L2 file handle support and the rest are for 
V4L2 events.

The patchset works with the OMAP 3 ISP driver. Patches for OMAP 3 ISP 
are not part of this patchset but are available in Gitorious (branch is 
called events):

	git://gitorious.org/omap3camera/mainline.git event

The major change since the last one v4l2_fh structure is now part of 
driver's own file handle. It's used as file->private_data as well. I did 
this based on Hans Verkuil's suggestion. Sequence numbers and event 
queue length limitation is there as well. There are countless of smaller 
changes, too.

A few notes on the patches:

- I don't like the locking too much. Perhaps the file handle specific 
lock (events->lock) could be dropped in favour of the lock for 
v4l2_file_handle in video_device?

- Poll. The V4L2 specifiction says:

	"When the application did not call VIDIOC_QBUF or
	VIDIOC_STREAMON yet the poll() function succeeds, but sets the
	POLLERR flag in the revents field."

   The current events for OMAP 3 ISP are related to streaming but not 
all might be in future. For example there might be some radio or DVB 
related events.

- Sequence numbers are local to file handles.

- Subscribing V4L2_EVENT_ALL causes any other events to be unsubscribed.

- If V4L2_EVENT_ALL has been subscribed, unsubscribing any one of the 
events leads to V4L2_EVENT_ALL to be unsubscribed. This problem would be 
difficult to work around since this would require the event system to be 
aware of the driver private events as well.

- If events are missed, the sequence number is incremented in any case. 
This way the user space knows events have been missed.

Comments would be very, very welcome.

Cheers,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
