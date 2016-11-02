Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36128 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753009AbcKBT6H (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 2 Nov 2016 15:58:07 -0400
Subject: Re: [PATCH v3 0/6] Add support for IR transmitters
To: Andi Shyti <andi.shyti@samsung.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Sean Young <sean@mess.org>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Jacek Anaszewski <j.anaszewski@samsung.com>
References: <20161102104010.26959-1-andi.shyti@samsung.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Shyti <andi@etezian.org>
From: Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <d94abce2-d11d-3776-3724-e2560c217ed2@gmail.com>
Date: Wed, 2 Nov 2016 20:57:55 +0100
MIME-Version: 1.0
In-Reply-To: <20161102104010.26959-1-andi.shyti@samsung.com>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 02.11.2016 um 11:40 schrieb Andi Shyti:
> Hi,
> 
> The main goal is to add support in the rc framework for IR
> transmitters, which currently is only supported by lirc but that
> is not the preferred way.
> 
> The last patch adds support for an IR transmitter driven by
> the MOSI line of an SPI controller, it's the case of the Samsung
> TM2(e) board which support is currently ongoing.
> 
> The last patch adds support for an IR transmitter driven by
> the MOSI line of an SPI controller, it's the case of the Samsung
> TM2(e) board which support is currently ongoing.
> 
> Thanks Sean for your prompt reviews.
> 
> Andi
> 
> Changelog from version 1:
> 
> The RFC is now PATCH. The main difference is that this version
> doesn't try to add the any bit streaming protocol and doesn't
> modify any LIRC interface specification.
> 
> patch 1: updates all the drivers using rc_allocate_device
> patch 2: fixed errors and warning reported from the kbuild test
>          robot
> patch 5: this patch has been dropped and replaced with a new one
>          which avoids waiting for transmitters.
> patch 6: added new properties to the dts specification
> patch 7: the driver uses the pulse/space input and converts it to
>          a bit stream.
> 
> 
> Changelog from version 2:
> 
> The original patch number 5 has been abandoned because it was not
> bringing much benenfit.
> 
> patch 1: rebased on the new kernel.
> patch 3: removed the sysfs attribute protocol for transmitters
> patch 5: the binding has been moved to the leds section instead
>          of the media. Fixed all the comments from Rob
> patch 6: fixed all the comments from Sean added also Sean's
>          review.
> 
> Andi Shyti (6):
>   [media] rc-main: assign driver type during allocation
>   [media] rc-main: split setup and unregister functions
>   [media] rc-core: add support for IR raw transmitters
>   [media] rc-ir-raw: do not generate any receiving thread for raw
>     transmitters
>   Documentation: bindings: add documentation for ir-spi device driver
>   [media] rc: add support for IR LEDs driven through SPI
> 
Hi Andi,

at least patches 1 and 2 conflict with recent extensions. See commits
ddbf7d5a698c "rc: core: add managed versions of rc_allocate_device and
rc_register_device" and b6f3ece38733 "[media] rc: nuvoton: use managed
versions of rc_allocate_device and rc_register_device".

It would be good if you could rebase your patch set on top of the
latest master branch of media tree. Most likely you will have to make
changes to the recently introduced managed versions of
rc_allocate_device and rc_register_device.

Rgds, Heiner

