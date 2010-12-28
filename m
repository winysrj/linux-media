Return-path: <mchehab@gaivota>
Received: from bordeaux.papayaltd.net ([82.129.38.124]:38369 "EHLO
	bordeaux.papayaltd.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033Ab0L1RZa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Dec 2010 12:25:30 -0500
Subject: Re: ngene & Satix-S2 dual problems
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=iso-8859-1
From: Andre <linux-media@dinkum.org.uk>
In-Reply-To: <4D19D8A0.6010606@gmail.com>
Date: Tue, 28 Dec 2010 17:25:27 +0000
Cc: linux-media@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <9F1CEDCB-8BB0-4C54-8410-FC554E9E4F6D@dinkum.org.uk>
References: <4D1753CF.9010205@gmail.com> <55B5612B-5E2B-4C2E-AD5E-B0D5A7AC865B@dinkum.org.uk> <4D19D8A0.6010606@gmail.com>
To: =?iso-8859-1?Q?Ludovic_BOU=C9?= <ludovic.boue@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>


On 28 Dec 2010, at 12:31, Ludovic BOUÉ wrote:

> 
> 
> Le 27/12/2010 10:07, Andre a écrit :
>> On 26 Dec 2010, at 14:40, Ludovic BOUÉ wrote:
>> 
>>> Hi all,
>>> 
>>> I have a Satix-S2 Dual and I'm trying to get to work without his CI in a first time. I'm trying ngene-test2 
>>> from http://linuxtv.org/hg/~endriss/ngene-test2/ under 
>>> 2.6.32-21-generic.
>>> 
>>> It contains too much nodes (extra demuxes, dvrs & nets):
>> Yes, if you read this thread back you will see why and that it doesn't prevent anything working.
>> 
>>> was working with stable driver dans 1.5 firmware.
>> Again back in the thread you will see that with the in kernel driver (I hesitate to use the description stable) there is a serious problem when both tuners are in use, this work in progress driver fixes that problem.
>> 
>> The extra nodes are a pain, especially when you have a lot of tuners in one machine but tuners that stop working mid recording are much more of a pain!
> 
> I seems to work with the last patch commited by Oliver Endriss. Did you
> try with a CI ?

No I didn't, I don't have a CI.

I'll try Olivers latest commit in a few days, I'm a long way from my Myth system right now :-)

Thanks again Oliver, much appreciated.

Andre