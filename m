Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:58533 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752825AbZEEXe4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 5 May 2009 19:34:56 -0400
Subject: Re: [linux-dvb] Can't scan transponders with Terratec Cinergy HT
	PCI  board
From: hermann pitton <hermann-pitton@arcor.de>
To: Charles <landemaine@gmail.com>
Cc: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
In-Reply-To: <e6575a30905041313n7d8de379nea976f9bb9254245@mail.gmail.com>
References: <e6575a30904300454w117e6293p4793ad6c2b5c706@mail.gmail.com>
	 <1241137592.5108.12.camel@pc07.localdom.local>
	 <e6575a30905011018q3b72307aqc73faf01bc380300@mail.gmail.com>
	 <e6575a30905041313n7d8de379nea976f9bb9254245@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 06 May 2009 01:32:31 +0200
Message-Id: <1241566351.16938.21.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Montag, den 04.05.2009, 22:13 +0200 schrieb Charles:
> On Fri, May 1, 2009 at 2:26 AM, hermann pitton <hermann-pitton@arcor.de> wrote:
> > Hi Charles,
> >
> > Am Donnerstag, den 30.04.2009, 13:54 +0200 schrieb Charles:
> >> Hello,
> >>
> >>
> >> I installed my Terratec Cinergy HT PCI DVB-T board on Ubuntu 9.04
> >
> > I guess HT PCI can mean a lot, like My Cinema, WinFast and the like ...
> >
> >> using your tutorial
> >> (http://www.linuxtv.org/wiki/index.php/How_to_Obtain%2C_Build_and_Install_V4L-DVB_Device_Drivers)
> >> and when trying to scan transponders, no result was found:
> >>
> >> $ ls -l /dev/dvb/adapter0
> >> total 0
> >> crw-rw----+ 1 root video 212, 1 2009-04-30 12:19 demux0
> >> crw-rw----+ 1 root video 212, 2 2009-04-30 12:19 dvr0
> >> crw-rw----+ 1 root video 212, 0 2009-04-30 12:19 frontend0
> >> crw-rw----+ 1 root video 212, 3 2009-04-30 12:19 net0
> >>
> >> $ scan /usr/share/dvb/dvb-t/fr-Nantes
> >> scanning /usr/share/dvb/dvb-t/fr-Nantes
> >> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> >> initial transponder 498000000 0 2 9 3 1 0 0
> >> initial transponder 506000000 0 2 9 3 1 0 0
> >> initial transponder 522000000 0 2 9 3 1 0 0
> >> initial transponder 530000000 0 2 9 3 1 0 0
> >> initial transponder 658000000 0 2 9 3 1 0 0
> >> initial transponder 802000000 0 2 9 3 1 0 0
> >
> > Can't tell offhand if the zl10353 eventually has this problem too, which
> > is well known on the tda10046.
> >
> > Please try to add plus 167 kHz to your initial scan file for Nantes,
> > like you can see it here for one of the Lyon transmitters.
> >
[snip]

> 
> Hi Hermann,
> 
> Thank you. I added 167Khz to the scan file but it didn't solve my problem:
> 
> 
> $ scan /usr/share/dvb/dvb-t/fr-Nantes
> scanning /usr/share/dvb/dvb-t/fr-Nantes
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> initial transponder 498167000 0 2 9 3 1 0 0
> initial transponder 506167000 0 2 9 3 1 0 0
> initial transponder 522167000 0 2 9 3 1 0 0
> initial transponder 530167000 0 2 9 3 1 0 0
> initial transponder 658167000 0 2 9 3 1 0 0
> initial transponder 802167000 0 2 9 3 1 0 0
> >>> tune to: 498167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
> WARNING: >>> tuning failed!!!
> >>> tune to: 498167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
> WARNING: >>> tuning failed!!!
> >>> tune to: 506167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
> WARNING: >>> tuning failed!!!
> >>> tune to: 506167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
> WARNING: >>> tuning failed!!!
> >>> tune to: 522167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
> WARNING: >>> tuning failed!!!
> >>> tune to: 522167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
> WARNING: >>> tuning failed!!!
> >>> tune to: 530167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
> WARNING: >>> tuning failed!!!
> >>> tune to: 530167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
> WARNING: >>> tuning failed!!!
> >>> tune to: 658167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
> WARNING: >>> tuning failed!!!
> >>> tune to: 658167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
> WARNING: >>> tuning failed!!!
> >>> tune to: 802167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
> WARNING: >>> tuning failed!!!
> >>> tune to: 802167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
> WARNING: >>> tuning failed!!!
> ERROR: initial tuning failed
> dumping lists (0 services)
> Done.
> $
> 
> 
> Any other idea?

Not really.

Which HT PCI it is, copy/paste relevant parts of "dmesg".

If it is not a known issue with a certain card/driver,
I would assume the signal is too poor.

Cheers,
Hermann


