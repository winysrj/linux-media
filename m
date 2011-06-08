Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36669 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab1FHQYt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jun 2011 12:24:49 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Koen Kooi <koen@beagleboard.org>
Subject: Re: [beagleboard] Re: [PATCH v7 1/2] Add driver for Aptina (Micron) mt9p031 sensor.
Date: Wed, 8 Jun 2011 18:24:44 +0200
Cc: javier Martin <javier.martin@vista-silicon.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	beagleboard@googlegroups.com, linux-media@vger.kernel.org,
	carlighting@yahoo.co.nz, mch_kot@yahoo.com.cn
References: <1307014603-22944-1-git-send-email-javier.martin@vista-silicon.com> <BANLkTinw6GoHgQYqJexbD-4=qitP6j0hDg@mail.gmail.com> <51BA5835-2D1F-4BD3-B5BF-B01B339C347E@beagleboard.org>
In-Reply-To: <51BA5835-2D1F-4BD3-B5BF-B01B339C347E@beagleboard.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106081824.46027.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Koen,

On Wednesday 08 June 2011 14:47:13 Koen Kooi wrote:
> Op 8 jun 2011, om 14:42 heeft javier Martin het volgende geschreven:
> > On 8 June 2011 14:39, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> >> On Wed, 8 Jun 2011, Koen Kooi wrote:
> >>> Op 8 jun 2011, om 13:57 heeft Laurent Pinchart het volgende geschreven:
> >>>> Hi Javier,
> >>>> 
> >>>> I'm testing your patch on a 2.6.39 kernel. Here's what I get when
> >>>> loading the omap3-isp module.
> >>>> 
> >>>> root@arago:~# modprobe omap3-isp
> >>>> [  159.523681] omap3isp omap3isp: Revision 15.0 found
> >>>> [  159.528991] omap-iommu omap-iommu.0: isp: version 1.1
> >>>> [  159.875701] omap_i2c omap_i2c.2: Arbitration lost
> >>>> [  159.881622] mt9p031 2-0048: Failed to reset the camera
> >>>> [  159.887054] omap3isp omap3isp: Failed to power on: -5
> >>>> [  159.892425] mt9p031 2-0048: Failed to power on device: -5
> >>>> [  159.898956] isp_register_subdev_group: Unable to register subdev
> >>>> mt9p031
> >>>> 
> >>>> Have you (or anyone else) seen that issue ?
> >>> 
> >>> I build in both statically to avoid that problem.
> >> 
> >> I used modules and it worked for me.
> > 
> > Maybe u-boot version Laurent uses does not enable internal pull-up
> > resistors for i2c2 interface.
> > You could either use a different u-boot version or attach external
> > pull-up resistors to that interface.
> 
> http://dominion.thruhere.net/koen/angstrom/beagleboard/2.6.39/MLO
> http://dominion.thruhere.net/koen/angstrom/beagleboard/2.6.39/u-boot.bin
> 
> The above MLO and uboot enable the pullups and work will all released
> versions of the beagleboard.

That works much better, thank you.

-- 
Regards,

Laurent Pinchart
