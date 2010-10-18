Return-path: <mchehab@pedra>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4710 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219Ab0JRNVu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Oct 2010 09:21:50 -0400
Message-ID: <60e527c4ec4e9f8e4cf793e2d60d6b94.squirrel@webmail.xs4all.nl>
In-Reply-To: <4CBC484E.3080907@redhat.com>
References: <E1P7Yvq-0001kW-Pf@www.linuxtv.org>
    <201010172214.15773.hverkuil@xs4all.nl> <4CBC445C.5000903@samsung.com>
    <4CBC484E.3080907@redhat.com>
Date: Mon, 18 Oct 2010 15:21:34 +0200
Subject: Re: [git:v4l-dvb/v2.6.37] [media] Add driver for Siliconfile
 SR030PC30 VGA camera
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Mauro Carvalho Chehab" <mchehab@redhat.com>
Cc: "Sylwester Nawrocki" <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org,
	"Kyungmin Park" <kyungmin.park@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


> Em 18-10-2010 10:58, Sylwester Nawrocki escreveu:
>>
>> Hello Hans,
>>
>> On 10/17/2010 10:14 PM, Hans Verkuil wrote:
>>> On Sunday, October 17, 2010 21:28:29 Mauro Carvalho Chehab wrote:
>>>> This is an automatic generated email to let you know that the
>>>> following patch were queued at the
>>>> http://git.linuxtv.org/media_tree.git tree:
>>>>
>>>> Subject: [media] Add driver for Siliconfile SR030PC30 VGA camera
>>>> Author:  Sylwester Nawrocki <s.nawrocki@samsung.com>
>>>> Date:    Mon Oct 11 13:33:57 2010 -0300
>>>>
>> [snip]
>>> It fails to compile with this error:
>>>
>>> drivers/media/video/sr030pc30.c: In function ‘sr030pc30_probe’:
>>> drivers/media/video/sr030pc30.c:834: error: implicit declaration of
>>> function ‘kzalloc’
>>> drivers/media/video/sr030pc30.c:834: warning: assignment makes pointer
>>> from integer without a cast
>>> drivers/media/video/sr030pc30.c: In function ‘sr030pc30_remove’:
>>> drivers/media/video/sr030pc30.c:858: error: implicit declaration of
>>> function ‘kfree’
>>>
>>> Here is the patch to fix this:
>> [snip]
>>> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
>>>
>>
>> Thank you for fixing this. I will definitely improve my test environment
>> so this kind of errors do not appear in the future.
>
> I suspect that, depending on what are compiled, slab.h is included on some
> cases, as,
> on my tests with allyesconfig, I didn't notice the need for slab.h.

For the record: this was a x86_64 compilation.

Regards,

          Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco

