Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-out.m-online.net ([212.18.0.9])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <zzam@gentoo.org>) id 1Jcm6k-0003NX-O2
	for linux-dvb@linuxtv.org; Fri, 21 Mar 2008 19:36:53 +0100
Received: from mail01.m-online.net (mail.m-online.net [192.168.3.149])
	by mail-out.m-online.net (Postfix) with ESMTP id EF37022715B
	for <linux-dvb@linuxtv.org>; Fri, 21 Mar 2008 19:36:18 +0100 (CET)
Received: from localhost (unknown [192.168.1.157])
	by mail.m-online.net (Postfix) with ESMTP id 2D48C90092
	for <linux-dvb@linuxtv.org>; Fri, 21 Mar 2008 19:36:08 +0100 (CET)
Received: from mail.mnet-online.de ([192.168.3.149])
	by localhost (scanner1.m-online.net [192.168.1.157]) (amavisd-new,
	port 10024) with ESMTP id 34b3n+MKGN5B for <linux-dvb@linuxtv.org>;
	Fri, 21 Mar 2008 19:36:07 +0100 (CET)
Received: from gauss.x.fun (ppp-88-217-123-54.dynamic.mnet-online.de
	[88.217.123.54]) by mail.nefkom.net (Postfix) with ESMTP
	for <linux-dvb@linuxtv.org>; Fri, 21 Mar 2008 19:36:07 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by gauss.x.fun (Postfix) with ESMTP id DFCD41D538B
	for <linux-dvb@linuxtv.org>; Fri, 21 Mar 2008 19:36:06 +0100 (CET)
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-dvb@linuxtv.org
Date: Fri, 21 Mar 2008 19:36:05 +0100
References: <Pine.LNX.4.62.0803141625320.8859@ns.bog.msu.ru>
	<47E2D3C4.2050005@gmail.com>
	<200803211015.54663@orion.escape-edv.de>
In-Reply-To: <200803211015.54663@orion.escape-edv.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803211936.06052.zzam@gentoo.org>
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

On Freitag, 21. M=E4rz 2008, Oliver Endriss wrote:
> Hi,
>
> Manu Abraham wrote:
> > Hi Hartmut,
> >
> > Hartmut Hackmann wrote:
> > > This might be right! I could not get good information regarding the
> > > transponder bandwidths. We might need to make this depend on the
> > > symbol rate or a module parameter.
> >
> > You can calculate the tuner bandwidth from the transponder symbol rate
> > (in Mbaud) for DVB-S:
> >
> > BW =3D (1 + RO) * SR/2 + 5) * 1.3
>
> Apparently I need some lessons in signal theory. ;-)
> What does R0 stand for?
>
> Do we have to select a higher cut-off value to compensate for the LNB
> drift and other stuff like that?
>
Zarlink zl1003x datasheet (avail on net) tells this:
fbw =3D (alpha * symbol rate) / (2.0 * 0.8) + foffset

where alpha is roll-off 1.35 for dvb-s and 1.20 for DSS

The manual suggests to use highest possible bandwidth for aquiring a lock.
And after that read back the offset from the demod and adjust the tuner the=
n.

Regards
Matthias

-- =

Matthias Schwarzott (zzam)

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
