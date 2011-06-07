Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:59725 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab1FGGqY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2011 02:46:24 -0400
Date: Tue, 7 Jun 2011 08:46:19 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] V4L: tw9910: remove bogus ENUMINPUT implementation
In-Reply-To: <w3ppqmq8n1a.wl%kuninori.morimoto.gx@renesas.com>
Message-ID: <Pine.LNX.4.64.1106070845400.31635@axis700.grange>
References: <Pine.LNX.4.64.1106061915210.11169@axis700.grange>
 <Pine.LNX.4.64.1106061922460.11169@axis700.grange>
 <w3ppqmq8n1a.wl%kuninori.morimoto.gx@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 7 Jun 2011, Kuninori Morimoto wrote:

> 
> Dear Guennadi
> 
> Thank you for your email.
> 
> > Morimoto-san, sorry, that was a wrong address of yours again in the 
> > original mail. With the correct request also comes a request: would it be 
> > difficult for you to give this patch a try? If you don't happen to have a 
> > set up ready at hand, no problem, I'll dig out some video signal source 
> > myself and test.
> 
> I'm sorry too.
> I don't know why, but I had lost V4L2 ML since last month somehow.
> I didn't notice about it.
> 
> I tried this patch on SH7724 Ecovec board.
> I'm using NTSC video player, and it works well.
> 
> But I just played video.
> Is this test OK for you ?

Yes, very good, thanks very much! Can I add your "Tested-by" to the patch?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
