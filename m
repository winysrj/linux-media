Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:38020 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751852AbdIVTiA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 15:38:00 -0400
Subject: Re: [PATCH v3 0/4] AS3645A fixes
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-leds@vger.kernel.org
References: <20170922093238.13070-1-sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, devicetree@kernel.org
From: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Message-ID: <650b7cb3-f7dd-5959-3147-df7284415521@gmail.com>
Date: Fri, 22 Sep 2017 21:37:06 +0200
MIME-Version: 1.0
In-Reply-To: <20170922093238.13070-1-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 09/22/2017 11:32 AM, Sakari Ailus wrote:
> Hi Jacek and others,
> 
> Here are a few fixes for the as3645a DTS as well as changes in bindings.
> The driver is not in a release yet.
> 
> Jacek: Could you take these to your fixes branch so we don't get faulty DT
> bindings to a release? I've dropped the patches related to LED naming and
> label property as the discusion appears to continue on that.

No problem. One question - isn't patch 3/4 missing?

Best regards,
Jacek Anaszewski

> Thanks.
> 
> 
> since v2:
> 
> - Drop patches related to LED naming.
> 
> - No other changes.
> 
> since v1:
> 
> - Add LED colour to the name of the LED, this adds two patches to the set.
> 
> - Add a patch to unregister the indicator LED in driver remove function.
> 
> - No changes to v1 patches.
> 
> Sakari Ailus (4):
>   as3645a: Use ams,input-max-microamp as documented in DT bindings
>   dt: bindings: as3645a: Use LED number to refer to LEDs
>   as3645a: Use integer numbers for parsing LEDs
>   as3645a: Unregister indicator LED on device unbind
> 
>  .../devicetree/bindings/leds/ams,as3645a.txt       | 28 +++++++++++++--------
>  arch/arm/boot/dts/omap3-n950-n9.dtsi               | 10 +++++---
>  drivers/leds/leds-as3645a.c                        | 29 +++++++++++++++++++---
>  3 files changed, 51 insertions(+), 16 deletions(-)
> 
