Return-path: <mchehab@pedra>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3669 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab1C2OvQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Mar 2011 10:51:16 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Willy POISSON <willy.poisson@stericsson.com>
Subject: Re: v4l: Buffer pools
Date: Tue, 29 Mar 2011 16:50:49 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <757395B8DE5A844B80F3F4BE9867DDB652374B2340@EXDCVYMBSTM006.EQ1STM.local>
In-Reply-To: <757395B8DE5A844B80F3F4BE9867DDB652374B2340@EXDCVYMBSTM006.EQ1STM.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103291650.50501.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday, March 29, 2011 16:01:33 Willy POISSON wrote:
> Hi all,
> 	Following to the Warsaw mini-summit action point, I would like to open the thread to gather buffer pool & memory manager requirements.
> The list of requirement for buffer pool may contain:
> -	Support physically contiguous and virtual memory
> -	Support IPC, import/export handles (between processes/drivers/userland/etc)
> -	Security(access rights in order to secure no one unauthorized is allowed to access buffers)
> -	Cache flush management (by using setdomain and optimize when flushing is needed)
> -	Pin/unpin in order to get the actual address to be able to do defragmentation
> -	Support pinning in user land in order to allow defragmentation while buffer is mmapped but not pined.
> -	Both a user API and a Kernel API is needed for this module. (Kernel drivers needs to be able to resolve buffer handles as well from the memory manager module, and pin/unpin)
> -	be able to support any platform specific allocator (Separate memory allocation from management as allocator is platform dependant)
> -	Support multiple region domain (Allow to allocate from several memory domain ex: DDR1, DDR2, Embedded SRAM to make for ex bandwidth load balancing ...)

Thanks for your input, Willy!

I have one question: do you know which of the points mentioned above are
implemented in actual existing code that ST-Ericsson uses? Ideally with links
to such code as well if available :-)

That will help as a reference.

> Another idea, but not so linked to memory management (more usage of buffers), would be to have a common data container (structure to access data) shared by several media (Imaging, video/still codecs, graphics, Display...) to ease usage of the data. This container could  embed data type (video frames, Access Unit) , frames format, pixel format, width, height, pixel aspect ratio, region of interest, CTS (composition time stamp),  ColorSpace, transparency (opaque, alpha, color key...), pointer on buffer(s) handle)... 

Regards,

	Hans
