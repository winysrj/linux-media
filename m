Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:38184 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750981AbaFOTT6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jun 2014 15:19:58 -0400
Message-ID: <539DF1D4.8050402@codethink.co.uk>
Date: Sun, 15 Jun 2014 20:19:48 +0100
From: Ben Dooks <ben.dooks@codethink.co.uk>
MIME-Version: 1.0
To: Robert Jarzmik <robert.jarzmik@free.fr>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: linux-media@vger.kernel.org
Subject: Re: soc_camera and device-tree
References: <87ppibtes8.fsf@free.fr>
In-Reply-To: <87ppibtes8.fsf@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 14/06/14 21:30, Robert Jarzmik wrote:
> Hi Guennadi,
> 
> I'm slowly converting all of my drivers to device-tree.
> In the process, I met ... soc_camera.
> 
> I converted mt9m111.c and pxa_camera.c, but now I need the linking
> soc_camera. And I don't have a clear idea on how it should be done.
> 
> I was thinking of having soc_camera_pdrv_probe() changed, to handle
> device-tree. What bothers me a bit is that amongst the needed data for me are
> the bus_id and a soc_camera_subdev_desc. I was thinking that this could be
> expressed in device-tree like :

I will put a new series out today for review.

-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius
