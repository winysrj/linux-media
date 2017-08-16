Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:36644 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752336AbdHPU2C (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Aug 2017 16:28:02 -0400
Subject: Re: [PATCH 0/3] AS3645A flash support
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
References: <20170816125440.27534-1-sakari.ailus@linux.intel.com>
Cc: linux-leds@vger.kernel.org, devicetree@vger.kernel.org
From: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Message-ID: <0534a432-39ff-e498-d208-770812cd8f1d@gmail.com>
Date: Wed, 16 Aug 2017 22:27:17 +0200
MIME-Version: 1.0
In-Reply-To: <20170816125440.27534-1-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 08/16/2017 02:54 PM, Sakari Ailus wrote:
> Hi everyone,
> 
> This set adds support for the AS3645A flash driver which can be found e.g.
> in Nokia N9.
> 
> The set depeds on the flash patches here so I'd prefer to merge this
> through mediatree.
> 
> <URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=flash>
> 
> Jacek: would that be ok for you?

No problem.

> 
> Since the RFC set:
> 
> - Add back the DT binding documentation I lost long ago.
> 
> - Use colon (":") in the default names instead of a space.
> 
> Sakari Ailus (3):
>   dt: bindings: Document DT bindings for Analog devices as3645a
>   leds: as3645a: Add LED flash class driver
>   arm: dts: omap3: N9/N950: Add AS3645A camera flash
> 
>  .../devicetree/bindings/leds/ams,as3645a.txt       |  56 ++
>  MAINTAINERS                                        |   6 +
>  arch/arm/boot/dts/omap3-n9.dts                     |   1 +
>  arch/arm/boot/dts/omap3-n950-n9.dtsi               |  14 +
>  arch/arm/boot/dts/omap3-n950.dts                   |   1 +
>  drivers/leds/Kconfig                               |   8 +
>  drivers/leds/Makefile                              |   1 +
>  drivers/leds/leds-as3645a.c                        | 785 +++++++++++++++++++++
>  8 files changed, 872 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/leds/ams,as3645a.txt
>  create mode 100644 drivers/leds/leds-as3645a.c
> 

-- 
Best regards,
Jacek Anaszewski
