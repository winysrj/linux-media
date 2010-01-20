Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418Ab0ATX0o (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jan 2010 18:26:44 -0500
Message-ID: <4B57912A.9000908@redhat.com>
Date: Wed, 20 Jan 2010 21:26:34 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: HoP <jpetrous@gmail.com>
CC: ajurik@quick.cz, linux-media@vger.kernel.org
Subject: Re: [PATCH v3] isl6421.c - added tone control and temporary diseqc
 	overcurrent
References: <846899810912150749q38d8a1ffy96b135cf355fe8eb@mail.gmail.com>	 <4B27CF77.1050008@redhat.com>	 <846899810912151620m35a96025hf9ffb924d77eafa8@mail.gmail.com>	 <846899811001200558g78693d1cy2f399840c6572af0@mail.gmail.com>	 <4B574BEB.9040509@redhat.com> <846899811001201443g60bd03edg9bd6fb5a4d3888a8@mail.gmail.com>
In-Reply-To: <846899811001201443g60bd03edg9bd6fb5a4d3888a8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

HoP wrote:
> Hi Mauro,
> 
> 2010/1/20 Mauro Carvalho Chehab <mchehab@redhat.com>:
>> HoP wrote:
>>> Hi Mauro,
>>>
>>> Not to hassle you, I'm sure you're very busy.
>>>
>>> But I'm not yet received a response from you on mail with corrected patch.
>>>
>>> Your attention would be appreciated
>> Hi Honza,
>>
>> The patch looks correct to me, but, as I previously mentioned, our policy is
>> to add new features at the kernel driver only together with a driver that
>> actually requires it. This helps to avoid increasing the kernel without need.
>>
>> So, please re-submit it when you have your driver requiring the isl6421
>> changes ready for submission, on the same patch series.
>>
> 
> Are you sure about such policy?
> 
> I did small google research and found out the following:
> 
> My feeling is different otherwise I don't understand why did you
> accept WITHOUT any word Oliver Endriss' PULL request
> from December 12th:
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg13302.html
> 
> I'm pointing on Oliver's pull request only because he did very similar
> thing for lnbp21 like I did for isl6421.
> 
> You very quickly added his patch to 2.6.33 on December 16th:
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg13429.html
> 
> So again. If I'm not blind you have accepted same work from him
> but not from me. Please show me what I have overlooked
> and this is not true.
> 
> Another possible explanation is that I'm totally unknow.
> 
> I hope you have some other explanation otherwise it feels to
> me like elitism.

As far as I understood, those changes are needed by the mantis driver, that
got committed on the next day, as shown at the commit logs:

http://linuxtv.org/hg/v4l-dvb/rev/07c36cb88bce
http://linuxtv.org/hg/v4l-dvb/rev/d644727cd528

So, on that time I had already a pull request for the mantis driver. 

It is fine if I receive two separate pull requests, one depending of the other.

That's said, Oliver is the maintainer of isl6421 driver, so he is the one that better 
know what bugs are there and what fixes are needed. Due to that, when I receive a 
patch from a driver maintainer, I'm inclined to ack with the changes, in the belief
that he is doing the better for the driver. Even so, I review the driver looking
for troubles on his approach taking more care with new exported symbols added and with
new userspace API's that the patch might have.

Cheers,
Mauro.
