Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46708 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751023AbdGHWeT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 8 Jul 2017 18:34:19 -0400
Date: Sun, 9 Jul 2017 01:34:13 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Alan Cox <alan@linux.intel.com>
Cc: Arvind Yadav <arvind.yadav.cs@gmail.com>, mchehab@kernel.org,
        gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: atomisp: gc0310: constify acpi_device_id.
Message-ID: <20170708223413.35eg55wkhnqcmxzy@valkosipuli.retiisi.org.uk>
References: <7d7e1a0d6e7f90a9f8b4545fec2077ea3b351cb6.1499357881.git.arvind.yadav.cs@gmail.com>
 <1499424463.5590.12.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1499424463.5590.12.camel@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 07, 2017 at 11:47:43AM +0100, Alan Cox wrote:
> On Thu, 2017-07-06 at 21:50 +0530, Arvind Yadav wrote:
> > acpi_device_id are not supposed to change at runtime. All functions
> > working with acpi_device_id provided by <acpi/acpi_bus.h> work with
> > const acpi_device_id. So mark the non-const structs as const.
> > 
> > File size before:
> >    text	   data	    bss	    dec	    hex	
> > filename
> >   10297	   1888	      0	  12185	   2f99
> > drivers/staging/media/atomisp/i2c/gc0310.o
> > 
> > File size After adding 'const':
> >    text	   data	    bss	    dec	    hex	
> > filename
> >   10361	   1824	      0	  12185	   2f99
> > drivers/staging/media/atomisp/i2c/gc0310.o
> > 
> > Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
> > ---
> >  drivers/staging/media/atomisp/i2c/gc0310.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/staging/media/atomisp/i2c/gc0310.c
> > b/drivers/staging/media/atomisp/i2c/gc0310.c
> > index 1ec616a..c8162bb 100644
> > --- a/drivers/staging/media/atomisp/i2c/gc0310.c
> > +++ b/drivers/staging/media/atomisp/i2c/gc0310.c
> > @@ -1453,7 +1453,7 @@ static int gc0310_probe(struct i2c_client
> > *client,
> >  	return ret;
> >  }
> >  
> > -static struct acpi_device_id gc0310_acpi_match[] = {
> > +static const struct acpi_device_id gc0310_acpi_match[] = {
> >  	{"XXGC0310"},
> >  	{},
> >  };
> 
> (All four)
> 
> Acked-by: Alan Cox <alan@linux.intel.com>

There's four more... I've applied all to my atomisp branch.

Arvind: please send the patches as a single set next time.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
