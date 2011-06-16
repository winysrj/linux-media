Return-path: <mchehab@pedra>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56305 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab1FPFbm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2011 01:31:42 -0400
Received: by pwj7 with SMTP id 7so82523pwj.19
        for <linux-media@vger.kernel.org>; Wed, 15 Jun 2011 22:31:41 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 16 Jun 2011 13:31:41 +0800
Message-ID: <BANLkTikKA_0QEyaeJth4FYzm61tYT+_Gow@mail.gmail.com>
Subject: no mmu on videobuf2
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: m.szyprowski@samsung.com, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Marek and Laurent,

I am working on v4l2 drivers for blackfin which is a no mmu soc.
I found videobuf allocate memory in mmap not reqbuf, so I turn to videobuf2.
But __setup_offsets() use plane offset to fill m.offset, which is
always 0 for single-planar buffer.
So pgoff in get_unmapped_area callback equals 0.
I only found uvc handled get_unmapped_area for no mmu system, but it
manages buffers itself.
I really want videobuf2 to manage buffers. Please give me some advice.

Thanks.
Regards,
Scott
