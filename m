Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59151 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbbFKOkv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2015 10:40:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Allwright <michael.allwright@upb.de>
Cc: Tony Lindgren <tony@atomide.com>, linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Arnd Bergmann <arnd@arndb.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Tero Kristo <t-kristo@ti.com>
Subject: Re: [RFC] v4l: omap4iss: DT bindings development
Date: Thu, 11 Jun 2015 06:55:30 +0300
Message-ID: <2787470.IbMFQAbZxh@avalon>
In-Reply-To: <CALcgO_5kEsvZiWXQPyt1YGOBz34-rPpd_mogbXrNBUKRdrUNKA@mail.gmail.com>
References: <CALcgO_6mcTpEORqWMVzPONYHZH-h8bBMDMddkKxSyrc7F3-oiQ@mail.gmail.com> <1908360.UcyYMlCq0t@avalon> <CALcgO_5kEsvZiWXQPyt1YGOBz34-rPpd_mogbXrNBUKRdrUNKA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michael,

On Sunday 07 June 2015 17:35:48 Michael Allwright wrote:
> Thanks for the patch Laurent!
> 
> I have found out now what I have missed, I did not declare the DMA
> channels in my DT. I'm now able to capture frames at 720p. VGA and
> QVGA frames are coming out grainy and discoloured for the moment so
> this will require some further investigation. See:
> 
> QVGA - https://db.tt/Asyq0xj8
> VGA - https://db.tt/BIy8oVDv
> 720P - https://db.tt/32c9aEOF
> 
> I will slowly move forwards now and develop a set of patches that
> allow for the ISS to work on a mainline DT enabled kernel.

Please feel free to post patches incrementally, you don't have to fix all 
problems in one go. It will actually be easier for me to review the patches if 
they're sent incrementally than in one large series.

> I think it is also necessary to extend the V4L2 API slightly to create a
> function called v4l2_of_parse_sensor_bus which takes a remote endpoint and
> returns the underlying control bus (generally i2c) following what is
> outlined in Documentation/devicetree/bindings/media/video-interfaces.txt
> - This is required for setting up V4L2 asynchronous match between the
> sensor and the ISS.

I'm not convinced about that. Can't you just use V4L2_ASYNC_MATCH_OF instead 
of V4L2_ASYNC_MATCH_I2C ?

> Thanks again for the support everyone!

You're welcome.

-- 
Regards,

Laurent Pinchart

