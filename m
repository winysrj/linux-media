Return-path: <mchehab@gaivota>
Received: from casper.infradead.org ([85.118.1.10]:42250 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab0LUXzv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Dec 2010 18:55:51 -0500
Message-ID: <4D113E7C.7000307@infradead.org>
Date: Tue, 21 Dec 2010 21:55:40 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Thiago Farina <tfransosi@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] drivers/media/video/v4l2-compat-ioctl32.c: Check the
 return value of copy_to_user
References: <d21ad74592c295d59f5806f30a053745b5765397.1292894256.git.tfransosi@gmail.com>	<201012211925.38201.arnd@arndb.de> <AANLkTikbvST_B+4x3Xt=gxFhM1TBOrXVc1HjZT3zTXrt@mail.gmail.com>
In-Reply-To: <AANLkTikbvST_B+4x3Xt=gxFhM1TBOrXVc1HjZT3zTXrt@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 21-12-2010 16:34, Thiago Farina escreveu:
> On Tue, Dec 21, 2010 at 4:25 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Tuesday 21 December 2010 02:18:06 Thiago Farina wrote:
>>> diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
>>> index e30e8df..55825ec 100644
>>> --- a/drivers/media/video/v4l2-compat-ioctl32.c
>>> +++ b/drivers/media/video/v4l2-compat-ioctl32.c
>>> @@ -206,7 +206,9 @@ static struct video_code __user *get_microcode32(struct video_code32 *kp)
>>>          * user address is invalid, the native ioctl will do
>>>          * the error handling for us
>>>          */
>>> -       (void) copy_to_user(up->loadwhat, kp->loadwhat, sizeof(up->loadwhat));
>>> +       if (copy_to_user(up->loadwhat, kp->loadwhat, sizeof(up->loadwhat)))
>>> +               return NULL;
>>> +
>>>         (void) put_user(kp->datasize, &up->datasize);
>>>         (void) put_user(compat_ptr(kp->data), &up->data);
>>>         return up;
>>
>> Did you read the comment above the code you changed?
>>
> Yes, I read, but I went ahead.
> 
>> You can probably change this function to look at the return code of
>> copy_to_user, but then you need to treat the put_user return code
>> the same, and change the comment.
>>
> 
> Right, I will do the same with put_user, but I'm afraid of changing the comment.

Well, we should just remove all V4L1 stuff for .38, so I don't see much sense on keeping
the VIDIOCGMICROCODE32 compat stuff.

Cheers,
Mauro
