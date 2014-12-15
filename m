Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54516 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaLOJSq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Dec 2014 04:18:46 -0500
Message-ID: <1418635114.3193.1.camel@pengutronix.de>
Subject: Re: [PATCH] Add LVDS RGB media bus formats
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Boris Brezillon <boris.brezillon@free-electrons.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de
Date: Mon, 15 Dec 2014 10:18:34 +0100
In-Reply-To: <20141212230745.GA17565@valkosipuli.retiisi.org.uk>
References: <1418403062-15663-1-git-send-email-p.zabel@pengutronix.de>
	 <20141212230745.GA17565@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Am Samstag, den 13.12.2014, 01:07 +0200 schrieb Sakari Ailus:
[...]
> > diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml b/Documentation/DocBook/media/v4l/subdev-formats.xml
> > index 0d6f731..6d59a0e 100644
> > --- a/Documentation/DocBook/media/v4l/subdev-formats.xml
> > +++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
> > @@ -89,6 +89,14 @@
> >        <constant>MEDIA_BUS_FMT_RGB555_2X8_PADHI_BE</constant>.
> >        </para>
> >  
> > +      <para>On LVDS buses, usually each sample is transferred serialized in seven
> 
> 80 characters per line, please.
> 
> Could you move this paragraph just before the LVDS table?

Will do.

[...]
> > diff --git a/include/uapi/linux/media-bus-format.h b/include/uapi/linux/media-bus-format.h
> > index 37091c6..3fb9cbb 100644
> > --- a/include/uapi/linux/media-bus-format.h
> > +++ b/include/uapi/linux/media-bus-format.h
> > @@ -33,7 +33,7 @@
> >  
> >  #define MEDIA_BUS_FMT_FIXED			0x0001
> >  
> > -/* RGB - next is	0x1010 */
> 
> Does your patch depend on another patch which is not merged yet?

Yes, it depends on Boris Brezillon's patch to
"Add RGB444_1X12 and RGB565_1X16 media bus formats":
https://lkml.org/lkml/2014/11/16/12

thanks
Philipp

