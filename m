Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay-pt1.poste.it ([62.241.4.164])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Nicola.Sabbi@poste.it>) id 1KLyxb-0002HU-T2
	for linux-dvb@linuxtv.org; Thu, 24 Jul 2008 13:26:18 +0200
Received: from nico2.od.loc (89.97.249.170) by relay-pt1.poste.it (7.3.122)
	(authenticated as Nicola.Sabbi@poste.it)
	id 4887C6810000457A for linux-dvb@linuxtv.org;
	Thu, 24 Jul 2008 13:26:12 +0200
From: Nico Sabbi <Nicola.Sabbi@poste.it>
To: linux-dvb@linuxtv.org
Date: Thu, 24 Jul 2008 13:26:07 +0200
References: <488860FE.5020500@iinet.net.au> <4888623F.5000108@to-st.de>
	<488863EF.8000402@iinet.net.au>
In-Reply-To: <488863EF.8000402@iinet.net.au>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807241326.07492.Nicola.Sabbi@poste.it>
Subject: Re: [linux-dvb] dvb mpeg2?
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

On Thursday 24 July 2008 13:13:51 Tim Farrington wrote:
> Tobias Stoeber wrote:
> > Tim Farrington schrieb:
> >> Can you please give me some guidance as to how to discover
> >> what format is output from the v4l-dvb driver.
> >>
> >> The DVB-T standard is, as I understand it, MPEG2,
> >> however with kaffeine, me-tv, mplayer if I record to a file,
> >> (dump from the raw data stream),
> >> it appears to be stored as a MPEG1 file.
> >> If I use GOPchop, it will not open any of these files,
> >> as it will only open MPEG2 files.
> >
> > Well if I remember it right, a DVB stream (in MPEG2) is MPEG2-TS
> > and GOPchop will handle MPEG2-PS!
> >
> > Cheers, Tobias
>
> Hi Tobias,
> Do you mean GOPchop won't open MPEG2-TS?
>
> What I'm after is some tool/means which will accurately display a
> format descriptor for
> a MPEG(x) file/stream.
>
> MPEG2-TS is what is supposed to be the format, but how can I
> discover if it really is?
>
> Regards,
> Tim Farrington
>

www.avidemux.org will open it.
file file.ts should say something about it

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
