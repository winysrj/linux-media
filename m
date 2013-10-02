Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:27430 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754429Ab3JBNot (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Oct 2013 09:44:49 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	teemux.tuominen@intel.com
Subject: [RFC v2 0/4]
Date: Wed,  2 Oct 2013 16:45:12 +0300
Message-Id: <1380721516-488-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This is the second RFC set after the initial patch that makes poll return
POLLERR if no events are subscribed. There are other issues as well which
these patches address.

The original RFC patch is here:

<URL:http://www.spinics.net/lists/linux-media/msg68077.html>

poll(2) and select(2) can both be used for I/O multiplexing. While both
provide slightly different semantics. man 2 select:

       select() and  pselect()  allow  a  program  to  monitor  multiple  file
       descriptors,  waiting  until one or more of the file descriptors become
       "ready" for some class of I/O operation (e.g., input possible).  A file
       descriptor  is considered ready if it is possible to perform the corre‐
       sponding I/O operation (e.g., read(2)) without blocking.

The two system calls provide slightly different semantics: poll(2) can
signal POLLERR related to a file handle but select(2) does not: instead, on
POLLERR it sets a bit corresponding to a file handle in the read and write
sets. This is somewhat confusing since with the original patch --- using
select(2) would suggest that there's something to read or write instead of
knowing no further exceptions are coming.

Thus, also denying polling a subdev file handle using select(2) will mean
the POLLERR never gets through in any form.

So the meaningful alternatives I can think of are:

1) Use POLLERR | POLLPRI. When the last event subscription is gone and
select(2) IOCTL is issued, all file descriptor sets are set for a file
handle. Users of poll(2) will directly see both of the flags, making the
case visible to the user immediately in some cases. On sub-devices this is
obvious but on V4L2 devices the user should poll(2) (or select(2)) again to
know whether there's I/O waiting to be read, written or whether buffers are
ready.

2) Use POLLPRI only. While this does not differ from any regular event at
the level of poll(2) or select(2), the POLLIN or POLLOUT flags are not
adversely affected.

In each of the cases to ascertain oneself in a generic way of whether events
cannot no longer be obtained one has to call VIDIOC_DQEVENT IOCTL, which
currently may block. A patch in the set makes VIDIOC_DQEVENT to signal EIO
error code if no events are subscribed.

The videobuf2 changes are untested at the moment since I didn't have a
device using videobuf2 at hand right now.

Comments and questions are very welcome.

-- 
Kind regards,
Sakari


