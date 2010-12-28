Return-path: <mchehab@gaivota>
Received: from mailout-de.gmx.net ([213.165.64.22]:47083 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751043Ab0L1PWe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Dec 2010 10:22:34 -0500
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: Ludovic =?iso-8859-1?q?BOU=C9?= <ludovic.boue@gmail.com>
Subject: Re: ngene & Satix-S2 dual problems
Date: Tue, 28 Dec 2010 16:01:05 +0100
Cc: linux-media@vger.kernel.org, linux-media@dinkum.org.uk
References: <4D1753CF.9010205@gmail.com> <201012280857.35664@orion.escape-edv.de> <4D19D66D.4040108@gmail.com>
In-Reply-To: <4D19D66D.4040108@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201012281601.06586@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi,

On Tuesday 28 December 2010 13:22:05 Ludovic BOUÉ wrote:
> ...
> [  403.893231] LNBx2x attached on addr=a
> [  403.893323] stv6110x_attach: Attaching STV6110x
> [  403.893327] DVB: registering new adapter (nGene)
> [  403.893332] DVB: registering adapter 0 frontend 0 (STV090x
> Multistandard)...
> [  403.894359] LNBx2x attached on addr=8
> [  403.894451] stv6110x_attach: Attaching STV6110x
> [  403.894456] DVB: registering adapter 0 frontend 0 (STV090x
> Multistandard)...
> 
> 14:13 root@telstar /home/lboue # ls /dev/dvb/adapter0/
> demux0  demux1  dvr0  dvr1  frontend0  frontend1  net0  net1
> 
> The is only the needed adapters but I think there is a errror about the
> frontend number. It should be
> DVB: registering adapter 0 frontend 1 (STV090x Multistandard)
> instead of: DVB: registering adapter 0 frontend 0 (STV090x Multistandard)

Confirmed. There is a harmless bug in dvb_core:
The message is printed before the frontend number has been assigned.
I will commit a fix for that later.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
