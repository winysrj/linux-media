Return-path: <linux-media-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:38141 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751368AbdCDMV6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 4 Mar 2017 07:21:58 -0500
Date: Sat, 4 Mar 2017 12:10:20 +0000
From: Andrey Utkin <andrey_utkin@fastmail.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Andy Walls <awalls@md.metrocast.net>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Mike Isely <isely@pobox.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Stephen Backway <stev391@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        GEORGE <geoubuntu@gmail.com>, Shuah Khan <shuah@kernel.org>,
        Oleh Kravchenko <oleg@kaa.org.ua>
Subject: Re: [PATCH] [media] tveeprom: get rid of unused arg on
 tveeprom_hauppauge_analog()
Message-ID: <20170304121020.GB25089@dell-m4800.Home>
References: <a0c1fc52fda7e36389fd0c19ea320e5c37b00c17.1488537200.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0c1fc52fda7e36389fd0c19ea320e5c37b00c17.1488537200.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 03, 2017 at 07:33:43AM -0300, Mauro Carvalho Chehab wrote:
> tveeprom_hauppauge_analog() used to need the I2C adapter in
> order to print debug messages. As it now uses pr_foo() facilities,
> this is not needed anymore.
> 
> So, get rid of it.

Hi  Mauro,

Thanks for CCing :)

> diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
> index 5f90d0899a45..5f80a1b2fb8c 100644
> --- a/drivers/media/usb/em28xx/em28xx-cards.c
> +++ b/drivers/media/usb/em28xx/em28xx-cards.c
> @@ -2974,8 +2974,7 @@ static void em28xx_card_setup(struct em28xx *dev)
>  #endif
>  		/* Call first TVeeprom */
>  
> -		dev->i2c_client[dev->def_i2c_bus].addr = 0xa0 >> 1;
> -		tveeprom_hauppauge_analog(&dev->i2c_client[dev->def_i2c_bus], &tv, dev->eedata);
> +		tveeprom_hauppauge_analog(&tv, dev->eedata);

Are we sure no other code relies on
dev->i2c_client[dev->def_i2c_bus].addr being set here?
I am completely not familiar with this driver, that's why I'm asking.
