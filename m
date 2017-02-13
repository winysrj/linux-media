Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx209.ext.ti.com ([198.47.19.16]:12633 "EHLO
        fllnx209.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751666AbdBMJ0M (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 04:26:12 -0500
Subject: Re: [PATCH 00/10] ARM: davinci: add vpif display support
To: Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Kevin Hilman <khilman@kernel.org>,
        Patrick Titiano <ptitiano@baylibre.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexandre Bailon <abailon@baylibre.com>,
        David Lechner <david@lechnology.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Lad Prabhakar <prabhakar.csengg@gmail.com>
References: <1486485683-11427-1-git-send-email-bgolaszewski@baylibre.com>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-media@vger.kernel.org>
From: Sekhar Nori <nsekhar@ti.com>
Message-ID: <058423ca-c53b-93a2-035e-54fe3ce6dcfe@ti.com>
Date: Mon, 13 Feb 2017 14:52:57 +0530
MIME-Version: 1.0
In-Reply-To: <1486485683-11427-1-git-send-email-bgolaszewski@baylibre.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bartosz,

On Tuesday 07 February 2017 10:11 PM, Bartosz Golaszewski wrote:
> The following series adds support for v4l2 display on da850-evm with
> a UI board in device tree boot mode.
> 
> Patches 1/10 - 5/10 deal with the device tree: we fix whitespace
> errors in dts files and bindings, extend the example and the dts for
> da850-evm with the output port and address the pinmuxing.
> 
> Patch 6/10 enables the relevant modules in the defconfig file.
> 
> Patches 7/10 and 8/10 fix two already existing bugs encountered
> during development.
> 
> Patch 9/10 make it possible to use a different i2c adapter in the
> vpif display driver.
> 
> The last patch adds the pdata quirks necessary to enable v4l2 display.
> 
> Tested with a modified version of yavta[1] as gstreamer support for
> v4l2 seems to be broken and results in picture artifacts.
> 
> [1] https://github.com/brgl/yavta davinci/vpif-display

Can you also share the command line you used ?

Thanks,
Sekhar
