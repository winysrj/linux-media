Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:59496 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752333Ab1C1W5z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Mar 2011 18:57:55 -0400
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: Malcolm Priestley <tvboxspy@gmail.com>
Subject: Re: [PATCH 1/2] STV0299 incorrect standby setting issues register 02 (MCR)
Date: Tue, 29 Mar 2011 00:32:41 +0200
Cc: linux-media@vger.kernel.org
References: <1301187453.2179.2.camel@localhost>
In-Reply-To: <1301187453.2179.2.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201103290032.42334@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sunday 27 March 2011 01:57:33 Malcolm Priestley wrote:
> Issues with Register 02 causing spurious channel locking from standby.
> Should have always bits 4 & 5 written to 1.
> Lower nibble not used in any current driver. Usage if necessary can be applied
> through initab to mcr_reg.
> stv0299 not out of standby before writing inittab.
> 
> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> ---
>  drivers/media/dvb/frontends/stv0299.c |   10 ++++++++--
>  1 files changed, 8 insertions(+), 2 deletions(-)
> ...

Acked-by: Oliver Endriss <o.endriss@gmx.de>

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
