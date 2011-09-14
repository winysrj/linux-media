Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59132 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612Ab1INGNr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Sep 2011 02:13:47 -0400
Received: by ywb5 with SMTP id 5so1151113ywb.19
        for <linux-media@vger.kernel.org>; Tue, 13 Sep 2011 23:13:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFhB-RACaxtkBuXsch5-giTBqCHR+s5_SP-sGeR=E1HVeGfQLQ@mail.gmail.com>
References: <CAFhB-RACaxtkBuXsch5-giTBqCHR+s5_SP-sGeR=E1HVeGfQLQ@mail.gmail.com>
Date: Wed, 14 Sep 2011 14:13:32 +0800
Message-ID: <CAFhB-RBLA410nRJ3w7qyEq2dD+96=eDTneVfmo5Bm6NwevW0Pw@mail.gmail.com>
Subject: Asking advice for Camera/ISP driver framework design
From: Cliff Cai <cliffcai.sh@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear guys,

I'm currently working on a camera/ISP Linux driver project.Of course,I
want it to be a V4L2 driver,but I got a problem about how to design
the driver framework.
let me introduce the background of this ISP(Image signal processor) a
little bit.
1.The ISP has two output paths,first one called main path which is
used to transfer image data for taking picture and recording,the other
one called preview path which is used to transfer image data for
previewing.
2.the two paths have the same image data input from sensor,but their
outputs are different,the output of main path is high quality and
larger image,while the output of preview path is smaller image.
3.the two output paths have independent DMA engines used to move image
data to system memory.

The problem is currently, the V4L2 framework seems only support one
buffer queue,and in my case,obviously,two buffer queues are required.
Any idea/advice for implementing such kind of V4L2 driver? or any
other better solutions?

Thanks a lot!
Cliff
