Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.186]:64347 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811Ab1BWQka (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Feb 2011 11:40:30 -0500
Date: Wed, 23 Feb 2011 17:40:16 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Stan <svarbanov@mm-sol.com>, Hans Verkuil <hansverk@cisco.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	saaguirre@ti.com
Subject: Re: [RFC/PATCH 0/1] New subdev sensor operation g_interface_parms
In-Reply-To: <201102231737.06421.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1102231740040.11581@axis700.grange>
References: <cover.1298368924.git.svarbanov@mm-sol.com>
 <201102230910.43069.hverkuil@xs4all.nl> <Pine.LNX.4.64.1102231020330.8880@axis700.grange>
 <201102231737.06421.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 23 Feb 2011, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> On Wednesday 23 February 2011 10:31:21 Guennadi Liakhovetski wrote:
> 
> [snip]
> 
> > Currently soc-camera auto-configures the following parameters:
> > 
> > hsync polarity
> > vsync polarity
> > data polarity
> 
> Data polarity ? Are there sensors that can invert the data polarity ?

Yes.

Regards
Guennadi

> 
> > master / slave mode
> > data bus width
> > pixel clock polarity
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
