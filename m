Return-path: <mchehab@pedra>
Received: from psmtp04.wxs.nl ([195.121.247.13]:59512 "EHLO psmtp04.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753982Ab0H0GZ4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Aug 2010 02:25:56 -0400
Received: from localhost (ip545779c6.direct-adsl.nl [84.87.121.198])
 by psmtp04.wxs.nl
 (iPlanet Messaging Server 5.2 HotFix 2.15 (built Nov 14 2006))
 with ESMTP id <0L7S00ENMSJ149@psmtp04.wxs.nl> for linux-media@vger.kernel.org;
 Fri, 27 Aug 2010 08:25:49 +0200 (MEST)
Date: Fri, 27 Aug 2010 08:25:47 +0200
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Subject: Re: HG has errors on kernel 2.6.32
In-reply-to: <AANLkTikQV03w6MBOVdirrg3kLBw52HbnJmC4BLfeUObO@mail.gmail.com>
To: Douglas Schilling Landgraf <dougsland@gmail.com>
Cc: linux-media@vger.kernel.org, Thomas Holzeisen <thomas@holzeisen.de>
Message-id: <4C775A6B.4030107@hoogenraad.net>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <4C1D1228.1090702@holzeisen.de> <4C5BA16C.7060808@hoogenraad.net>
 <5a5511b4767b245485b150836b1526f0.squirrel@holzeisen.de>
 <4C760DBC.5000605@hoogenraad.net> <4C768B43.9080403@holzeisen.de>
 <4C76C662.3070003@hoogenraad.net>
 <AANLkTikQV03w6MBOVdirrg3kLBw52HbnJmC4BLfeUObO@mail.gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Douglas: Thanks in advance

Douglas Schilling Landgraf wrote:
> Hi Jan,
> 
> On Thu, Aug 26, 2010 at 4:54 PM, Jan Hoogenraad
> <jan-conceptronic@hoogenraad.net> wrote:
>> Douglas:
>>
>> I see on that
>> http://www.xs4all.nl/~hverkuil/logs/Thursday.log
>> that building linux-2.6.32 yields ERRORS
>>
>> skip_spaces has only been included in string.h starting from linux-2.6.33.
>>
>> Should I have a look on how to fix this, or do you want to do this ?
> 
> It's up to you.  I can fix it, easily.
Please: I would have to learn from scratch about the code
> 
>> --
>>
>> second request: can we do some small changes to avoid the compiler warnings
>> ?
> 
> I will check on the git tree which patch touch on this and commit it. As
> backport tree, I cannot commit anything besides on existing source of git tree.
Please: I have not installed the git tree.
> 
> Thanks
> Douglas
> 


-- 
Jan Hoogenraad
Hoogenraad Interface Services
Postbus 2717
3500 GS Utrecht
