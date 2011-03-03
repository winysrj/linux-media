Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:34078 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751325Ab1CCOze (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Mar 2011 09:55:34 -0500
Subject: Re: [RFC] snapshot mode, flash capabilities and control
From: Andy Walls <awalls@md.metrocast.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hansverk@cisco.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Kim HeungJun <riverful@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stanimir Varbanov <svarbanov@mm-sol.com>
In-Reply-To: <201103031504.08405.laurent.pinchart@ideasonboard.com>
References: <Pine.LNX.4.64.1102240947230.15756@axis700.grange>
	 <201103031250.10495.laurent.pinchart@ideasonboard.com>
	 <1299160585.2037.59.camel@morgan.silverblock.net>
	 <201103031504.08405.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Mar 2011 09:55:54 -0500
Message-ID: <1299164154.4353.15.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, 2011-03-03 at 15:04 +0100, Laurent Pinchart wrote:


> The LED API is too limited. We need to program flash time, pre-flash time, 
> current limits, report overheat/overcurrent events, ... See 
> http://www.analog.com/static/imported-files/data_sheets/ADP1653.pdf for an 
> example of the features found in LED flash controllers.


OK.  Thanks.

Since, I have unwittingly managed to get myself into the position of
Devil's Advocate for the LED API, I should mention that a driver can add
whatever custom sysfs nodes it needs to the LED's sysfs directory, for
various parameter settings and controls.

Using those driver-custom sysfs nodes can lead to significant variation
in how applications must control LEDs exported via the LED API by
various drivers.  If *all* drivers in the kernel providing an LED API
don't have a common convention for controlling flash LED's, then you
have a problem analogous to the problem with driver-private V4L2
controls.

To clarify my position, I don't like the LED API being used in
conjunction with video capture applications.  The LED API is too
open-ended and more suited for twiddling LEDs with scripts, than for use
with general video capture or camera applications.

Regards,
Andy

