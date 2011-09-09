Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:51086 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759549Ab1IISBQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Sep 2011 14:01:16 -0400
Date: Fri, 9 Sep 2011 20:01:14 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 08/13 v3] ov6650: convert to the control framework.
In-Reply-To: <201109091907.05823.jkrzyszt@tis.icnet.pl>
Message-ID: <Pine.LNX.4.64.1109091947540.915@axis700.grange>
References: <1315471446-17890-1-git-send-email-g.liakhovetski@gmx.de>
 <1315471446-17890-9-git-send-email-g.liakhovetski@gmx.de>
 <201109091907.05823.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Janusz

On Fri, 9 Sep 2011, Janusz Krzysztofik wrote:

> On Thu, 8 Sep 2011 at 10:44:01 Guennadi Liakhovetski wrote:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > [g.liakhovetski@gmx.de: simplified pointer arithmetic]
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> 
> Hi,
> I've successfully tested this one for you, to the extent possible using 
> mplayer, i.e., only saturation, hue and brightness controls, and an 
> overall functionality.

Thanks for testing and reviewing!

> Modifications to other (not runtime tested) controls look good to me, 
> except for one copy-paste mistake, see below. With that erratic REG_BLUE 
> corrected:
> 
> Acked-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> 
> There are also a few minor comments for you to consider.

Well, some of them are not so minor, I would say;-) But I personally would 
be happy to have this just as an incremental patch. Would you like to 
prepare one or should I do it?

I basically agree with all your comments apart from maybe

[snip]

> > @@ -1176,9 +1021,11 @@ static int ov6650_probe(struct i2c_client *client,
> >  	priv->colorspace  = V4L2_COLORSPACE_JPEG;
> >  
> >  	ret = ov6650_video_probe(icd, client);
> > +	if (!ret)
> > +		ret = v4l2_ctrl_handler_setup(&priv->hdl);
> 
> Are you sure the probe function should fail if v4l2_ctrl_handler_setup() 
> fails? Its usage is documented as optional.

Not sure what the standard really meant, but it looks like this is done in 
all patches in this series. So, we'd have to change this everywhere. Most 
other drivers indeed do not care.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
