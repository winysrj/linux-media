Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:28636 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011Ab1CAKjD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Mar 2011 05:39:03 -0500
Message-ID: <4D6CCCB5.1060607@redhat.com>
Date: Tue, 01 Mar 2011 07:38:45 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "Igor M. Liplianin" <liplianin@me.by>
CC: Mariusz Bialonczyk <manio@skyboo.net>, linux-media@vger.kernel.org
Subject: Re: [PATCH] Prof 7301: switching frontend to stv090x, fixing "LOCK
 FAILED" issue
References: <4D3358C5.5080706@skyboo.net> <201102282237.07948.liplianin@me.by> <4D6C20A0.40705@skyboo.net> <201103010117.28411.liplianin@me.by>
In-Reply-To: <201103010117.28411.liplianin@me.by>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 28-02-2011 20:17, Igor M. Liplianin escreveu:
> В сообщении от 1 марта 2011 00:24:32 автор Mariusz Bialonczyk написал:
>> On 02/28/2011 09:37 PM, Igor M. Liplianin wrote:
>>> Sorry, I have nothing against you personally.
>>
>> me too :)
>>
>>> I have excuses, but you not intresting, I think.
>>> Peace, friendship, chewing gum, like we use to say in my childhood :)
>>>
>>> Switching to other driver not helps me, so be patient.
>>>
>>> I patched stv0900 and send pull request.
>>
>> I've tested it - and for the first sight it seems that it indeed
>> solves the problem. Thank you :)
>>
>> And about frontend: I think I found a solution which I hope will
>> satisfy all of us. I think it would be great if user have
>> an alternative option to use stv090x frontend anyway. I mean your
>> frontend as default, but a module parameter which enables using
>> stv090x instead of stv0900 (enabling what's is inside my patch).
>> This will be a flexible solution which shouldn't harm anyone,
>> but instead gives an option.
>>
>> Igor, Mauro, do you have objections against this solution?
>> If you agree, then I'll try to prepare an RFC patch for that.
> Well, I didn't change my mind.
> There is not an option, but splitting efforts in two ways.

An option to switch between them will just double maintenance efforts, as
both ways would needed to be tested. So, I don't think this is the
right way.

The proper long-term solution would be to merge stv090x and stv0900.

Cheers,
Mauro

