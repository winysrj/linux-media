Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:38580 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750799Ab1FYAOb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2011 20:14:31 -0400
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: Linux Media Mailing List <linux-media@vger.kernel.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [DVB] Octopus driver status
Date: Sat, 25 Jun 2011 02:02:39 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"=?iso-8859-1?q?S=E9bastien_RAILLARD?= (COEXSI)" <sr@coexsi.fr>
References: <017201cc31ec$de287ce0$9a7976a0$@coexsi.fr> <201106241151.34019@orion.escape-edv.de> <4E047B9C.1010308@redhat.com>
In-Reply-To: <4E047B9C.1010308@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201106250202.40633@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

On Friday 24 June 2011 13:57:16 Mauro Carvalho Chehab wrote:
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

Just for the record: Ralph did most of the work.
I just contributed some glue stuff.

I'll check with Ralph, whether he has any updates pending.
These should be applied before fixing the coding-style.

If you could wait until next weekend, I could prepare a patch series,
which you could start with. The current repository has some files at
the wrong places, etc.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
