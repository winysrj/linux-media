Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1JT4BT-0002sm-HS
	for linux-dvb@linuxtv.org; Sun, 24 Feb 2008 00:53:35 +0100
Message-ID: <47C0B1F9.1000609@gmail.com>
Date: Sun, 24 Feb 2008 03:53:29 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Vangelis Nonas <vnonas@otenet.gr>
References: <32245669.2613.1203594791803.JavaMail.tomcat@dali.otenet.gr>	<47C01325.10407@otenet.gr>	<20080223174406.GB30387@moelleritberatung.de>	<47C0803D.2020504@gmail.com>	<20080223212013.GD30387@moelleritberatung.de>	<47C0903B.70606@gmail.com>	<20080223213258.GE30387@moelleritberatung.de>	<20080223214718.GF30387@moelleritberatung.de>	<47C09519.2090904@gmail.com>
	<47C09BCC.50403@gmail.com> <47C0CADE.6040203@otenet.gr>
In-Reply-To: <47C0CADE.6040203@otenet.gr>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TechniSat SkyStar HD: Problems scaning and zaping
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

Vangelis Nonas wrote:
> Thank you all for your help,
> 
> With the latest changeset I can tune channels correctly. I tried vdr and 
> szap (from Manu).
> 
> I dont know how to undo the last changesets and go back to 7200. Please 
> tell me how to do it and I'll get the timings.


clone the multiproto tree

from there, do a partial clone locally

hg clone -r 7200 multiproto multiproto_7200


> I also tried to scan Hotbird and it seems that scanning is now 
> consistent when you scan the same transponder more than once.
> 
> A full scan produced 1722 channels which is not bad, but it needs 
> improvement. There are about 2200 channels I think.

If you can provide a log with verbose=5 for the channels which it doesn't
scan it will be a bit more helpful. Will need the logs (/var/log/messages)
to debug this as well. The module parameters the same for both the
STB0899 and the STB6100

> I attach the log of the scan. It fails to scan certain transponders and 
> I believe (not 100% sure, but I did some testing) that this is 
> consistent across runs.

The log is just the output of the scan utility, will need the output from
the driver and a bit of thoughts.



Regards,
Manu

> Regards
> Vagelis
> 
> 
> 
> Manu Abraham wrote:
>> Manu Abraham wrote:
>>  
>>> Artem Makhutov wrote:
>>>    
>>>> Hi,
>>>>
>>>> On Sat, Feb 23, 2008 at 10:32:58PM +0100, Artem Makhutov wrote:
>>>>      
>>>>> On Sun, Feb 24, 2008 at 01:29:31AM +0400, Manu Abraham wrote:
>>>>>        
>>>>>> Are you sure that you got the top level 2 changes changeset 7204 
>>>>>> and 7203
>>>>>> respectively ?
>>>>>>           
>>>>> Oh, I only got 7203. Will try with 7204 in a few minutes.
>>>>>         
>>>> Awesome! It fixed the problem:
>>>>
>>>> Try: 100
>>>> Failes: 0
>>>> Tunes: 100
>>>>
>>>> Great job!
>>>>       
>>
>> Also, can you please do a benchmark in lock timings between changeset 
>> 7205 and 7200 ?
>>
>> The timing can be looked at by enabling the time stamps in the kernel 
>> config and
>> looking at timestamps in the logs for start - stop (FE_HAS_LOCK) 
>> between the 2
>> changesets.
>>
>> Regards,
>> Manu
>>
>> _______________________________________________
>> linux-dvb mailing list
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>
>>
>>   
> 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
