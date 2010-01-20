Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:52172 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab0ATX7J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jan 2010 18:59:09 -0500
Received: by fxm20 with SMTP id 20so766930fxm.1
        for <linux-media@vger.kernel.org>; Wed, 20 Jan 2010 15:59:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B57912A.9000908@redhat.com>
References: <846899810912150749q38d8a1ffy96b135cf355fe8eb@mail.gmail.com>
	 <4B27CF77.1050008@redhat.com>
	 <846899810912151620m35a96025hf9ffb924d77eafa8@mail.gmail.com>
	 <846899811001200558g78693d1cy2f399840c6572af0@mail.gmail.com>
	 <4B574BEB.9040509@redhat.com>
	 <846899811001201443g60bd03edg9bd6fb5a4d3888a8@mail.gmail.com>
	 <4B57912A.9000908@redhat.com>
Date: Thu, 21 Jan 2010 00:59:08 +0100
Message-ID: <846899811001201559rb456074y7e5d84f48c7c4637@mail.gmail.com>
Subject: Re: [PATCH v3] isl6421.c - added tone control and temporary diseqc
	overcurrent
From: HoP <jpetrous@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: ajurik@quick.cz, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2010/1/21 Mauro Carvalho Chehab <mchehab@redhat.com>:
> HoP wrote:
>> Hi Mauro,
>>
>> 2010/1/20 Mauro Carvalho Chehab <mchehab@redhat.com>:
>>> HoP wrote:
>>>> Hi Mauro,
>>>>
>>>> Not to hassle you, I'm sure you're very busy.
>>>>
>>>> But I'm not yet received a response from you on mail with corrected patch.
>>>>
>>>> Your attention would be appreciated
>>> Hi Honza,
>>>
>>> The patch looks correct to me, but, as I previously mentioned, our policy is
>>> to add new features at the kernel driver only together with a driver that
>>> actually requires it. This helps to avoid increasing the kernel without need.
>>>
>>> So, please re-submit it when you have your driver requiring the isl6421
>>> changes ready for submission, on the same patch series.
>>>
>>
>> Are you sure about such policy?
>>
>> I did small google research and found out the following:
>>
>> My feeling is different otherwise I don't understand why did you
>> accept WITHOUT any word Oliver Endriss' PULL request
>> from December 12th:
>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg13302.html
>>
>> I'm pointing on Oliver's pull request only because he did very similar
>> thing for lnbp21 like I did for isl6421.
>>
>> You very quickly added his patch to 2.6.33 on December 16th:
>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg13429.html
>>
>> So again. If I'm not blind you have accepted same work from him
>> but not from me. Please show me what I have overlooked
>> and this is not true.
>>
>> Another possible explanation is that I'm totally unknow.
>>
>> I hope you have some other explanation otherwise it feels to
>> me like elitism.
>
> As far as I understood, those changes are needed by the mantis driver, that
> got committed on the next day, as shown at the commit logs:
>
> http://linuxtv.org/hg/v4l-dvb/rev/07c36cb88bce
> http://linuxtv.org/hg/v4l-dvb/rev/d644727cd528
>
> So, on that time I had already a pull request for the mantis driver.
>
> It is fine if I receive two separate pull requests, one depending of the other.
>
> That's said, Oliver is the maintainer of isl6421 driver, so he is the one that better
> know what bugs are there and what fixes are needed. Due to that, when I receive a
> patch from a driver maintainer, I'm inclined to ack with the changes, in the belief
> that he is doing the better for the driver. Even so, I review the driver looking
> for troubles on his approach taking more care with new exported symbols added and with
> new userspace API's that the patch might have.
>

OK, you beat me.

Good bye

/Honza
