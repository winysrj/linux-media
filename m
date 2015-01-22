Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f174.google.com ([209.85.160.174]:43019 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbbAVDve (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Jan 2015 22:51:34 -0500
MIME-Version: 1.0
In-Reply-To: <CA+V-a8ur2KV_s5zM9qbQZ+MLvocO9AE0KduWb3R-rUhA9912cw@mail.gmail.com>
References: <1419072462-3168-1-git-send-email-prabhakar.csengg@gmail.com>
	<CA+V-a8ur2KV_s5zM9qbQZ+MLvocO9AE0KduWb3R-rUhA9912cw@mail.gmail.com>
Date: Thu, 22 Jan 2015 11:51:33 +0800
Message-ID: <CAHG8p1Dussin4G29Ghupu-SyUSGWMxFu-2b2QacHuk7dkvaQnw@mail.gmail.com>
Subject: Re: [PATCH 00/15] media: blackfin: bfin_capture enhancements
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	adi-buildroot-devel@lists.sourceforge.net,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lad,

>>
>> Although I was on holiday but couldn't resist myself from working,
>> since I was away from my hardware I had to choose a different one,
>> blackfin driver was lucky one. Since I don't have the blackfin
>> board I haven't tested them on the actual board, but just compile
>> tested, Can you please test it & ACK.
>>
>> Lad, Prabhakar (15):
>>   media: blackfin: bfin_capture: drop buf_init() callback
>>   media: blackfin: bfin_capture: release buffers in case
>>     start_streaming() call back fails
>>   media: blackfin: bfin_capture: set min_buffers_needed
>>   media: blackfin: bfin_capture: improve buf_prepare() callback
>>   media: blackfin: bfin_capture: improve queue_setup() callback
>>   media: blackfin: bfin_capture: use vb2_fop_mmap/poll
>>   media: blackfin: bfin_capture: use v4l2_fh_open and vb2_fop_release
>>   media: blackfin: bfin_capture: use vb2_ioctl_* helpers
>>   media: blackfin: bfin_capture: make sure all buffers are returned on
>>     stop_streaming() callback
>>   media: blackfin: bfin_capture: return -ENODATA for *std calls
>>   media: blackfin: bfin_capture: return -ENODATA for *dv_timings calls
>>   media: blackfin: bfin_capture: add support for vidioc_create_bufs
>>   media: blackfin: bfin_capture: add support for VB2_DMABUF
>>   media: blackfin: bfin_capture: add support for VIDIOC_EXPBUF
>>   media: blackfin: bfin_capture: set v4l2 buffer sequence
>>
>>  drivers/media/platform/blackfin/bfin_capture.c | 310 ++++++++-----------------
>>  1 file changed, 98 insertions(+), 212 deletions(-)
>>
> If you are done with the review of all the patches,should I go ahead
> and post a v2 fixing the two issues which you pointed out ?
>
Yes, I have reviewed and tested other patches.

Thanks,
Scott
