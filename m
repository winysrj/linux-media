Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:36210 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759Ab1IPUXH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Sep 2011 16:23:07 -0400
Date: Fri, 16 Sep 2011 23:23:03 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Cliff Cai <cliffcai.sh@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Asking advice for Camera/ISP driver framework design
Message-ID: <20110916202302.GJ1845@valkosipuli.localdomain>
References: <CAFhB-RACaxtkBuXsch5-giTBqCHR+s5_SP-sGeR=E1HVeGfQLQ@mail.gmail.com>
 <CAFhB-RBLA410nRJ3w7qyEq2dD+96=eDTneVfmo5Bm6NwevW0Pw@mail.gmail.com>
 <4E723281.6070208@iki.fi>
 <CAFhB-RCNN74MdPCGB-J9Jqu0f_nxxspFoGsp+R97cQrWSUDFdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFhB-RCNN74MdPCGB-J9Jqu0f_nxxspFoGsp+R97cQrWSUDFdw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 16, 2011 at 10:44:00AM +0800, Cliff Cai wrote:
> On Fri, Sep 16, 2011 at 1:14 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> > Cliff Cai wrote:
> >> Dear guys,
> >
> > Hi Cliff,
> >
> >> I'm currently working on a camera/ISP Linux driver project.Of course,I
> >> want it to be a V4L2 driver,but I got a problem about how to design
> >> the driver framework.
> >> let me introduce the background of this ISP(Image signal processor) a
> >> little bit.
> >> 1.The ISP has two output paths,first one called main path which is
> >> used to transfer image data for taking picture and recording,the other
> >> one called preview path which is used to transfer image data for
> >> previewing.
> >> 2.the two paths have the same image data input from sensor,but their
> >> outputs are different,the output of main path is high quality and
> >> larger image,while the output of preview path is smaller image.
> >
> > Is the ISP able to process images which already are in memory, or is
> > this only from the sensor?
> 
> yes,it has another DMA to achieve  this.

If you wish to support this, there would need to be an additional video
node.

What about the image processing performed by this ISP? Does it e.g. do
scaling or cropping? They also should be configured using the V4L2 subdev
interface. The OMAP 3 ISP is a good example of this; the technical reference
manual is publicly available and the driver is exemplary.

Your original message hints such functionality is available. It would be
very helpful to know what kind of processing (scaling, pixel format
conversion, crop, etc.) is supported by the ISP and what are the exact data
paths through it. That defines what the media device graph implemented by
the ISP driver should be. If you could show a graphical representation of
this, all the better.

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
