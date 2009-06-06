Return-path: <linux-media-owner@vger.kernel.org>
Received: from [195.7.61.12] ([195.7.61.12]:59671 "EHLO killala.koala.ie"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbZFFUhs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Jun 2009 16:37:48 -0400
Message-ID: <4A2AD39B.9010700@koala.ie>
Date: Sat, 06 Jun 2009 21:37:47 +0100
From: Simon Kenyon <simon@koala.ie>
MIME-Version: 1.0
To: "Igor M. Liplianin" <liplianin@me.by>
CC: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] SDMC DM1105N not being detected
References: <e6ac15e50904022156u40221c3fib15d1b4cdf36461@mail.gmail.com> <4A295F87.50307@koala.ie> <4A2966EA.8080406@koala.ie> <200906061157.16433.liplianin@me.by>
In-Reply-To: <200906061157.16433.liplianin@me.by>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Igor M. Liplianin wrote:
> On 5 June 2009 21:41:46 Simon Kenyon wrote:
>> Simon Kenyon wrote:
>>> Simon Kenyon wrote:
>>>> the picture seems to be breaking up badly
>>>> will revert to my version and see if that fixes it
>>> [sorry for the delay. i was away on business]
>>>
>>> i've checked and your original code, modified to compile and including
>>> my changes to control the LNB works very well; the patch you posted does
>>> not. i have swapped between the two and rebooted several times to make
>>> sure.
>>>
>>> i will do a diff and see what the differences are
>>>
>>> regards
>>> --
>>> simon
>> the main changes seem to be a reworking of the interrupt handling and
>> some i2c changes
>> --
>> simon
> How fast is your system?
> 

reasonably fast
it is a dual core AMD64 X2 running at 3.1GHz


/proc/cpuinfo says:

processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 107
model name      : AMD Athlon(tm) 64 X2 Dual Core Processor 6000+
stepping        : 2
cpu MHz         : 3100.268
cache size      : 512 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext 
fxsr_opt rdtscp lm 3dnowext 3dnow rep_good pni cx16 lahf_lm cmp_legacy 
svm extapic cr8_legacy 3dnowprefetch
bogomips        : 6203.89
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc 100mhzsteps

processor       : 1
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 107
model name      : AMD Athlon(tm) 64 X2 Dual Core Processor 6000+
stepping        : 2
cpu MHz         : 3100.268
cache size      : 512 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
apicid          : 1
initial apicid  : 1
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext 
fxsr_opt rdtscp lm 3dnowext 3dnow rep_good pni cx16 lahf_lm cmp_legacy 
svm extapic cr8_legacy 3dnowprefetch
bogomips        : 6203.89
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc 100mhzsteps
