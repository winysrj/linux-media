Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.tttech.com ([188.20.77.195]:57296 "EHLO mail.tttech.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626Ab3JUNHR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Oct 2013 09:07:17 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.tttech.com (Postfix) with ESMTP id 994C33EEBB
	for <linux-media@vger.kernel.org>; Mon, 21 Oct 2013 15:01:10 +0200 (CEST)
Received: from mail.tttech.com ([127.0.0.1])
	by localhost (tttmaildmz.vie.at.tttech.ttt [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5ICqTiOU84YH for <linux-media@vger.kernel.org>;
	Mon, 21 Oct 2013 15:01:10 +0200 (CEST)
Received: from domino01.vie.at.tttech.ttt (unknown [10.100.10.4])
	by mail.tttech.com (Postfix) with ESMTP id 8828C3EEBA
	for <linux-media@vger.kernel.org>; Mon, 21 Oct 2013 15:01:10 +0200 (CEST)
Message-ID: <52652594.4010102@tttech.com>
Date: Mon, 21 Oct 2013 15:01:08 +0200
From: =?UTF-8?B?TWF0dGhpYXMgV8OkY2h0ZXI=?= <matthias.waechter@tttech.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: I/O USERPTR for videobuf2-dma-sg
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone,

I’m in the process of providing a driver for a camera input and have 
just finished SG DMA operation to work in hardware and driver. Now I’m 
quite surprised that videobuf2-dma-sg is lacking basic support for user 
pointers to I/O memory (i.e., to graphics card). However, 
videobuf2-dma-contig does have support for it, at least from reading the 
code I see that vb2_dc_get_userptr() can tell I/O memory from RAM and as 
such do the right thing for I/O. OTOH, vb2_dma_sg_get_userptr() just 
does plain get_user_pages() which is not returning any page information 
for I/O memory.

Is this missing just because no-one has bothered to do it, or is there a 
known problem ? Right now it seems that only one driver in the kernel 
tree is actually using videobuf2-dma-sg, so maybe it hasn’t been worth 
the effort. Similarly, DMABUF has not been implemented in videobuf2-dma-sg.

Would a patch for adding I/O USERPTR functionality similar to 
vb2_dc_get/put_userptr() be accepted? Any known problems with this task 
I’m going to face?

Thanks,
– Matthias
