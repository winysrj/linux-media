Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:39298 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732AbZINRVz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2009 13:21:55 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Mon, 14 Sep 2009 22:51:44 +0530
Subject: RE: [ANOUNCE] Staging trees at V4L/DVB trees
Message-ID: <19F8576C6E063C45BE387C64729E73940436BA556F@dbde02.ent.ti.com>
References: <20090913210841.6a4db925@caramujo.chehab.org>
In-Reply-To: <20090913210841.6a4db925@caramujo.chehab.org>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Mauro Carvalho Chehab
> Sent: Monday, September 14, 2009 5:39 AM
> To: linux-media@vger.kernel.org
> Subject: [ANOUNCE] Staging trees at V4L/DVB trees
> 
> Probably some of you already noticed that we're creating some
> staging trees at
> V4L/DVB trees.
> 
> There are currently 2 staging trees:
> 
> 1) /linux/drivers/staging - With drivers that aren't ready yet for
> merge, needing
> help for being finished.
> 
[Hiremath, Vaibhav] Hi Mauro,

As you know I am also working on OMAP3 V4L2 display driver and posted initial patches (Posted by myself and Hardik Shah) to the community which went through couple of review cycles. Since it was having dependency on DSS2 library being developed by and at Nokia (Tomi) we decided to wait for it to be accepted. 

Now DSS2 has already being submitted to the community and will make his way to mainline soon. 

Do you want me to submit the OMAP3 DSS driver for staging tree, this would be really good candidate for this. I will make sure that it stays updated and tested till DSS2 gets accepted.

Please let me know your inputs, if you feel it should be done then I will submit patch tomorrow as soon as I get into office.

Thanks,
Vaibhav

> There are currently two drivers there:
> 	go7007 driver - Used on some designs with a Micronas encoder.
> 	cx25821 driver - Driver for Conexant cx25821 chips.
> 
> The go7007 driver were written a long time ago and requires not only
> CodingStyle fixes but also porting to some new API's and to V4L2
> framework.
> This driver is already at kernel upstream, under /drivers/staging.
> 
> The cx25821 driver is a new driver written this year for some very
> powerful
> PCIe chips, capable of up to 10 simultaneous video input/outputs.
> The driver
> needs several CodingStyle fixes, and has duplicated code for each
> input/output.
> 
> I intend to add tm6000 driver there later this week, if time permits
> to port it
> to the new i2c interface.
> 
> The policy to accept new drivers code at staging tree is less rigid
> than
> at /drivers/media: the kernel driver for an unsupported hardware
> shouldn't
> depend on any userspace library other than libv4l and dvb-apps and
> the code
> should compile fine with the latest kernel, and the developer(s)
> should be
> working on fixing it for upstream inclusion. Drivers with bugs,
> CodingStyle
> errors, deprecated API usage, etc can be accepted. Also, drivers
> there not
> maintained for some time can be removed.
> 
> 2) /staging-specs - This contains the latest V4L and DVB API specs,
> in DocBook
> XML 4.1.2. This is the same DocBook version used in kernel.
> 
> It basically contains an effort to finally merge the API's at kernel
> DocBook
> directory.
> 
> Currently, this is _not_ the official API, and the document still
> needs review
> and cleanups.
> 
> My intention is to add the first tree upstream, under
> drivers/staging for
> kernel 2.6.32. As those drivers are new, if we can get them on a
> good shape
> during 2.6.32 rc cycle, it could be possible to move them to
> drivers/media for
> 2.6.32. All depends on how they'll evolute.
> 
> If time is enough and we have the DocBook tree in good shape on the
> next two
> weeks, I intend to add it also to 2.6.32.
> 
> Feel free to contribute to both trees.
> 
> Have Fun!
> 
> Cheers,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-
> media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

