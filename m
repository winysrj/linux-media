Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1JcnPV-0002Zd-ER
	for linux-dvb@linuxtv.org; Fri, 21 Mar 2008 21:00:18 +0100
Message-ID: <47E413C5.6080002@gmail.com>
Date: Sat, 22 Mar 2008 00:00:05 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Matthias Schwarzott <zzam@gentoo.org>
References: <Pine.LNX.4.62.0803141625320.8859@ns.bog.msu.ru>	<47E2D3C4.2050005@gmail.com>	<200803211015.54663@orion.escape-edv.de>
	<200803211936.06052.zzam@gentoo.org>
In-Reply-To: <200803211936.06052.zzam@gentoo.org>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi Mathias,

Matthias Schwarzott wrote:
> Zarlink zl1003x datasheet (avail on net) tells this:
> fbw = (alpha * symbol rate) / (2.0 * 0.8) + foffset
> 
> where alpha is roll-off 1.35 for dvb-s and 1.20 for DSS
> 
> The manual suggests to use highest possible bandwidth for aquiring a lock.
> And after that read back the offset from the demod and adjust the tuner then.


There are some small differences between some of the demodulators. Most
of the Intel DVB-S demods have a striking feature, which are found in
few other demods only. This was seen on the Zarlink and Microtune
devices, from where it originated from.

Other vendors also have implementations similar to this such as Fujitsu
and the newer devices from STM. This involves more complexity within the
demodulator core.

They are capable of doing Auto SR. ie, you request the maximum possible,
the demod gives you a SR offset and you can re-adjust the BW filter on
the tuner.

This feature is also more popularly known as "Blindscan", where you need
to just know the frequency of the signal only. This is the basic feature
upon which Blindscan is built upon. Most demods can accomodate a SR
tolerance of around +/-5% only, greater than which they will fail to
acquire. Since the sampling frequency aka Nyquist sampling rate depends
directly on the Symbol rate (SR) in which case you need to know the
Symbol Rate, which is used to set up the tuner BW filter too.

In this regard, you cannot apply the logic that's available for a Auto
SR capable demodulator to a standard demodulator.

Regards,
Manu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
