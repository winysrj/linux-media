Return-path: <mchehab@pedra>
Received: from smtp-68.nebula.fi ([83.145.220.68]:35727 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758207Ab1CCO3T (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2011 09:29:19 -0500
Date: Thu, 3 Mar 2011 16:29:14 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hansverk@cisco.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Kim HeungJun <riverful@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: Re: [RFC] snapshot mode, flash capabilities and control
Message-ID: <20110303142914.GA26392@valkosipuli.localdomain>
References: <Pine.LNX.4.64.1102240947230.15756@axis700.grange>
 <201103021919.30003.hverkuil@xs4all.nl>
 <1299114300.22292.21.camel@localhost>
 <201103031250.10495.laurent.pinchart@ideasonboard.com>
 <1299160585.2037.59.camel@morgan.silverblock.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299160585.2037.59.camel@morgan.silverblock.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Mar 03, 2011 at 08:56:25AM -0500, Andy Walls wrote:
> With embedded platforms, like a mobile phone, are the LEDs really tied
> to the camera device: controlled by the GPIOs from the camera bridge
> chip or sensor chip?  Or are they more general purpose peripherals, not
> necessarily tied to the camera?

Besides to what Laurent noted, there are cameras which have a hardware
strobe signal for the flash. The sensor triggers the flash pulse which is
programmed to the flash chip by the host before that. So there is an actual
hardware dependency between the sensor and the flash.

Also, the flash is physically associated with the sensor. This information
would be (eventually) enumerable using the MC API.

-- 
Sakari Ailus
sakari dot ailus at iki dot fi
