Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:36146 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753264Ab1HIPwr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Aug 2011 11:52:47 -0400
Message-ID: <4E4157C5.10303@maxwell.research.nokia.com>
Date: Tue, 09 Aug 2011 18:52:37 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Subash Patel <subashrp@gmail.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Tuukka Toivonen <tuukka.toivonen@intel.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [ANN] Meeting minutes of the Cambourne meeting
References: <201107261647.19235.laurent.pinchart@ideasonboard.com> <201108081750.07000.laurent.pinchart@ideasonboard.com> <4E410342.3010502@gmail.com>
In-Reply-To: <4E410342.3010502@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Subash Patel wrote:
> Hi Sakari,

Hi Subash,

> I have a point with the pixel clock. During discussion we found that
> pixel clock get/set is required for user space to do fine control over
> the frame-rate etc. What if the user sets the pixel array clock which is
> above the system/if bus clock? Suppose we are setting the pixel clock

The pixel array clock should be calculated by the driver based on CSI-2
bus frequency (user specified), lanes (from board data), binning,
skipping and crop. This is since there are typically limitations for its
value, and the sensor driver can come up with a "best value" for it,
based on the information above. Exactly how, that depends on the sensor
driver and the sensor.

So the pixel array clock is read-only for the user, and the frame rate
can then be chosen using the blanking configuration.

> (which user space sets) to higher rate at sensor array, but for some
> reason the bus cannot handle that rate (either low speed or loaded) or
> lower PCLK at say CSI2 interface is being set. Are we not going to loose
> data due to this? Also, there would be data validation overhead in
> driver on what is acceptable PCLK values for a particular sensor on an
> interface etc.

This is something that must be handled independently of the way the
sensor pixel clock is configured. Typically the limitation is on either
the bus frequency or the pixel rate on the bus.

This actually can be better avoided when the user has a chance to choose
the bus frequency explicitly rather than receive just something the
driver happens to produce based on frame rate and resolution settings.

> I am still not favoring user space controlling this, and wish driver
> decides this for a given frame-rate requested by the user space :)
> 
> Frame-rate   resolution  HSYNC  VSYNC  PCLK(array)  PCLK (i/f bus) ...

You can still do that, but it comes with limitations. Any fixed set of
the above parameters is very hardware and use case dependent.

> Let user space control only first two, and driver decide rest (PCLK can
> be different at different ISP h/w units though)

I'm definitely not against this. We do have drivers which use this kind
of interface already and some vendors do not even provide enough
information to write a driver for their sensor offering any other kind
of interface.

Cheers,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
