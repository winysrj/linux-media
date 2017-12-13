Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:60503 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752948AbdLMP0G (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Dec 2017 10:26:06 -0500
Date: Wed, 13 Dec 2017 13:26:02 -0200
From: Mauro Carvalho Chehab <mchehab@kernel.org>
To: Daniel Scheller <d.scheller.oss@gmail.com>
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com
Subject: Re: [PATCH 2/2] [media] ddbridge: don't break on single/last port
 attach failure
Message-ID: <20171213132602.79a35512@vento.lan>
In-Reply-To: <20171206175915.20669-3-d.scheller.oss@gmail.com>
References: <20171206175915.20669-1-d.scheller.oss@gmail.com>
        <20171206175915.20669-3-d.scheller.oss@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed,  6 Dec 2017 18:59:15 +0100
Daniel Scheller <d.scheller.oss@gmail.com> escreveu:

> From: Daniel Scheller <d.scheller@gmx.net>
> 
> As all error handling improved quite a bit, don't stop attaching frontends
> if one of them failed, since - if other tuner modules are connected to
> the PCIe bridge - other hardware may just work, so lets not break on a
> single port failure, but rather initialise as much as possible. Ie. if
> there are issues with a C2T2-equipped PCIe bridge card which has
> additional DuoFlex modules connected and the bridge generally works,
> the DuoFlex tuners can still work fine. Also, this only had an effect
> anyway if the failed device/port was the last one being enumerated.
> 
> Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
> ---
>  drivers/media/pci/ddbridge/ddbridge-core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
> index 11c5cae92408..b43c40e0bf73 100644
> --- a/drivers/media/pci/ddbridge/ddbridge-core.c
> +++ b/drivers/media/pci/ddbridge/ddbridge-core.c
> @@ -1962,7 +1962,7 @@ int ddb_ports_attach(struct ddb *dev)
>  	}
>  	for (i = 0; i < dev->port_num; i++) {
>  		port = &dev->port[i];
> -		ret = ddb_port_attach(port);
> +		ddb_port_attach(port);

Nah, ignoring an error doesn't seem right. It should at least print
that attach failed. Also, if all attaches fail, probably the best
would be to just detach everything and go to the error handling code,
as there's something serious happening.

Something like:

  	for (i = 0; i < dev->port_num; i++) {
  		port = &dev->port[i];
		ret = ddb_port_attach(port);
		if (ret) {
			dev_warn(port->dev->dev, "attach failed\n");
			err_ports++;
	}
	if (err_ports == dev->port_num)
		return -ENODEV;

Thanks,
Mauro
