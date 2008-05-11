Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1JvGOl-0001EB-94
	for linux-dvb@linuxtv.org; Sun, 11 May 2008 20:35:56 +0200
From: Andy Walls <awalls@radix.net>
To: Manu Abraham <abraham.manu@gmail.com>
In-Reply-To: <48268EB9.6060000@gmail.com>
References: <482560EB.2000306@gmail.com>
	<200805101717.23199@orion.escape-edv.de>
	<200805101727.55810@orion.escape-edv.de>
	<1210456421.7632.29.camel@palomino.walls.org>
	<48261EB5.2090604@gmail.com>
	<1210463068.7632.102.camel@palomino.walls.org>
	<48268EB9.6060000@gmail.com>
Date: Sun, 11 May 2008 14:35:16 -0400
Message-Id: <1210530916.3198.72.camel@palomino.walls.org>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Fix the unc for the frontends
	tda10021	and	stv0297
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

On Sun, 2008-05-11 at 10:14 +0400, Manu Abraham wrote:
> Andy Walls wrote:
> > On Sun, 2008-05-11 at 02:16 +0400, Manu Abraham wrote:
> >> Andy Walls wrote:
> >>> On Sat, 2008-05-10 at 17:27 +0200, Oliver Endriss wrote:
> >>>> Oliver Endriss wrote:
> >>>>> e9hack wrote:
> >>>>>> the uncorrected block count is reset on a read request for the tda10021 and stv0297. This 
> >>>>>> makes the UNC value of the femon plugin useless.
> >>>>> Why? It does not make sense to accumulate the errors forever, i.e.
> >>>>> nobody wants to know what happened last year...
> >>>>>
> >>>>> Afaics it is ok to reset the counter after reading it.
> >>>>> All drivers should behave this way.
> >>>>>
> >>>>> If the femon plugin requires something else it might store the values
> >>>>> and process them as desired.
> >>>>>
> >>>>> Afaics the femon command line tool has no problems with that.
> >>>> Argh, I just checked the API 1.0.0. spec:
> >>>> | FE READ UNCORRECTED BLOCKS
> >>>> | This ioctl call returns the number of uncorrected blocks detected by the device
> >>>> | driver during its lifetime. For meaningful measurements, the increment
> >>>> | in block count during a speci c time interval should be calculated. For this
> >>>> | command, read-only access to the device is suf cient.
> >>>> | Note that the counter will wrap to zero after its maximum count has been
> >>>> | reached
> >>>>
> >>>> So it seens you are right and the drivers should accumulate the errors
> >>>> forever. Any opinions?

> >> UNC: Uncorrected symbols over a lifetime, well this is not practically
> >> possible and will wrap around. This is not related to time, but it is
> >> just a measure of the symbols that wasn't been able by the FEC engine to
> >> correct.
> > 
> > Right.  But maybe a Symbol Error (or Erasure) Rate provides more useful
> > information than just a count, no?
> 
> 
> Let me make it more clear. All the parameters defined are quite
> standard, and used consistently for all demodulators.
> eg: Es/No ==> SNR or CNR
> 
> For the channel as it is, there is no UNC used there. No channel is
> considered noise free at any rate for a given bandwidth. To avoid this
> situation, encoding/decoding is used.
> 
> For the channel as it is, the errors are mentioned in relation to time,
> ie BER
> 
> After it passes through this channel, then BER is useless, because the
> constraints of the channel do not apply any more. The encoding/decoding
> concept follows the methodology that a certain number of errors can be
> corrected when some information is sent alongwith in the same channel
> alongwith the same data in a cyclic fashion.
> 
> The decoder in this case is able to correct a certain number of symbols
> and in certain cases there will uncorrectable symbols. There is not much
> of a use knowing at what exact instance these were uncorrectable, as
> these are just dealing with block errors.
> 
> > 
> > An error rate computed over a "short" interval can be used to detect a
> > period of communications interruption within software to alert the user
> > or to take corrective action.
> > 
> > Absolute counts aren't useful for assessing the current "health" of the
> > system.
> 
> 
> When you want to state how many blocks the FEC engine corrected (there
> are different FEC engines that we use currently RS32, TurboCodes, LDPC),
> you have only the uncorrectable symbols to state and unfortunately these
> are not really time bound.

Assuming the channel conditions are consistent with the assumptions
(e.g. AWGN) made in the design of the system.

