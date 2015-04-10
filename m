Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45874 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbbDJRXl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Apr 2015 13:23:41 -0400
Message-ID: <5528071C.2040102@infradead.org>
Date: Fri, 10 Apr 2015 10:23:40 -0700
From: Randy Dunlap <rdunlap@infradead.org>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
CC: linux-kernel@vger.kernel.org,
	linux-media <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@nokia.com>
Subject: Re: linux-next: Tree for Apr 10 (media/i2c/adp1653)
References: <20150410211806.574ae8f9@canb.auug.org.au>
In-Reply-To: <20150410211806.574ae8f9@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/10/15 04:18, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20150409:
> 

on i386:

  CC [M]  drivers/media/i2c/adp1653.o
../drivers/media/i2c/adp1653.c: In function '__adp1653_set_power':
../drivers/media/i2c/adp1653.c:317:38: error: 'struct adp1653_platform_data' has no member named 'power_gpio'
   gpio_set_value(flash->platform_data->power_gpio, on);
                                      ^
../drivers/media/i2c/adp1653.c:336:38: error: 'struct adp1653_platform_data' has no member named 'power_gpio'
   gpio_set_value(flash->platform_data->power_gpio, 0);
                                      ^
../drivers/media/i2c/adp1653.c: In function 'adp1653_of_init':
../drivers/media/i2c/adp1653.c:471:4: error: 'struct adp1653_platform_data' has no member named 'power_gpio'
  pd->power_gpio = of_get_gpio_flags(node, 0, &flags);
    ^
../drivers/media/i2c/adp1653.c:472:8: error: 'struct adp1653_platform_data' has no member named 'power_gpio'
  if (pd->power_gpio < 0) {
        ^
../drivers/media/i2c/adp1653.c:433:6: warning: unused variable 'gpio' [-Wunused-variable]
  int gpio;
      ^



-- 
~Randy
