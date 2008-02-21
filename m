Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailhost.okg-computer.de ([85.131.254.125])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux-dvb@okg-computer.de>) id 1JSKrQ-0007mQ-Dn
	for linux-dvb@linuxtv.org; Fri, 22 Feb 2008 00:29:52 +0100
Received: from [10.10.43.100] (e180066193.adsl.alicedsl.de [85.180.66.193])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mailhost.okg-computer.de (Postfix) with ESMTP id C1CE2441B7
	for <linux-dvb@linuxtv.org>; Fri, 22 Feb 2008 00:29:48 +0100 (CET)
Message-ID: <47BE095E.3040301@okg-computer.de>
Date: Fri, 22 Feb 2008 00:29:34 +0100
From: =?ISO-8859-15?Q?Jens_Krehbiel-Gr=E4ther?=
 <linux-dvb@okg-computer.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <47BDA96B.7080700@okg-computer.de>
	<200802212208.05930.dkuhlen@gmx.net>
In-Reply-To: <200802212208.05930.dkuhlen@gmx.net>
Subject: Re: [linux-dvb] Need Help with PCTV 452e (USB DVB-S2 device with
 STB0899)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Dominik Kuhlen schrieb:
> On Thursday 21 February 2008, Jens Krehbiel-Gr=E4ther wrote:
>   =

>> Hi!
>>
>> After two defective devices I got now a working one from pinnacle =

>> support (I tested it in Windows and it works fine).
>>
>> But under Linux I could not get a positive scan or channel-lock. Could =

>> please anyone tell me what I am doing wrong? I read the list and =

>> searched the list archive and did everything described here, but my =

>> device isn't working.
>>
>> I followed the instructions of the wiki about this device:
>>
>> hg clone http://www.jusst.de/hg/multiproto
>> wget -O pctv452e.patch http://www.linuxtv.org/pipermail/linux-dvb/attach=
ments/20080125/b9e1d749/attachment-0001.patch
>> cd multiproto
>> patch -p1 < ../pctv452e.patch
>>     =

> Hmm, I discovered that there's in an issue in pctv452e.c line 426 which s=
hould be:
>   { STB0899_I2CRPT        , 0x58 },
> In the patch there's 0x5c as value which doesn't work for me.
>
> Could you please try this and report if it works for you too.
>   =



Great, that was the trick, now scanning and szap work fine.

Thanks for that hint!

Jens

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
