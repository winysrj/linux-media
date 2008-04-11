Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailout02.t-online.de ([194.25.134.17])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hartmut.hackmann@t-online.de>) id 1JkQXe-0003dA-HP
	for linux-dvb@linuxtv.org; Fri, 11 Apr 2008 23:12:15 +0200
Message-ID: <47FFD432.8020609@t-online.de>
Date: Fri, 11 Apr 2008 23:12:18 +0200
From: Hartmut Hackmann <hartmut.hackmann@t-online.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <Pine.LNX.4.62.0803141625320.8859@ns.bog.msu.ru>	<200803220711.07186@orion.escape-edv.de>	<47E53E1B.5050302@gmail.com>
	<200804102240.13933@orion.escape-edv.de>
In-Reply-To: <200804102240.13933@orion.escape-edv.de>
Subject: Re: [linux-dvb] TDA10086 fails? DiSEqC bad? TT S-1401 Horizontal
 transponder fails
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

Hi,

Oliver Endriss schrieb:
> Hi,
> 
> Manu Abraham wrote:
>> Oliver Endriss wrote:
>> ...
>>> Ok, some calculations according your formula
>>>
>>>>>>> BW = (1 + RO) * SR/2 + 5) * 1.3
>>> 45 MSPS:
>>> BW = ((1 + 0.35) * 45/2 + 5) * 1.3 = 46
>>>
>>> -> cutoff 36 MHz (maximum value supported)
>>>
>>> 27 MSPS:
>>> BW = ((1 + 0.35) * 27/2 + 5) * 1.3 = 30,2
>>>
>>> -> cutoff 31 MHz
>>>
>>> 22 MSPS:
>>> BW = ((1 + 0.35) * 22/2 + 5) * 1.3 = 25,8
>>>
>>> -> cutoff 26 MHz
>>>
>>> Are these calculations correct, or did I miss something here?
>>
>> It looks fine, just round it off to the next integer. ie always round it
>> up, rather than rounding it down. For the cutoff at 36MHz, it is fine as
>> well, since at the last step, you will not need an offset, since it
>> would be the last step in the spectrum.
>> ...
>>> Afaics a simple pre-calculated lookup table with 32 entries should do
>>> the job. At least for the cut-off frequency.
>> That's possible, since you need only 32 precomputed entries, rather than
>> continuous values. That would be much better too, without any runtime
>> overheads. Just the table needs to be done nice.
> 
> Now I found some time to come back to this issue,
> 
> I prepared a small patch to set the cutoff according to Manu's formula.
> The calculation is simple enough for integer arithmetic, so it is not
> worth to prepare a lookup-table.
> 
> @ldvb:
> Please test and report whether it works for you.
> 
> CU
> Oliver
> 
I intended to do the same.
Since I have a patch for tda10086 which needs public testing as well, i
would like to propose this:
I do a static check and integrate the patch in my repository together
with my patch and ask for public testing.
Hope this will not overstress the few testers we have ;-)

Best regards
   Hartmut

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
