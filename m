Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51592 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932299Ab2KOA11 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Nov 2012 19:27:27 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Florian Neuhaus <florian.neuhaus@reberinformatik.ch>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"sakari.ailus@iki.fi" <sakari.ailus@iki.fi>,
	"dacohen@gmail.com" <dacohen@gmail.com>
Subject: Re: AW: [omap3-isp-live] Autofocus buffer interpretation of H3A engine
Date: Thu, 15 Nov 2012 01:28:21 +0100
Message-ID: <1989863.9WD6H5ak7o@avalon>
In-Reply-To: <6EE9CD707FBED24483D4CB0162E854671008F9FD@AM2PRD0710MB375.eurprd07.prod.outlook.com>
References: <6EE9CD707FBED24483D4CB0162E854671007E05D@AM2PRD0710MB375.eurprd07.prod.outlook.com> <1588578.t5rbryooTj@avalon> <6EE9CD707FBED24483D4CB0162E854671008F9FD@AM2PRD0710MB375.eurprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Florian,

On Friday 09 November 2012 15:57:58 Florian Neuhaus wrote:
> Laurent Pinchart wrote on 2012-11-04:
> > The AD5821 is similar to the AD5820, for which I have a driver that I need
> > to clean up and post. Would you be interested in that ?
> 
> Yes, you can send me the driver.

I've just sent it to you and CC'ed the list.

> Just as a note:
> I (probably) found an error in the current ad5398 and ad5821 driver
> http://lxr.free-electrons.com/source/drivers/regulator/ad5398.c
> It seems that the enable and disable functions are switched
> (at least for the ad5821).

I think you're right.

> Also it's not possible to set the maximum current. I've done a patch but
> didn't have the time to submit it. Is this the right place for it?

As the ad5398 driver implements the regulator driver API you should send the 
patch to the appropriate mailing lists.

$ ./scripts/get_maintainer.pl -f drivers/regulator/ad5398.c 
Michael Hennerich <michael.hennerich@analog.com> (supporter:AD5398 CURRENT 
RE...)
Liam Girdwood <lrg@ti.com> (supporter:VOLTAGE AND CURRE...)
Mark Brown <broonie@opensource.wolfsonmicro.com> (supporter:VOLTAGE AND 
CURRE...)
device-drivers-devel@blackfin.uclinux.org (open list:AD5398 CURRENT RE...)
linux-kernel@vger.kernel.org (open list)

> > Even though that buffer structure is pretty simple, I'm afraid I can't
> > provide that information as it's covered by an NDA.
> 
> I have written the TI-support and here's the answer:
> START QUOTE
> " After checking it seems that we unfortunately do not make the DM37x H3A
> documention available. Implementing Autofocus is quite complexe and the
> documentation is likely not going to provide enough help. A lot of
> experience is required to handle the mecanics and control loop aspect for
> the Autofocus.
> 
> We have partners that do have experience with the H3A module and that might
> be able to help. For example MMS that mentionned is the below document:
>      http://www.ti.com/lit/ml/swpt052/swpt052.pdf
> Also Leopard Imaging has experience on the H3A:
>     https://www.leopardimaging.com/Services.html
> END QUOTE
> 
> It's sad that they can't provide any further information, because we are not
> that far to get this stuff working...

Try pushing a bit more, sometimes it helps. Ask what it would take to get 
access to the documentation, possibly as a partner.

> > could try to figure it out ourselves. Looking at the FCam project, I've
> > found
> > 
> > http://vcs.maemo.org/svn/fcam/fcam-
> > dev/tags/1.1.0/src/N900/V4L2Sensor.cpp
> > 
> > Does that help figuring out what the buffer contains ?
> 
> That helps a lot! Thank you. I found also a little info here:
> http://www.mail-archive.com/davinci-linux-open-source@linux.davincidsp.com/m
> sg18438.html

If you can figure out the format and the configuration parameters from the 
above sources, I would greatly appreciate if you could write a bit of 
documentation and send a patch for Documentation/video4linux/omap3isp.txt. I 
unfortunately can't do it myself without TI's approval as I've had access to 
the documentation.

> > I haven't started, and it's currently not on my to-do list I'm afraid.
> 
> That's too bad, as your help is always appreciated.

Spare time is unfortunately limited :-)

> Have you already seen my patch for the rotation in your omap3-isp-live
> program?

It's still in my mailbox, I'll try to process it in the near future.

> I have seen also another little issue, if you are interested (snapshot_init
> should be after aewb as the output format changes during snapshot-init).

Sure, please send it.

> I am now off for 3 weeks (annual refresher course in the Swiss armed
> forces).

-- 
Regards,

Laurent Pinchart

