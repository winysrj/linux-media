Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:48911 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751030AbeC0LDG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Mar 2018 07:03:06 -0400
Message-ID: <1522148575.21176.22.camel@linux.intel.com>
Subject: Re: [PATCH 07/18] media: staging: atomisp: fix endianess issues
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
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
Date: Tue, 27 Mar 2018 14:02:55 +0300
In-Reply-To: <cc521a255756c0241572816f96e3b97126ac16de.1522098456.git.mchehab@s-opensource.com>
References: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
         <cc521a255756c0241572816f96e3b97126ac16de.1522098456.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2018-03-26 at 17:10 -0400, Mauro Carvalho Chehab wrote:
> There are lots of be-related warnings there, as it doesn't properly
> mark what data uses bigendian.

> @@ -107,7 +107,7 @@ mt9m114_write_reg(struct i2c_client *client, u16
> data_length, u16 reg, u32 val)
>  	int num_msg;
>  	struct i2c_msg msg;
>  	unsigned char data[6] = {0};
> -	u16 *wreg;
> +	__be16 *wreg;
> 

> +		u16 *wdata = (void *)&data[2];
> +
> +		*wdata = be16_to_cpu(*(__be16 *)&data[2]);

> +		u32 *wdata = (void *)&data[2];
> +
> +		*wdata = be32_to_cpu(*(__be32 *)&data[2]);

For x86 it is okay, though in general it should use get_unaligned().

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
