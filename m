Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:36030 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965076AbcLVQkd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Dec 2016 11:40:33 -0500
Date: Thu, 22 Dec 2016 10:40:29 -0600
From: Rob Herring <robh@kernel.org>
To: Andi Shyti <andi.shyti@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Sean Young <sean@mess.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Shyti <andi@etezian.org>
Subject: Re: [PATCH v6 5/6] Documentation: bindings: add documentation for
 ir-spi device driver
Message-ID: <20161222164029.7qr3dxr5lnnyrrqh@rob-hp-laptop>
References: <20161218111138.12831-1-andi.shyti@samsung.com>
 <20161218111138.12831-6-andi.shyti@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161218111138.12831-6-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Dec 18, 2016 at 08:11:37PM +0900, Andi Shyti wrote:
> Document the ir-spi driver's binding which is a IR led driven
> through the SPI line.
> 
> Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
> Reviewed-by: Sean Young <sean@mess.org>
> ---
>  .../devicetree/bindings/leds/irled/spi-ir-led.txt  | 29 ++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/leds/irled/spi-ir-led.txt

Acked-by: Rob Herring <robh@kernel.org>
