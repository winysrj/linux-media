Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56890 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab1DKLab (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Apr 2011 07:30:31 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: javier Martin <javier.martin@vista-silicon.com>
Subject: Re: mt9t111 sensor on Beagleboard xM
Date: Mon, 11 Apr 2011 13:30:40 +0200
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <BANLkTin35p+xPHWkf3WsGNPzL9aeUwsazQ@mail.gmail.com> <201104081907.02509.laurent.pinchart@ideasonboard.com> <BANLkTikXGVLG6E9TeQc1PQjiybeZxrNYdw@mail.gmail.com>
In-Reply-To: <BANLkTikXGVLG6E9TeQc1PQjiybeZxrNYdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104111330.40504.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Javier,

On Monday 11 April 2011 11:11:06 javier Martin wrote:
> Hi Laurent,
> 
> > Adding pad-level operations will not break any existing driver, as long
> > as you keep the existing operations functional.
> 
> Is it really possible to have a sensor driver supporting soc-camera,
> v4l2-subdev and pad-level operations?

Probably. Guennadi should be able to help you some more with that, he's the 
soc-camera expert.

> I've been reviewing the code of mt9t112 and I'm not very sure soc-camera
> code can be easily isolated.
> 
> What is the future of soc-camera anyway? Since it seems v4l2-subdev and
> media-controller clearly make it deprecated.

My understanding is that soc-camera will stay, but sensor drivers will likely 
not depend on soc-camera anymore. soc-camera will use pad-level operations, as 
well as a bus configuration ioctl that has been proposed on the list (but not 
finalized yet). Guennadi, can you share some information about this ?

> Wouldn't it be more suitable to just develop a separate mt9t112 driver
> which includes v4l2-subdev and pad-level operations without soc-camera?

I don't think duplicate drivers will be accepted for mainline.

-- 
Regards,

Laurent Pinchart
