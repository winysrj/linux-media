Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:50223 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758700Ab1IJKbm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Sep 2011 06:31:42 -0400
Date: Sat, 10 Sep 2011 12:30:34 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
cc: Sylwester Nawrocki <snjw23@gmail.com>, linux-media@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 08/13 v3] ov6650: convert to the control framework.
In-Reply-To: <201109092258.06012.jkrzyszt@tis.icnet.pl>
Message-ID: <Pine.LNX.4.64.1109101228460.25219@axis700.grange>
References: <1315471446-17890-1-git-send-email-g.liakhovetski@gmx.de>
 <Pine.LNX.4.64.1109091947540.915@axis700.grange> <4E6A59AA.3060703@gmail.com>
 <201109092258.06012.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 9 Sep 2011, Janusz Krzysztofik wrote:

> On Fri, 9 Sep 2011 at 20:23:38 Sylwester Nawrocki wrote:
> > Hi,
> > 
> > On 09/09/2011 08:01 PM, Guennadi Liakhovetski wrote:
> 
> [snip]
> 
> > > I basically agree with all your comments apart from maybe
> > > 
> > > [snip]
> > > 
> > >>> @@ -1176,9 +1021,11 @@ static int ov6650_probe(struct i2c_client *client,
> > >>>   	priv->colorspace  = V4L2_COLORSPACE_JPEG;
> > >>>
> > >>>   	ret = ov6650_video_probe(icd, client);
> > >>> +	if (!ret)
> > >>> +		ret = v4l2_ctrl_handler_setup(&priv->hdl);
> > >>
> > >> Are you sure the probe function should fail if v4l2_ctrl_handler_setup()
> > >> fails? Its usage is documented as optional.
> > > 
> > > Not sure what the standard really meant, but it looks like this is done in
> > > all patches in this series. So, we'd have to change this everywhere. Most
> > > other drivers indeed do not care.
> > 
> > The usage of v4l2_ctrl_handler_setup() is optional, but if this function
> > is not used, then AFAIU the driver writer needs to ensure the control's 
> > values after the device is initialized are exactly as those specified during
> > the control creation. Of course v4l2_ctrl_handler_setup() failure might
> > mean s_ctrl op failed, which might be caused by some H/W access errors.
> > So IMHO it is always a good idea to check the return value if we know
> > the batch controls setup shouldn't fail.
> 
> I'm not for ignoring that return value, only wondering if the i2c_driver 
> .probe handler should really fail in such cases, effectivelly preventing 
> the device from being accessible at all.
> 
> Perhaps a warning message would be sufficient?

Well, restoring the state is normally something pretty basic like writing 
a couple of registers via i2c. If that didn't work out, there's little 
chance you'll be able to use the device anyway. So, I'd feel pretty safe 
with erroring out. If we ever encounter a case, where this can fail in a 
non-fatal way, we can always relax it.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
