Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-out.m-online.net ([212.18.0.9])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <zzam@gentoo.org>) id 1JcneN-0004Gs-B4
	for linux-dvb@linuxtv.org; Fri, 21 Mar 2008 21:15:41 +0100
From: Matthias Schwarzott <zzam@gentoo.org>
To: Manu Abraham <abraham.manu@gmail.com>
Date: Fri, 21 Mar 2008 21:15:01 +0100
References: <Pine.LNX.4.62.0803141625320.8859@ns.bog.msu.ru>
	<200803211936.06052.zzam@gentoo.org> <47E413C5.6080002@gmail.com>
In-Reply-To: <47E413C5.6080002@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803212115.01478.zzam@gentoo.org>
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

On Freitag, 21. M=E4rz 2008, Manu Abraham wrote:
> Hi Mathias,
>
> Matthias Schwarzott wrote:
> > Zarlink zl1003x datasheet (avail on net) tells this:
> > fbw =3D (alpha * symbol rate) / (2.0 * 0.8) + foffset
> >
> > where alpha is roll-off 1.35 for dvb-s and 1.20 for DSS
> >
> > The manual suggests to use highest possible bandwidth for aquiring a
> > lock. And after that read back the offset from the demod and adjust the
> > tuner then.
>
> There are some small differences between some of the demodulators. Most
> of the Intel DVB-S demods have a striking feature, which are found in
> few other demods only. This was seen on the Zarlink and Microtune
> devices, from where it originated from.
>
> Other vendors also have implementations similar to this such as Fujitsu
> and the newer devices from STM. This involves more complexity within the
> demodulator core.
>
> They are capable of doing Auto SR. ie, you request the maximum possible,
> the demod gives you a SR offset and you can re-adjust the BW filter on
> the tuner.
>
> This feature is also more popularly known as "Blindscan", where you need
> to just know the frequency of the signal only. This is the basic feature
> upon which Blindscan is built upon. Most demods can accomodate a SR
> tolerance of around +/-5% only, greater than which they will fail to
> acquire. Since the sampling frequency aka Nyquist sampling rate depends
> directly on the Symbol rate (SR) in which case you need to know the
> Symbol Rate, which is used to set up the tuner BW filter too.
>
I meant not doing auto SR for demod, but just setting tuner to maximum BW a=
nd =

programming demod as usual (with setting SR). And then read offset freq. fr=
om =

demod (that is basically the full foffset).
So we can calc the real needed bandwidth filter to get the signal through o=
r =

even retune to get the signal more near to zero-IF.
Maybe this even require a thread to follow drift.

> In this regard, you cannot apply the logic that's available for a Auto
> SR capable demodulator to a standard demodulator.
>
Does only auto SR capable demods offer reading freq. offset back?

Regards,
Matthias



-- =

Matthias Schwarzott (zzam)

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
