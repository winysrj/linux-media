Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54896 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691Ab0E1SZe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 28 May 2010 14:25:34 -0400
Message-ID: <4C000A96.3010308@iki.fi>
Date: Fri, 28 May 2010 21:25:26 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Nikola Pajkovsky <npajkovs@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] V4L/DVB: New NXP tda18218 tuner
References: <1274349174-3961-1-git-send-email-npajkovs@redhat.com>
In-Reply-To: <1274349174-3961-1-git-send-email-npajkovs@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Terve,

On 05/20/2010 12:52 PM, Nikola Pajkovsky wrote:
> Signed-off-by: Nikola Pajkovsky<npajkovs@redhat.com>
> ---
>   drivers/media/common/tuners/Kconfig         |    7 +
>   drivers/media/common/tuners/Makefile        |    1 +
>   drivers/media/common/tuners/tda18218.c      |  432 +++++++++++++++++++++++++++
>   drivers/media/common/tuners/tda18218.h      |   44 +++
>   drivers/media/common/tuners/tda18218_priv.h |   36 +++
>   drivers/media/dvb/dvb-usb/af9015.c          |   13 +-
>   drivers/media/dvb/frontends/af9013.c        |   15 +
>   drivers/media/dvb/frontends/af9013_priv.h   |    5 +-
>   8 files changed, 548 insertions(+), 5 deletions(-)
>   create mode 100644 drivers/media/common/tuners/tda18218.c
>   create mode 100644 drivers/media/common/tuners/tda18218.h
>   create mode 100644 drivers/media/common/tuners/tda18218_priv.h

tda18218_write_reg() could use tda18218_write_regs()

tda18218_set_params() correct frequency limits. No need to check both 
upper and lower limit.

printk(KERN_INFO "We've got a lock!");
it does not sounds good idea to print INFO when lock

while(i < 10) {
use for loop insted. Two rows less code.

tda18218_init()
why return -EREMOTEIO; ?

tda18218_attach()
printk(KERN_WARNING "Device is not a TDA18218!\n");
we should fail without noise since many times tuner attach is used for 
probe correct tuner

A lot of error checkings are missing when reg write / read

checkpatch returns a lot of warnings and for errors too almost every 
file changed

Is that checked TDA18218 uses same demod settings as TDA18271?

And the biggest problem is that driver author Lauris haven't replied any 
mails...

regards
Antti


-- 
http://palosaari.fi/
