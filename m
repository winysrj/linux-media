Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:54870 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755026Ab1GAMD2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Jul 2011 08:03:28 -0400
Message-ID: <4E0DB78D.5020108@redhat.com>
Date: Fri, 01 Jul 2011 09:03:25 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Hans Verkuil <hansverk@cisco.com>,
	Hans de Goede <hdegoede@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: RFC: poll behavior
References: <201106291326.47527.hansverk@cisco.com> <201106301546.35803.hansverk@cisco.com> <4E0CDE03.1040906@redhat.com> <201107011145.51118.hverkuil@xs4all.nl> <4E0DB692.7040605@redhat.com>
In-Reply-To: <4E0DB692.7040605@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 01-07-2011 08:59, Mauro Carvalho Chehab escreveu:
> Em 01-07-2011 06:45, Hans Verkuil escreveu:
>> On Thursday, June 30, 2011 22:35:15 Mauro Carvalho Chehab wrote:
> 
>>>> This also leads to another ambiguity with poll(): what should poll do if 
>>>> another filehandle started streaming? So fh1 called STREAMON (and so becomes 
>>>> the 'owner' of the stream), and you poll on fh2. If a frame becomes available, 
>>>> should fh2 wake up? Is fh2 allowed to call DQBUF?
>>>
>>> IMO, both fh's should get the same results. This is what happens if you're
>>> writing into a file and two or more processes are selecting at the EOF.
>>
>> Yes, but multiple filehandles are allowed to write/read from a file at the
>> same time. That's not true for V4L2. Only one filehandle can do I/O at a time.
> 
> Actually, this is not quite true currently, as you could, for example use one fd
> for QBUF, and another for DQBUF, with the current behavior, but, with luck,
> no applications are doing weird things like that. Yet, tests are needed to avoid
> breaking something, if we're willing to change it.
> 
>> I'm going to look into changing fs/select.c so that the poll driver function
>> can actually see the event mask provided by the application.
> 
> Why? A POLLERR should be notified, whatever mask is there, as the application
> may need to abort (for example, in cases like hardware removal).

I was too quick on my last comment. Your patch is clear: you want to start it only
if the poll mask has "in" or "out" file descriptiors. Ok, this makes sense to me.

Cheers,
Mauro
