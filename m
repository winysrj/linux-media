Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:1377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020Ab1AKRGf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jan 2011 12:06:35 -0500
Message-ID: <4D2CAA33.9020508@redhat.com>
Date: Tue, 11 Jan 2011 17:06:27 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Pawel Osciak <pawel@osciak.com>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [GIT PATCHES FOR 2.6.38] Videbuf2 framework, NOON010PC30 sensor
 driver and s5p-fimc updates
References: <4D21FDC1.7000803@samsung.com> <4D2CA021.5080001@redhat.com> <AANLkTimovx-bhpV-1bRn=KvvH4ZtvAsSmnJB5_bjn6xX@mail.gmail.com>
In-Reply-To: <AANLkTimovx-bhpV-1bRn=KvvH4ZtvAsSmnJB5_bjn6xX@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 11-01-2011 14:42, Pawel Osciak escreveu:
> Hi Mauro,
> 
> On Tue, Jan 11, 2011 at 10:23, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
>>> Pawel Osciak (8):
>>>       v4l: Add multi-planar API definitions to the V4L2 API
>>>       v4l: Add multi-planar ioctl handling code
>>
>>>       v4l: Add compat functions for the multi-planar API
>>>       v4l: fix copy sizes in compat32 for ext controls
>>
>> Are you sure that we need to add compat32 stuff for the multi-planar definitions?
>> Had you test if the compat32 code is actually working? Except if you use things
>> that have different sizes on 32 and 64 bit architectures, there's no need to add
>> anything for compat.
>>
> 
> v4l2_buffer and v4l2_plane contain pointers to buffers and/or arrays
> of planes. In fact buffer conversion was already there, I only added
> the new planes field. I believe those additions to the compat code are
> needed...

Ok.
> 
>> Anyway, I'll be merging the two compat functions into just one patch, as it will
>> help to track any regressions there, if ever needed. They are at my temporary
>> branch, but, if they are not needed, I'll drop when merging upstream.
>>
>>>       v4l: v4l2-ioctl: add buffer type conversion for multi-planar-aware ioctls
>>
>> NACK.
>>
>> We shouldn't be doing those videobuf memcpy operations inside the kernel.
>> If you want such feature, please implement it on libv4l.
>>
> 
> I can see your point. We don't really use it. It was to prevent
> applications from using two versions of API and thus being
> overcomplicated. It allowed using old drivers with the new API. If you
> think it is a bad idea, the patch can just be dropped without
> affecting anything else. I will fix the documentation if you decide to
> do so.

Yeah, I prefer to not have such conversions in Kernel. We've made already a lot of 
efforts to remove V4L1 compat conversion from kernel. It is interesting to add
it to libv4l, together with other conversions that are already done there.


Cheers,
Mauro
