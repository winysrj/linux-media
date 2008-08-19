Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yx-out-2324.google.com ([74.125.44.29])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <beth.null@gmail.com>) id 1KVS2i-0005cz-Jl
	for linux-dvb@linuxtv.org; Tue, 19 Aug 2008 16:18:41 +0200
Received: by yx-out-2324.google.com with SMTP id 8so1219748yxg.41
	for <linux-dvb@linuxtv.org>; Tue, 19 Aug 2008 07:18:36 -0700 (PDT)
Message-ID: <7641eb8f0808190718j272d3f49gabe4f33f00154668@mail.gmail.com>
Date: Tue, 19 Aug 2008 16:18:35 +0200
From: Beth <beth.null@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <63574.203.82.187.131.1219140832.squirrel@webmail.planb.net.au>
MIME-Version: 1.0
Content-Disposition: inline
References: <7641eb8f0808180228y3446ca36y9ed9f770a3c2ec54@mail.gmail.com>
	<7641eb8f0808190220r53c8e214r54e3d568dbfb454c@mail.gmail.com>
	<63574.203.82.187.131.1219140832.squirrel@webmail.planb.net.au>
Subject: Re: [linux-dvb] Skystar HD2 (device don't stream data).
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

Hi Kevin, thanks for your help, I am still trying to interpret the
information given by dvbsnoop, but all seems to be ok, oops, this make
things worst because some must be wrong :). The problem is that I
don't know what I am looking for, so yes, I get pid lists on the
stream, data from an VID, but I really don't know what I am doing, or
doing wrong.

Thanks for your kind help, regards.

2008/8/19 Kevin Sheehan <ks@ephedrine.net>:
> dvbsnoop is your friend.
>
> http://dvbsnoop.sourceforge.net/
>
>
>> Last night I had the thing running and here are the results:
>>
>>
>> time dd if=/dev/dvb/adapter0/dvr0 of=test_100M.ts bs=1M count=100
>> 100+0 records in
>> 100+0 records out
>> 104857600 bytes (105 MB) copied, 35327.8 s, 3.0 kB/s
>>
>> real  588m47.813s
>> user  0m0.000s
>> sys   0m1.020s
>>
>>
>> Hey ten hours for a 100Mb file, definitively it's a turtle.
>>
>> What can I do with that file? as mplayer and similar doesn't plays it.
>>
>> Can I turn on something for debugging?
>>
>> Thats all (for today) thanks and kind regards.
>>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
