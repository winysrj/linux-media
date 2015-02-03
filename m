Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f176.google.com ([209.85.160.176]:51223 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093AbbBCIJ1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Feb 2015 03:09:27 -0500
MIME-Version: 1.0
In-Reply-To: <54CF5E70.3000302@xs4all.nl>
References: <1421965128-10470-1-git-send-email-prabhakar.csengg@gmail.com>
	<CA+V-a8uVRZr3cYNsq5yehxjWoZMp6HMzm486KktKOXYkzJyFbA@mail.gmail.com>
	<54CF5E70.3000302@xs4all.nl>
Date: Tue, 3 Feb 2015 16:09:26 +0800
Message-ID: <CAHG8p1A=z+SEP6Dhk7_JNFyUVj1mh++jB71aMa38eBUMtrm8xA@mail.gmail.com>
Subject: Re: [PATCH v2 00/15] media: blackfin: bfin_capture enhancements
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	LMML <linux-media@vger.kernel.org>,
	adi-buildroot-devel@lists.sourceforge.net,
	LKML <linux-kernel@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,


>> On Thu, Jan 22, 2015 at 10:18 PM, Lad, Prabhakar
>> <prabhakar.csengg@gmail.com> wrote:
>>> This patch series, enhances blackfin capture driver with
>>> vb2 helpers.
>>>
>>> Changes for v2:
>>> --------------
>>> Only patches 5/15 and 8/15 as per Scott's suggestions.
>>>
>>> Lad, Prabhakar (15):
>>>   media: blackfin: bfin_capture: drop buf_init() callback
>>>   media: blackfin: bfin_capture: release buffers in case
>>>     start_streaming() call back fails
>>>   media: blackfin: bfin_capture: set min_buffers_needed
>>>   media: blackfin: bfin_capture: improve buf_prepare() callback
>>>   media: blackfin: bfin_capture: improve queue_setup() callback
>>>   media: blackfin: bfin_capture: use vb2_fop_mmap/poll
>>>   media: blackfin: bfin_capture: use v4l2_fh_open and vb2_fop_release
>>>   media: blackfin: bfin_capture: use vb2_ioctl_* helpers
>>>   media: blackfin: bfin_capture: make sure all buffers are returned on
>>>     stop_streaming() callback
>>>   media: blackfin: bfin_capture: return -ENODATA for *std calls
>>>   media: blackfin: bfin_capture: return -ENODATA for *dv_timings calls
>>>   media: blackfin: bfin_capture: add support for vidioc_create_bufs
>>>   media: blackfin: bfin_capture: add support for VB2_DMABUF
>>>   media: blackfin: bfin_capture: add support for VIDIOC_EXPBUF
>>>   media: blackfin: bfin_capture: set v4l2 buffer sequence
>>>
>>>  drivers/media/platform/blackfin/bfin_capture.c | 311 ++++++++-----------------
>>>  1 file changed, 99 insertions(+), 212 deletions(-)
>>>
>> Can you ACK the series ? so that its easier for Hans to pick it up.
>
> ping!
>
> Scott, I can't take it unless you Ack it. Actually, I'd like to see a
> 'Tested-by' tag.
>
One patch has problem, I have modified this patch and tested it.

> And if you are testing anyway, then I would really like to see the output
> of 'v4l2-compliance -s', using the v4l2-compliance from the latest v4l-utils.git.
>
> I'm curious to see the results of that.
>
v4l2-utils can't be compiled under uClibc.
