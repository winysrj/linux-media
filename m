Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:56994 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932968Ab1FWTru (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jun 2011 15:47:50 -0400
Message-ID: <4E03985D.108@redhat.com>
Date: Thu, 23 Jun 2011 15:47:41 -0400
From: Jarod Wilson <jarod@redhat.com>
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jeff Brown <jeffbrown@android.com>
Subject: Re: [PATCH] [media] rc: call input_sync after scancode reports
References: <1308851886-4607-1-git-send-email-jarod@redhat.com> <20110623183957.GC14950@core.coreip.homeip.net>
In-Reply-To: <20110623183957.GC14950@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Dmitry Torokhov wrote:
> Hi Jarod,
>
> On Thu, Jun 23, 2011 at 01:58:06PM -0400, Jarod Wilson wrote:
>> @@ -623,6 +624,7 @@ static void ir_do_keydown(struct rc_dev *dev, int scancode,
>>   			  u32 keycode, u8 toggle)
>>   {
>>   	input_event(dev->input_dev, EV_MSC, MSC_SCAN, scancode);
>> +	input_sync(dev->input_dev);
>>
>>   	/* Repeat event? */
>>   	if (dev->keypressed&&
>
> It looks like we would be issuing up to 3 input_sync() for a single
> keypress... Order of events is wrong too (we first issue MSC_SCAN for
> new key and then release old key). How about we change it a bit like in
> the patch below?

Yeah, your patch does result in a nicer overall flow of things (esp. the 
ordering of the release, which I hadn't noticed), and eliminates the 
extra unnecessary syncs. I've got one tiny tweak, where I just pass a 
true/false to ir_do_keyup to say whether or not it should do a sync to 
further reduce some code duplication. Building and testing here locally 
to make sure it does behave as expected, will then send it along.

-- 
Jarod Wilson
jarod@redhat.com


