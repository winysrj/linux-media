Return-path: <linux-media-owner@vger.kernel.org>
Received: from snt0-omc2-s17.snt0.hotmail.com ([65.55.90.92]:43036 "EHLO
	snt0-omc2-s17.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752160AbZDUW0c convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2009 18:26:32 -0400
Message-ID: <SNT106-W82268CBDC5C795201B4C2BD4770@phx.gbl>
From: Honzor Mortl <goaraver@hotmail.com>
To: <linux-media@vger.kernel.org>
Subject: Problem with pinnacle pctv 72e usb stick (dib0700 - based)
Date: Wed, 22 Apr 2009 00:20:20 +0200
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi,

ive got a problem with my dib0700-based usb dvb-t stick.

I'm currently using firmware 1.20 with module parameter "force_lna_activation=1".

Actually, when i set the long filter timeout option, i can use w_scan
and successfully find 8 channels. But i do not get any output from the
card when accessing /dev/dvb/adapter1/dvr0. The tzap output is the
following:




	Code:
	using '/dev/dvb/adapter1/frontend0' and '/dev/dvb/adapter1/demux0'
reading channels from file 'dvbt_channels.conf'
tuning to 762000000 Hz
video pid 0x012d, audio pid 0x012e
status 1e | signal ffff | snr 0000 | ber 001fffff | unc 00000256 | FE_HAS_LOCK
status 1e | signal ffff | snr 0000 | ber 00000180 | unc 00002aa3 | FE_HAS_LOCK
status 1e | signal ffff | snr 0000 | ber 00000a20 | unc 00002b2d | FE_HAS_LOCK
status 1e | signal ffff | snr 0000 | ber 00004af0 | unc 00002b7c | FE_HAS_LOCK
status 1e | signal ffff | snr 0000 | ber 00000900 | unc 00002c5b | FE_HAS_LOCK
status 1e | signal ffff | snr 0000 | ber 00007a90 | unc 00002c31 | FE_HAS_LOCK
status 1e | signal ffff | snr 0000 | ber 00005ba0 | unc 00002c9c | FE_HAS_LOCK
status 1e | signal ffff | snr 0000 | ber 000003a0 | unc 00002df8 | FE_HAS_LOCK
status 1e | signal ffff | snr 0000 | ber 000001c0 | unc 00002d80 | FE_HAS_LOCK
status 1e | signal ffff | snr 0000 | ber 00002870 | unc 00002efd | FE_HAS_LOCK


But the strange thing is, when i boot the system into windows and
reboot it into linux again (thus letting the windows driver download
the firmware to the stick so linux finds it in warm state and doesnt
download it again) it works flawlessy with exactly the same commands.
The status of tzap then changes from "1e" as above to "1f".



I would really appreciate any help for this problem, if any other information is needed, i'll be glad to post it here!



P.S.: i also tried with different (older) firmware versions and also
tried to compile the newest drivers from the linuxtv mercurial repo
with no luck...
_________________________________________________________________
Chiama gratis dal tuo PC! Parla su Messenger
http://clk.atdmt.com/GBL/go/140630369/direct/01/