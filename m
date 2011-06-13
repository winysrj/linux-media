Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:54827 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab1FMSqg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jun 2011 14:46:36 -0400
Date: Mon, 13 Jun 2011 20:46:34 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	=?ISO-8859-1?Q?Teresa_G=E1mez?= <t.gamez@phytec.de>
Subject: Re: [PATCH 1/2] V4L: mt9m111: propagate higher level abstraction
 down in functions
In-Reply-To: <4DF656A7.5020709@free.fr>
Message-ID: <Pine.LNX.4.64.1106132046110.27497@axis700.grange>
References: <Pine.LNX.4.64.1106061918010.11169@axis700.grange>
 <4DED36A8.5000300@free.fr> <Pine.LNX.4.64.1106071159030.31635@axis700.grange>
 <4DF656A7.5020709@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 13 Jun 2011, Robert Jarzmik wrote:

> On 06/07/2011 12:02 PM, Guennadi Liakhovetski wrote:
> > 
> > A general question to you: from your comments I haven't understood: have
> > you also tested the patches or only reviewed them?
> 
> I had reviewed them so far.
> 
> Now, please have my :
> Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>

Great, thanks a lot!

> 
> The ack includes a test done on my platform, with a suspend in the middle of
> an image capture. The system wakes up and sends back the captured image
> without a problem.
> The test is for your 2 patch series : "mt9m111: propagate higher level
> abstraction down in functions" and v2 of "pxa-camera: minor updates".
> 
> Cheers.
> 
> --
> Robert

Regards
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
