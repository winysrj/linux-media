Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36028 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726128AbeIUCDs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Sep 2018 22:03:48 -0400
Date: Thu, 20 Sep 2018 23:18:34 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v2 4/4] [media] ad5820: Add support for of-autoload
Message-ID: <20180920201833.2d2skjn7fkrbdsqx@valkosipuli.retiisi.org.uk>
References: <20180920161912.17063-4-ricardo.ribalda@gmail.com>
 <20180920183151.2933-1-ricardo.ribalda@gmail.com>
 <2401971.XiI38RXFgU@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2401971.XiI38RXFgU@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Thu, Sep 20, 2018 at 11:10:23PM +0300, Laurent Pinchart wrote:
> > +MODULE_DEVICE_TABLE(of, ad5820_of_table);
> > +
> >  static SIMPLE_DEV_PM_OPS(ad5820_pm, ad5820_suspend, ad5820_resume);
> > 
> >  static struct i2c_driver ad5820_i2c_driver = {
> >  	.driver		= {
> >  		.name	= AD5820_NAME,
> >  		.pm	= &ad5820_pm,
> > +		.of_match_table = ad5820_of_table,
> 
> As the driver doesn't depend on CONFIG_OF, would it make sense to use 
> of_config_ptr() (and to compile the of table conditionally on CONFIG_OF) ?

You get ACPI support as a bonus if you don't use of_config_ptr(). :-) Other
changes could be needed but this enables probing the driver for a device.

In this case the probability of anyone using this device on an ACPI system
could be pretty low though.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
