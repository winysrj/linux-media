Return-path: <mchehab@pedra>
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:36990 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750750Ab1C2OcH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Mar 2011 10:32:07 -0400
Received: from zeta.dmz-eu.st.com (ns2.st.com [164.129.230.9])
	by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 85738B1
	for <linux-media@vger.kernel.org>; Tue, 29 Mar 2011 14:01:35 +0000 (GMT)
Received: from relay2.stm.gmessaging.net (unknown [10.230.100.18])
	by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 1F0C2275E
	for <linux-media@vger.kernel.org>; Tue, 29 Mar 2011 14:01:35 +0000 (GMT)
Received: from exdcvycastm003.EQ1STM.local (alteon-source-exch [10.230.100.61])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(Client CN "exdcvycastm003", Issuer "exdcvycastm003" (not verified))
	by relay2.stm.gmessaging.net (Postfix) with ESMTPS id 30FC4A807D
	for <linux-media@vger.kernel.org>; Tue, 29 Mar 2011 16:01:29 +0200 (CEST)
From: Willy POISSON <willy.poisson@stericsson.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 29 Mar 2011 16:01:33 +0200
Subject: v4l: Buffer pools
Message-ID: <757395B8DE5A844B80F3F4BE9867DDB652374B2340@EXDCVYMBSTM006.EQ1STM.local>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi all,
	Following to the Warsaw mini-summit action point, I would like to open the thread to gather buffer pool & memory manager requirements.
The list of requirement for buffer pool may contain:
-	Support physically contiguous and virtual memory
-	Support IPC, import/export handles (between processes/drivers/userland/etc)
-	Security(access rights in order to secure no one unauthorized is allowed to access buffers)
-	Cache flush management (by using setdomain and optimize when flushing is needed)
-	Pin/unpin in order to get the actual address to be able to do defragmentation
-	Support pinning in user land in order to allow defragmentation while buffer is mmapped but not pined.
-	Both a user API and a Kernel API is needed for this module. (Kernel drivers needs to be able to resolve buffer handles as well from the memory manager module, and pin/unpin)
-	be able to support any platform specific allocator (Separate memory allocation from management as allocator is platform dependant)
-	Support multiple region domain (Allow to allocate from several memory domain ex: DDR1, DDR2, Embedded SRAM to make for ex bandwidth load balancing ...)
Another idea, but not so linked to memory management (more usage of buffers), would be to have a common data container (structure to access data) shared by several media (Imaging, video/still codecs, graphics, Display...) to ease usage of the data. This container could  embed data type (video frames, Access Unit) , frames format, pixel format, width, height, pixel aspect ratio, region of interest, CTS (composition time stamp),  ColorSpace, transparency (opaque, alpha, color key...), pointer on buffer(s) handle)... 
Regards,
	Willy.
=============
Willy Poisson
ST-Ericsson
