Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f51.google.com ([209.85.210.51]:57730 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755892Ab2DXAmE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Apr 2012 20:42:04 -0400
Received: by dadz8 with SMTP id z8so156670dad.10
        for <linux-media@vger.kernel.org>; Mon, 23 Apr 2012 17:42:03 -0700 (PDT)
Date: Mon, 23 Apr 2012 17:42:02 -0700 (PDT)
Message-ID: <87d36yezag.wl%kuninori.morimoto.gx@renesas.com>
From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux-V4L2 <linux-media@vger.kernel.org>,
	Magnus <magnus.damm@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>
Subject: Re: Current status of SuperH soc-camera/CEU driver
In-Reply-To: <Pine.LNX.4.64.1204231325300.19312@axis700.grange>
References: <87ehrf9fjo.wl%kuninori.morimoto.gx@renesas.com>
	<Pine.LNX.4.64.1204231325300.19312@axis700.grange>
MIME-Version: 1.0 (generated by SEMI 1.14.6 - "Maruoka")
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Guennadi

Thanks for reply.

> AFAICS, all these platforms only use 8 bits, so, none of them is broken. 
> OTOH, I'm not sure any more, what was the motivation behind that removal. 
> Maybe exactly because we didn't have any platforms with 16-bit camera 
> connections and maybe I saw a problem with it, so, I decided to remove 
> them until we get a chance to properly implement and test 16-bits? Do you 
> have such a board?

about 16bit camera, one guy has it, but he is using v3.0 kernel,
so, it is not in trouble at this point.
(it is working)

The motivation was just "misunderstand-able", not super important at this point.
So please keep considering about it.

> > 2) ff51345832628eb641805a01213aeae0bb4a23c1
> > ([media] V4L: mt9t112: remove superfluous soc-camera client operations)
> > 
> > 	this patch remoded MT9T112_FLAG_DATAWIDTH_xx flags from mt9t112 driver,
> > 	but Ecovec platform still has it.
> > 
> > 	arch/sh/boards/mach-ecovec24/
> 
> Perhaps, the reason was more or less the same - no users, untested code.

About this, now, I'm trying to use this camera on new board (but 8bit),
and the platform code was copied from ecovec.
But the camera image was not correct.

So, I checked the platform/ceu/mt9t112, 
and noticed that the driver is using new mbus style,
but platform is still using old style.
And I got confusion.

Now, this code is no users, untested.
So, the reason why image was broken is 50% new board specific issue,
but 50% original code issue.

Best regards
---
Kuninori Morimoto
