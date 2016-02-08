Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:33674 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752223AbcBHK3U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Feb 2016 05:29:20 -0500
Subject: Re: [RFC PATCH v0] Add tw5864 driver
To: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
References: <1451785302-3173-1-git-send-email-andrey.utkin@corp.bluecherry.net>
 <56938969.30104@xs4all.nl>
 <CAM_ZknVgTETBNXu+8N6eJa=cf_Mmj=+tA=ocKB9SJL5rkSyijQ@mail.gmail.com>
 <56B866D9.5070606@xs4all.nl>
 <CAM_ZknVjRo0vo2_SLmZSW7R_8LpNkmj-c3q1uBahEa_bSBK0hQ@mail.gmail.com>
Cc: Linux Media <linux-media@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kernel-mentors@selenic.com" <kernel-mentors@selenic.com>,
	devel@driverdev.osuosl.org,
	kernel-janitors <kernel-janitors@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andrey Utkin <andrey.od.utkin@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56B86DFA.6090600@xs4all.nl>
Date: Mon, 8 Feb 2016 11:29:14 +0100
MIME-Version: 1.0
In-Reply-To: <CAM_ZknVjRo0vo2_SLmZSW7R_8LpNkmj-c3q1uBahEa_bSBK0hQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/08/2016 11:23 AM, Andrey Utkin wrote:
> On Mon, Feb 8, 2016 at 11:58 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> Hi Andrey,
>>
>> Hmm, it looks like I forgot to reply. Sorry about that.
> 
> Thank you very much anyway.
> 
>> I wouldn't change the memcpy: in my experience it is very useful to get a
>> well-formed compressed stream out of the hardware. And the overhead of
>> having to do a memcpy is a small price to pay and on modern CPUs should
>> be barely noticeable for SDTV inputs.
> 
> So there's no usecase for scatter-gather approach, right?

The only advantage scatter-gather would bring is more efficient memory usage:
dma-contig requires physically contiguous memory, dma-sg doesn't. If you need
a lot of contiguous memory you can run into out-of-memory situations. The
alternative is to build a kernel with CMA enabled and reserve memory that way.

dma-sg doesn't have these problems, so that can be a good alternative, but it
comes at the price of higher complexity.

> 
>> I don't believe that the lockups you see are related to the memcpy as
>> such. The trace says that a cpu is stuck for 22s, no way that is related
>> to something like that. It looks more like a deadlock somewhere.
> 
> There was a locking issue (lack of _irqsave) and was fixed since then.
> 
>> Regarding the compliance tests: don't pass VB2_USERPTR (doesn't work well
>> with videobuf2-dma-contig). Also add vidioc_expbuf = vb2_ioctl_expbuf for
>> the DMABUF support. That should clear up some of the errors you see.
> 
> Thank you!
> 

Regards,

	Hans
