Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from schoebelonline.de ([85.214.26.217])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hagen@schoebel-online.net>) id 1JqMJU-00061m-23
	for linux-dvb@linuxtv.org; Mon, 28 Apr 2008 07:54:09 +0200
Message-ID: <48156679.3030000@schoebel-online.net>
Date: Mon, 28 Apr 2008 07:54:01 +0200
From: =?ISO-8859-1?Q?Hagen_Sch=F6bel?= <hagen@schoebel-online.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <2f8cbffc0804271318gf146080yfc988718556ad405@mail.gmail.com>
	<E1JqLG0-000Jpq-00.goga777-bk-ru@f132.mail.ru>
In-Reply-To: <E1JqLG0-000Jpq-00.goga777-bk-ru@f132.mail.ru>
Cc: Ian Bonham <ian.bonham@gmail.com>
Subject: Re: [linux-dvb] HVR4000 & Heron
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


Before you try the 'new' modules you have to remove the 'original' 
Ubuntu-Version of cx88*. These modules can found in 
/lib/modules/2.6.24-16-generic/ubuntu/media/cx88 (don't now why not in 
normal tree) and come with paket linux-ubuntu-modules-2.6.24-16-generic.

Hagen

>> Hi All.
>>
>> Ok, so just installed the shiny, spangly new Ubuntu 8.04LTS (Hardy Heron) on
>> my machine with the HVR4000 in, and now, no TV! It's gone on with kernel
>> 2.6.24-16 on a P4 HyperThread, and everything worked just fine under Gutsy.
>> I've pulled down the v4l-dvb tree (current and revision 127f67dea087 as
>> suggested in Wiki) and tried patching with dev.kewl.org's MFE and SFE
>> current patches (7285) and the latest.
>>
>> Everything 'seems' to compile Ok, and installs fine. When I reboot however I
>> get a huge chunk of borked stuff and no card. (Dmesg output at end of
>> message)
>>
>> Could anyone please give me any pointers on how (or if) they have their
>> HVR4000 running under Ubuntu 8.04LTS ?
>>
>> Would really appriciate it.
>> Thanks in advance,
>>
>> Ian
>>
>> DMESG Output:
>> cx88xx: disagrees about version of symbol videobuf_waiton
>> [   37.790909] cx88xx: Unknown symbol videobuf_waiton
>>
>>     
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>   


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
