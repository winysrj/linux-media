Return-path: <mchehab@pedra>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:41608 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755477Ab1FTTKD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2011 15:10:03 -0400
From: =?iso-8859-1?Q?S=E9bastien_RAILLARD_=28COEXSI=29?= <sr@coexsi.fr>
To: "'Devin Heitmueller'" <dheitmueller@kernellabs.com>,
	"'HoP'" <jpetrous@gmail.com>
Cc: =?iso-8859-1?Q?'R=E9mi_Denis-Courmont'?= <remi@remlab.net>,
	<linux-media@vger.kernel.org>
References: <BANLkTimtnbAzLTdFY2OiSddHTjmD_99CfA@mail.gmail.com>	<201106202037.19535.remi@remlab.net>	<BANLkTinn0uN3VwGfqCbYbxFoVf6aNo1VSA@mail.gmail.com>	<BANLkTin14LnwP+_K1m-RsEXza4M4CjqnEw@mail.gmail.com> <BANLkTimR-zWnnLBcD2w8d8NpeFJi=eT9nQ@mail.gmail.com>
In-Reply-To: <BANLkTimR-zWnnLBcD2w8d8NpeFJi=eT9nQ@mail.gmail.com>
Subject: RE: [RFC] vtunerc - virtual DVB device driver
Date: Mon, 20 Jun 2011 21:10:00 +0200
Message-ID: <005a01cc2f7d$a799be30$f6cd3a90$@coexsi.fr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Language: fr
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>



> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Devin Heitmueller
> Sent: lundi 20 juin 2011 20:25
> To: HoP
> Cc: Rémi Denis-Courmont; linux-media@vger.kernel.org
> Subject: Re: [RFC] vtunerc - virtual DVB device driver
> 
> On Mon, Jun 20, 2011 at 2:17 PM, HoP <jpetrous@gmail.com> wrote:
> > Can you tell me when such disscussion was done? I did a big attempt to
> > check if my work is not reinventing wheels, but I found only some very
> > generic frontend template by Emard <emard@softhome.net>.
> 
> See the "userspace tuner" thread here for the background:
> 
> http://www.linuxtv.org/pipermail/linux-dvb/2007-August/thread.html#19840
> 
> >> easier for evil tuner manufacturers to leverage all the hard work
> >> done by the LinuxTV developers while providing a closed-source
> solution.
> >
> > May be I missunderstood something, but I can't see how frontend
> > virtualization/sharing can help to leverage others work.
> 
> It helps in that it allows third parties to write drivers in userspace
> that leverage the in-kernel implementation of DVB core.  It means that a
> product developer who didn't want to abide by the GPL could write a
> closed-source driver in userland which takes advantage of the thousands
> of lines of code that make up the DVB core.
> 
> >> It was an explicit goal to *not* allow third parties to reuse the
> >> Linux DVB core unless they were providing in-kernel drivers which
> >> conform to the GPL.
> >
> > I'm again not sure if you try to argument against vtunerc code or
> > nope.
> 
> I am against things like this being in the upstream kernel which make it
> easier for third parties to leverage GPL code without making their code
> available under the GPL.
> 

If I may put my two cents in this discussion regarding the closed source
code problem: maybe it could be great to have some closed source drivers
making some DVB hardware working better or even allowing more DVB hardware
working under Linux. For example, there is a good support of PCI DVB
devices, but not yet so much support for PCIe DVB devices (and even less if
you're searching for DVB-S2 tuner with CAM support at reasonable price).
Also, most the DVB drivers code released under GPL is nearly impossible to
understand as there is no documentation (because of NDA agreements with
developers - as I understood) and no inline comments. So does-it make so
much difference with closed source code? I really don't want to aggress
anybody here, but it's really a question I have.
 
> Devin
> 
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media"
> in the body of a message to majordomo@vger.kernel.org More majordomo
> info at  http://vger.kernel.org/majordomo-info.html

