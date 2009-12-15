Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:48871 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666AbZLOMMx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Dec 2009 07:12:53 -0500
Message-ID: <4B277D2A.7050201@maxwell.research.nokia.com>
Date: Tue, 15 Dec 2009 14:12:26 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Guru Raj <gururaj.nagendra@intel.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mike Krufky <mkrufky@linuxtv.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	"Ivan T. Ivanov" <iivanov@mm-sol.com>,
	Zutshi Vimarsh <vimarsh.zutshi@nokia.com>
Subject: [RFC 0/4] V4L2 file handles and event interface
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Here's the first version of the V4L2 file handle and event interface 
patchset. I posted it as RFC since there are a few issues with the 
contents and I have no assurrances that this even is functional at the 
moment.

The first patch adds the V4L2 file handle support and the rest are for 
V4L2 events.

A few notes on the patches:

- I don't like the locking too much. Perhaps the file handle specific 
lock (events->lock) could be dropped in favour of the lock for 
v4l2_file_handle in video_device.

- Event queue depth is not controlled at the moment.

- (Un)subscribing all events is not supported.

Comments are very welcome.

Cheers,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com



