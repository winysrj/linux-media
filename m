Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:56585 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755037AbaIBTFX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Sep 2014 15:05:23 -0400
Message-ID: <54061381.5080309@schinagl.nl>
Date: Tue, 02 Sep 2014 20:59:13 +0200
From: Olliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 00/12] dvbv5 scan tables for Brazil
References: <1401209432-7327-1-git-send-email-m.chehab@samsung.com> <539A0691.1030608@schinagl.nl> <20140727223925.66683c2c.m.chehab@samsung.com> <20140831135702.045bfbc3.m.chehab@samsung.com>
In-Reply-To: <20140831135702.045bfbc3.m.chehab@samsung.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ah, you sent this to my +list e-mail, I have a backlog there of 10k 
mails due to a new job there now :)

I pulled from your repository, and pushed it upstream.

Thanks!

Olliver


On 08/31/2014 06:57 PM, Mauro Carvalho Chehab wrote:
> Ping.
>
> Em Sun, 27 Jul 2014 22:39:25 -0300
> Mauro Carvalho Chehab <m.chehab@samsung.com> escreveu:
>
>> Hi Olliver,x
>>
>> Em Thu, 12 Jun 2014 21:59:13 +0200
>> Olliver Schinagl <oliver+list@schinagl.nl> escreveu:
>>
>>> Mauro,
>>>
>>> Sorry for my late reply!!
>>>
>>> I've tried to merge your patches, but besides some blank line errors, I got:
>>>
>>> fatal: cannot convert from true to UTF-8
>>>
>>> I upgraded to git 2.0.0 and kept getting the error, atleast for 02.
>>>
>>> My git-foo is not strong enough to figure out whats going on here, or if
>>> the error is on my end or not. If it is on your end, could you re-send
>>> the patch series with the correct formatting?
>>
>> Weird... the patches are already in UTF-8. I just re-checked and
>> applied them without any issue. I didn't even get any blank line errors.
>>
>> I suspect that something got mangled when you saved the patches from a
>> file.
>>
>> I'm enclosing a tarball with all of them. As the patches are using
>> UTF-8 encoding (due to the name of the Brazilian cities and due to
>> the channel names that have accents), you need to be sure that you're
>> using UTF-8 on your distribution.
>>
>> Here, I'm using:
>>
>> LANG=pt_BR.UTF-8
>>
>> On my environment, to be sure that my charset is UTF-8.
>>
>> Anyway, you can also pull from my git tree directly with:
>> 	git pull git://linuxtv.org/mchehab/dtv-scan-tables.git
>>
>> It will miss your SOB on the patches, though, but you can sign
>> them either with git rebase or with git filter, with something like:
>>
>> 	$ git branch base
>> 	$ git pull git://linuxtv.org/mchehab/dtv-scan-tables.git
>> 	$ git filter-branch -f --msg-filter 'cat && echo "Signed-off-by: Olliver Schinagl <oliver+list@schinagl.nl>"' base..HEAD
>> 	$ git branch -d base
>>
>>
>> Regards,
>> Mauro

