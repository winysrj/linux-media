Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44181 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab1CBLFe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Mar 2011 06:05:34 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: isp or soc-camera for image co-processors
Date: Wed, 2 Mar 2011 12:05:46 +0100
Cc: Bhupesh SHARMA <bhupesh.sharma@st.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <D5ECB3C7A6F99444980976A8C6D896384DEFA5983D@EAPEX1MAIL1.st.com> <D5ECB3C7A6F99444980976A8C6D896384DEFA5998E@EAPEX1MAIL1.st.com> <4D6E2233.6090602@maxwell.research.nokia.com>
In-Reply-To: <4D6E2233.6090602@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103021205.46432.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sakari,

On Wednesday 02 March 2011 11:55:47 Sakari Ailus wrote:
> Bhupesh SHARMA wrote:

[snip]

> >>> Are there are reference drivers that I can use for my study?
> >> 
> >> The OMAP3 ISP driver.
> > 
> > Thanks, I will go through the same.
> 
> The major difference in this to OMAP 3 is that the OMAP 3 does have
> access to host side memory but the co-processor doesn't --- as it's a
> CSI-2 link.
> 
> Additional CSI-2 receiver (and a driver for it) is required on the host
> side. This receiver likely is not dependent on the co-processor so the
> driver shouldn't be either.
> 
> For example, using this co-processor should well be possible with the
> OMAP 3 ISP, in theory at least. What would be needed in this case is...
> support for multiple complex Media device drivers under a single Media
> device --- both drivers would be accessible through the same media device.
> 
> The co-processor would mostly look like a sensor for the OMAP 3 ISP
> driver. Its internal topology would be more complex, though.
> 
> Just a few ideas; what do you think of this? :-)

Hierachical subdevs is something that will be discussed during the next V4L2 
brainstorming meeting. We will need hierachical entities support in the Media 
Controller as well. This should help in this case, the co-processor entity 
will be made of several sub-entities.

-- 
Regards,

Laurent Pinchart
