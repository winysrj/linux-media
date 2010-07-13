Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45825 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637Ab0GMHyt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jul 2010 03:54:49 -0400
Received: by iwn7 with SMTP id 7so5580677iwn.19
        for <linux-media@vger.kernel.org>; Tue, 13 Jul 2010 00:54:49 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 13 Jul 2010 17:54:48 +1000
Message-ID: <AANLkTilzstvLDKE0VrXEw7awNLOLRVOyUpWpcf0B98HM@mail.gmail.com>
Subject: Reception issue: DViCO Fusion HDTV DVB-T Dual Express
From: David Shirley <tephra@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

I am having reception issues with this particular card, the problem
manifests itself with missing video frames and popping sounds on the
audio streams.

As far as I can tell it only some channels do it, "Nine" and its
multiplexes are the worst for it

You can see that TZAP every now and reports some unc/ber:

crystal:/usr/share/dvb/dvb-t# tzap -a 0 -c 0 "Nine Digital HD"
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
reading channels from file '0'
tuning to 191625000 Hz
video pid 0x0200, audio pid 0x0000
status 00 | signal 0b28 | snr 0000 | ber 00000000 | unc 000012c8 |
status 1e | signal b64c | snr dede | ber 00000000 | unc 000013ce | FE_HAS_LOCK
status 1e | signal bb88 | snr cece | ber 00000000 | unc 00001420 | FE_HAS_LOCK
status 1e | signal 9b78 | snr e1e1 | ber 00000000 | unc 00001420 | FE_HAS_LOCK
status 1e | signal 95a4 | snr e0e0 | ber 00000000 | unc 00001420 | FE_HAS_LOCK
status 1e | signal ae4c | snr ecec | ber 00000000 | unc 00001420 | FE_HAS_LOCK
status 1e | signal a7b4 | snr e9e9 | ber 00000316 | unc 00001420 | FE_HAS_LOCK
status 1e | signal b7bc | snr d7d7 | ber 00000316 | unc 00001420 | FE_HAS_LOCK
status 1e | signal a988 | snr f2f2 | ber 00000316 | unc 00001420 | FE_HAS_LOCK
status 1e | signal a5a0 | snr f1f1 | ber 00000316 | unc 00001420 | FE_HAS_LOCK
status 1e | signal ad70 | snr e5e5 | ber 00000316 | unc 00001420 | FE_HAS_LOCK
status 1e | signal b358 | snr dfdf | ber 0000000d | unc 00001432 | FE_HAS_LOCK
status 1e | signal 9de8 | snr e5e5 | ber 0000000d | unc 00001432 | FE_HAS_LOCK
status 1e | signal 9dd0 | snr dada | ber 0000000d | unc 00001432 | FE_HAS_LOCK
status 1e | signal ac04 | snr eded | ber 0000000d | unc 00001432 | FE_HAS_LOCK
status 1e | signal a340 | snr e9e9 | ber 0000000d | unc 00001432 | FE_HAS_LOCK
status 1e | signal a910 | snr e7e7 | ber 000001e7 | unc 00001432 | FE_HAS_LOCK
status 1e | signal aefc | snr e7e7 | ber 000001e7 | unc 00001432 | FE_HAS_LOCK
status 1e | signal 8d34 | snr f6f6 | ber 000001e7 | unc 00001432 | FE_HAS_LOCK
status 1e | signal 10ac | snr f8f8 | ber 000001e7 | unc 00001432 | FE_HAS_LOCK
status 1e | signal 0224 | snr f6f6 | ber 000001e7 | unc 00001432 | FE_HAS_LOCK
status 1e | signal 9b74 | snr ecec | ber 00000000 | unc 00001432 | FE_HAS_LOCK
status 1e | signal 24cc | snr f4f4 | ber 00000000 | unc 00001432 | FE_HAS_LOCK
status 1e | signal a2f4 | snr f9f9 | ber 00000000 | unc 00001432 | FE_HAS_LOCK
status 1e | signal 9d20 | snr f6f6 | ber 00000000 | unc 00001432 | FE_HAS_LOCK
status 1e | signal a7d8 | snr f0f0 | ber 00000000 | unc 00001432 | FE_HAS_LOCK
status 1e | signal a74c | snr f4f4 | ber 000000a9 | unc 00001432 | FE_HAS_LOCK
status 1e | signal a0fc | snr f1f1 | ber 000000a9 | unc 00001432 | FE_HAS_LOCK
status 1e | signal a2d4 | snr f1f1 | ber 000000a9 | unc 00001432 | FE_HAS_LOCK
status 1e | signal 0000 | snr fafa | ber 000000a9 | unc 00001432 | FE_HAS_LOCK
status 1e | signal a490 | snr e7e7 | ber 000000a9 | unc 00001432 | FE_HAS_LOCK
status 1e | signal 0000 | snr fafa | ber 00000000 | unc 00001432 | FE_HAS_LOCK


