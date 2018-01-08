Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:43455 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751600AbeAHK3v (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 Jan 2018 05:29:51 -0500
Date: Mon, 8 Jan 2018 11:29:44 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org,
        "H . Nikolaus Schaller" <hns@goldelico.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v2 1/2] media: ov9650: support device tree probing
Message-ID: <20180108102944.GN9493@w540>
References: <1515344064-23156-1-git-send-email-akinobu.mita@gmail.com>
 <1515344064-23156-2-git-send-email-akinobu.mita@gmail.com>
 <20180108091838.GM9493@w540>
 <20180108093712.xqpxmgbqsmkhw632@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20180108093712.xqpxmgbqsmkhw632@paasikivi.fi.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Mon, Jan 08, 2018 at 11:37:12AM +0200, Sakari Ailus wrote:
> Hi Jacopo,
>
> On Mon, Jan 08, 2018 at 10:18:38AM +0100, jacopo mondi wrote:
> > > @@ -1561,9 +1605,19 @@ static const struct i2c_device_id ov965x_id[] = {
> > >  };
> > >  MODULE_DEVICE_TABLE(i2c, ov965x_id);
> > >
> > > +#if IS_ENABLED(CONFIG_OF)
> > > +static const struct of_device_id ov965x_of_match[] = {
> > > +	{ .compatible = "ovti,ov9650", },
> > > +	{ .compatible = "ovti,ov9652", },
> > > +	{ /* sentinel */ }
> > > +};
> > > +MODULE_DEVICE_TABLE(of, ov965x_of_match);
> > > +#endif
> > > +
> > >  static struct i2c_driver ov965x_i2c_driver = {
> > >  	.driver = {
> > >  		.name	= DRIVER_NAME,
> > > +		.of_match_table = of_match_ptr(ov965x_of_match),
> >
> > If CONFIG_OF is not defined, this will break compilation.
> > Please guard this with #if IS_ENABLED(CONFIG_OF) as well.
>
> of_match_ptr() will be NULL if CONFIG_OF is not defined, so AFAICT this is
> fine.
>

That's even better. Thanks for pointing this out!
Please ignore my comment then!

Cheers
   j

> --
> Sakari Ailus
> sakari.ailus@linux.intel.com
