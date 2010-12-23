Return-path: <mchehab@gaivota>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:56722 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752676Ab0LWSeJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Dec 2010 13:34:09 -0500
Subject: Re: smatch report: cx231xx: incorrect check in
 cx231xx_write_i2c_data()
From: Andy Walls <awalls@md.metrocast.net>
To: Dan Carpenter <error27@gmail.com>
Cc: Srinivasa.Deevi@conexant.com, linux-media@vger.kernel.org
In-Reply-To: <20101223164347.GA16612@bicker>
References: <20101223164347.GA16612@bicker>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Dec 2010 13:34:52 -0500
Message-ID: <1293129292.24752.9.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Thu, 2010-12-23 at 19:43 +0300, Dan Carpenter wrote:
> Hi,
> 
> I was doing an audit and I came across this.
> 
> drivers/media/video/cx231xx/cx231xx-core.c +1644 cx231xx_write_i2c_data(14)
> 	warn: 'saddr_len' is non-zero. Did you mean 'saddr'
> 
>   1642          if (saddr_len == 0)
>   1643                  saddr = 0;
>   1644          else if (saddr_len == 0)
>   1645                  saddr &= 0xff;
> 
> We check "saddr_len == 0" twice which doesn't make sense.  I'm not sure
> what the correct fix is though.

Given that "saddr" probably means "sub-address", that "saddr_len"
probably means "sub-address length", that saddr is only a 16 bit value,
and this switch in cx231xx_send_usb_command():

        /* set index value */
        switch (saddr_len) {
        case 0:
                ven_req.wIndex = 0;     /* need check */
                break;
        case 1:
                ven_req.wIndex = (req_data->saddr_dat & 0xff);
                break;
        case 2:
                ven_req.wIndex = req_data->saddr_dat;
                break;
        }

and noting that "req_data->saddr_dat" holds what was "saddr";
the if statement, and the many others like it, should probably be:

	if (saddr_len == 0)
		saddr = 0;
	else if (saddr_len == 1)       <----- == 1
		saddr &= 0xff;


Regards,
Andy

>   It's been this way since the driver was
> merged.
> 
> regards,
> dan carpenter



