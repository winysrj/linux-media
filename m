Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:39264 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750804Ab0BKEcd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Feb 2010 23:32:33 -0500
From: Oliver Endriss <o.endriss@gmx.de>
To: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 1/1] DVB: ngene, fix memset parameters
Date: Thu, 11 Feb 2010 05:20:50 +0100
Cc: mchehab@redhat.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, jirislaby@gmail.com,
	Matthias Benesch <twoof7@freenet.de>,
	Ralph Metzler <rjkm@metzlerbros.de>
References: <1265844762-17730-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1265844762-17730-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201002110520.55301@orion.escape-edv.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jiri Slaby wrote:
> Switch second and third memset parameter to stamp the length buffer bytes
> by 0xff's, not 255 bytes by low 8 bits of Length.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Matthias Benesch <twoof7@freenet.de>
> Cc: Ralph Metzler <rjkm@metzlerbros.de>
> Cc: Oliver Endriss <o.endriss@gmx.de>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  drivers/media/dvb/ngene/ngene-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/dvb/ngene/ngene-core.c b/drivers/media/dvb/ngene/ngene-core.c
> index cb5982e..0150dfe 100644
> --- a/drivers/media/dvb/ngene/ngene-core.c
> +++ b/drivers/media/dvb/ngene/ngene-core.c
> @@ -564,7 +564,7 @@ static void FillTSBuffer(void *Buffer, int Length, u32 Flags)
>  {
>  	u32 *ptr = Buffer;
>  
> -	memset(Buffer, Length, 0xff);
> +	memset(Buffer, 0xff, Length);
>  	while (Length > 0) {
>  		if (Flags & DF_SWAP32)
>  			*ptr = 0x471FFF10;
> -- 
> 1.6.6.1

Acked-by: Oliver Endriss <o.endriss@gmx.de>

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
