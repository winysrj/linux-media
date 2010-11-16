Return-path: <mchehab@pedra>
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1356 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757536Ab0KPBK7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Nov 2010 20:10:59 -0500
From: Andrew Chew <AChew@nvidia.com>
To: "'linux-media@vger.kernel.org'" <linux-media@vger.kernel.org>
Date: Mon, 15 Nov 2010 17:10:39 -0800
Subject: Allocating videobuf_buffer, but lists not being initialized
Message-ID: <643E69AA4436674C8F39DCC2C05F763816BB828A37@HQMAIL03.nvidia.com>
References: <643E69AA4436674C8F39DCC2C05F763816BB828A36@HQMAIL03.nvidia.com>
In-Reply-To: <643E69AA4436674C8F39DCC2C05F763816BB828A36@HQMAIL03.nvidia.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I'm looking at drivers/media/video/videobuf-dma-contig.c's __videobuf_alloc() routine.  We call kzalloc() to allocate the videobuf_buffer.  However, I don't see where the two lists (vb->stream and vb->queue) that are a part of struct videobuf_buffer get initialized (with, say, INIT_LIST_HEAD).

This results in a warning in the V4L2 camera host driver that I'm developing when the buf_prepare method gets called.  I do a similar sanity check to the sh_mobile_ceu_camera driver (WARN_ON(!list->empty(&vb->queue));) in my buf_prepare method, and see the warning.  If I add INIT_LIST_HEAD to __videobuf_alloc(), this warning goes away.

Is this a known bug?

-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
