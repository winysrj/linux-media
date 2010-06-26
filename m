Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41875 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab0FZXDF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Jun 2010 19:03:05 -0400
Received: by bwz10 with SMTP id 10so233876bwz.19
        for <linux-media@vger.kernel.org>; Sat, 26 Jun 2010 16:03:04 -0700 (PDT)
From: Jaroslav Klaus <jaroslav.klaus@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: TS discontinuity with TT S-2300
Date: Sun, 27 Jun 2010 01:05:57 +0200
Message-Id: <1CF58597-201D-4448-A80C-55815811753E@gmail.com>
To: linux-media@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1081)
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm loosing TS packets in my dual CAM premium TT S-2300 card (av7110+saa7146).

Is it possible the problem is in firmware? Here is the description:

04:00.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
        Subsystem: Technotrend Systemtechnik GmbH Technotrend/Hauppauge DVB card rev2.3
        Flags: bus master, medium devsel, latency 32, IRQ 20
        Memory at fddff000 (32-bit, non-prefetchable) [size=512]
        Kernel driver in use: dvb

dvb 0000:04:00.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
IRQ 20/: IRQF_DISABLED is not guaranteed on shared IRQs
saa7146: found saa7146 @ mem ffffc90005248000 (revision 1, irq 20) (0x13c2,0x000e).
dvb 0000:04:00.0: firmware: requesting dvb-ttpci-01.fw
DVB: registering new adapter (Technotrend/Hauppauge WinTV Nexus-S rev2.3)
adapter has MAC addr = 00:d0:5c:04:2e:ea
dvb 0000:04:00.0: firmware: requesting av7110/bootcode.bin
dvb-ttpci: info @ card 0: firm f0240009, rtsl b0250018, vid 71010068, app 80f12623
dvb-ttpci: firmware @ card 0 supports CI link layer interface

I've tried also:
 dvb-ttpci: info @ card 1: firm f0240009, rtsl b0250018, vid 71010068, app 8000261a
 dvb-ttpci: info @ card 1: firm f0240009, rtsl b0250018, vid 71010068, app 80002622
without any impact.

SR of my signal is 27500, 2x official CAMs (videoguard).

I use dvblast to select 4 TV channels (~ 16 PIDs) from multiplex, descramble them and stream them to network. Dvblast reports TS discontinuity across all video PIDs only (no audio) usually every 1-3 minutes ~80 packets. But sometimes it goes well for tens of minutes (up to 1-2hours). Everything seems to be ok with 3 TV channels.

Do you thing it is av7110 issue? Do you know any relevant limits of av7110? What should I test/try more? Thanks

Regards,
Jaroslav

