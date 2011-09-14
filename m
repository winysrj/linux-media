Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:52091 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756035Ab1INHWE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Sep 2011 03:22:04 -0400
Date: Wed, 14 Sep 2011 09:22:01 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Scott Jiang <scott.jiang.linux@gmail.com>
cc: Mike Frysinger <vapier.adi@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	uclinux-dist-devel@blackfin.uclinux.org,
	linux-media@vger.kernel.org
Subject: Re: [uclinux-dist-devel] [PATCH 4/4] v4l2: add blackfin capture
 bridge driver
In-Reply-To: <CAHG8p1DEjntNnTabjhpdYFqEW07UFm=mAHkYP_z7c8rqaLhWVw@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1109140918540.32012@axis700.grange>
References: <1315938892-20243-1-git-send-email-scott.jiang.linux@gmail.com>
 <1315938892-20243-4-git-send-email-scott.jiang.linux@gmail.com>
 <CAMjpGUfKehYY7_Tw+aUZ1hxtxxiO2i9hR1ENqw1MqibppYNKmw@mail.gmail.com>
 <CAHG8p1DEjntNnTabjhpdYFqEW07UFm=mAHkYP_z7c8rqaLhWVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 14 Sep 2011, Scott Jiang wrote:

> > i think at least these three are unused and should get punted
> >
> >> +static int __devinit bcap_probe(struct platform_device *pdev)
> >> +{
> >> +       struct bcap_device *bcap_dev;
> >> +       struct video_device *vfd;
> >> +       struct i2c_adapter *i2c_adap;
> >
> > you need to include linux/i2c.h for this
> >
> no, bfin_capture.h already contains this.

It doesn't matter. You're supposed to _explicitly_ include every header, 
that is required to build your code.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
