Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yw-out-2324.google.com ([74.125.46.29])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <kosio.dimitrov@gmail.com>) id 1KnyeQ-0008Ip-5e
	for linux-dvb@linuxtv.org; Thu, 09 Oct 2008 18:46:13 +0200
Received: by yw-out-2324.google.com with SMTP id 3so28394ywj.41
	for <linux-dvb@linuxtv.org>; Thu, 09 Oct 2008 09:46:05 -0700 (PDT)
Message-ID: <8103ad500810090946m15f6f5a3k4d78becd6232ff52@mail.gmail.com>
Date: Thu, 9 Oct 2008 19:46:05 +0300
From: "Konstantin Dimitrov" <kosio.dimitrov@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <8103ad500810090926i7b506822o9ece29bc5725fc9b@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <455973.84516.qm@web23203.mail.ird.yahoo.com>
	<c74595dc0810090845h656f143r8519e8fe54669b6d@mail.gmail.com>
	<c74595dc0810090848k14ede67fu81c9c2d0423d2849@mail.gmail.com>
	<8103ad500810090926i7b506822o9ece29bc5725fc9b@mail.gmail.com>
Subject: Re: [linux-dvb] [vdr] stb0899 and tt s2-3200
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

btw looking with hex editor in the TT S2-3200 Windows drivers
(ttbudget2.sys) shows that the STB0899 function names are the same as
in stb0899_chip.c from the Twinhan Linux drivers, which makes me
convinced that the code in the Twinhan Linux drivers is really the
reference Microelectronics code for STB0899 and STB6100ST on which the
Technotrend Windows drivers are based.

On Thu, Oct 9, 2008 at 7:26 PM, Konstantin Dimitrov
<kosio.dimitrov@gmail.com> wrote:
> the STB0899 (and STB6100) code in the Twinhan Linux drivers is different:
>
> http://www.twinhan.com/files/AW/Linux/AZLinux_v1.4.2_CI_FC6.tar.gz
>
> most of the files don't have copyright notice, but in one of the files
> there is "Copyright STMicroelectronics".
>
> so, maybe Twinhan Linux drivers include the reference STB0899 and
> STB6100 code from STMicroelectronics.
>
> 2008/10/9 Alex Betis <alex.betis@gmail.com>:
>> cheched = checked :)
>>
>> Typing too fast...
>>
>> Since tuner lock is more reliable, I'll try to remove some of my workarounds
>> on DVB-S search algorithm.
>>
>>
>> On Thu, Oct 9, 2008 at 5:45 PM, Alex Betis <alex.betis@gmail.com> wrote:
>>>
>>> On Thu, Oct 9, 2008 at 5:17 PM, Newsy Paper
>>> <newspaperman_germany@yahoo.com> wrote:
>>>>
>>>> I have Alex Betis' + Ales Jurik's patch running with liplianindvb, but
>>>> still the same problem with those DVB-S2 8PSK transponders.
>>>>
>>>
>>> Same here. Although I see improvements on signal lock. With Ales's tuner
>>> changes the signal is constantly found on all S2 transponders I've cheched,
>>> FEC is locked and dropped very fast (that gives the result of bad or no
>>> image).
>>> Now we need someone with scope and logic on stb0899 chip :)
>>> This time I'll be happy to receive stb0899 documentation.
>>>
>>> Thanks Ales, one step to the right direction!
>>
>>
>> _______________________________________________
>> linux-dvb mailing list
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
