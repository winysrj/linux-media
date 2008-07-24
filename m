Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.150])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <timf@iinet.net.au>) id 1KLzWM-0007kC-LW
	for linux-dvb@linuxtv.org; Thu, 24 Jul 2008 14:02:12 +0200
Message-ID: <48886F49.8030206@iinet.net.au>
Date: Thu, 24 Jul 2008 20:02:17 +0800
From: Tim Farrington <timf@iinet.net.au>
MIME-Version: 1.0
To: Nico Sabbi <Nicola.Sabbi@poste.it>
References: <488860FE.5020500@iinet.net.au>
	<4888623F.5000108@to-st.de>	<488863EF.8000402@iinet.net.au>
	<200807241326.07492.Nicola.Sabbi@poste.it>
In-Reply-To: <200807241326.07492.Nicola.Sabbi@poste.it>
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
> On Thursday 24 July 2008 13:13:51 Tim Farrington wrote:
>   
>> Tobias Stoeber wrote:
>>     
>>> Tim Farrington schrieb:
>>>       
>>>> Can you please give me some guidance as to how to discover
>>>> what format is output from the v4l-dvb driver.
>>>>
>>>> The DVB-T standard is, as I understand it, MPEG2,
>>>> however with kaffeine, me-tv, mplayer if I record to a file,
>>>> (dump from the raw data stream),
>>>> it appears to be stored as a MPEG1 file.
>>>> If I use GOPchop, it will not open any of these files,
>>>> as it will only open MPEG2 files.
>>>>         
>>> Well if I remember it right, a DVB stream (in MPEG2) is MPEG2-TS
>>> and GOPchop will handle MPEG2-PS!
>>>
>>> Cheers, Tobias
>>>       
>> Hi Tobias,
>> Do you mean GOPchop won't open MPEG2-TS?
>>
>> What I'm after is some tool/means which will accurately display a
>> format descriptor for
>> a MPEG(x) file/stream.
>>
>> MPEG2-TS is what is supposed to be the format, but how can I
>> discover if it really is?
>>
>> Regards,
>> Tim Farrington
>>
>>     
>
> www.avidemux.org will open it.
> file file.ts should say something about it
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
>   
Hi Nico,
I was a huge fan of avidemux until about 2 hours ago when I discovered
that editing a file caused all sorts of grief with a/v sync.
Its doc's tell me to send the file through Projectx first, etc

Hence, I was attracted to gopchop.

All I would like is an mpeg gui editor which can simply edit a file 
dumped from
my dvb stream. I've tried many such as Cinerra (I think that's its name),
but this help from Tobias may give me a clue as to why many of them 
won't open
these files - they are MPEG2-TS and the apps perhaps need MPEG2-PS

Regards,
Tim Farrington

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
