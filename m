Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:33655 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754028AbbBBLZM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Feb 2015 06:25:12 -0500
Message-ID: <54CF5E70.3000302@xs4all.nl>
Date: Mon, 02 Feb 2015 12:24:32 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	LMML <linux-media@vger.kernel.org>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	adi-buildroot-devel@lists.sourceforge.net
CC: LKML <linux-kernel@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH v2 00/15] media: blackfin: bfin_capture enhancements
References: <1421965128-10470-1-git-send-email-prabhakar.csengg@gmail.com> <CA+V-a8uVRZr3cYNsq5yehxjWoZMp6HMzm486KktKOXYkzJyFbA@mail.gmail.com>
In-Reply-To: <CA+V-a8uVRZr3cYNsq5yehxjWoZMp6HMzm486KktKOXYkzJyFbA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/30/2015 04:49 PM, Lad, Prabhakar wrote:
> Hello Scott,
> 
> On Thu, Jan 22, 2015 at 10:18 PM, Lad, Prabhakar
> <prabhakar.csengg@gmail.com> wrote:
>> This patch series, enhances blackfin capture driver with
>> vb2 helpers.
>>
>> Changes for v2:
>> --------------
>> Only patches 5/15 and 8/15 as per Scott's suggestions.
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
>>  drivers/media/platform/blackfin/bfin_capture.c | 311 ++++++++-----------------
>>  1 file changed, 99 insertions(+), 212 deletions(-)
>>
> Can you ACK the series ? so that its easier for Hans to pick it up.

ping!

Scott, I can't take it unless you Ack it. Actually, I'd like to see a
'Tested-by' tag.

And if you are testing anyway, then I would really like to see the output
of 'v4l2-compliance -s', using the v4l2-compliance from the latest v4l-utils.git.

I'm curious to see the results of that.

Regards,

	Hans

> 
> Cheers,
> --Prabhakar Lad
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

