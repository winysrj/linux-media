Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37465 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525Ab2EMKFz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 May 2012 06:05:55 -0400
Received: by pbbrp8 with SMTP id rp8so4971475pbb.19
        for <linux-media@vger.kernel.org>; Sun, 13 May 2012 03:05:54 -0700 (PDT)
From: Mark Purcell <mark@purcell.id.au>
To: linux-media@vger.kernel.org
Subject: Fwd: Bug#669715: dvb-apps: Channel/frequency/etc. data needs updating for London transmitters
Date: Sun, 13 May 2012 20:05:45 +1000
Cc: Russel Winder <russel@winder.org.uk>,
	Darren Salt <linux@youmustbejoking.demon.co.uk>,
	669715-forwarded@bugs.debian.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201205132005.47858.mark@purcell.id.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


----------  Forwarded Message  ----------

Subject: Bug#669715: dvb-apps: Channel/frequency/etc. data needs updating for 
London transmitters
Date: Sun, 22 Apr 2012, 13:17:48
From: Russel Winder <russel@winder.org.uk>
To: Darren Salt <linux@youmustbejoking.demon.co.uk>
CC: 669715@bugs.debian.org

The representative of the Amalgamated Union of Philosophers, Sages,
Luminaries, and other professional thinking persons quoth:

On Sun, 2012-04-22 at 03:16 +0100, Darren Salt wrote:
> I demand that Russel Winder may or may not have written...
> 
> > The "digital switch over" (DSO) -- closing of analogue television
> > transmision -- has involved quite a convoluted rearrangement of the
> > multiplexes and channels.  The DSO completed for London, and in my case
> > Crystal Palace, 2012-04-18.  The channel data distributed with dvb-apps is
> > now incorrect.
> 
> You should use w_scan to gather the new information. It would be useful if
> you attach the new tuning information to this bug report.

Not sure about w_scan, I have scan.  It doesn't generate a channel list.

I calculated the following replacement for the uk-CrystalPalace file:

        # UK, Crystal Palace
        #
        # Manually calculated by RLW 2012-04-21T10:20+01:00
        #
        # T freq bw fec_hi fec_lo mod transmission-mode guard-interval
        hierarchy
        #
        # BBC A — 23
        T 490000000 8MHz 2/3 NONE QAM64 2k 1/32 NONE
        # D3&4 — 26
        T 514000000 8MHz 2/3 NONE QAM64 2k 1/32 NONE
        # BBC B — 30-
        T 545833000 8MHz 2/3 NONE QAM256 2k 1/32 NONE
        # SDN — 25
        T 506000000 8MHz 3/4 NONE QAM64 2k 1/32 NONE
        # Arqiva A — 22
        T 482000000 8MHz 3/4 NONE QAM64 2k 1/32 NONE
        # Arqiva B — 28-
        # ITV4
        T 529833000 8MHz 3/4 NONE QAM64 2k 1/32 NONE

The BBC A, D3&4, SDN, Arqiva A, and Arqiva B frequencies all work fine
with vlc, I get all the channels on the multiplex.  BBC B seems to fail
but I have a suspicion that may be that the TerraTec USB unit I have
does not handle HD.  I am not sure what the NONE entries are, and I am
not sure if the 1/32 is correct.  All other entries come straight from
the OfCom document -- which I assume is definitive.

Running scan I get:

|> scan uk-CrystalPalace_RLW
scanning uk-CrystalPalace_RLW
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 490000000 0 2 9 3 0 0 0
initial transponder 514000000 0 2 9 3 0 0 0
initial transponder 545833000 0 2 9 5 0 0 0
initial transponder 506000000 0 3 9 3 0 0 0
initial transponder 482000000 0 3 9 3 0 0 0
initial transponder 529833000 0 3 9 3 0 0 0
>>> tune to: 
490000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 
490000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE 
(tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 
514000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 
514000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE 
(tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 
545833000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_256:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 
545833000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_256:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE 
(tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 
506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 
506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE 
(tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 
482000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 
482000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE 
(tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 
529833000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 
529833000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE 
(tuning failed)
WARNING: >>> tuning failed!!!
ERROR: initial tuning failed
dumping lists (0 services)
Done.


> Also, as of 26 September, it'll also be incorrect for Pontop Pike...

Is that the last to go?

-- 
Russel.
=============================================================================
Dr Russel Winder      t: +44 20 7585 2200   voip: sip:russel.winder@ekiga.net
41 Buckmaster Road    m: +44 7770 465 077   xmpp: russel@winder.org.uk
London SW11 1EN, UK   w: www.russel.org.uk  skype: russel_winder

-----------------------------------------
