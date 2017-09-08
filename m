Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:47852 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933029AbdIHNnZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Sep 2017 09:43:25 -0400
Date: Fri, 8 Sep 2017 16:43:20 +0300
From: Mika Westerberg <mika.westerberg@intel.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org, pavel@ucw.cz, sre@kernel.org
Subject: Re: [PATCH v9 17/24] ACPI: Document how to refer to LEDs from remote
 nodes
Message-ID: <20170908134320.GC2477@lahna.fi.intel.com>
References: <20170908131235.30294-1-sakari.ailus@linux.intel.com>
 <20170908131822.31020-13-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170908131822.31020-13-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 08, 2017 at 04:18:15PM +0300, Sakari Ailus wrote:
> +	Device (LED)
> +	{
> +		Name ((_DSD), Package () {
> +			ToUUID("dbb8e3e6-5886-4ba6-8795-1319f52a966b"),
> +			Package () {
> +				Package () { "led0", "LED0" },
> +				Package () { "led1", "LED1" },
> +			}
> +		})
> +		Name ((LED0), Package () {
> +			ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> +			Package () {
> +				Package () { "led", 0 },
> +				Package () { "flash-max-microamp", 1000000 },
> +				Package () { "led-max-microamp", 100000 },
> +				Package () { "label", "led:salama" },
> +			}
> +		})
> +		Name ((LED1), Package () {
> +			ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> +			Package () {
> +				Package () { "led", 1 },
> +				Package () { "led-max-microamp", 10000 },
> +				Package () { "label", "led:huomiovalo" },
> +			}
> +		})
> +	}
> +
> +	Device (SEN)
> +	{
> +		Name ((_DSD), Package () {
> +			ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> +			Package () {
> +				Package () {
> +					"flash-leds",
> +					Package () { \\LED, 0, \\LED, 1 },
> +				}
> +			}
> +		})
> +	}

You should probably try to compile these examples first ;-)
