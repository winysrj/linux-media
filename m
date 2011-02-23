Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:55184 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424Ab1BWPwq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Feb 2011 10:52:46 -0500
Date: Wed, 23 Feb 2011 16:52:40 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: "Aguirre, Sergio" <saaguirre@ti.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Stan <svarbanov@mm-sol.com>, Hans Verkuil <hansverk@cisco.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [RFC/PATCH 0/1] New subdev sensor operation g_interface_parms
In-Reply-To: <201102231630.43759.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1102231635320.11581@axis700.grange>
References: <cover.1298368924.git.svarbanov@mm-sol.com>
 <Pine.LNX.4.64.1102231020330.8880@axis700.grange>
 <A24693684029E5489D1D202277BE894488C57571@dlee02.ent.ti.com>
 <201102231630.43759.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 23 Feb 2011, Laurent Pinchart wrote:

> > > Currently soc-camera auto-configures the following parameters:
> > > 
> > > hsync polarity
> > > vsync polarity
> > > data polarity
> > > master / slave mode
> 
> What do you mean by master/slave mode ?

Many datasheets define a slave mode, in which the sensor is receiving the 
sync signals and the pixel clock from the host and is only driving the 
data lanes.

> > > data bus width
> 
> The data bus width can already be configured through the media bus format. Do 
> we need to set it explicitly ?

Maybe we'd have to think about it more, but I think, we need it: Bus 
width, specified by media bus formats tells you how the data can be 
sampled on the bus. Whereas the above parameter tells you, how the devices 
are physically connected. With one and the same physical connection you 
can get several data formats, e.g., by using shifters, like on omap3.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
