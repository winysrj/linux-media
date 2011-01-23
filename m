Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:62328 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200Ab1AWTpD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Jan 2011 14:45:03 -0500
Date: Sun, 23 Jan 2011 20:44:12 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Kuninori Morimoto <morimoto.kuninori@renesas.com>,
	Alberto Panizzo <maramaopercheseimorto@gmail.com>,
	Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
	Marek Vasut <marek.vasut@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: Re: [RFC PATCH 01/12] soc_camera: add control handler support
In-Reply-To: <Pine.LNX.4.64.1101191838300.1425@axis700.grange>
Message-ID: <Pine.LNX.4.64.1101232041440.9054@axis700.grange>
References: <1294787172-13638-1-git-send-email-hverkuil@xs4all.nl>
 <8aa4d48eaf40a1e967e4a7450d9313de0e2c8452.1294786597.git.hverkuil@xs4all.nl>
 <Pine.LNX.4.64.1101191838300.1425@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 19 Jan 2011, Guennadi Liakhovetski wrote:

> > @@ -963,15 +897,15 @@ static int soc_camera_probe(struct device *dev)
> >  	if (icl->reset)
> >  		icl->reset(icd->pdev);
> >  
> > -	ret = ici->ops->add(icd);
> > -	if (ret < 0)
> > -		goto eadd;
> > -
> >  	/* Must have icd->vdev before registering the device */
> >  	ret = video_dev_create(icd);
> >  	if (ret < 0)
> >  		goto evdc;
> >  
> > +	ret = ici->ops->add(icd);
> > +	if (ret < 0)
> > +		goto eadd;
> > +
> 
> Yes, this is something, I'll have to think about / have a look at / test.

Right, this looks harmless.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
