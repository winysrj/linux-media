Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:36346 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754159AbdGJPdG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Jul 2017 11:33:06 -0400
Received: by mail-wr0-f196.google.com with SMTP id 77so25681120wrb.3
        for <linux-media@vger.kernel.org>; Mon, 10 Jul 2017 08:33:05 -0700 (PDT)
Date: Mon, 10 Jul 2017 17:32:57 +0200
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: Ralph Metzler <rjkm@metzlerbros.de>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com, jasmin@anw.at, d_spingler@gmx.de
Subject: Re: [PATCH 09/14] [media] ddbridge: fix possible buffer overflow in
 ddb_ports_init()
Message-ID: <20170710173257.236dce4a@audiostation.wuest.de>
In-Reply-To: <22883.14629.6872.987122@morden.metzler>
References: <20170709194221.10255-1-d.scheller.oss@gmail.com>
        <20170709194221.10255-10-d.scheller.oss@gmail.com>
        <22883.14629.6872.987122@morden.metzler>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Mon, 10 Jul 2017 10:21:57 +0200
schrieb Ralph Metzler <rjkm@metzlerbros.de>:

> Daniel Scheller writes:
>  > From: Daniel Scheller <d.scheller@gmx.net>
>  > 
>  > Report from smatch:
>  > 
>  >   drivers/media/pci/ddbridge/ddbridge-core.c:2659 ddb_ports_init()
>  > error: buffer overflow 'dev->port' 32 <= u32max
>  > 
>  > Fix by making sure "p" is greater than zero before checking for
>  > "dev->port[].type == DDB_CI_EXTERNAL_XO2".
>  > 
>  > Cc: Ralph Metzler <rjkm@metzlerbros.de>
>  > Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
>  > ---
>  >  drivers/media/pci/ddbridge/ddbridge-core.c | 2 +-
>  >  1 file changed, 1 insertion(+), 1 deletion(-)
>  > 
>  > diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c
>  > b/drivers/media/pci/ddbridge/ddbridge-core.c index
>  > aba53fd27f3e..8981795b0819 100644 ---
>  > a/drivers/media/pci/ddbridge/ddbridge-core.c +++
>  > b/drivers/media/pci/ddbridge/ddbridge-core.c @@ -2551,7 +2551,7 @@
>  > void ddb_ports_init(struct ddb *dev) port->dvb[0].adap =
>  > &dev->adap[2 * p]; port->dvb[1].adap = &dev->adap[2 * p + 1];
>  >  
>  > -			if ((port->class == DDB_PORT_NONE) && i &&
>  > +			if ((port->class == DDB_PORT_NONE) && i
>  > && p > 0 && dev->port[p - 1].type == DDB_CI_EXTERNAL_XO2) {
>  >  				port->class = DDB_PORT_CI;
>  >  				port->type =
>  > DDB_CI_EXTERNAL_XO2_B; -- 
>  > 2.13.0  
> 
> p cannot be 0 if i is not.
> So, checking for both is redundant.
> 
> smatch seems to look a things very locally.

Fully agreed on this, since both i and p are incremented at the same
time in the surrounding loop. No strong opinion really, but I believe
if we don't "fix" this at this time, someone else surely will...

Best regards,
Daniel Scheller
-- 
https://github.com/herrnst
