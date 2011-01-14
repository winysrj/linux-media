Return-path: <mchehab@pedra>
Received: from mailout3.samsung.com ([203.254.224.33]:32663 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab1ANEVe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Jan 2011 23:21:34 -0500
Received: from epmmp1 (mailout3.samsung.com [203.254.224.33])
 by mailout3.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LEZ00820W3VHZA0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Fri, 14 Jan 2011 13:21:31 +0900 (KST)
Received: from JONGHUNHA11 ([12.23.103.140])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LEZ00JRWW3V8X@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 14 Jan 2011 13:21:31 +0900 (KST)
Date: Fri, 14 Jan 2011 13:21:17 +0900
From: Jonghun Han <jonghun.han@samsung.com>
Subject: Query for inter-process buffer sharing
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com
Message-id: <009401cbb3a2$85a8d7e0$90fa87a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Hello, 

How do you think about adding a new callback function which makes allocator
for vb2 fill the reserved field in v4l2_buffer as below.
As-Is:  VIDIOC_QUERYBUF -> v4l2_m2m_querybuf -> vb2_querybuf ->
__fill_v4l2_buffer
To-Be: VIDIOC_QUERYBUF -> v4l2_m2m_querybuf -> vb2_querybuf ->
__fill_v4l2_buffer + vb2_mem_ops.fill_v4l2_buffer

I want to use the reserved field as for process unique key to share the
buffer between inter-process.
When I want to send a buffer which is allocated by A device to other
process, I want to get the process unique key from VIDIOC_QUERYBUF.
The process which gets the process unique key from other process will make
user virtual address from the key in any other way.
And then send it to B device using QBUF with USERPTR buffer type.

How do you think about this concept ?


      Process A
Process B

1. VIDIOC_QUERYBUF to get the process unique key 

2. VIDIOC_DQBUF

3. Send the process unique key to Process B
----------------------------------->    Process unique key

						                  4. Make a
user virtual address from the process unique key

                                                                       5.
VIDIOC_QBUF with user virtual address

                                                                       6.
find the paddr or device address from the user virtual addr. in videobuf2

                                                                       7.
H/W operation.

SCM_RIGHTS can be the solution for inter-process buffer sharing.
http://blog.toidinamai.de/en/programming/SCM_RIGHTS
But it has risk that other process can also control the device using the
shared file descriptor.
So I'm trying to make another solution.

Best regards,


