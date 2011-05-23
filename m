Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.9]:49465 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab1EWJ0o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 05:26:44 -0400
Date: Mon, 23 May 2011 11:26:38 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Javier Martin <javier.martin@vista-silicon.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	carlighting@yahoo.co.nz, beagleboard@googlegroups.com,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/2] MT9P031: Add support for Aptina mt9p031 sensor.
In-Reply-To: <201105231103.26775.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1105231123100.30305@axis700.grange>
References: <1305899272-31839-1-git-send-email-javier.martin@vista-silicon.com>
 <Pine.LNX.4.64.1105211334260.25424@axis700.grange>
 <201105231103.26775.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 23 May 2011, Laurent Pinchart wrote:

> > > +{
> > > +	struct mt9p031 *mt9p031 = to_mt9p031(client);
> > > +	int ret;
> > > +
> > > +	/* Disable chip output, synchronous option update */
> > > +	ret = reg_write(client, MT9P031_RST, MT9P031_RST_ENABLE);
> > > +	if (ret < 0)
> > > +		return -EIO;
> > > +	ret = reg_write(client, MT9P031_RST, MT9P031_RST_DISABLE);
> > > +	if (ret < 0)
> > > +		return -EIO;
> > > +	ret = mt9p031_set_output_control(mt9p031, MT9P031_OUTPUT_CONTROL_CEN,
> > > 0); +	if (ret < 0)
> > > +		return -EIO;
> > > +	return 0;
> > 
> > I think, a sequence like
> > 
> > 	ret = fn();
> > 	if (!ret)
> > 		ret = fn();
> > 	if (!ret)
> > 		ret = fn();
> > 	return ret;
> > 
> > is a better way to achieve the same.
> 
> I disagree with you on that :-) I find code sequences that return as soon as 
> an error occurs, using the main code path for the error-free case, easier to 
> read. It can be a matter of personal taste though.

Whichever way, but it should be consistent, IMHO.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
