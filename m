Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp202.alice.it ([82.57.200.98]:42802 "EHLO smtp202.alice.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726401AbeIZQCj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Sep 2018 12:02:39 -0400
Received: from [172.13.1.12] (79.3.133.33) by smtp202.alice.it (8.6.060.43) (authenticated as antonio.tringali)
        id 5BA96D9E015B0131 for linux-media@vger.kernel.org; Wed, 26 Sep 2018 11:50:14 +0200
From: Antonio Tringali <antonio.tringali@alice.it>
Subject: Capturing camera frames from an i.MX51 board.
To: linux-media@vger.kernel.org
Message-ID: <a80cd5d7-fc4c-03e2-74a2-696407611bad@alice.it>
Date: Wed, 26 Sep 2018 11:50:14 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Language: it-IT
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  Dear linux-media Developers,
I was assigned the task to port a recent kernel (4.18.6, downloaded from 
kernel.org) to an old imx51-babbage style board. It works with a 2.6.36 
kernel.

  I know, i.MX51 is "mature" in NXP lingo. Not supported anymore in my 
mind, but work is work.

  The i.MX51 board uses a monochrome Aptina MT9V024 driver for the 
sensor. I patched the DTS and imx-media driver in 
drivers/staging/media/imx only to later find out that my experience was 
very similar to the one described in this thread:

https://www.spinics.net/lists/linux-media/msg129273.html

  Trying to start a capture yields EPIPE from v4l2-ctl. Following 
pointers I found that the node pertaining the ipu_csi0 has two NULL 
pointers for sink and src_pad in the V4L2 subdev and csi_link_setup() in 
imx-media-csi.c is never invoked.

  So I will not repeat the questions in the previous thread, because I 
suppose I would not get any answer. I have to evaluate which of these 
two paths costs less:

1. Debug imx-media for my architecture, knowing that it is really 
specialized for i.MX6.

2. Find another Linux kernel branch supporting i.MX51 and the Aptina driver.

  Is there any such thing as point (2)?

  I found:

http://git.freescale.com/git/cgit.cgi/imx/linux-imx.git/?h=imx_4.9.11_1.0.0_ga

but this branch directly supports OV564x sensors only. I have to 
minimize time/cost at this point, avoiding to write/rewrite a driver.

  Thank you in advance,
Antonio Tringali
