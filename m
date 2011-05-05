Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:59160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753437Ab1EENji (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 May 2011 09:39:38 -0400
Message-ID: <4DC2A892.5080104@redhat.com>
Date: Thu, 05 May 2011 10:39:30 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
CC: Andy Walls <awalls@md.metrocast.net>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Steven Toth <stoth@kernellabs.com>
Subject: Re: [PATCH] cx18: Clean up mmap() support for raw YUV
References: <4DBFDF71.5090705@redhat.com> <201105041032.24644.simon.farnsworth@onelan.co.uk> <4DC28CEE.1080304@redhat.com> <201105051344.59759.simon.farnsworth@onelan.co.uk>
In-Reply-To: <201105051344.59759.simon.farnsworth@onelan.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 05-05-2011 09:44, Simon Farnsworth escreveu:
> On Thursday 5 May 2011, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
>> There are a few new warnings with your code:
>>
>> drivers/media/video/cx18/cx18-mailbox.c: In function
>> ‘cx18_mdl_send_to_videobuf’: drivers/media/video/cx18/cx18-mailbox.c:206:
>> warning: passing argument 1 of ‘ktime_get_ts’ from incompatible pointer
>> type include/linux/ktime.h:331: note: expected ‘struct timespec *’ but
>> argument is of type ‘struct timeval *’
>> drivers/media/video/cx18/cx18-mailbox.c:170: warning: unused variable ‘i’
>> drivers/media/video/cx18/cx18-mailbox.c:167: warning: unused variable ‘u’
>>
>> Could you please fix them?
>>
> I'm not doing well on the driving git front today, and I've managed to send 
> the fix patch with a wrong "In-reply-to"; it's message ID is 
> <1304599356-21951-1-git-send-email-simon.farnsworth@onelan.co.uk>, and it's 
> elsewhere in this thread (in reply to <4DC138F7.5050400@infradead.org>)

No problem. I don't rely very much on in-reply-to, as patchwork doesn't care
about it (unfortunately, as it would help to detect patches superseded/grouped).

Mauro.



