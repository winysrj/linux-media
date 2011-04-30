Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:46837 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751367Ab1D3CaU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2011 22:30:20 -0400
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: Jan <jan@x34.nl>
Subject: Re: "new" tt s-1500 diseqc
Date: Sat, 30 Apr 2011 04:24:50 +0200
Cc: linux-media@vger.kernel.org
References: <4DB98AE7.6020404@x34.nl>
In-Reply-To: <4DB98AE7.6020404@x34.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201104300424.53244@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thursday 28 April 2011 17:42:31 Jan wrote:
> I try to get the "new" tt-1500 model using the BSBE1-D01A tuner to work with a diseqc switch.
> 
> Currently I am working with a Gentoo 2.6.36 kernel patched with this patch 
> (http://www.mail-archive.com/linux-media@vger.kernel.org/msg29871.html) by Oliver Endriss. This runs 
> great if the card is directly connected to the dish.
> 
> Once connected trough a diseqc switch dvblast-1.2.0 no longer gets a lock. Where this was possible 
> when using the "old" tt-1500 using the BSBE1-502A tuner.
> 
> Does anyone have the "new" tt-1500 working using a diseqc switch?

Yes, I verified that DiSEqC works with this card,
before I submitted the patch.

You need the latest version of the stv0288 frontend driver.

The DiSEqC bug was fixed in this commit:

commit 352a587ccdd4690b4465e29fef91942d8c94826d
Author: Malcolm Priestley <tvboxspy@gmail.com>
Date:   Sun Sep 26 15:16:20 2010 -0300

    [media] DiSEqC bug fixed for stv0288 based interfaces

    Fixed problem with DiSEqC communication. The message was wrongly modulated,
    so the DiSEqC switch was not work.

    This patch fixes DiSEqC messages, simple tone burst and tone on/off.
    I verified it with osciloscope against the DiSEqC documentation.

    Interface: PCI DVB-S TV tuner TeVii S420
    Kernel: 2.6.32-24-generic (UBUNTU 10.4)

    Signed-off-by: Josef Pavlik <josef@pavlik.it>
    Tested-by: Malcolm Priestley <tvboxspy@gmail.com>
    Cc: Igor M. Liplianin <liplianin@me.by>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>


HTH,
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
