Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:39846 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751223AbeC1JZy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Mar 2018 05:25:54 -0400
Date: Wed, 28 Mar 2018 06:25:45 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Luis Oliveira <Luis.Oliveira@synopsys.com>,
        Aishwarya Pant <aishpant@gmail.com>,
        Riccardo Schirone <sirmy15@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, devel@driverdev.osuosl.org
Subject: Re: [PATCH 07/18] media: staging: atomisp: fix endianess issues
Message-ID: <20180328062545.6b30aac8@vento.lan>
In-Reply-To: <1522148575.21176.22.camel@linux.intel.com>
References: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
        <cc521a255756c0241572816f96e3b97126ac16de.1522098456.git.mchehab@s-opensource.com>
        <1522148575.21176.22.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 27 Mar 2018 14:02:55 +0300
Andy Shevchenko <andriy.shevchenko@linux.intel.com> escreveu:

> On Mon, 2018-03-26 at 17:10 -0400, Mauro Carvalho Chehab wrote:
> > There are lots of be-related warnings there, as it doesn't properly
> > mark what data uses bigendian.  
> 
> > @@ -107,7 +107,7 @@ mt9m114_write_reg(struct i2c_client *client, u16
> > data_length, u16 reg, u32 val)
> >  	int num_msg;
> >  	struct i2c_msg msg;
> >  	unsigned char data[6] = {0};
> > -	u16 *wreg;
> > +	__be16 *wreg;
> >   
> 
> > +		u16 *wdata = (void *)&data[2];
> > +
> > +		*wdata = be16_to_cpu(*(__be16 *)&data[2]);  
> 
> > +		u32 *wdata = (void *)&data[2];
> > +
> > +		*wdata = be32_to_cpu(*(__be32 *)&data[2]);  
> 
> For x86 it is okay, though in general it should use get_unaligned().
> 

Yeah, it makes sense to change those to use 
get_unaligned_be16()/get_unaligned_be32(), but still the endianness
issue remains, as it will still require the usage of __be casts.

The main goal here in this patch series is to get rid of hundreds
of smatch/sparce warnings, as it makes very hard to identify new
warnings, due to all polution inside atomisp.

A change to get_unaligned_foo() is meant to do a different
thing: to make those i2c drivers more arch-independent.

So, feel free to submit a separate patch doing that, on the
top of it.

Thanks,
Mauro
