Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43060 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751817AbbCaJOw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Mar 2015 05:14:52 -0400
Date: Tue, 31 Mar 2015 12:14:14 +0300
From: "sakari.ailus@iki.fi" <sakari.ailus@iki.fi>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Jacek Anaszewski <j.anaszewski@samsung.com>,
	"linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	"pavel@ucw.cz" <pavel@ucw.cz>,
	"cooloney@gmail.com" <cooloney@gmail.com>,
	"rpurdie@rpsys.net" <rpurdie@rpsys.net>,
	"s.nawrocki@samsung.com" <s.nawrocki@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Lee Jones <lee.jones@linaro.org>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3] DT: Add documentation for the mfd Maxim max77693
Message-ID: <20150331091414.GH18321@valkosipuli.retiisi.org.uk>
References: <1427709149-15014-1-git-send-email-j.anaszewski@samsung.com>
 <1427709149-15014-2-git-send-email-j.anaszewski@samsung.com>
 <20150330115729.GG17971@leverpostej>
 <55194509.1070008@samsung.com>
 <20150330132002.GA29200@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150330132002.GA29200@leverpostej>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mark and Jacek,

On Mon, Mar 30, 2015 at 02:20:03PM +0100, Mark Rutland wrote:
> Hi,
> 
> > >> +Optional properties:
> > >> +- maxim,trigger-type : Flash trigger type.
> > >> +	Possible trigger types:
> > >> +		LEDS_TRIG_TYPE_EDGE (0) - Rising edge of the signal triggers
> > >> +			the flash,
> > >> +		LEDS_TRIG_TYPE_LEVEL (1) - Strobe pulse length controls duration
> > >> +			of the flash.
> > >
> > > Surely this is required? What should be assumed if this property isn't
> > > present?
> > 
> > LEDS_TRIG_TYPE_LEVEL allows for an ISP to do e.g. short flash blink
> > before the actual strobe - it is used for eliminating photographs with
> > closed eyes, or can serve for probing ambient light conditions.
> > 
> > With LEDS_TRIG_TYPE_EDGE flash strobe is triggered on rising edge
> > and lasts until programmed timeout expires.
> > 
> > This setting is tightly related to a camera sensor, which generates
> > the strobe signal. Effectively it depends on board configuration.
> 
> My comment wasn't to do with the semantics of eitehr option but rather
> the optionality of the property.
> 
> Surely it's vital to know what this should be, and hence this property
> should be required rather than optional?
> 
> If it isn't required, what would the assumed default be?

I wonder if there's a use case for edge triggering. In level trigger mode,
whichever component generates the trigger signal, determines also the strobe
time (up to the timeout). The sensor or (in the case of lack of the signal
from the sensor) the ISP has the most information on the sensor timing.

The existing as3654a driver only supports level triggering while the chip
can do edge, too.

I'd make level default and perhaps add a V4L2 control / sysfs file to change
this if needed.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
