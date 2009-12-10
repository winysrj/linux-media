Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:52115 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769AbZLJTjT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2009 14:39:19 -0500
Received: by fxm21 with SMTP id 21so248796fxm.1
        for <linux-media@vger.kernel.org>; Thu, 10 Dec 2009 11:39:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40155C809AB@dlee06.ent.ti.com>
References: <A69FA2915331DC488A831521EAE36FE40155C809AB@dlee06.ent.ti.com>
Date: Thu, 10 Dec 2009 20:39:24 +0100
Message-ID: <846899810912101139g6e8a36f7j78fa650e6629ad1b@mail.gmail.com>
Subject: Re: Latest stack that can be merged on top of linux-next tree
From: HoP <jpetrous@gmail.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

2009/12/10 Karicheri, Muralidharan <m-karicheri2@ti.com>:
> Guennadi,
>
> I am not sure if your MT9T031 changes are part of linux-next tree at v4l-dvb. If not, can you point me to the latest stack that I can apply on top of linux-next tree to get your latest changes for MT9T031 sensor driver?
>
> I plan to do integrate sensor driver with vpfe capture driver this week.
>
> BTW, Is there a driver for the PCA9543 i2c switch that is part of MT9T031 headboard?
>

I would like to know answer also :)

I had to add support for pca9542 (what is 2 port switch) for our project.
After some googling I found some patches for similar kernel I was
working on (2.6.22). You can find original patches for example there:
http://www.mail-archive.com/i2c@lm-sensors.org/msg00315.html

FYI, the driver pca954x.c seems to be driver for full family of i2c
muxes/switches. Such code works fine for me.

The only thing I didn't find was why the code was never merged.

I hope it can helps you.

/Honza
