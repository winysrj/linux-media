Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.150])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <timf@iinet.net.au>) id 1KM1ZP-0007k0-K9
	for linux-dvb@linuxtv.org; Thu, 24 Jul 2008 16:13:32 +0200
Message-ID: <48888E02.60009@iinet.net.au>
Date: Thu, 24 Jul 2008 22:13:22 +0800
From: Tim Farrington <timf@iinet.net.au>
MIME-Version: 1.0
To: Nico Sabbi <Nicola.Sabbi@poste.it>
References: <48888700.6030105@iinet.net.au>	<200807241557.06705.Nicola.Sabbi@poste.it>
	<200807241601.14850.Nicola.Sabbi@poste.it>
In-Reply-To: <200807241601.14850.Nicola.Sabbi@poste.it>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] dvb mpeg2?
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

Nico Sabbi wrote:
> On Thursday 24 July 2008 15:57:06 Nico Sabbi wrote:
>
>   
>> be aware that demuxing the TS in its elementary streams implicitly
>> drops all timestamps (that are recorded in the PES headers), thus
>> recombining the audio and video streams will produce a
>> desynchronized output, unless you are lucky.
>> There simply aren't enough informations to keep synchrony without
>> timestamps. With your method if a stream is corrupt
>> you will likely see a desynchronization from the first breakage
>> onward, while working on the TS the muxer has a chance to recover
>>
>>     
>
> BTW, although mencoder is broken in countless respects,
> generating an mpeg-ps is quite safe:
>
> $ mencoder -demuxer lavf -of mpeg -mpegopts format=dvd -oac copy -ovc 
> copy -o output.mpg input.ts 
>
> eventually dropping -demuxer lavf if it doesn't work (lavf's demuxer
> isn't nearly as permissive as my native TS demuxer (the default one)
> but it has an advantage: strictly correct timestamps on all frames)
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
>   
Hi Nico,
Yes I wondered about corrupt streams, so I watched projectx in action 
carefully.
I need to understand it a bit more, but it found many corrupt timestamps
while demuxing, and repaired on the run. Time will tell, however I have 
some progress,
and I can't fault the process yet!

I intend to try all of everybody's suggestions. One question - with 
mencoder why format=dvd?

Regards,
Timf

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
