Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:6566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465Ab1FCOAp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Jun 2011 10:00:45 -0400
Message-ID: <4DE8E8FF.8050203@redhat.com>
Date: Fri, 03 Jun 2011 11:00:31 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Dmitri Belimov <d.belimov@gmail.com>, thunder.m@email.cz,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: XC4000: added card_type
References: <4D764337.6050109@email.cz>	<20110531124843.377a2a80@glory.local>	<BANLkTi=Lq+FF++yGhRmOa4NCigSt6ZurHg@mail.gmail.com>	<20110531174323.0f0c45c0@glory.local>	<BANLkTimEEGsMP6PDXf5W5p9wW7wdWEEOiA@mail.gmail.com>	<4DE8D5AC.7060002@mailbox.hu> <BANLkTi=c+OQvh9Mj4njF4dJtSQdR=cAMaA@mail.gmail.com> <4DE8DEC6.6080008@mailbox.hu>
In-Reply-To: <4DE8DEC6.6080008@mailbox.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 03-06-2011 10:16, istvan_v@mailbox.hu escreveu:
> On 06/03/2011 02:46 PM, Devin Heitmueller wrote:
> 
>> I understand what you're trying to do here, but this is not a good
>> approach.  We do not want to be littering tuner drivers with
>> card-specific if() statements.  Also, this is inconsistent with the
>> way all other tuner drivers work.
>>
>> The approach you are attempting may seem easier at first, but it gets
>> very difficult to manage over time as the number of boards that use
>> the driver increases.
>>
>> You should have the bridge driver be setting up the cfg structure and
>> passing it to the xc4000 driver, just like the xc5000 and xc3028 do.
> 
> Well, for now, I just create patches that reproduce all the changes
> I have made to the driver. Of course, these may not always be the
> best or most elegant possible solutions, and I expect many will not be
> accepted, or further changes/cleanup will be needed later.
> 
> I do not think the number of boards that use this tuner is likely to
> increase much in the future, though, since the XC4000 seems to be a
> discontinued product (at least it no longer appears anywhere on the
> Xceive web site).

While the xc4000 is not merged upstream, we may have such hack, but
before merging, this issue should be solved.

However, it seems better to just do the right thing since the beginning:

just add a patch for cx88 adding the xc4000 boards there and filling
the config stuff inside cx88 driver.

Cheers,
Mauro
