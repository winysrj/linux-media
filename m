Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1Jv4pI-0004OK-Eu
	for linux-dvb@linuxtv.org; Sun, 11 May 2008 08:14:29 +0200
Message-ID: <48268EB9.6060000@gmail.com>
Date: Sun, 11 May 2008 10:14:17 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
References: <482560EB.2000306@gmail.com>	
	<200805101717.23199@orion.escape-edv.de>	
	<200805101727.55810@orion.escape-edv.de>	
	<1210456421.7632.29.camel@palomino.walls.org>
	<48261EB5.2090604@gmail.com>
	<1210463068.7632.102.camel@palomino.walls.org>
In-Reply-To: <1210463068.7632.102.camel@palomino.walls.org>
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
> On Sun, 2008-05-11 at 02:16 +0400, Manu Abraham wrote:
>> Andy Walls wrote:
>>> On Sat, 2008-05-10 at 17:27 +0200, Oliver Endriss wrote:
>>>> Oliver Endriss wrote:
>>>>> e9hack wrote:
>>>>>> the uncorrected block count is reset on a read request for the tda10021 and stv0297. This 
>>>>>> makes the UNC value of the femon plugin useless.
>>>>> Why? It does not make sense to accumulate the errors forever, i.e.
>>>>> nobody wants to know what happened last year...
>>>>>
>>>>> Afaics it is ok to reset the counter after reading it.
>>>>> All drivers should behave this way.
>>>>>
>>>>> If the femon plugin requires something else it might store the values
>>>>> and process them as desired.
>>>>>
>>>>> Afaics the femon command line tool has no problems with that.
>>>> Argh, I just checked the API 1.0.0. spec:
>>>> | FE READ UNCORRECTED BLOCKS
>>>> | This ioctl call returns the number of uncorrected blocks detected by the device
>>>> | driver during its lifetime. For meaningful measurements, the increment
>>>> | in block count during a speci c time interval should be calculated. For this
>>>> | command, read-only access to the device is suf cient.
>>>> | Note that the counter will wrap to zero after its maximum count has been
>>>> | reached
>>>>
>>>> So it seens you are right and the drivers should accumulate the errors
>>>> forever. Any opinions?
>>> For communications systems, whether its is two-way or one-way broadcast,
>>> most people are concerned with the error *rate* (errors per unit time)
>>> rather than absolute error counts.  Communications engineers have a good
>>> understanding of what it means to have a 10^-2 BER vs 10^-12 BER, and
>>> adjust their expectations accordingly.  Absolute counts have less
>>> meaning to engineers, and I'm not sure what a layman would make of them.
>> There is different terminology involved:
>>
>> BER: implies a rate which is averaged over a period of time. This
>> implies the errors in the stream, not after FEC.
> 
> Yes.  I used the term too loosely in my example.  Thank you for the
> clarification/correction.
> 
> 
>> UNC: Uncorrected symbols over a lifetime, well this is not practically
>> possible and will wrap around. This is not related to time, but it is
>> just a measure of the symbols that wasn't been able by the FEC engine to
>> correct.
> 
> Right.  But maybe a Symbol Error (or Erasure) Rate provides more useful
> information than just a count, no?


Let me make it more clear. All the parameters defined are quite
standard, and used consistently for all demodulators.
eg: Es/No ==> SNR or CNR

For the channel as it is, there is no UNC used there. No channel is
considered noise free at any rate for a given bandwidth. To avoid this
situation, encoding/decoding is used.

For the channel as it is, the errors are mentioned in relation to time,
ie BER

After it passes through this channel, then BER is useless, because the
constraints of the channel do not apply any more. The encoding/decoding
concept follows the methodology that a certain number of errors can be
corrected when some information is sent alongwith in the same channel
alongwith the same data in a cyclic fashion.

The decoder in this case is able to correct a certain number of symbols
and in certain cases there will uncorrectable symbols. There is not much
of a use knowing at what exact instance these were uncorrectable, as
these are just dealing with block errors.

> 
> An error rate computed over a "short" interval can be used to detect a
> period of communications interruption within software to alert the user
> or to take corrective action.
> 
> Absolute counts aren't useful for assessing the current "health" of the
> system.


When you want to state how many blocks the FEC engine corrected (there
are different FEC engines that we use currently RS32, TurboCodes, LDPC),
you have only the uncorrectable symbols to state and unfortunately these
are not really time bound.

> 
>> Generally a meaningless term, in many cases except a few.
> 
> I agree.
> 
>> Absolute errors are used very scantily, but have been used to see how
>> good/bad the whole system is.
> 
> Except for in safety critical systems (fire suppression system,
> automobile brakes, etc.), how can a "good/bad" determination based on an
> error count be separated from a time interval over which that error
> count occurred?


It defines whether the FEC engine worked as expected. eg: Just looking
at a UNC counter counting up with a high BER shows a bad channel.
looking at a UNC counter going up with a low BER shows a bad error
correction scheme. looking at a very low BER and a high number of
uncorrectables imply a bad FEC engine/scheme.

Error correction works by looking at the last n symbols received, not
symbol errors per unit time.


>>  BER cannot define this, as it is defined
>> before the FEC. Sometimes what's defined in the BER, the FEC engine
>> might be able to correct and hence.
> 
> Right BER doesn't define performance of a system, just a constraint
> under which the system is expected to work.

BER (BER) and Es/No (SNR) together defines the quality of a channel.


> So we can call what I suggested Uncorrected Symbol Rate, or Symbol Error
> Rate, or Message Error Rate if the FEC covers more than 1 symbol -
> whatever makes the most sense.

Error correction is never a part of the channel. In all cases as the
receiver, we are interested in the channel only, but for a safeguard
sometimes we look at what the Error correction engine did, whether the
scheme as a whole worked well. For the channel, the broadcaster knows
that he doesn't have to look at UNC in the long run, but while setting
up his system as a whole UNC is very much useful, as to find whether his
scheme worked as expected.

For the noisy channel, there is no error correction. The channel doesn't
know what error correction you use. Always Rate is measured against time
Similar to an Energy meter in your home doesn't know what you use the
energy for, but it knows how much you consumed and at what power factor.

> My opinion is that reporting of rate is more useful than absolute
> counts.

It is rate that which is used (BER) for the channel, Absolute count from
the FEC engine is used to find whether the FEC scheme alongwith the
engine worked as expected. Error correction schemes are used
selectively, depending upon different conditions. Sometimes it is tested
empirically, by the broadcaster. In this case UNC is very much helpful.
UNC per unit time doesn't make sense in that regard. UNC can be
considered more like a log sheet, that some events occured.


Regards,
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
