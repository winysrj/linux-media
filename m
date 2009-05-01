Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:48953 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762708AbZEAA06 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2009 20:26:58 -0400
Subject: Re: [linux-dvb] Can't scan transponders with Terratec Cinergy HT
	PCI board
From: hermann pitton <hermann-pitton@arcor.de>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
In-Reply-To: <e6575a30904300454w117e6293p4793ad6c2b5c706@mail.gmail.com>
References: <e6575a30904300454w117e6293p4793ad6c2b5c706@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 01 May 2009 02:26:32 +0200
Message-Id: <1241137592.5108.12.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Charles,

Am Donnerstag, den 30.04.2009, 13:54 +0200 schrieb Charles:
> Hello,
> 
> 
> I installed my Terratec Cinergy HT PCI DVB-T board on Ubuntu 9.04

I guess HT PCI can mean a lot, like My Cinema, WinFast and the like ...

> using your tutorial
> (http://www.linuxtv.org/wiki/index.php/How_to_Obtain%2C_Build_and_Install_V4L-DVB_Device_Drivers)
> and when trying to scan transponders, no result was found:
> 
> $ ls -l /dev/dvb/adapter0
> total 0
> crw-rw----+ 1 root video 212, 1 2009-04-30 12:19 demux0
> crw-rw----+ 1 root video 212, 2 2009-04-30 12:19 dvr0
> crw-rw----+ 1 root video 212, 0 2009-04-30 12:19 frontend0
> crw-rw----+ 1 root video 212, 3 2009-04-30 12:19 net0
> 
> $ scan /usr/share/dvb/dvb-t/fr-Nantes
> scanning /usr/share/dvb/dvb-t/fr-Nantes
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> initial transponder 498000000 0 2 9 3 1 0 0
> initial transponder 506000000 0 2 9 3 1 0 0
> initial transponder 522000000 0 2 9 3 1 0 0
> initial transponder 530000000 0 2 9 3 1 0 0
> initial transponder 658000000 0 2 9 3 1 0 0
> initial transponder 802000000 0 2 9 3 1 0 0

Can't tell offhand if the zl10353 eventually has this problem too, which
is well known on the tda10046.

Please try to add plus 167 kHz to your initial scan file for Nantes,
like you can see it here for one of the Lyon transmitters.

# T freq bw fec_hi fec_lo mod transmission-mode guard-interval
hierarchy
# R1 : Canal 56
T 754167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# R2 : Canal 36
T 594167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# R3 : Canal 21
T 474167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# R4 : Canal 54
T 738167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# R5 : Canal 27
T 522167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
# R6 : Canal 24
T 498167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE

At least we can exclude this then.

Cheers,
Hermann

> >>> tune to: 498000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
> WARNING: >>> tuning failed!!!
> >>> tune to: 498000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
> WARNING: >>> tuning failed!!!
> >>> tune to: 506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
> WARNING: >>> tuning failed!!!
> >>> tune to: 506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
> WARNING: >>> tuning failed!!!
> >>> tune to: 522000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
> WARNING: >>> tuning failed!!!
> >>> tune to: 522000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
> WARNING: >>> tuning failed!!!
> >>> tune to: 530000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
> WARNING: >>> tuning failed!!!
> >>> tune to: 530000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
> WARNING: >>> tuning failed!!!
> >>> tune to: 658000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
> WARNING: >>> tuning failed!!!
> >>> tune to: 658000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
> WARNING: >>> tuning failed!!!
> >>> tune to: 802000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
> WARNING: >>> tuning failed!!!
> >>> tune to: 802000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
> WARNING: >>> tuning failed!!!
> ERROR: initial tuning failed
> dumping lists (0 services)
> Done.
> 
> $ dvbscan /usr/share/dvb/dvb-t/fr-Nantes
> Unable to query frontend status
> 
> $ w_scan -ft -X
> w_scan version 20081106
> Info: using DVB adapter auto detection.
>    Found DVB-T frontend. Using adapter /dev/dvb/adapter0/frontend0
> -_-_-_-_ Getting frontend capabilities-_-_-_-_
> frontend Zarlink ZL10353 DVB-T supports
> INVERSION_AUTO
> QAM_AUTO
> TRANSMISSION_MODE_AUTO
> GUARD_INTERVAL_AUTO
> HIERARCHY_AUTO
> FEC_AUTO
> -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
> 177500:
> 184500:
> 191500:
> 198500:
> 205500:
> 212500:
> 219500:
> 226500:
> 474000:
> 482000:
> 490000:
> 498000:
> 506000:
> 514000:
> 522000:
> 530000:
> 538000:
> 546000:
> 554000:
> 562000:
> 570000:
> 578000:
> 586000:
> 594000:
> 602000:
> 610000:
> 618000:
> 626000:
> 634000:
> 642000:
> 650000:
> 658000:
> 666000:
> 674000:
> 682000:
> 690000:
> 698000:
> 706000:
> 714000:
> 722000:
> 730000:
> 738000:
> 746000:
> 754000:
> 762000:
> 770000:
> 778000:
> 786000:
> 794000:
> 802000:
> 810000:
> 818000:
> 826000:
> 834000:
> 842000:
> 850000:
> 858000:
> ERROR: Sorry - i couldn't get any working frequency/transponder
>  Nothing to scan!!
> dumping lists (0 services)
> Done.
> $
> 
> 
> 
> Any idea?
> Thanks in advance,
> 
> Charles.
> 