I have 2 other DVB-T cards in my system and they are fine:
crystal:/usr/share/dvb/dvb-t# tzap -a 3 -c 0 "Nine Digital HD"
using '/dev/dvb/adapter3/frontend0' and '/dev/dvb/adapter3/demux0'
reading channels from file '0'
tuning to 191625000 Hz
video pid 0x0200, audio pid 0x0000
status 01 | signal b15f | snr 0000 | ber 00000000 | unc 00000000 |
status 1f | signal b27f | snr ebeb | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal b2ef | snr ebeb | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal b1af | snr eaea | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal b23f | snr eaea | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal b0df | snr ebeb | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal b2ff | snr ebeb | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal b27f | snr e9e9 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal b20f | snr ebeb | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal b36f | snr ebeb | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal b3bf | snr e8e8 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal b17f | snr ebeb | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal b36f | snr eaea | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal b28f | snr ebeb | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal b33f | snr ebeb | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal b30f | snr ebeb | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal b2ef | snr ebeb | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal b10f | snr e8e8 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal b2df | snr eaea | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal b30f | snr ebeb | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal b37f | snr eaea | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal b38f | snr ecec | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal b2ff | snr ebeb | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal b34f | snr ebeb | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal b36f | snr ebeb | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal b3bf | snr ecec | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal b34f | snr ebeb | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal b2af | snr ebeb | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal b23f | snr ebeb | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal b3df | snr eaea | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal b36f | snr ebeb | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal b3cf | snr ecec | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal b2df | snr eaea | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal b2bf | snr ebeb | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal b36f | snr ebeb | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal b40f | snr eaea | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal b2cf | snr eaea | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal b35f | snr eaea | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal b32f | snr ebeb | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal b2af | snr eaea | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal b47f | snr eaea | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal b3bf | snr ebeb | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal b41f | snr ebeb | ber 00000000 | unc 00000000 | FE_HAS_LOCK

crystal:/usr/share/dvb/dvb-t# dmesg |grep -i dvb
CORE cx23885[0]: subsystem: 18ac:db78, board: DViCO FusionHDTV DVB-T
Dual Express [card=11,autodetected]
cx88[1]: subsystem: 18ac:db10, board: DViCO FusionHDTV DVB-T Plus
[card=21,autodetected], frontend(s): 1
cx23885_dvb_register() allocating 1 frontend(s)
cx23885[0]: cx23885 based dvb card
DVB: registering new adapter (cx23885[0])
DVB: registering adapter 0 frontend 0 (Zarlink ZL10353 DVB-T)...
cx23885_dvb_register() allocating 1 frontend(s)
cx23885[0]: cx23885 based dvb card
DVB: registering new adapter (cx23885[0])
DVB: registering adapter 1 frontend 0 (Zarlink ZL10353 DVB-T)...
cx88/2: cx2388x dvb driver version 0.0.7 loaded
cx88/2: registering cx8802 driver, type: dvb access: shared
cx88[0]/2: cx2388x based DVB/ATSC card
DVB: registering new adapter (cx88[0])
DVB: registering adapter 2 frontend 0 (Conexant CX22702 DVB-T)...
cx88[1]/2: subsystem: 18ac:db10, board: DViCO FusionHDTV DVB-T Plus [card=21]
cx88[1]/2: cx2388x based DVB/ATSC card
DVB: registering new adapter (cx88[1])
DVB: registering adapter 3 frontend 0 (Zarlink MT352 DVB-T)...

crystal:/usr/share/dvb/dvb-t# uname -a
Linux crystal 2.6.32.14 #1 SMP PREEMPT Sat Jun 26 12:47:01 EST 2010
i686 GNU/Linux

Hopefully someone can help or give me instructions on how to debug...

Cheers
David
