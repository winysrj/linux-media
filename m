Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1JuxMm-0006AO-DC
	for linux-dvb@linuxtv.org; Sun, 11 May 2008 00:16:37 +0200
Message-ID: <48261EB5.2090604@gmail.com>
Date: Sun, 11 May 2008 02:16:21 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
References: <482560EB.2000306@gmail.com>	<200805101717.23199@orion.escape-edv.de>	<200805101727.55810@orion.escape-edv.de>
	<1210456421.7632.29.camel@palomino.walls.org>
In-Reply-To: <1210456421.7632.29.camel@palomino.walls.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Fix the unc for the frontends tda10021	and
 stv0297
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

Andy Walls wrote:
> On Sat, 2008-05-10 at 17:27 +0200, Oliver Endriss wrote:
>> Oliver Endriss wrote:
>>> e9hack wrote:
>>>> the uncorrected block count is reset on a read request for the tda10021 and stv0297. This 
>>>> makes the UNC value of the femon plugin useless.
>>> Why? It does not make sense to accumulate the errors forever, i.e.
>>> nobody wants to know what happened last year...
>>>
>>> Afaics it is ok to reset the counter after reading it.
>>> All drivers should behave this way.
>>>
>>> If the femon plugin requires something else it might store the values
>>> and process them as desired.
>>>
>>> Afaics the femon command line tool has no problems with that.
>> Argh, I just checked the API 1.0.0. spec:
>> | FE READ UNCORRECTED BLOCKS
>> | This ioctl call returns the number of uncorrected blocks detected by the device
>> | driver during its lifetime. For meaningful measurements, the increment
>> | in block count during a speci c time interval should be calculated. For this
>> | command, read-only access to the device is suf cient.
>> | Note that the counter will wrap to zero after its maximum count has been
>> | reached
>>
>> So it seens you are right and the drivers should accumulate the errors
>> forever. Any opinions?
> 
> For communications systems, whether its is two-way or one-way broadcast,
> most people are concerned with the error *rate* (errors per unit time)
> rather than absolute error counts.  Communications engineers have a good
> understanding of what it means to have a 10^-2 BER vs 10^-12 BER, and
> adjust their expectations accordingly.  Absolute counts have less
> meaning to engineers, and I'm not sure what a layman would make of them.

There is different terminology involved:

BER: implies a rate which is averaged over a period of time. This
implies the errors in the stream, not after FEC.

UNC: Uncorrected symbols over a lifetime, well this is not practically
possible and will wrap around. This is not related to time, but it is
just a measure of the symbols that wasn't been able by the FEC engine to
correct. Generally a meaningless term, in many cases except a few.

Absolute errors are used very scantily, but have been used to see how
good/bad the whole system is. BER cannot define this, as it is defined
before the FEC. Sometimes what's defined in the BER, the FEC engine
might be able to correct and hence.

Regards,
Manu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
