Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:51186 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752189Ab0EZOj4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 May 2010 10:39:56 -0400
Date: Wed, 26 May 2010 16:40:11 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: About master clock frequency in soc-camera
In-Reply-To: <20100526141208.GT17272@pengutronix.de>
Message-ID: <Pine.LNX.4.64.1005261630180.22516@axis700.grange>
References: <20100526141208.GT17272@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 26 May 2010, Sascha Hauer wrote:

> Hi Guennadi et all,
> 
> On our i.MX27 board we have a wide range of cameras (mt9m001, mt9v022,
> mt9m131). Registering all of them and let the probe routines decide
> which one is connected works quite good.
> The problem I have now is that the mt9m131 allows for a higher master
> clock frequency. ATM the mclk is given with the mx2_camera platform data
> (same on i.MX31), thus only one mclk frequency is supported per kernel
> image. Do you have any hints on how to make the mclk a parameter of the
> sensors?

So then, it looks like one more parameter we have to negotiate (oops, 
sorry, hard-code;)) between the sensor and the platform. If we didn't have 
the soc-camera bus-parameter negotiation removal in favour of a new 
hard-coded configuration planned for some now-very-near future, I would 
say - add this there, and select the minimum of the two frequencies in the 
host driver. But now... also here we are blocked by this pending 
transition. So, this means, we have to wait until a conversion strategy is 
ready, until the bulk has been converted, and then we can add new features 
to the new bus-parameter set up procedure.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
