Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:53221 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756634Ab2EUIaW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 May 2012 04:30:22 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id E38F0189B6B
	for <linux-media@vger.kernel.org>; Mon, 21 May 2012 10:30:19 +0200 (CEST)
Date: Mon, 21 May 2012 10:30:19 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [Q] vb2 userptr: struct vb2_ops::buf_cleanup() is called without
 buf_init()
Message-ID: <Pine.LNX.4.64.1205210902060.30522@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

A recent report

http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/47594

has revealed the following asymmetry in how videobuf2 functions:

as is also documented in videobuf2-core.h, the user's struct 
vb2_ops::buf_init() method in the MMAP case is called after allocating the 
respective buffer, which happens at REQBUFS time, in the USERPTR case it 
is called after acquiring a new buffer at QBUF time. If the allocation in 
MMAP case fails, the respective buffer simply doesn't get created. 
However, if acquiring a new USERPTR buffer at QBUF time fails, the buffer 
object remains on the queue, but the user-provided .buf_init() method is 
not called for it. When the queue is destroyed, the user's .buf_cleanup() 
method is called on an uninitialised buffer. This is exactly the reason 
for the BUG() in the above referenced report.

Therefore my question: is this videobuf2-core behaviour really correct and 
we should be prepared in .buf_cleanup() to process uninitialised buffers, 
or should the videobuf2-core be adjusted?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
