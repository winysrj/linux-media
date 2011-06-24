Return-path: <mchehab@pedra>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:57861 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488Ab1FXLSu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2011 07:18:50 -0400
Received: from mfilter4-d.gandi.net (mfilter4-d.gandi.net [217.70.178.134])
	by relay4-d.mail.gandi.net (Postfix) with ESMTP id EB0BE172087
	for <linux-media@vger.kernel.org>; Fri, 24 Jun 2011 13:18:48 +0200 (CEST)
Received: from relay4-d.mail.gandi.net ([217.70.183.196])
	by mfilter4-d.gandi.net (mfilter4-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id FPyFbr1Jjirn for <linux-media@vger.kernel.org>;
	Fri, 24 Jun 2011 13:18:47 +0200 (CEST)
Received: from WIN7PC (ALyon-157-1-176-152.w109-213.abo.wanadoo.fr [109.213.63.152])
	(Authenticated sender: sr@coexsi.fr)
	by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 23FC6172079
	for <linux-media@vger.kernel.org>; Fri, 24 Jun 2011 13:18:46 +0200 (CEST)
From: =?iso-8859-1?Q?S=E9bastien_RAILLARD_=28COEXSI=29?= <sr@coexsi.fr>
To: "'Linux Media Mailing List'" <linux-media@vger.kernel.org>
References: <017201cc31ec$de287ce0$9a7976a0$@coexsi.fr> <201106241151.34019@orion.escape-edv.de>
In-Reply-To: <201106241151.34019@orion.escape-edv.de>
Subject: RE: [DVB] Octopus driver status
Date: Fri, 24 Jun 2011 13:18:51 +0200
Message-ID: <003a01cc3260$7f9bade0$7ed309a0$@coexsi.fr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Language: fr
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>



> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Oliver Endriss
> Sent: vendredi 24 juin 2011 11:52
> To: S�bastien RAILLARD (COEXSI)
> Cc: Linux Media Mailing List
> Subject: Re: [DVB] Octopus driver status
> 
> Hi,
> 
> On Thursday 23 June 2011 23:31:08 S�bastien RAILLARD wrote:
> > Dear all,
> >
> > I'm looking at the Octopus DVB cards system from Digital Devices for a
> > while as their system seems to be very interesting
> >
> > Here is link with their products:
> > http://shop.digital-devices.de/epages/62357162.sf/en_GB/?ObjectPath=/S
> > hops/6
> > 2357162/Categories
> >
> > The good points I have found:
> >
> > * They support most of the common DVB standards: DVB-C, DVB-T, DVB-S
> > and
> > DVB-S2
> > * They are moderately priced
> > * There is a CAM support with a CI adapter for unscrambling channels
> > * They are using the now de-facto standard PCI-Express bus
> > * The new Octopus system is using a LATTICE PCI-Express bridge that
> > seems to be more future proof than the previous bridge Micronas
> > APB7202A
> > * They seem to be well engineered ("Designed and manufactured in
> > Germany" as they say!)
> >
> > And now the doubts :
> >
> > * The DVB-C/T frontend driver is specific to this system and is very
> > new, so as Devin said one week ago, it's maybe not yet production
> > ready
> > * The way the CAM is supported break all the existing userland DVB
> > applications (gnutv, mumudvb, vlc, etc.)
> > * There isn't so much information about the Digital Devices company
> > and their products roadmap (at least in English)
> >
> > So, my two very simple questions to the developers who worked on the
> > drivers (I think Oliver and Ralph did) and know the product:
> > * How you feel the future about the Octopus driver?
> 
> The drivers work fine. I am not aware of any problems.
> 
> All Digital Devices cards and tuner variants are supported by the driver
> http://linuxtv.org/hg/~endriss/media_build_experimental
> 
> ddbridge (Lattice bridge):
> - Octopus (all variants)
> - cineS2 v6
> - DuoFlex S2 (stv0900 + stv6110 + lnbp21)
> - DuoFlex C/T (Micronas DRXK + NXP TDA18271C2)
> 
> ngene bridge:
> - cineS2 (v4,v5), Satix S2 Dual
> - PCIe bridge, mini PCIe bridge
> - DuoFlex S2 (stv0900 + stv6110 + lnbp21)
> - DuoFlex C/T (Micronas DRXK + NXP TDA18271C2)
> 
> For a German description, see
> http://www.vdr-portal.de/board16-video-disk-recorder/board85-hdtv-dvb-
> s2/105803-aktuelle-treiber-f�r-octopus-ddbridge-cines2-ngene-ddbridge-
> duoflex-s2-duoflex-ct-sowie-tt-s2-6400
> 
> From an operational point of view, the driver is ready for the kernel.
> Unfortunately I did not have the time yet to clean up the coding-style.
> There are thousands of coding-style issues waiting to be fixed...
> 

Ok, thank you for the update.
We will try some Octopus cards.

> > * Do you think a compatibility mode (like module parameter) can be
> > added to simulate the way the CAM is handled in the other drivers?
> 
> Yes, this could be done:
> ++ The CI could be used with any application.
> -- The CI will be attached to one tuner exclusively.
> 
> It is not very hard to implement this.
> Patches are welcome. ;-)
> 

Maybe I'll ask for advices!!!

> CU
> Oliver
> 
> --
> ----------------------------------------------------------------
> VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
> 4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
> Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
> ----------------------------------------------------------------
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media"
> in the body of a message to majordomo@vger.kernel.org More majordomo
> info at  http://vger.kernel.org/majordomo-info.html

