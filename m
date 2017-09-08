Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:34995 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757011AbdIHTwR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Sep 2017 15:52:17 -0400
Subject: Re: [PATCH 0/3] AS3645A fixes
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
References: <20170908124213.18904-1-sakari.ailus@linux.intel.com>
Cc: linux-leds@vger.kernel.org, devicetree@vger.kernel.org
From: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Message-ID: <4b4517bc-e215-ef48-3431-1fc2396034cd@gmail.com>
Date: Fri, 8 Sep 2017 21:51:22 +0200
MIME-Version: 1.0
In-Reply-To: <20170908124213.18904-1-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch set.

On 09/08/2017 02:42 PM, Sakari Ailus wrote:
> Hi folks,
> 
> Here are a few fixes for the as3645a DTS as well as changes in bindings.
> The driver is not in a release yet. I'd like to get these in as through
> the media tree fixes branch.
> 
> Sakari Ailus (3):
>   as3645a: Use ams,input-max-microamp as documented in DT bindings
>   dt: bindings: as3645a: Use LED number to refer to LEDs
>   as3645a: Use integer numbers for parsing LEDs
> 
>  .../devicetree/bindings/leds/ams,as3645a.txt       | 28 ++++++++++++++--------
>  arch/arm/boot/dts/omap3-n950-n9.dtsi               | 10 +++++---
>  drivers/leds/leds-as3645a.c                        | 28 +++++++++++++++++++---
>  3 files changed, 50 insertions(+), 16 deletions(-)
> 

Acked-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>

-- 
Best regards,
Jacek Anaszewski
