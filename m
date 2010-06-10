Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:33420 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981Ab0FJDZH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Jun 2010 23:25:07 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1OMYO7-0003QO-H3
	for linux-media@vger.kernel.org; Thu, 10 Jun 2010 05:25:03 +0200
Received: from 216-239-45-4.google.com ([216.239.45.4])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 10 Jun 2010 05:25:03 +0200
Received: from zhujiajun by 216-239-45-4.google.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 10 Jun 2010 05:25:03 +0200
To: linux-media@vger.kernel.org
From: jiajun <zhujiajun@gmail.com>
Subject: V4L Camera frame timestamp question
Date: Thu, 10 Jun 2010 03:24:05 +0000 (UTC)
Message-ID: <loom.20100610T052202-829@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, 

I'm currently using the V4L-DVB driver to control a few logitech webcams and
playstation eye cameras on a Gubuntu system.

Everything works just fine except one thing:  the buffer timestamp value seems
wrong.

The way I get the timestamp value is through the v4l2_buffer struct like this:

  struct v4l2_buffer buf;
  CLEAR(buf);
  buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
  buf.memory = V4L2_MEMORY_MMAP;
  assert(ioctl(fd_, VIDIOC_DQBUF, &buf));
  
  printf("timestamp = %.3f", buf.timestamp.tv_sec + buf.timestamp.tv_usec /
1000000);

this should be the timestamp of when the image is taken (similar to
gettimeofday() function)
but the value I got is something way smaller (e.g. 75000) than what it should be
(e.g. 1275931384)


Is this a known problem?


Thanks!

