Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4892 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642AbaDGK53 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Apr 2014 06:57:29 -0400
Message-ID: <53428483.7060107@xs4all.nl>
Date: Mon, 07 Apr 2014 12:57:07 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Divneil Wadhawan <divneil@outlook.com>,
	Pawel Osciak <pawel@osciak.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: videobuf2-vmalloc suspect for corrupted data
References: <BAY176-W225B62F958527124202669A9680@phx.gbl>,<CAMm-=zDKUoFN7OiGpL3c=7KCkmYNhiyns20t8H7Pz_=qgaeHMw@mail.gmail.com> <BAY176-W524A762315BE245FCCD5DCA9680@phx.gbl>
In-Reply-To: <BAY176-W524A762315BE245FCCD5DCA9680@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/07/2014 12:49 PM, Divneil Wadhawan wrote:
> Hi Pawel,
> 
> Thanks for the quick response.
> 
>> Is it possible that your userspace is not always queuing the same
>> userptr memory areas with the same v4l2_buffer index values?
> No, userptr is always consistent with the index.
> In fact, when we dump the captured buffer (Transport Stream) in this case, kernel space data and user-space are different.
> When that TS is played, macroblocks are observed from user-space and not from the kernel space dump.
> Although, user-space bad data is random, but, I have never seen kernel space dumped TS as bad.
> 
>> In other words, if you have 2 buffers in use, under userspace mapping
>> at addr1 and addr2, if you queue addr1 with index=0 and addr2 with
>> index=1 initially,
>> you should always keep queuing addr1 with index=0 and never 1, etc.
> Yeah! this is the same rule which is being followed.
> 
>> Also, what architecture are you running this on?
> ARM Cortex A9 SMP

Two more questions:

Which kernel version are you using?

Which capture driver are you using?

Regards,

	Hans
