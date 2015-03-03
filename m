Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:56548 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754952AbbCCIuJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Mar 2015 03:50:09 -0500
Message-ID: <54F575AD.5020307@xs4all.nl>
Date: Tue, 03 Mar 2015 09:49:49 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Scott Jiang <scott.jiang.linux@gmail.com>,
	Lad Prabhakar <prabhakar.csengg@gmail.com>
CC: adi-buildroot-devel@lists.sourceforge.net,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 00/15] media: blackfin: bfin_capture enhancements
References: <1424544001-19045-1-git-send-email-prabhakar.csengg@gmail.com> <CAHG8p1DFu8Y1qaDc9c0m0JggUHrF4grHBj9VZQ4224v2wPJRbQ@mail.gmail.com>
In-Reply-To: <CAHG8p1DFu8Y1qaDc9c0m0JggUHrF4grHBj9VZQ4224v2wPJRbQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/02/2015 08:57 AM, Scott Jiang wrote:
> Hi Lad and Hans,
> 
> 2015-02-22 2:39 GMT+08:00 Lad Prabhakar <prabhakar.csengg@gmail.com>:
>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>
>> This patch series, enhances blackfin capture driver with
>> vb2 helpers.
>>
>> Changes for v3:
>> 1: patches unchanged except for patch 8/15 fixing starting of ppi only
>>    after we have the resources.
>> 2: Rebased on media tree.
>>
>> v2: http://lkml.iu.edu/hypermail/linux/kernel/1501.2/04655.html
>>
>> v1: https://lkml.org/lkml/2014/12/20/27
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
>>  drivers/media/platform/blackfin/bfin_capture.c | 306 ++++++++-----------------
>>  1 file changed, 94 insertions(+), 212 deletions(-)
>>
>> --
> 
> For all these patches,
> Acked-by: Scott Jiang <scott.jiang.linux@gmail.com>
> Tested-by: Scott Jiang <scott.jiang.linux@gmail.com>

Thanks!

Is it possible for you to run 'v4l2-compliance -s' with this driver and
report the results? I'd be interested in that.

Regards,

	Hans