Unfortunately for me, since I am far (65 miles?) from the broadcasting
stations, I receive many digital stations at a marginal SNR (Es/No *
Rs/W) for the FEC to work effectively.  Weather conditions (wind, rain,
cold fronts) between my antenna and the station cause transient channel
fades.  The Es/No can intermittently fall below the threshold for the
BER for which the FEC was designed, thus I do get time dependent
uncorrectable symbol indications.  The rate of change of uncorrectable
symbols being declared over a window of time, can tell me when I'm in a
channel fade (rate > 0) or not (rate == 0).

> > 
> >> Generally a meaningless term, in many cases except a few.
> > 
> > I agree.
> > 
> >> Absolute errors are used very scantily, but have been used to see how
> >> good/bad the whole system is.
> > 
> > Except for in safety critical systems (fire suppression system,
> > automobile brakes, etc.), how can a "good/bad" determination based on an
> > error count be separated from a time interval over which that error
> > count occurred?
> 
> 
> It defines whether the FEC engine worked as expected. eg: Just looking
> at a UNC counter counting up with a high BER shows a bad channel.
> looking at a UNC counter going up with a low BER shows a bad error
> correction scheme. looking at a very low BER and a high number of
> uncorrectables imply a bad FEC engine/scheme.
> 
> Error correction works by looking at the last n symbols received, not
> symbol errors per unit time.
> 
> 
> >>  BER cannot define this, as it is defined
> >> before the FEC. Sometimes what's defined in the BER, the FEC engine
> >> might be able to correct and hence.
> > 
> > Right BER doesn't define performance of a system, just a constraint
> > under which the system is expected to work.
> 
> BER (BER) and Es/No (SNR) together defines the quality of a channel.
>
> 
> > So we can call what I suggested Uncorrected Symbol Rate, or Symbol Error
> > Rate, or Message Error Rate if the FEC covers more than 1 symbol -
> > whatever makes the most sense.
> 
> Error correction is never a part of the channel. In all cases as the
> receiver, we are interested in the channel only, but for a safeguard
> sometimes we look at what the Error correction engine did, whether the
> scheme as a whole worked well. For the channel, the broadcaster knows
> that he doesn't have to look at UNC in the long run, but while setting
> up his system as a whole UNC is very much useful, as to find whether his
> scheme worked as expected.
> 
> For the noisy channel, there is no error correction. The channel doesn't
> know what error correction you use. Always Rate is measured against time
> Similar to an Energy meter in your home doesn't know what you use the
> energy for, but it knows how much you consumed and at what power factor.
> 
> > My opinion is that reporting of rate is more useful than absolute
> > counts.
> 
> It is rate that which is used (BER) for the channel,
>  Absolute count from
> the FEC engine is used to find whether the FEC scheme alongwith the
> engine worked as expected.

And if the channel experiences fades in addition to the typically
assumed AWGN characteristic, then the FEC can work well almost all of
the time, but still experience periods of time, during fades, that it
does not work.


>  Error correction schemes are used
> selectively, depending upon different conditions. Sometimes it is tested
> empirically, by the broadcaster. In this case UNC is very much helpful.
> UNC per unit time doesn't make sense in that regard.

OK, for selecting an FEC scheme when testing over a real or simulated
channel.  You still must take a certain amount of time before you
declare a good FEC scheme: the time or message count to declare the UNC
have stopped or are not going to occur (hence you're still dealing with
a rate measurement even if the message count you need to make the
declaration is 1).


>  UNC can be
> considered more like a log sheet, that some events occured.

And getting back to Oliver's original call for opinions: what good is
that log sheet, especially after a long time?

Assuming a good FEC system was selected for the system, the rate of
change of UNC at some short time after tuning to a channel tells you
whether you've got good reception (rate == 0) or not (rate > 0).

Similar periodic UNC rate measurements can tell you whether or not
you're in a fade and have lost reception or regained reception.  But
those measurements don't require you to keep the entire log sheet, just
a short window into the immediate past.

I can't think of a reason to keep the UNC log indefinitely.

In other words:
> >>>> | FE READ UNCORRECTED BLOCKS
> >>>> | This ioctl call returns the number of uncorrected blocks detected by the device
> >>>> | driver during its lifetime. For meaningful measurements, the increment
> >>>> | in block count during a speci c time interval should be calculated.

I agree with that: specifically for the case of declaring good reception
after changing channels or watching for intermittent fades.

>  For this
> >>>> | command, read-only access to the device is suf cient.

I don't agree with that.  Unless the device or driver can maintain an
extremely large accumulations of UNC blocks, an application trying to
make a rate measurement will need to set the counter to a known value if
the driver doesn't provide a rate measurement.



> 
> Regards,
> Manu

Regards,
Andy


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
