Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:58373 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbaENSpr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 14 May 2014 14:45:47 -0400
Message-ID: <5373B9D9.8020100@schinagl.nl>
Date: Wed, 14 May 2014 20:45:45 +0200
From: Olliver Schinagl <oliver@schinagl.nl>
MIME-Version: 1.0
To: fredboboss@free.fr
CC: Jonathan McCrohan <jmccrohan@gmail.com>,
	linux-media@vger.kernel.org, 746404@bugs.debian.org
Subject: Re: Bug#746404: dtv-scan-tables: /usr/share/dvb/dvb-t/fr-all file
 : invalid enum and no DVB-T services found
References: <1244967357.3000867.1400086241095.JavaMail.root@zimbra33-e6.priv.proxad.net>
In-Reply-To: <1244967357.3000867.1400086241095.JavaMail.root@zimbra33-e6.priv.proxad.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey Fred,

On 05/14/2014 06:50 PM, fredboboss@free.fr wrote:
> Thank you guys for your support !
>
> Olliver,
> thank you for your commit I tested it and the parsing 1) is now good.
>
> However problem 2) is still there : no services are found at the end of the scan.
>
> I mean when doing :
> scan dtv-scan-tables/dvb-t/fr-All
>
> the end result is :
> "ERROR: initial tuning failed
> dumping lists (0 services)
> Done.
> "
>
> Digging further I think the problem is due to FEC, QAM and Guard Interval parameters consistency.
>
> Indeed in France it seems there are 2 schemes for DVB-T services depending on where you live (I'm not quite 100% sure as I could only find very few official & reliable information) :
> FEC 3/4, QAM64, Guard Interval 1/8
> FEC 2/3, QAM16, Guard Interval 1/32
>
> Whereas in the file we have :
> FEC 2/3, QAM64, Guard Interval 1/32
Have you tried wscan? wscan is able to generate a 'initial scanning 
file' which should result in a proper file. See, the thing is, I don't 
know what is right and what is from for the entirety of France, I don't 
have the range nor the lingustic skill to read the dvb-t sites from 
French providers about the proper parameters. We are kind of Dependant 
on people who live in an area to submit the proper scan files.

If you think or know that identical frequencies are used with different 
parameters in different regions, then that is something that needs to be 
explored. If the auto setting works well, we could use that. But try to 
do a wscan and generate an initial scan file from it and see what it 
says, I'd be very curious indeed.

Olliver
> However I think this scheme may be OK depending on your HW frontend tolerance. Unfortunately it doesn't work with my Hauppauge NOVA-TD-500.
>
> I propose 2 options :
> A) rely on the the AUTO capability and use FEC AUTO, QAM AUTO, GI AUTO in the frequency file (please refer to attached file fr-All-optionA)
> B) double the file with both schemes for each frequency (please refer to attached file fr-All-optionB) : the drawback is that the scan is twice longer.
>
> I sucessfully managed to scan services with both A & B. I've attached both tests outputs for your reference.
> => But I only have TV channels with the first scheme in my area.
>
> Do you have an opinion about A or B ?
>
> Thank you.
>
> Cheers,
> Fred
>
>
>
>
>
> ----- Original Message -----
> From: "Olliver Schinagl" <oliver@schinagl.nl>
> Cc: "fredboboss" <fredboboss@free.fr>
> Sent: Monday, May 12, 2014 11:16:18 PM
> Subject: Re: Fwd: Bug#746404: dtv-scan-tables: /usr/share/dvb/dvb-t/fr-all file : invalid enum and no DVB-T services found
>
> Apologies to all involved, I overlooked this e-mail. I patched it to fix
> the casing as suggested in the e-mail and pushed it upstream. Can you
> please test it?
>
> Olliver
>
> On 04/29/2014 11:57 PM, Jonathan McCrohan wrote:
>> Hi Oliver,
>>
>> Please find Debian bug report from fredboboss regarding
>> dtv-scan-tables below.
>>
>> Thanks,
>> Jon
>>
>> On Tue, 29 Apr 2014 19:50:57 +0200, fredboboss wrote:
>>> Package: dtv-scan-tables
>>> Version: 0+git20140326.cfc2975-1
>>> Severity: normal
>>> 1246b27f8b45f84c1824925060ad931530542f2e
>>> Dear Maintainer,
>>>
>>> Dear Debian Maintainer,
>>>
>>> when performing a DVB-T frequency scan with the /usr/bin/scan utility (dvb-apps package) and the /usr/share/dvb/dvb-t/fr-All frequency file (dtv-scan-tables packages) the following 2 problems occur :
>>>
>>> 1) file parsing error :
>>> ERROR: invalid enum value '8MHZ'
>>> ERROR: invalid enum value '8K'
>>>
>>> 2) in the end no DVB-T services are found with a Hauppauge NOVA-TD-500 DVB-T card.
>>>
>>> Those problems seem to come from the /usr/share/dvb/dvb-t/fr-All file.
>>>
>>> The following changes are proposed in this file :
>>>
>>> For 1) :
>>> - 8MHZ changed by 8MHz
>>> - 8K changed by 8k
>>>
>>> For 2) :
>>> - change FEC_HI parameter by AUTO
>>>
>>> Thus the 1st frequency line of the file would be changed like that :
>>> -T 474000000 8MHZ 2/3 NONE QAM64 8K 1/32 NONE #Channel UHF 21
>>> +T 474000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 21
>>>
>>> (Please refer to the end of the mail for the complete modified file).
>>>
>>> Thanks to those modifications I successfully performed a DVB-T scan with the NOVA TD-500 card.
>>>
>>> In case more information is needed don't hesitate to contact me.
>>>
>>> Best regards,
>>> Fred
>>>
>>> -- System Information:
>>> Debian Release: jessie/sid
>>>     APT prefers testing-updates
>>>     APT policy: (500, 'testing-updates'), (500, 'testing')
>>> Architecture: amd64 (x86_64)
>>>
>>> Kernel: Linux 3.13-1-amd64 (SMP w/4 CPU cores)
>>> Locale: LANG=C, LC_CTYPE=en_US.utf8 (charmap=UTF-8)
>>> Shell: /bin/sh linked to /bin/dash
>>>
>>> -- no debconf information
>>>
>>> Modified file :
>>> # France ALL (All channel 21 to 60)
>>> # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
>>> T 474000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 21
>>> T 482000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 22
>>> T 490000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 23
>>> T 498000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 24
>>> T 506000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 25
>>> T 514000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 26
>>> T 522000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 27
>>> T 530000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 28
>>> T 538000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 29
>>> T 546000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 30
>>> T 554000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 31
>>> T 562000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 32
>>> T 570000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 33
>>> T 578000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 34
>>> T 586000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 35
>>> T 594000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 36
>>> T 602000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 37
>>> T 610000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 38
>>> T 618000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 39
>>> T 626000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 40
>>> T 634000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 41
>>> T 642000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 42
>>> T 650000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 43
>>> T 658000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 44
>>> T 666000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 45
>>> T 674000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 46
>>> T 682000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 47
>>> T 690000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 48
>>> T 698000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 49
>>> T 706000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 50
>>> T 714000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 51
>>> T 722000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 52
>>> T 730000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 53
>>> T 738000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 54
>>> T 746000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 55
>>> T 754000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 56
>>> T 762000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 57
>>> T 770000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 58
>>> T 778000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 59
>>> T 786000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 60

