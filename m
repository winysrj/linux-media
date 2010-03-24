Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:57551 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab0CXJF6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Mar 2010 05:05:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: Re: [Resubmit: PATCH-V2] Introducing ti-media directory
Date: Wed, 24 Mar 2010 10:05:50 +0100
Cc: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <hvaibhav@ti.com> <19F8576C6E063C45BE387C64729E7394044DE0EBC5@dbde02.ent.ti.com> <A69FA2915331DC488A831521EAE36FE4016A785F05@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE4016A785F05@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003241005.51075.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Murali,

On Tuesday 23 March 2010 18:52:44 Karicheri, Muralidharan wrote:
> Laurent,
> 
> > > I'm not too sure to like the ti-media name. It will soon get quite
> > > crowded, and name collisions might occur (look at the linux-omap-camera
> > > tree and the ISP driver in there for instance). Isn't there an internal
> > > name to refer to both the DM6446 and AM3517 that could be used ?
> >
> > [Hiremath, Vaibhav] Laurent,
> >
> > ti-media directory is top level directory where we are putting all TI
> > devices drivers. So having said that, we should worrying about what goes
> > inside this directory.
> > For me ISP is more generic, if you compare davinci and OMAP.
> >
> > Frankly, there are various naming convention we do have from device to
> > device, even if the IP's are being reused. For example, the internal name
> > for OMAP is ISP but Davinci refers it as a VPSS.
> 
> Could you explain what name space issue you are referring to in
> linux-omap-camera since I am not quite familiar with that tree?

The linux-omap-camera tree contains a driver for the OMAP3 ISP. Basically, 
most source files start with the "isp" prefix and are stored in 
drivers/media/video/isp/.

ISP is quite a generic name, and other vendors will probably develop an ISP at 
some point (if not already done), so there's already a potential name conflict 
today.

Using a dedicated directory in drivers/media/video for TI-specific cores is 
definitely a good idea (assuming the same IP cores won't be used by other 
vendors in the future).

My concern is that, if we move the ISP driver in drivers/media/video/ti-media, 
the directory will soon get quite crowded. If a new TI processor comes up with 
a totally incompatible ISP, we will get a name conflict in 
drivers/media/video/ti-media. I was thinking about either replacing the "isp" 
prefix with "omap3isp" (or similar), or moving the driver to 
drivers/media/video/ti-media/omap3isp, but that will impede code sharing code 
between the Davinci and OMAP processor families. That's where my uncertainty 
comes from.

> Myself and Vaibhav had discussed this in the past and ti-media is the
> generic name that we could agree on. On DM SoCs (DM6446, DM355, DM365) I
> expect ti-media to be the home for all vpfe and vpbe driver files. Since
> we had a case of common IP across OMAP and DMxxx SoCs, we want to place
> all OMAP and DMxxx video driver files in a common directory so that
> sharing the drivers across the SoCs will be easy. We could discuss and
> agree on another name if need be. Any suggestions?

It's not the name ti-media that I don't agree on, it's just that this will 
move the problem one step further in the directory hierarchy without actually 
solving it :-)

Is it guaranteed today that no TI processors with new generation video blocks 
will reuse the names ISP, VPFE and VPBE ? The OMAP3 datasheet refers to VPFE 
and VPBE, but luckily those blocks are further divided into subblocks, and the 
driver doesn't refer to the VPFE and VPBE directly.

-- 
Regards,

Laurent Pinchart
