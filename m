Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:19191 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755674Ab0BFSBI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Feb 2010 13:01:08 -0500
Message-ID: <4B6DAE5A.5090508@maxwell.research.nokia.com>
Date: Sat, 06 Feb 2010 20:00:58 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"Ivan T. Ivanov" <iivanov@mm-sol.com>,
	Guru Raj <gururaj.nagendra@intel.com>,
	Cohen David Abraham <david.cohen@nokia.com>
Subject: [PATCH 0/8] V4L2 file handles and event interface
Content-Type: multipart/mixed;
 boundary="------------040906040204080200090808"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040906040204080200090808
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,

Here's the third version of the V4L2 file handle and event interface
patchset. I've marked this as PATCH instead of RFC for the first time.

The first patch adds the V4L2 file handle support and the rest are for
V4L2 events.

The second patch adds reference count for the v4l2_fh structures. This
is useful later when queueing events to file handles.

The next six patches are for the event interface.

The patchset has been tested with the OMAP 3 ISP driver. A simple test
program can be found as the attachment. Patches for OMAP 3 ISP are not
part of this patchset but are available in Gitorious (branch is called
event):

	git://gitorious.org/omap3camera/mainline.git event

The major change since the last RFC set is changing the kmem_cache
allocation to static per file handle allocation. The number of
allocatable events that way is likely small and can now be set by the
driver. Adding further events to free queue is also possible runtime.
Also, if a driver does not use events, the event system overhead for the
driver is limited to one pointer in v4l2_fh structure.

Locking has been also improved. The v4l2_fh structures have reference
count which makes it possible to free the list lock when working on
individual file handles. The spinlocks have been moved from events to
the file handles themselves.

To unsubscribe V4L2_EVENT_ALL, VIDIOC_UNSUBSCRIBE_EVENT has to be issued
for that event ID.

Comments would be welcome indeed. Especially on the new locking and
refcounting scheme.

Cheers,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com

--------------040906040204080200090808
Content-Type: text/x-csrc;
 name="polltest2.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="polltest2.c"

#include <stdio.h>

#include <sys/select.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#include <linux/videodev2.h>
#include <mach/isp_user.h>

int main(int argc, char *argv) {
	struct v4l2_event_subscription sub;
	struct v4l2_event ev;
	int fd;
	fd_set exfds;
	int ret;

	fd = open("/dev/video0", O_RDONLY);
	if (fd < 0) {
		perror("select()");
		return 1;
	}

	printf("fd %d\n", fd);

	sub.type = V4L2_EVENT_ALL;

	ret = ioctl(fd, VIDIOC_SUBSCRIBE_EVENT, &sub);
	if (ret < 0) {
		perror("subscribe()");
	} else
		printf("okay...\n");

	FD_ZERO(&exfds);
	FD_SET(fd, &exfds);

	while (1) {
		ret = pselect(fd + 1, NULL, NULL, &exfds, NULL, NULL);
		printf("pselect %d\n", ret);
		if (ret < 0)
			break;
	
		ret = ioctl(fd, VIDIOC_DQEVENT, &ev);
		if (ret < 0) {
			perror("dequeue");
			return 1;
		} else
			printf("okay...\n");
	
		printf("type         %x\n",ev.type);
		printf("sequence     %d\n",ev.sequence);
		printf("count        %d\n",ev.count);
		printf("timestamp    %u.%9.9u\n",ev.timestamp.tv_sec,ev.timestamp.tv_nsec);
	}

	return 0;
}

--------------040906040204080200090808--
