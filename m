Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from joan.kewl.org ([212.161.35.248])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <darron@kewl.org>) id 1Kr4Zp-0001BP-Ia
	for linux-dvb@linuxtv.org; Sat, 18 Oct 2008 07:42:15 +0200
From: Darron Broad <darron@kewl.org>
To: "Devin Heitmueller" <devin.heitmueller@gmail.com>
In-reply-to: <412bdbff0810171306n5f8768a2g48255db266d16aa8@mail.gmail.com> 
References: <412bdbff0810171104ob627994me2876504b43c18d8@mail.gmail.com>
	<2207.1224273353@kewl.org>
	<412bdbff0810171306n5f8768a2g48255db266d16aa8@mail.gmail.com>
Date: Sat, 18 Oct 2008 06:42:08 +0100
Message-ID: <5905.1224308528@kewl.org>
Cc: Linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [RFC] SNR units in tuners
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

In message <412bdbff0810171306n5f8768a2g48255db266d16aa8@mail.gmail.com>, "Devin Heitmueller" wrote:

hi

>On Fri, Oct 17, 2008 at 3:55 PM, Darron Broad <darron@kewl.org> wrote:
>>>===
>> <SNIP>
>>>cx24116.c       percent scaled to 0-0xffff, support for ESN0
>> <SNIP>
>>
>> There is no hole here but I thought I would pass you by some
>> history with this.
>>
>> The scaled value was calibrated against two domestic satellite
>> receivers. The first being a nokia 9600s with dvb2000 and
>> the other being a Fortec star beta. At the time there was
>> no knowledge of what the cx24116 value represented and no
>> great idea of what the domestic box values represented.
>> However, the scaling function matches very closely to those
>> two machines. What this means in essence is not much but
>> may be useful to you.
>
>By all means, if you have information to share about how the
>calculation was arrived at, please do.
>
>At this point the goal is to understand what the value means for
>different demods.  For the simple cases where the answer is "it's the
>SNR in 0.1db as provided by register X", then it's easy.  If it's "I
>don't really know and I just guessed based on empirical testing, then
>that is useful information too.
>
>Once people have reported in with the information, I will see about
>submitting a patch reflecting this information as a comment in the
>driver source for the various demods.

The trouble there is that the scaling for the cx24116 already works
from an end-user perspective. The value derived in the code is
a possible maximum of 160 from the chip. REELBOX decided on 176
which may be more accurate.

A quick glance here:
http://www.mathworks.com/matlabcentral/files/19717/ExactBER.jpg
Would suggest that if that 160 equates to around 10 esn0 (QPSK)
then the register on that chip may equal -5 when 0. I have no real
idea of course as I have no access to any confidential information.

Also, if you refer to that graph, we can see that to scale esn0
for the end user it also needs to take into account that it's
maximum requirement varies per modulation scheme.

I am no expert on this but it doesn't seem as simple as it
may do on first sight.

cya

--

 // /
{:)==={ Darron Broad <darron@kewl.org>
 \\ \ 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
