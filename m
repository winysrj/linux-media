Return-path: <mchehab@pedra>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:64484 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab1FXMqn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2011 08:46:43 -0400
Received: by yia27 with SMTP id 27so1071716yia.19
        for <linux-media@vger.kernel.org>; Fri, 24 Jun 2011 05:46:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E047B9C.1010308@redhat.com>
References: <017201cc31ec$de287ce0$9a7976a0$@coexsi.fr> <201106241151.34019@orion.escape-edv.de>
 <4E047B9C.1010308@redhat.com>
From: Simon Liddicott <simon@liddicott.com>
Date: Fri, 24 Jun 2011 13:46:23 +0100
Message-ID: <BANLkTik-N1WLzj_XK8RFYorZsjUfLvYb6g@mail.gmail.com>
Subject: Re: [DVB] Octopus driver status
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 24 June 2011 12:57, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
>
> Em 24-06-2011 06:51, Oliver Endriss escreveu:
> > Hi,
> >
> > On Thursday 23 June 2011 23:31:08 Sébastien RAILLARD wrote:
> >> Dear all,
> >>
> >> I'm looking at the Octopus DVB cards system from Digital Devices for a while
> >> as their system seems to be very interesting
> >>
> >> Here is link with their products:
> >> http://shop.digital-devices.de/epages/62357162.sf/en_GB/?ObjectPath=/Shops/6
> >> 2357162/Categories
> >>
> >> The good points I have found:
> >>
> >> * They support most of the common DVB standards: DVB-C, DVB-T, DVB-S and
> >> DVB-S2
> >> * They are moderately priced
> >> * There is a CAM support with a CI adapter for unscrambling channels
> >> * They are using the now de-facto standard PCI-Express bus
> >> * The new Octopus system is using a LATTICE PCI-Express bridge that seems to
> >> be more future proof than the previous bridge Micronas APB7202A
> >> * They seem to be well engineered ("Designed and manufactured in Germany" as
> >> they say!)
> >>
> >> And now the doubts :
> >>
> >> * The DVB-C/T frontend driver is specific to this system and is very new, so
> >> as Devin said one week ago, it's maybe not yet production ready
> >> * The way the CAM is supported break all the existing userland DVB
> >> applications (gnutv, mumudvb, vlc, etc.)
> >> * There isn't so much information about the Digital Devices company and
> >> their products roadmap (at least in English)
> >>
> >> So, my two very simple questions to the developers who worked on the drivers
> >> (I think Oliver and Ralph did) and know the product:
> >> * How you feel the future about the Octopus driver?
> >
> > The drivers work fine. I am not aware of any problems.
> >
> > All Digital Devices cards and tuner variants are supported by the driver
> > http://linuxtv.org/hg/~endriss/media_build_experimental
> >
> > ddbridge (Lattice bridge):
> > - Octopus (all variants)
> > - cineS2 v6
> > - DuoFlex S2 (stv0900 + stv6110 + lnbp21)
> > - DuoFlex C/T (Micronas DRXK + NXP TDA18271C2)
> >
> > ngene bridge:
> > - cineS2 (v4,v5), Satix S2 Dual
> > - PCIe bridge, mini PCIe bridge
> > - DuoFlex S2 (stv0900 + stv6110 + lnbp21)
> > - DuoFlex C/T (Micronas DRXK + NXP TDA18271C2)
> >
> > For a German description, see
> > http://www.vdr-portal.de/board16-video-disk-recorder/board85-hdtv-dvb-s2/105803-aktuelle-treiber-für-octopus-ddbridge-cines2-ngene-ddbridge-duoflex-s2-duoflex-ct-sowie-tt-s2-6400
> >
> > From an operational point of view, the driver is ready for the kernel.
> > Unfortunately I did not have the time yet to clean up the coding-style.
> > There are thousands of coding-style issues waiting to be fixed...
>
> Hi Oliver,
>
> If it is ok for you, I have here a few devices with DRXK that I'm seeking for
> some time to work with. I'll probably have some time this weekend for them,
> so I can do the CodingStyle cleanups, if it is ok for you.
>
> Cheers,
> Mauro.
> --

Do you have a Terratec Cinergy 2400i? It belongs to the ngene family
but has PLL tuners.
http://linuxtv.org/wiki/index.php/TerraTec_Cinergy_2400i_DVB-T

There are some drivers floating on the net that I have got to work in
Ubuntu 8.04 but the current ngene drivers has moved on a long way and
left it behind.

Si.
