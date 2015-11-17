Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:36554 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbbKQHjl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2015 02:39:41 -0500
Received: by igcph11 with SMTP id ph11so73784947igc.1
        for <linux-media@vger.kernel.org>; Mon, 16 Nov 2015 23:39:40 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 17 Nov 2015 09:39:40 +0200
Message-ID: <CAJ2oMhLN1T5GL3OhdcOLpK=t74NpULTz4ezu=fZDOEaXYVoWdg@mail.gmail.com>
Subject: cobalt & dma
From: Ran Shalit <ranshalit@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I intend to use cobalt driver as a refence for new pci v4l2 driver,
which is required to use several input simultaneously. for this cobalt
seems like a best starting point.
read/write streaming will probably be suffecient (at least for the
dirst debugging).
The configuration in my cast is i7 core <-- pci ---> fpga.
I see that the dma implementation is quite complex, and would like to
ask for some tips regarding the following points related to dma issue:

1. Is it possible to do the read/write without dma (for debug as start) ?
What changes are required for read without dma (I assume dma is used
by default in read/write) ?
Is it done by using  #include <media/videobuf2-vmalloc.h> instead of
#include <media/videobuf2-dma*> ?

2. I find it difficult to unerstand  cobalt_dma_start_streaming()
implementation, which has many specific cobalt memory writing
iowrite32().
How can I understand how/what to implement dma in my specific platform/device ?


Best Regards,
Ran
