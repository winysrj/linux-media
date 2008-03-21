Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1JcjOu-0004XD-Ng
	for linux-dvb@linuxtv.org; Fri, 21 Mar 2008 16:43:27 +0100
Received: from [212.12.32.49] (helo=smtp.work.de)
	by mail.work.de with esmtp (Exim 4.62)
	(envelope-from <abraham.manu@gmail.com>) id 1JcjOq-0008W6-Nk
	for linux-dvb@linuxtv.org; Fri, 21 Mar 2008 16:43:20 +0100
Received: from [86.97.13.12] (helo=[192.168.1.101])
	by smtp.work.de with esmtpa (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1JcjOq-0006Mu-8y
	for linux-dvb@linuxtv.org; Fri, 21 Mar 2008 16:43:20 +0100
Message-ID: <47E3D790.4020004@gmail.com>
Date: Fri, 21 Mar 2008 19:43:12 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <Pine.LNX.4.62.0803141625320.8859@ns.bog.msu.ru>	<47E2CF49.8070302@t-online.de>
	<47E2D3C4.2050005@gmail.com>
	<200803211015.54663@orion.escape-edv.de>
In-Reply-To: <200803211015.54663@orion.escape-edv.de>
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

Hi Oliver,

Oliver Endriss wrote:
> Hi,
> 
> Manu Abraham wrote:
>> Hi Hartmut,
>>
>> Hartmut Hackmann wrote:
>>
>>> This might be right! I could not get good information regarding the
>>> transponder bandwidths. We might need to make this depend on the
>>> symbol rate or a module parameter.
>> You can calculate the tuner bandwidth from the transponder symbol rate
>> (in Mbaud) for DVB-S:
>>
>> BW = (1 + RO) * SR/2 + 5) * 1.3
> 
> Apparently I need some lessons in signal theory. ;-)
> What does R0 stand for?

RO stands for Rolloff. This isn't anything big, but just defines the
sharpness of the bandwidth curve. You can think how a filter's bandwidth
would look like, when it is plotted out. This is just a filter
characteristic.

Normally why you need this is not new. Traditionally for old PLL based
tuners, this used to be in hardware, ie a LC component in the pre
stages, prior to the tuner.

With the arrival of Silicon Tuners, things do have changed. These things
have been made software configurable. There are advantages and
disadvantages to this. Well, there's so much that can talked about it,
but well let me not make it too long.

For Broadcast applications, ie all TV signals that we receive RO = 35%
We do have other rolloff as well, but generally the others are not used
in broadcast apps, but for professional purposes. When you have a lower
rolloff, what happens is that the filter is more of a tuned filter and
considered narrower slightly.

The advantage of a narrower filter is that since the edges fall of
sharply, lesser power is wasted, but brings in the disadvantage that the
spectrum is a bit more congested, but alternatibvely somebody could just
argue as well, you can pack in more into the entire spectrum.


> Do we have to select a higher cut-off value to compensate for the LNB
> drift and other stuff like that?

The "5" in there, is in fact implies +/-5Mhz for the LNB drift (5 Mhz on
either side off the offset. A LNB can drift in either direction at
different periods of the day, depending on the temperature. This drift
can cause an acquisition to fail, or an already acquired LOCK to fail on
a very general note). The drift is standard and is specified in one of
the ETSI specifications, one which i read a while back but don't
remember the specification number.


Regards,
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
