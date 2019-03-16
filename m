Return-Path: <SRS0=HTTW=RT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09A7EC43381
	for <linux-media@archiver.kernel.org>; Sat, 16 Mar 2019 08:59:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CED5C218FE
	for <linux-media@archiver.kernel.org>; Sat, 16 Mar 2019 08:59:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbfCPI7b (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 16 Mar 2019 04:59:31 -0400
Received: from gofer.mess.org ([88.97.38.141]:51099 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbfCPI7a (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Mar 2019 04:59:30 -0400
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 1D26C60359; Sat, 16 Mar 2019 08:59:28 +0000 (GMT)
Date:   Sat, 16 Mar 2019 08:59:28 +0000
From:   Sean Young <sean@mess.org>
To:     Stefan Becker <chemobejk@gmail.com>
Cc:     linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH] media: si2168: add parameter to disable DVB-T support
Message-ID: <20190316085928.o53czq5gkie6rge3@gofer.mess.org>
References: <20190308222148.15194-1-chemobejk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190308222148.15194-1-chemobejk@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Sat, Mar 09, 2019 at 12:21:48AM +0200, Stefan Becker wrote:
> Some DVB clients are broken and only recognize the DVB-T/T2 support in
> the frontend. Thus they are unable to use the frontend in DVB-C mode.
> One example is the incomplete DVBv5 API support added in mythtv 0.30:
> 
>    https://code.mythtv.org/trac/ticket/12638
> 
> The boolean module parameter "disable_dvb_t" removes DVB-T and DVB-T2
> from the delsys list in dvb_frontend_ops and thus forces the client to
> recognize a DVB-C frontend.

This is wrong in a few ways. DVBv5 has been around for sometime and clients
really should be updated by now. If if there were an option to disable 
DVB-T and DVB-T2 then that would not exist in a specific frontend.

NAK

Sean

> 
> Signed-off-by: Stefan Becker <chemobejk@gmail.com>
> ---
>  drivers/media/dvb-frontends/si2168.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
> index 324493e05f9f..8aeb024057dc 100644
> --- a/drivers/media/dvb-frontends/si2168.c
> +++ b/drivers/media/dvb-frontends/si2168.c
> @@ -14,10 +14,15 @@
>   *    GNU General Public License for more details.
>   */
>  
> +#include <linux/module.h>
>  #include <linux/delay.h>
>  
>  #include "si2168_priv.h"
>  
> +static bool disable_dvb_t;
> +module_param(disable_dvb_t, bool, 0644);
> +MODULE_PARM_DESC(disable_dvb_t, "Disable DVB-T/T2 support (default: enabled)");
> +
>  static const struct dvb_frontend_ops si2168_ops;
>  
>  /* execute firmware command */
> @@ -800,6 +805,10 @@ static int si2168_probe(struct i2c_client *client,
>  
>  	/* create dvb_frontend */
>  	memcpy(&dev->fe.ops, &si2168_ops, sizeof(struct dvb_frontend_ops));
> +	if (disable_dvb_t) {
> +		memset(dev->fe.ops.delsys, 0, sizeof(dev->fe.ops.delsys));
> +		dev->fe.ops.delsys[0] = SYS_DVBC_ANNEX_A;
> +	}
>  	dev->fe.demodulator_priv = client;
>  	*config->i2c_adapter = dev->muxc->adapter[0];
>  	*config->fe = &dev->fe;
> -- 
> 2.20.1
