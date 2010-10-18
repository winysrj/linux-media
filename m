Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:12615 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755878Ab0JRTBi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Oct 2010 15:01:38 -0400
Message-ID: <4CBC9969.30005@redhat.com>
Date: Mon, 18 Oct 2010 17:00:57 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: mmotm 2010-10-13 - GSPCA SPCA561 webcam driver broken
References: <201010140044.o9E0iuR3029069@imap1.linux-foundation.org> <201010151202.31629.hverkuil@xs4all.nl> <4CB84393.3020205@redhat.com> <201010151423.52318.hverkuil@xs4all.nl>
In-Reply-To: <201010151423.52318.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 15-10-2010 09:23, Hans Verkuil escreveu:
> On Friday, October 15, 2010 14:05:39 Mauro Carvalho Chehab wrote:
>> Em 15-10-2010 07:02, Hans Verkuil escreveu:
>>> On Friday, October 15, 2010 11:05:26 Andrew Morton wrote:
>>>> On Fri, 15 Oct 2010 10:45:45 +0200 Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>>>
>>>>> On Thursday, October 14, 2010 22:06:29 Valdis.Kletnieks@vt.edu wrote:
>>>>>> On Wed, 13 Oct 2010 17:13:25 PDT, akpm@linux-foundation.org said:
>>>>>>> The mm-of-the-moment snapshot 2010-10-13-17-13 has been uploaded to
>>>
>>> Mauro, is this something for you to fix?
>>
>> I have a patch fixing this conflict already:
>>
>> http://git.linuxtv.org/mchehab/sbtvd.git?a=commit;h=88164fbe701a0a16e9044b74443dddb6188b54cc
>>
>> The patch is currently on a separate tree, that I'm using to test some experimental
>> drivers for Brazilian Digital TV system (SBTVD). I'm planning to merge this patch, among
>> with other patches I received for .37 during this weekend.
> 
> No, this patch isn't sufficient. It backs out the wrong code but doesn't put
> in the 'video_is_registered()' if statements that were in my original patch.
> 
> Those are really needed.

Ok, I've re-done the conflict fix patch:

http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-next.git;a=commitdiff;h=f9fccbad2a67668240edeaa6ada5aea2281d10b3

Cheers,
Mauro.
