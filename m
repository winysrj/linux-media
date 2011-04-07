Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:64931 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350Ab1DGLvY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Apr 2011 07:51:24 -0400
Date: Thu, 7 Apr 2011 13:51:12 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Willy POISSON <willy.poisson@stericsson.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: v4l: Buffer pools
In-Reply-To: <201104010150.44097.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1104071340420.26842@axis700.grange>
References: <757395B8DE5A844B80F3F4BE9867DDB652374B2340@EXDCVYMBSTM006.EQ1STM.local>
 <201104010150.44097.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent

On Fri, 1 Apr 2011, Laurent Pinchart wrote:

[snip]

> - Cache management (ISP and DSS)
> 
> Cache needs to be synchronized between userspace applications, kernel space 
> and hardware. Synchronizing the cache is an expensive operation and should be 
> avoided when possible. Userspace applications don't need to select memory 
> mapping cache attributes, but should be able to either handle cache 
> synchronization explicitly, or override the drivers' default behaviour.

So, what cache attributes are currently used by the driver? Presumably, it 
is some cacheable variant? And which way should the application be able to 
override the driver's behaviour? One of these overrides would probably be 
"skip cache invalidate (input) / flush (output)," right? Anything else?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
