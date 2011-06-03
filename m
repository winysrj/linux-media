Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41952 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633Ab1FCAOH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jun 2011 20:14:07 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: javier Martin <javier.martin@vista-silicon.com>
Subject: Re: Does omap3isp driver inherit controls of attached sensors?
Date: Fri, 3 Jun 2011 02:14:08 +0200
Cc: linux-media@vger.kernel.org
References: <BANLkTinpCigLcTD_3ucjzFVM_1PvNwQ3Rg@mail.gmail.com>
In-Reply-To: <BANLkTinpCigLcTD_3ucjzFVM_1PvNwQ3Rg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106030214.09201.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Javier,

On Thursday 02 June 2011 15:52:57 javier Martin wrote:
> Hi,
> I'm trying to add VFLIP control to the mt9p031 driver (don't worry
> Guennadi, I won't send the patch yet). For that purpose I've followed
> the code in mt9v032 sensor.
> When I try to query available controls using yavta I get the following:
> 
> root@beagleboard:~# ./media-ctl -e "OMAP3 ISP CCDC output"
> /dev/video2
> 
> root@beagleboard:~# ./yavta -l /dev/video2
> Device /dev/video2 opened: OMAP3 ISP CCDC output (media).
> No control found.
> 
> As I have read here [1], drivers using subdevices should inherit their
> controls. Is this the case with omap3isp?

No, the OMAP3 ISP video nodes don't inherit subdev controls. You need to 
access the control directly on the sensor subdev.

> [1]
> http://lxr.linux.no/#linux+v2.6.39/Documentation/video4linux/v4l2-controls
> .txt

-- 
Regards,

Laurent Pinchart
