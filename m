Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.186]:52433 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab1FGKCU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2011 06:02:20 -0400
Date: Tue, 7 Jun 2011 12:02:18 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	=?ISO-8859-1?Q?Teresa_G=E1mez?= <t.gamez@phytec.de>
Subject: Re: [PATCH 1/2] V4L: mt9m111: propagate higher level abstraction
 down in functions
In-Reply-To: <4DED36A8.5000300@free.fr>
Message-ID: <Pine.LNX.4.64.1106071159030.31635@axis700.grange>
References: <Pine.LNX.4.64.1106061918010.11169@axis700.grange>
 <4DED36A8.5000300@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 6 Jun 2011, Robert Jarzmik wrote:

> On 06/06/2011 07:20 PM, Guennadi Liakhovetski wrote:
> > It is more convenient to propagate the higher level abstraction - the
> > struct mt9m111 object into functions and then retrieve a pointer to
> > the i2c client, if needed, than to do the reverse.
> Agreed.
> 
> One minor point, you ofter replace :
> > -	struct mt9m111 *mt9m111 = to_mt9m111(client);
> > +	struct mt9m111 *mt9m111 = container_of(sd, struct mt9m111, subdev);
> 
> Why haven't you replaced the signature of to_mt9m111() into :
> static struct mt9m111 *to_mt9m111(const struct v4l2_subdev *sd)
> {
> 	return container_of(sd, struct mt9m111, subdev);
> }
> 
> This way, each to_mt9m111(client) will become to_mt9m111(sd), and the purpose
> of to_mt9m111() will be kept. Wouldn't that be better ?

Because "container_of(sd, struct mt9m111, subdev)" is still easy enough to 
write (copy-paste, of course:)) and understand, whereas 
"container_of(i2c_get_clientdata(client), struct mt9m111, subdev)" is 
already too awkward to look at, even though it is now only used at 4 
locations.

A general question to you: from your comments I haven't understood: have 
you also tested the patches or only reviewed them?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
