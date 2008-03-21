Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1Jco9S-0007ZR-Aj
	for linux-dvb@linuxtv.org; Fri, 21 Mar 2008 21:47:47 +0100
Message-ID: <47E41EE6.6020800@gmail.com>
Date: Sat, 22 Mar 2008 00:47:34 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Matthias Schwarzott <zzam@gentoo.org>
References: <Pine.LNX.4.62.0803141625320.8859@ns.bog.msu.ru>
	<200803211936.06052.zzam@gentoo.org> <47E413C5.6080002@gmail.com>
	<200803212115.01478.zzam@gentoo.org>
In-Reply-To: <200803212115.01478.zzam@gentoo.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TDA10086 fails? DiSEqC bad? TT S-1401 Horizontal
 transponder fails
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Matthias Schwarzott wrote:
> On Freitag, 21. M=E4rz 2008, Manu Abraham wrote:
>> Hi Mathias,
>>
>> Matthias Schwarzott wrote:
>>> Zarlink zl1003x datasheet (avail on net) tells this:
>>> fbw =3D (alpha * symbol rate) / (2.0 * 0.8) + foffset
>>>
>>> where alpha is roll-off 1.35 for dvb-s and 1.20 for DSS
>>>
>>> The manual suggests to use highest possible bandwidth for aquiring a
>>> lock. And after that read back the offset from the demod and adjust the
>>> tuner then.
>> There are some small differences between some of the demodulators. Most
>> of the Intel DVB-S demods have a striking feature, which are found in
>> few other demods only. This was seen on the Zarlink and Microtune
>> devices, from where it originated from.
>>
>> Other vendors also have implementations similar to this such as Fujitsu
>> and the newer devices from STM. This involves more complexity within the
>> demodulator core.
>>
>> They are capable of doing Auto SR. ie, you request the maximum possible,
>> the demod gives you a SR offset and you can re-adjust the BW filter on
>> the tuner.
>>
>> This feature is also more popularly known as "Blindscan", where you need
>> to just know the frequency of the signal only. This is the basic feature
>> upon which Blindscan is built upon. Most demods can accomodate a SR
>> tolerance of around +/-5% only, greater than which they will fail to
>> acquire. Since the sampling frequency aka Nyquist sampling rate depends
>> directly on the Symbol rate (SR) in which case you need to know the
>> Symbol Rate, which is used to set up the tuner BW filter too.
>>
> I meant not doing auto SR for demod, but just setting tuner to maximum BW=
 and =

> programming demod as usual (with setting SR). And then read offset freq. =
from =

> demod (that is basically the full foffset).

I followed you,

You wanted to do:

1*) Set Tuner to max avail BW (BW directly proportional to SR and RO,
nothing to do with frequency)

2*) You ask the tuner to tune to a frequency

3*) Request the demodulator to acquire at the Nyquist rate (SR involved)

4*) After acquisition and the transform applied internally by the demod,
you get a frequency offset


with the slight change to (1*) Auto SR devices and normal devices, just
do the same thing altogether.

> So we can calc the real needed bandwidth filter to get the signal through=
 or =

> even retune to get the signal more near to zero-IF.
> Maybe this even require a thread to follow drift.


With what math will you calculate BW from Carrier frequency ? AFAIK,
Bandwidth implies Symbols per Second or Symbol Rate and is independant
of frequency.

BW also known as Symbol Frequency according to Shannons Channel capacity
theorem as in:

http://en.wikipedia.org/wiki/Shannon-Hartley_theorem
http://en.wikipedia.org/wiki/Channel_capacity
http://en.wikipedia.org/wiki/Bit_rate

>> In this regard, you cannot apply the logic that's available for a Auto
>> SR capable demodulator to a standard demodulator.
>>
> Does only auto SR capable demods offer reading freq. offset back?


Almost all demods offer a freq offset readback. But how will you set up
the tuner bandwidth filter with a frequency offset readback ?

Anything that i am missing here ?

The tuner bandwidth filter depends upon the available SR, rather than
frequency. It has got nothing to do with the carrier frequency offset
that which is retrieved back from the demodulator.


Regards,
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
