Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:40004 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965428AbeCGUJb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Mar 2018 15:09:31 -0500
Received: by mail-wr0-f196.google.com with SMTP id o76so3434901wrb.7
        for <linux-media@vger.kernel.org>; Wed, 07 Mar 2018 12:09:31 -0800 (PST)
Date: Wed, 7 Mar 2018 21:09:26 +0100
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com
Subject: Re: [PATCH 3/4] [media] ddbridge: use common DVB I2C client
 handling helpers
Message-ID: <20180307210926.12cd482d@lt530>
In-Reply-To: <20180307164449.1aca9352@vento.lan>
References: <20180307192350.930-1-d.scheller.oss@gmail.com>
        <20180307192350.930-4-d.scheller.oss@gmail.com>
        <20180307164449.1aca9352@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Wed, 7 Mar 2018 16:44:49 -0300
schrieb Mauro Carvalho Chehab <mchehab@kernel.org>:

> Em Wed,  7 Mar 2018 20:23:49 +0100
> Daniel Scheller <d.scheller.oss@gmail.com> escreveu:
> 
> > From: Daniel Scheller <d.scheller@gmx.net>
> > 
> > Instead of keeping duplicated I2C client handling construct, make
> > use of the newly introduced dvb_module_*() helpers. This not only
> > keeps things way cleaner and removes the need for duplicated I2C
> > client attach code, but even allows to get rid of some variables
> > that won't help in making things look cleaner anymore.
> > 
> > The check on a valid ptr on port->en isn't really needed since the
> > cxd2099 driver will set it at a time where it is going to return
> > successfully from probing.
> > 
> > Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
> > ---
> >  drivers/media/pci/ddbridge/ddbridge-ci.c   | 33
> > ++++++--------------------
> > drivers/media/pci/ddbridge/ddbridge-core.c | 37
> > +++++++----------------------- 2 files changed, 15 insertions(+),
> > 55 deletions(-)
> > 
> > diff --git a/drivers/media/pci/ddbridge/ddbridge-ci.c
> > b/drivers/media/pci/ddbridge/ddbridge-ci.c index
> > 6585ef54ac22..d0ce6a1f1bd0 100644 ---
> > a/drivers/media/pci/ddbridge/ddbridge-ci.c +++
> > b/drivers/media/pci/ddbridge/ddbridge-ci.c @@ -324,34 +324,20 @@
> > static int ci_cxd2099_attach(struct ddb_port *port, u32 bitrate) {
> >  	struct cxd2099_cfg cxd_cfg = cxd_cfgtmpl;
> >  	struct i2c_client *client;
> > -	struct i2c_board_info board_info = {
> > -		.type = "cxd2099",
> > -		.addr = 0x40,
> > -		.platform_data = &cxd_cfg,
> > -	};
> >  
> >  	cxd_cfg.bitrate = bitrate;
> >  	cxd_cfg.en = &port->en;
> >  
> > -	request_module(board_info.type);
> > -
> > -	client = i2c_new_device(&port->i2c->adap, &board_info);
> > -	if (!client || !client->dev.driver)
> > -		goto err_ret;
> > -
> > -	if (!try_module_get(client->dev.driver->owner))
> > -		goto err_i2c;
> > -
> > -	if (!port->en)
> > -		goto err_i2c;
> > +	client = dvb_module_probe("cxd2099", "cxd2099",
> > &port->i2c->adap,
> > +				  0x40, &cxd_cfg);  
> 
> Here and on all similar calls, there's no need to duplicate the name,
> if they're identical. Just use NULL at the second time, e. g.:
> 
> 	client = dvb_module_probe("cxd2099", NULL, &port->i2c->adap,
> 				  0x40, &cxd_cfg);
> 
> The dvb_module_probe() will use the same string for both.

Convinced (wanted to make this look "complete" and "proper").

V2 sent, skipped the cover letter though :-)

Best regards,
Daniel Scheller
-- 
https://github.com/herrnst
