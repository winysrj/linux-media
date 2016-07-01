Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:59055 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbcGAMai (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Jul 2016 08:30:38 -0400
Date: Fri, 01 Jul 2016 21:30:35 +0900
From: Andi Shyti <andi.shyti@samsung.com>
To: Sean Young <sean@mess.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Rob Herring <robh+dt@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	devicetree@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Andi Shyti <andi@etezian.org>
Subject: Re: [PATCH] [media] rc: ir-spi: add support for IR LEDs connected with
 SPI
Message-id: <20160701123035.GA12029@samsunx.samsung>
References: <1467362022-12704-1-git-send-email-andi.shyti@samsung.com>
 <CGME20160701094505epcas1p469fb8084bd5195cdab5555a9f3368682@epcas1p4.samsung.com>
 <20160701094458.GA8933@gofer.mess.org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <20160701094458.GA8933@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean,

> > The ir-spi is a simple device driver which supports the
> > connection between an IR LED and the MOSI line of an SPI device.
> > 
> > The driver, indeed, uses the SPI framework to stream the raw data
> > provided by userspace through a character device. The chardev is
> > handled by the LIRC framework and its functionality basically
> > provides:
> > 
> >  - raw write: data to be sent to the SPI and then streamed to the
> >    MOSI line;
> >  - set frequency: sets the frequency whith which the data should
> >    be sent;
> >  - set length: sets the data length. This information is
> >    optional, if the length is set, then userspace should send raw
> >    data only with that length; while if the length is set to '0',
> >    then the driver will figure out himself the length of the data
> >    based on the length of the data written on the character
> >    device.
> >    The latter is not recommended, though, as the driver, at
> >    any write, allocates and deallocates a buffer where the data
> >    from userspace are stored.
> > 
> > The driver provides three feedback commands:
> > 
> >  - get length: reads the length set and (as mentioned), if the
> >    length is '0' it will be calculated at any write
> >  - get frequency: the driver reports the frequency. If userpace
> >    doesn't set the frequency, the driver will use a default value
> >    of 38000Hz.
> 
> This interface is not compatible with other lirc devices; there is no
> way of determining whether this is a regular lirc device or this new
> flavour you've invented.

except of the set length and get length which I'm using a bit
freely because I am dealing with devices that exchange always the
same amount of data, so that I don't need (in my case) to
pre-allocate or overallocate or runtime allocate. I don't
understand what else I invented :)

This is a simple driver which is driving an LED connected through
SPI and userspace writes raw data in it (LIRC_CAN_SEND_RAW).

> Also I don't see what justifies this new interface. This can be 
> implemented in rc-core in less lines of code and it will be entirely 
> compatible with existing user-space.

Also here I'm getting a bit confused. When I started writing
this, I didn't even know of the existence of a remote controlling
framework, but then I run across this:

"LIRC is a package that allows you to decode and send infra-red
signals of many (but not all) commonly used remote controls. "

taken from lirc.org: my case is exactly falling into this
description.

Am I missing anything?

Thanks,
Andi
