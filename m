Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:59470 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752333Ab1C1W5x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Mar 2011 18:57:53 -0400
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: Malcolm Priestley <tvboxspy@gmail.com>
Subject: Re: [PATCH 2/2] STV0299 Register 02 on Opera1/Bsru6/z0194a/mantis_vp1033
Date: Tue, 29 Mar 2011 00:34:28 +0200
Cc: linux-media@vger.kernel.org
References: <1301187827.2338.1.camel@localhost>
In-Reply-To: <1301187827.2338.1.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201103290034.29165@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sunday 27 March 2011 03:03:47 Malcolm Priestley wrote:
> Bits 4 and 5 on register 02 should always be set to 1.
> 
> Opera1/Bsru6/z0194a/mantis_vp1033
> 
> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> ---
>  drivers/media/dvb/dvb-usb/opera1.c       |    2 +-
>  drivers/media/dvb/frontends/bsru6.h      |    2 +-
>  drivers/media/dvb/frontends/z0194a.h     |    2 +-
>  drivers/media/dvb/mantis/mantis_vp1033.c |    2 +-
>  4 files changed, 4 insertions(+), 4 deletions(-)
>  ...

Acked-by: Oliver Endriss <o.endriss@gmx.de>

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
