Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:60048 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab1KTV1m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Nov 2011 16:27:42 -0500
Date: Sun, 20 Nov 2011 23:27:38 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [KS workshop follow-up] multiple sensor contexts
Message-ID: <20111120212738.GD27136@valkosipuli.localdomain>
References: <Pine.LNX.4.64.1111071645180.26363@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1111071645180.26363@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Mon, Nov 07, 2011 at 05:17:23PM +0100, Guennadi Liakhovetski wrote:
> Hi all
> 
> At the V4L/DVB workshop in Prague a couple of weeks ago possible merits of 
> supporting multiple camera sensor contexts have been discussed. Such 
> contexts are often promoted by camera manufacturers as a hardware 
> optimization to support fast switching to the snapshot mode. Such a switch 
> is often accompanied by a change of the frame format. Typically, a smaller 
> frame is used for the preview mode and a larger frame is used for photo 
> shooting. Those sensors provide 2 (or more) sets of frame size and data 
> format registers and a single command to switch between them. The 
> decision, whether or not to support these multiple camera contexts has 
> been postponed until some measurements become available, how much time 
> such a "fast switching" implementation would save us.
> 
> I took the mt9m111 driver, that supports mt9m111, mt9m131, and mt9m112 
> camera sensors from Aptina. They do indeed implement two contexts, 
> however, the driver first had to be somewhat reorganised to make use of 
> them. I pushed my (highly!) experimental tree to
> 
> git://linuxtv.org/gliakhovetski/v4l-dvb.git staging-3.3
> 
> with the addition of the below debugging diff, that pre-programs a fixed 
> format into the second context registers and switches to it, once a 
> matching S_FMT is called. On the i.MX31 based pcm037 board, that I've got, 
> this sensor is attached to the I2C bus #2, running at 20kHz. The explicit 
> programming of the new format parameters measures to take around 27ms, 
> which is also about what we win, when using the second context.

27 ms isn't a lot. May I ask what's the reason for such an unusual I2C
speed? Even the relatively low speed 400 kHz spec has been available for
almost 20 years by now.

> As for interpretation: firstly 20kHz is not much, I expect many other set 
> ups to run much faster. But even if we accept, that on some hardware > 
> 20kHz doesn't work and we really lose 27ms when not using multiple 
> register contexts, is it a lot? Thinking about my personal photographing 
> experiences with cameras and camera-phones, I don't think, I'd notice a 
> 27ms latency;-) I don't think anything below 200ms really makes a 
> difference and, I think, the major contributor to the snapshot latency is 
> the need to synchronise on a frame, and, possibly skip or shoot several 
> frames, instead of just one.
> 
> So, my conclusion would be: when working with "sane" camera sensors, i.e., 
> those, where you don't have to reprogram 100s of registers from some magic 
> tables to configure a different frame format (;-)), supporting several 
> register contexts doesn't bring a huge advantage in terms of snapshot 
> latency. OTOH, it can well happen, that at some point we anyway will have 
> to support those multiple register contexts for some other reason.

Sensor have seldom anything  which would require passing a huge amount of
data to configure the sensor. I personally don't see need for supporting
different contects in the foreseeable future --- but of course I could be
wrong. Also knowing much of a future desired configuration is a difficult
guess. The hardware people will hopefully rather provide a faster bus to
transfer the settings to the sensor to make the configuration delays
smaller.

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
