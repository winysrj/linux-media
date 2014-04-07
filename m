Return-path: <linux-media-owner@vger.kernel.org>
Received: from bay0-omc2-s12.bay0.hotmail.com ([65.54.190.87]:64445 "EHLO
	bay0-omc2-s12.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755039AbaDGKBT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Apr 2014 06:01:19 -0400
Message-ID: <BAY176-W225B62F958527124202669A9680@phx.gbl>
From: Divneil Wadhawan <divneil@outlook.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: videobuf2-vmalloc suspect for corrupted data
Date: Mon, 7 Apr 2014 15:26:13 +0530
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have a V4L2 capture driver accepting a malloc'ed buffer. 
The driver is using vb2_vmalloc_memops (../drivers/media/v4l2-core/videobuf2-vmalloc.c) for user-space to kvaddr translation.
Randomly, corrupted data is received by user-app.

So, the question is regarding the handling of get_userptr, put_userptr by v4l2-core:

const struct vb2_mem_ops vb2_vmalloc_memops = {
         ........
         .get_userptr    = vb2_vmalloc_get_userptr, (get_user_pages() and vm_map_ram())
         .put_userptr    = vb2_vmalloc_put_userptr, (set_page_dirty_lock() and put_page())
          .....
};

The driver prepares for the transaction by virtue of v4l2-core calling get_userptr (QBUF) 
After data is filled, driver puts on a done list (DQBUF)

We never mark the pages as dirty (or put_userptr) after a transaction is complete.
Here, in v4l2 core (videobuf2-core.c) , we conditionally put_userptr - when a QBUF with a different userptr on same index, or releasing buffers.

Is it correct? Probably seems to be the reason for corrupted data.

Regards,
Divneil 		 	   		  