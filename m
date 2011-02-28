Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.8]:50857 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915Ab1B1Moc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Feb 2011 07:44:32 -0500
Date: Mon, 28 Feb 2011 13:44:25 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sakari Ailus <sakari.ailus@iki.fi>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hansverk@cisco.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Kim HeungJun <riverful@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: Re: [RFC] snapshot mode, flash capabilities and control
In-Reply-To: <20110228120304.GA25250@valkosipuli.localdomain>
Message-ID: <Pine.LNX.4.64.1102281312380.11156@axis700.grange>
References: <Pine.LNX.4.64.1102240947230.15756@axis700.grange>
 <201102281140.31643.hansverk@cisco.com> <Pine.LNX.4.64.1102281148310.11156@axis700.grange>
 <201102281207.34106.laurent.pinchart@ideasonboard.com>
 <Pine.LNX.4.64.1102281220590.11156@axis700.grange>
 <20110228120304.GA25250@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 28 Feb 2011, Sakari Ailus wrote:

> On Mon, Feb 28, 2011 at 12:37:06PM +0100, Guennadi Liakhovetski wrote:
> > So, you'd also need a separate control for external exposure, there are 
> > also sensors, that can be configured to different shutter / exposure / 
> > readout sequence controlling... No, we don't have to support all that 
> > variety, but we have to be aware of it, while making decisions;)
> 
> Hi Guennadi,
> 
> Do you mean that there are sensors that can synchronise these parameters at
> frame level, or how? There are use cases for that but it doesn't limit to
> still capture.

No, sorry, I don't mean exposure value, by "external exposure" I meant the 
EXPOSURE pin. But in fact, as I see now, it is just another name for the 
TRIGGER pin:( But what we do have on some sensors, e.g., on MT9T031.

On mt9t031 they distinguish between the beginning of the shutter sequence, 
the exposure and the read sequence, and depending on a parameter they 
decide which signals to use to start which action.

> Are there any public datasheets that you know of on these?

I think, I just searched for mt9t031 and found a datasheet somewhere in 
the wild...

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
