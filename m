Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:58871 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab1BPTBB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Feb 2011 14:01:01 -0500
Date: Wed, 16 Feb 2011 20:00:58 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: javier Martin <javier.martin@vista-silicon.com>
cc: linux-media@vger.kernel.org
Subject: Re: Current soc-camera status.
In-Reply-To: <AANLkTi=G2yS=OhS2fjfxcLETtfzh1PqQtMmPkTc2h+6c@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1102161955190.20711@axis700.grange>
References: <AANLkTinqsN0_q=Ln5A-7YW1bnUqX8=b2kU7tt_cNjk+d@mail.gmail.com>
 <AANLkTi=G2yS=OhS2fjfxcLETtfzh1PqQtMmPkTc2h+6c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On Wed, 16 Feb 2011, javier Martin wrote:

> Hi,
> does currently soc-camera support using soc-camera host drivers with
> non soc-camera sensors?
> For instance, I would like to use soc-camera host driver
> "mx2_camera.c" with non soc-camera sensor "tvp5150.c".
> 
> How much effort would it take to accomplish this goal?

The answer is: it does not work yet out of the box, but the conversion 
effort should really be pretty low for standard v4l2-subdev drivers. It 
should be _very_ low if you just want to try it locally, however, it will 
become more essential to bring it into the mainline, because there it will 
have to be done _properly_, by extending existing, and adding missing 
APIs. Basically, we just need a real-life example to actually perform this 
work. Up to now there have been a few such requests, but each time the 
requester disappeared shortly after the first discussion round, so, we 
never had a chance to actually accomplish the task.

> Does it depends on conversion to v4l2-device API?
> (http://www.open-technology.de/index.php?/pages/soc-camera.html)

Thanks for reminding me;) As you can see, that page is dated by 2009, 
since then a couple of things have changed. You'd be better off looking at 
the sources or the soc-camera category in my blog.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
