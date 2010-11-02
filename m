Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:50675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905Ab0KBM31 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Nov 2010 08:29:27 -0400
Message-ID: <4CD00423.4060309@redhat.com>
Date: Tue, 02 Nov 2010 08:29:23 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: chris2553@googlemail.com
CC: linux-media@vger.kernel.org
Subject: Re: Warnings from latest -git
References: <201010300917.47372.chris2553@googlemail.com>
In-Reply-To: <201010300917.47372.chris2553@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 30-10-2010 04:17, Chris Clayton escreveu:
> Hi,
> 
> Please cc me on any reply as I'm not subscribed.
> 
> Building v2.6.36-9452-g2d10d87 pulled this morning, I get:
> 
> warning: (DVB_USB_DIB0700 && MEDIA_SUPPORT && DVB_CAPTURE_DRIVERS && DVB_CORE && 
> DVB_USB && !DVB_FE_CUSTOMISE) selects DVB_DIB8000 which has unmet direct 
> dependencies (MEDIA_SUPPORT && DVB_CAPTURE_DRIVERS && DVB_FE_CUSTOMISE && 
> DVB_CORE && I2C)

It certainly requires further investigation. From your config file, we have,
for dib0700:

CONFIG_DVB_USB_DIB0700=m
CONFIG_MEDIA_SUPPORT=m
CONFIG_DVB_CAPTURE_DRIVERS=y
CONFIG_DVB_CORE=m
CONFIG_DVB_USB=m
# CONFIG_DVB_FE_CUSTOMISE is not set

And, for dib8000:

CONFIG_MEDIA_SUPPORT=m
CONFIG_DVB_CAPTURE_DRIVERS=y
# CONFIG_DVB_FE_CUSTOMISE is not set
CONFIG_DVB_CORE=m
CONFIG_I2C=y

Both dib0700 and dib8000 were marked as m:

CONFIG_DVB_DIB8000=m
CONFIG_DVB_USB_DIB0700=m

So, in this specific example, it actually worked, but we need to find a fix
for this bug.

Cheers,
Mauro
