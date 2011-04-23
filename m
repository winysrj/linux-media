Return-path: <mchehab@pedra>
Received: from cmsout02.mbox.net ([165.212.64.32]:37952 "EHLO
	cmsout02.mbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab1DWMMf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Apr 2011 08:12:35 -0400
Message-ID: <4DB2C20E.1050701@usa.net>
Date: Sat, 23 Apr 2011 14:11:58 +0200
From: Issa Gorissen <flop.m@usa.net>
MIME-Version: 1.0
To: Martin Vidovic <xtronom@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: ngene CI problems
References: <4D74E28A.6030302@gmail.com> <4DB1FE58.20006@usa.net> <4DB2BA0B.20906@gmail.com>
In-Reply-To: <4DB2BA0B.20906@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 23/04/11 13:37, Martin Vidovic wrote:
> Hi Issa,
>> Running a bunch of test with gnutv and a DuoFLEX S2.
>>   
> I have a DuoFlex S2 running with CI, but not nGene based (it's
> attached to Octopus card - ddbridge module).
>
>> I would run gnutv  like 'gnutv -out stdout channelname >
>> /dev/dvb/adapter0/caio0' and then 'cat /dev/dvb/adapter0/caio0 |
>> mplayer -'
>> Mplayer would complain the file is invalid. Simply running simply 'cat
>> /dev/dvb/adapter0/caio0' will show me the same data pattern over and
>> over.
>>   
> I suspect the problem is that reads/writes are not aligned to 188
> bytes with such invocation of commands. Maybe if you tried replacing
> 'cat' and '>' with 'dd' (bs=188). Other important thing seems to be,
> to read from the caio0 fast enough or real data is overwritten with
> null packets (haven't proved it, but it looks this way on nGene).
>
> Hope this helps.
>
> Best regards,
> Martin Vidovic

Okay, but have you managed to decode any channel yet ?

I find some code odd, maybe you can take a look as well...

init_channel in ngene-core.c creates the device sec0/caio0 with the
struct ngene_dvbdev_ci. In ngene-dvb.c you can see that this struct
declares the methods ts_read/ts_write to handle r/w operations on the
device sec0/caio0.

Now take a look at those methods (ts_read/ts_write). I don't see how
they 'connect' to the file cxd2099.c which contains the methods handling
the i/o to the cam.

--
Issa
