Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:60819 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756306Ab2ADQfa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jan 2012 11:35:30 -0500
Date: Wed, 4 Jan 2012 17:35:27 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: javier Martin <javier.martin@vista-silicon.com>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	saaguirre@ti.com
Subject: Re: [PATCH] V4L: soc-camera: provide support for S_INPUT.
In-Reply-To: <CACKLOr0FxA72dhkjnVHCiWuT-VGYpcdk6WX9ubWoAnLkm7gnBQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1201041717130.30506@axis700.grange>
References: <1324022443-5967-1-git-send-email-javier.martin@vista-silicon.com>
 <201112191105.25855.laurent.pinchart@ideasonboard.com>
 <Pine.LNX.4.64.1112191113230.23694@axis700.grange>
 <201112191120.40084.laurent.pinchart@ideasonboard.com>
 <Pine.LNX.4.64.1112191139560.23694@axis700.grange>
 <CACKLOr0Z4BnB3bHCs8BjhwpwcHBHsZA1rDNrxzDW+z3+-qSRgQ@mail.gmail.com>
 <Pine.LNX.4.64.1112191155340.23694@axis700.grange>
 <CACKLOr1=vFs8xDaDMSX146Y1h18q=+fPEBGHekgNq2xRVCOGsA@mail.gmail.com>
 <4EEF66C2.7030003@infradead.org> <CACKLOr2hQnEteOey3kt2zv8Wrr12+b9DU-Zk66+c-k-F=9pqNw@mail.gmail.com>
 <Pine.LNX.4.64.1201031557130.7204@axis700.grange>
 <CACKLOr0FxA72dhkjnVHCiWuT-VGYpcdk6WX9ubWoAnLkm7gnBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 4 Jan 2012, javier Martin wrote:

[snip]

> For ov7725 it is a natural thing to do since it was originally
> developed for soc-camera and it can easily do the following to access
> platform data:
> 
> struct soc_camera_link	*icl = soc_camera_i2c_to_link(client);
> pdata = icl->priv;
> 
> However, tvp5150 is not aware about soc_camera. I should be able to
> tell whether it's being used with soc-camera or not. If soc camera was
> used I would do the previous method to retrieve platform data.
> But if soc-camera was not used I would do the classic method:
> 
> struct tvp5150_platform_data *pdata = client->dev.platform_data;
> 
> The problem is how to distinguish in tvp5150 whether I am using
> soc_camera or not.

Right, that _is_ the problem now. And we've known about it since the very 
first time we started to think about re-using the subdev drivers. The only 
solution I see so far is to introduce a standard platform data struct for 
all subdevices, similar to soc_camera_link. We could use it as a basis, of 
course, use a generic name, maybe reconsider fields - rename / remove / 
add, but the principle would be the same: a standard platform data struct 
with an optional private field.

Alternatively - would it be possible to find all tvp5150 users and port 
them to use struct soc_camera_link too?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
