Return-path: <linux-media-owner@vger.kernel.org>
Received: from web33506.mail.mud.yahoo.com ([68.142.206.155]:38576 "HELO
	web33506.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754088Ab0BILmX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Feb 2010 06:42:23 -0500
Message-ID: <846727.96589.qm@web33506.mail.mud.yahoo.com>
Date: Tue, 9 Feb 2010 03:35:43 -0800 (PST)
From: Patrick Cairns <patrick_cairns@yahoo.com>
Subject: Leadtek WinFast DVR3100 H zl10353_read_register: readreg error (reg=127, ret==-6)
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

I'm testing use of multiple Leadtek WinFast DVR3100 H cards for a project.   I've had large numbers of them working well in the same machine as encoders (haven't been using the DVB-T capabilities).

However if I use more than a few of these cards in the same machine then upon startup there are always one or two cards where Zarlink zl10353 reading errors are reported preventing their use:-

options: enc_yuv_buffers=0 enc_pcm_buffers=0 enc_vbi_buffers=0 radio=0 enc_idx_buffers=0 enc_mpg_bufsize=64

cx18-10: Initializing card 10
cx18-10: Autodetected Leadtek WinFast DVR3100 H card
cx18 0000:05:09.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
cx18-10: Unreasonably low latency timer, setting to 64 (was 32)
cx18-10: cx23418 revision 01010000 (B)
cx18-10: Simultaneous DVB-T and Analog capture supported,
        except when capturing Analog from the antenna input.
IRQ 18/cx18-10: IRQF_DISABLED is not guaranteed on shared IRQs
cx18-10: Disabled encoder YUV device
cx18-10: Disabled encoder VBI device
cx18-10: Disabled encoder PCM audio device
cx18-10: Disabled encoder IDX device
cx18-10: Registered device video10 for encoder MPEG (32 x 64 kB)
DVB: registering new adapter (cx18)
zl10353_read_register: readreg error (reg=127, ret==-6)
cx18-10: frontend initialization failed
cx18-10: DVB failed to register
cx18-10: Registered device radio10 for encoder radio
cx18-10: Error -1 registering devices
cx18-10: Error -1 on initialization
cx18: probe of 0000:05:09.0 failed with error -1

Looking/flailing around for more diagnostic information and related posts I tried a few things and found that if I enabled the bit_test in i2c-algo-bit, the second test failed with the offending cards whereas it normally succeeds.   I'm not certain this is relevant but it might indicate an underlying fault in card<->driver communication:-

cx18-10: Initializing card 10
cx18-10: Autodetected Leadtek WinFast DVR3100 H card
cx18-10: cx23418 revision 01010000 (B)
cx18-10:  i2c: i2c init
cx18 i2c driver #10-0: Test OK
cx18 i2c driver #10-1: bus seems to be busy
cx18-10: Could not initialize i2c
cx18-10: Error -19 on initialization

Can anyone advise how to debug this further or know any fixes to try?  I'm not quite sure what's going on under the hood.

More information:-

Tested against Kernel 2.6.32 (our own custom config including increased max dvb adapter count) with or without latest v4l staging development repository overlayed (the above dmesg output is from the default 2.6.32 v4l).

The problem almost always persists across soft reboots affecting the same one or two cards each time.   A full power cycle however often results in different cards being affected.   Reordering cards, varying bus positions/locations (there are 3 buses on my main test system) has no apparent effect on the problem.   So there is apparent randomness.  Problem has occurred with as few as 4 cards (not sure about 2/3 yet).  Sometimes, after a power cycle, no cards are affected, but within a few soft cycles, one or 2 cards become afflicted and the problem remains until power cycled.

I'm now testing a couple of alternative systems to see if the same behaviour occurs there but thought it best at this stage to post for suggestions.

Regards

Patrick Cairns



      
