Return-path: <linux-media-owner@vger.kernel.org>
Received: from yyz01.teckelworks.net ([208.76.111.99]:40089 "EHLO
	yyz01.teckelworks.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226AbbIIDC3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Sep 2015 23:02:29 -0400
Received: from localhost.localdomain ([127.0.0.1]:58737 helo=yyz01.teckelworks.net)
	by yyz01.teckelworks.net with esmtpa (Exim 4.85)
	(envelope-from <doug@stradm.com>)
	id 1ZZUZV-0006mL-Cc
	for linux-media@vger.kernel.org; Tue, 08 Sep 2015 21:53:13 -0400
Message-ID: <50eea204c270be3e44867576216677a0.squirrel@yyz01.teckelworks.net>
Date: Tue, 8 Sep 2015 21:53:13 -0400
Subject: V4L2 Overlay to reserved memory??
From: "Douglas Renton" <doug@stradm.com>
To: linux-media@vger.kernel.org
Reply-To: doug@stradm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
  I am trying to port some code I wrote for V4l to V4L2.
  What I am trying to do is "overlay" video in memory instead of to a
video card. This worked fine in V4L, I hope I can still pull such
tricks... My "good" reason to this is that I want to be able to analyse
the video in a "RTAI" realtime driver.

  Basically I have reserved "One G" of memory telling GRUB2 that there is
only 14G of memory in the system.

in my /etc/default/grub
# 14G
GRUB_CMDLINE_LINUX="mem=15032385536"

  I have a RTAI driver that I access this memory from, and a user space
application, they talk fine. (Yes all the covers are off the computer,
and no children are in the room.)

driver...
sd = (shared_data *) ioremap(ADDRESS,(unsigned long)sizeof(shared_data));

user..
sd = (shared_data *)mmap(0, sizeof(shared_data), PROT_READ|PROT_WRITE,
MAP_SHARED, MEM, ADDRESS);


  I believe my issue is in the VIDIOC_S_FBUF IOCTL call. I need the
"Physical base address of the frame buffer, the address of the pixel at
coordinates (0; 0)"

  fbuf.base = &(buf[0]);

  I have looked high and low, and have not found an example of using the
V4L2 "4.2. Video Overlay Interface".

  *************************
  Questions..

  Is this being done with V4L2?
  Any Idea how to pass the "Physical base address of the frame buffer" in
this situation?
  Any examples?
  Is this no longer possible?
  Is there another way to stream data continuously into memory? Ie without
constantly swapping buffers...

  Thanks
  Doug


