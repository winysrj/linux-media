Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43314 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248Ab2JJO6d (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 10:58:33 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Florian Neuhaus <florian.neuhaus@reberinformatik.ch>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: AW: omap3-isp-live does not allocate big enough buffers?
Date: Wed, 10 Oct 2012 16:59:17 +0200
Message-ID: <1417441.VpuOie6hkq@avalon>
In-Reply-To: <6EE9CD707FBED24483D4CB0162E85467100659AB@AM2PRD0710MB375.eurprd07.prod.outlook.com>
References: <6EE9CD707FBED24483D4CB0162E8546710061917@AM2PRD0710MB375.eurprd07.prod.outlook.com> <2456438.fJBUg8mpFd@avalon> <6EE9CD707FBED24483D4CB0162E85467100659AB@AM2PRD0710MB375.eurprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Florian,

On Wednesday 10 October 2012 09:19:37 Florian Neuhaus wrote:
> Laurent Pinchart wrote on 2012-10-08:
> >
> > The OMAP3 ISP resizer can't scale down 1944 pixels (the native sensor
> > height) to exactly 480 pixels as that would exceed the resizer limits.
> > You will thus have to crop the sensor image slightly. Cropping is
> > supported by libomap3isp and by the snapshot application but not by the
> > live application. Ideally the live application or the libomap3isp library
> > should realize that the ISP limits are exceeded and configure cropping on
> > the sensor accordingly. As an interim solution you could add manual crop
> > support to the live application using the snapshot application crop
> > support code as an example.
>
> I have seen, that the resizer "only" supports downscaling by 0.25, so with
> all the cropping, 1944 lines will come down to 482 which is too big for my
> framebuffer. If I apply some cropping in the omap3_isp_viewfinder_setup
> function, the output will work as expected. Now I'm going to crop on the
> sensor (or better on the first entity that supports cropping, as in your
> code) if the ratio "sensor input -> viewfinder output" exceeds 0.25. Are
> you interested in a patch for this?

Sure. I wonder if it wouldn't make more sense to crop on the resizer though, 
what do you think ?

-- 
Regards,

Laurent Pinchart

