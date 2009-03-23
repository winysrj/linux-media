Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:48785 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754140AbZCWQaC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Mar 2009 12:30:02 -0400
Date: Mon, 23 Mar 2009 17:30:14 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sedji Gaouaou <sedji.gaouaou@atmel.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: atmel v4l2 soc driver
In-Reply-To: <49C7B57C.7040809@atmel.com>
Message-ID: <Pine.LNX.4.64.0903231725490.6370@axis700.grange>
References: <49B789F8.3070906@atmel.com> <Pine.LNX.4.64.0903111100050.4818@axis700.grange>
 <49C7A8DF.3040101@atmel.com> <Pine.LNX.4.64.0903231632020.6370@axis700.grange>
 <49C7B226.6000302@atmel.com> <Pine.LNX.4.64.0903231705080.6370@axis700.grange>
 <49C7B57C.7040809@atmel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 23 Mar 2009, Sedji Gaouaou wrote:

> Well I am confused now...Should I still convert the atmel ISI driver to a soc
> driver?

Yes, don't worry, all drivers in the mainline will be converted 
"automatically," whereas, if you don't convert it now - before the switch 
to v4l2-device, you'll have to convert your driver yourself:-)

> My concern was not to release a driver for the ov9655, but to have one which
> is working so I could test my atmel-soc driver :)
> Because I only have an ov9655 sensor here...

Ok, yes, sure, if you're not afraid of losing your time, just wanted to 
warn you, that yet another driver for ov9655 will probably be not accepted 
into the mainline, still it might be used during the v4l2-device 
conversion. But of course you can convert it to soc-camera for your tests. 

As I said, look at the pxa example for how to bind a sensor and a host 
camera driver.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
