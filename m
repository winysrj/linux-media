Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48776 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753740AbdIHNyK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Sep 2017 09:54:10 -0400
Date: Fri, 8 Sep 2017 16:54:07 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mika Westerberg <mika.westerberg@intel.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org, pavel@ucw.cz, sre@kernel.org
Subject: Re: [PATCH v9 17/24] ACPI: Document how to refer to LEDs from remote
 nodes
Message-ID: <20170908135407.qxustmjr3yqhp7y5@valkosipuli.retiisi.org.uk>
References: <20170908131235.30294-1-sakari.ailus@linux.intel.com>
 <20170908131822.31020-13-sakari.ailus@linux.intel.com>
 <20170908134320.GC2477@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170908134320.GC2477@lahna.fi.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 08, 2017 at 04:43:20PM +0300, Mika Westerberg wrote:
> On Fri, Sep 08, 2017 at 04:18:15PM +0300, Sakari Ailus wrote:
> > +	Device (LED)
> > +	{
> > +		Name ((_DSD), Package () {
> > +			ToUUID("dbb8e3e6-5886-4ba6-8795-1319f52a966b"),
> > +			Package () {
> > +				Package () { "led0", "LED0" },
> > +				Package () { "led1", "LED1" },
> > +			}
> > +		})
> > +		Name ((LED0), Package () {
> > +			ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> > +			Package () {
> > +				Package () { "led", 0 },
> > +				Package () { "flash-max-microamp", 1000000 },
> > +				Package () { "led-max-microamp", 100000 },
> > +				Package () { "label", "led:salama" },
> > +			}
> > +		})
> > +		Name ((LED1), Package () {
> > +			ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> > +			Package () {
> > +				Package () { "led", 1 },
> > +				Package () { "led-max-microamp", 10000 },
> > +				Package () { "label", "led:huomiovalo" },
> > +			}
> > +		})
> > +	}
> > +
> > +	Device (SEN)
> > +	{
> > +		Name ((_DSD), Package () {
> > +			ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> > +			Package () {
> > +				Package () {
> > +					"flash-leds",
> > +					Package () { \\LED, 0, \\LED, 1 },
> > +				}
> > +			}
> > +		})
> > +	}
> 
> You should probably try to compile these examples first ;-)

Do you think I'm missing something else than s/\\\\/^/g ? :-)

Yes, I tested it but then changed the tested ASL afterwards. :-P

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
