Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60121 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752478AbbC3JfM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2015 05:35:12 -0400
Date: Mon, 30 Mar 2015 12:35:05 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, kyungmin.park@samsung.com,
	pavel@ucw.cz, cooloney@gmail.com, rpurdie@rpsys.net,
	s.nawrocki@samsung.com, Andrzej Hajda <a.hajda@samsung.com>,
	Lee Jones <lee.jones@linaro.org>,
	Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH v2 04/11] DT: Add documentation for the mfd Maxim max77693
Message-ID: <20150330093504.GC18321@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5518FD05.5060800@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

On Mon, Mar 30, 2015 at 09:36:37AM +0200, Jacek Anaszewski wrote:
> Hi Sakari,
> 
> On 03/28/2015 11:55 PM, Sakari Ailus wrote:
> >On Fri, Mar 27, 2015 at 02:49:38PM +0100, Jacek Anaszewski wrote:
> >>This patch adds device tree binding documentation for
> >>the flash cell of the Maxim max77693 multifunctional device.
> >>
> >>Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> >>Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> >>Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> >>Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> >>Cc: Lee Jones <lee.jones@linaro.org>
> >>Cc: Chanwoo Choi <cw00.choi@samsung.com>
> >>Cc: Bryan Wu <cooloney@gmail.com>
> >>Cc: Richard Purdie <rpurdie@rpsys.net>
> >>---
> >>  Documentation/devicetree/bindings/mfd/max77693.txt |   61 ++++++++++++++++++++
> >>  1 file changed, 61 insertions(+)
> >>
> >>diff --git a/Documentation/devicetree/bindings/mfd/max77693.txt b/Documentation/devicetree/bindings/mfd/max77693.txt
> >>index 38e6440..15c546ea 100644
> >>--- a/Documentation/devicetree/bindings/mfd/max77693.txt
> >>+++ b/Documentation/devicetree/bindings/mfd/max77693.txt
> >>@@ -76,7 +76,53 @@ Optional properties:
> >>      Valid values: 4300000, 4700000, 4800000, 4900000
> >>      Default: 4300000
> >>
> >>+- led : the LED submodule device node
> >>+
> >>+There are two LED outputs available - FLED1 and FLED2. Each of them can
> >>+control a separate LED or they can be connected together to double
> >>+the maximum current for a single connected LED. One LED is represented
> >>+by one child node.
> >>+
> >>+Required properties:
> >>+- compatible : Must be "maxim,max77693-led".
> >>+
> >>+Optional properties:
> >>+- maxim,trigger-type : Flash trigger type.
> >>+	Possible trigger types:
> >>+		LEDS_TRIG_TYPE_EDGE (0) - Rising edge of the signal triggers
> >>+			the flash,
> >>+		LEDS_TRIG_TYPE_LEVEL (1) - Strobe pulse length controls duration
> >>+			of the flash.
> >>+- maxim,boost-mode :
> >>+	In boost mode the device can produce up to 1.2A of total current
> >>+	on both outputs. The maximum current on each output is reduced
> >>+	to 625mA then. If not enabled explicitly, boost setting defaults to
> >>+	LEDS_BOOST_FIXED in case both current sources are used.
> >>+	Possible values:
> >>+		LEDS_BOOST_OFF (0) - no boost,
> >>+		LEDS_BOOST_ADAPTIVE (1) - adaptive mode,
> >>+		LEDS_BOOST_FIXED (2) - fixed mode.
> >>+- maxim,boost-mvout : Output voltage of the boost module in millivolts.
> >
> >What are the possible values for this?
> 
> maxim,boost-mvout : Output voltage of the boost module in millivolts
> 	Range: 3300 - 5500

Could you please add that?

> 
> Do you think it is necessary to mention also allowed step for all the
> values?

That's a good question. They probably are more or less visible in the driver
code. I think I'd document them here, but I'm fine with not adding them as
well. You probably wouldn't be able to meaningfully use the chip without the
datasheet anyway.

> >Is the datasheet publicly available btw.?
> 
> I have an access only to the non-public one.

I googled a bit, couldn't find anything relevant immediately at least.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
