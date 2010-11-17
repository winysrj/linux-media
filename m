Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:5509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752370Ab0KQCcN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 21:32:13 -0500
Message-ID: <4CE33E8B.2070902@redhat.com>
Date: Wed, 17 Nov 2010 00:31:39 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC: linux-media@vger.kernel.org,
	Marko Ristola <marko.ristola@kolumbus.fi>,
	Manu Abraham <abraham.manu@gmail.com>,
	Ben Hutchings <ben@decadent.org.uk>,
	Niklas Claesson <nicke.claesson@gmail.com>,
	Tuxoholic <tuxoholic@hotmail.de>
Subject: Re: [GIT PATCHES FOR 2.6.38] mantis for_2.6.38
References: <4CBB689F.1070100@redhat.com> <874obmiov5.fsf@nemi.mork.no>	<4CDEA000.8020104@redhat.com> <87fwv5gu3y.fsf@nemi.mork.no>
In-Reply-To: <87fwv5gu3y.fsf@nemi.mork.no>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Bjørn,

Em 13-11-2010 12:45, Bjørn Mork escreveu:
> Mauro Carvalho Chehab <mchehab@redhat.com> writes:
> 
>> Em 12-11-2010 12:43, Bjørn Mork escreveu:
>>>
>>>   git://git.mork.no/mantis.git for_2.6.38
>>
>> Didn't work:
>>
>> git pull git://git.mork.no/mantis.git for_2.6.38
>> fatal: Couldn't find remote ref for_2.6.38
> 
> Damn, sorry about that.  Was supposed to be 
> 
> git://git.mork.no/mantis.git for_v2.6.38

Except when drivers are not maintained anymore (or when the patch is trivial), 
I wait for the driver author(s) to test the patches and ask me to pull (or for them to
reply that a patch is ok with his ack).

Manu sent a pull request with some of the long-standing Mantis patches tested
plus with some improvements for the frontend tuning. I've applied them today.

Please test, and give us a feedback.

Thanks,
Mauro
