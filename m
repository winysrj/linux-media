Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.187]:65461 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275Ab1BVQ1w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Feb 2011 11:27:52 -0500
Date: Tue, 22 Feb 2011 17:27:47 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Stan <svarbanov@mm-sol.com>
cc: Hans Verkuil <hansverk@cisco.com>, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com, saaguirre@ti.com
Subject: Re: [RFC/PATCH 0/1] New subdev sensor operation g_interface_parms
In-Reply-To: <4D63D78E.3070000@mm-sol.com>
Message-ID: <Pine.LNX.4.64.1102221719220.1380@axis700.grange>
References: <cover.1298368924.git.svarbanov@mm-sol.com>
 <Pine.LNX.4.64.1102221215350.1380@axis700.grange> <201102221432.50847.hansverk@cisco.com>
 <Pine.LNX.4.64.1102221456590.1380@axis700.grange> <4D63D78E.3070000@mm-sol.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 22 Feb 2011, Stan wrote:

> In principle I agree with this bus negotiation.
> 
>  - So. let's start thinking how this could be fit to the subdev sensor
> operations.

Well, I'm afraid not everyone is convinced yet, so, it is a bit early to 
start designing interfaces;)

>  - howto isolate your current work into some common place and reuse it,
> even on platform part.
>  - and is it possible.
> 
> The discussion becomes very emotional and this is not a good adviser :)

No, no emotions at least on this side:) But it's also not technical, 
unfortunately. I'm prepared to discuss technical benefits or drawbacks of 
each of these approaches, but these arguments - can we trust programmers 
or can we not? or will anyone at some time in the future break it or not? 
Sorry, I am not a psychologist:) Personally, I would _exclusively_ 
consider technical arguments. Of course, things like "clean and simple 
APIs," "proper separation / layering" etc. are also important, but even 
they already can become difficult to discuss and are already on the border 
between technical issues and personal preferences... So, don't know, in 
the end, I think, it will just come down to who is making decisions and 
who is implementing them:) I just expressed my opinion, we don't have to 
agree, eventually, the maintainer will decide whether to apply patches or 
not:)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
