Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:51892 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754908Ab0F0NA4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jun 2010 09:00:56 -0400
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: Jaroslav Klaus <jaroslav.klaus@gmail.com>
Subject: Re: TS discontinuity with TT S-2300
Date: Sun, 27 Jun 2010 14:37:00 +0200
Cc: linux-media@vger.kernel.org
References: <1CF58597-201D-4448-A80C-55815811753E@gmail.com>
In-Reply-To: <1CF58597-201D-4448-A80C-55815811753E@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201006271437.01502@orion.escape-edv.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Sunday 27 June 2010 01:05:57 Jaroslav Klaus wrote:
> Hi,
> 
> I'm loosing TS packets in my dual CAM premium TT S-2300 card (av7110+saa7146).
> 
> Is it possible the problem is in firmware? Here is the description:
> 
> 04:00.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
>         Subsystem: Technotrend Systemtechnik GmbH Technotrend/Hauppauge DVB card rev2.3
>         Flags: bus master, medium devsel, latency 32, IRQ 20
>         Memory at fddff000 (32-bit, non-prefetchable) [size=512]
>         Kernel driver in use: dvb
> 
> dvb 0000:04:00.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
> IRQ 20/: IRQF_DISABLED is not guaranteed on shared IRQs
> saa7146: found saa7146 @ mem ffffc90005248000 (revision 1, irq 20) (0x13c2,0x000e).
> dvb 0000:04:00.0: firmware: requesting dvb-ttpci-01.fw
> DVB: registering new adapter (Technotrend/Hauppauge WinTV Nexus-S rev2.3)
> adapter has MAC addr = 00:d0:5c:04:2e:ea
> dvb 0000:04:00.0: firmware: requesting av7110/bootcode.bin
> dvb-ttpci: info @ card 0: firm f0240009, rtsl b0250018, vid 71010068, app 80f12623
> dvb-ttpci: firmware @ card 0 supports CI link layer interface
> 
> I've tried also:
>  dvb-ttpci: info @ card 1: firm f0240009, rtsl b0250018, vid 71010068, app 8000261a
>  dvb-ttpci: info @ card 1: firm f0240009, rtsl b0250018, vid 71010068, app 80002622
> without any impact.
> 
> SR of my signal is 27500, 2x official CAMs (videoguard).
> 
> I use dvblast to select 4 TV channels (~ 16 PIDs) from multiplex,
> descramble them and stream them to network. Dvblast reports TS
> discontinuity across all video PIDs only (no audio) usually every
> 1-3 minutes ~80 packets. But sometimes it goes well for tens of
> minutes (up to 1-2hours). Everything seems to be ok with 3 TV channels.
> 
> Do you thing it is av7110 issue? Do you know any relevant limits of
> av7110? What should I test/try more? Thanks 

The full-featured cards are not able to deliver the full bandwidth of a
transponder. It is a limitaion of the board design, not a firmware or
driver issue.

You can fix this by applying the 'full-ts' hardware modification.
For more information follow the link in my signature.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
