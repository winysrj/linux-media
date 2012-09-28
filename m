Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:37541 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756714Ab2I1NmY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Sep 2012 09:42:24 -0400
Date: Fri, 28 Sep 2012 15:42:10 +0200
From: Anatolij Gustschin <agust@denx.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] mt9v022: support required register settings in snapshot
 mode
Message-ID: <20120928154210.47670526@wker>
In-Reply-To: <Pine.LNX.4.64.1209281515480.5428@axis700.grange>
References: <1348786362-28586-1-git-send-email-agust@denx.de>
	<Pine.LNX.4.64.1209281428490.5428@axis700.grange>
	<20120928151004.7741efce@wker>
	<Pine.LNX.4.64.1209281515480.5428@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 28 Sep 2012 15:30:33 +0200 (CEST)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
...
> > Yes. But i.e. the driver calling the sub-device stream control function
> > on streamon knows that the normal mode is not supported and therefore it
> > calls this function with argument enable == 0, effectively setting the
> > snapshot mode.
> 
> Right, I thought you could be doing that... Well, on the one hand I should 
> be happy, that the problem is solved without driver modifications, OTOH 
> this isn't pretty... In fact this shouldn't work at all. After a 
> stream-off the buffer queue should be stopped too.

Yes, the capture driver stops its buffer queue on stream-off.

Thanks,
Anatolij
