Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:58427 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113AbcGAJpF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Jul 2016 05:45:05 -0400
Date: Fri, 1 Jul 2016 10:44:58 +0100
From: Sean Young <sean@mess.org>
To: Andi Shyti <andi.shyti@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Rob Herring <robh+dt@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	devicetree@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Andi Shyti <andi@etezian.org>
Subject: Re: [PATCH] [media] rc: ir-spi: add support for IR LEDs connected
 with SPI
Message-ID: <20160701094458.GA8933@gofer.mess.org>
References: <1467362022-12704-1-git-send-email-andi.shyti@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1467362022-12704-1-git-send-email-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 01, 2016 at 05:33:42PM +0900, Andi Shyti wrote:
> The ir-spi is a simple device driver which supports the
> connection between an IR LED and the MOSI line of an SPI device.
> 
> The driver, indeed, uses the SPI framework to stream the raw data
> provided by userspace through a character device. The chardev is
> handled by the LIRC framework and its functionality basically
> provides:
> 
>  - raw write: data to be sent to the SPI and then streamed to the
>    MOSI line;
>  - set frequency: sets the frequency whith which the data should
>    be sent;
>  - set length: sets the data length. This information is
>    optional, if the length is set, then userspace should send raw
>    data only with that length; while if the length is set to '0',
>    then the driver will figure out himself the length of the data
>    based on the length of the data written on the character
>    device.
>    The latter is not recommended, though, as the driver, at
>    any write, allocates and deallocates a buffer where the data
>    from userspace are stored.
> 
> The driver provides three feedback commands:
> 
>  - get length: reads the length set and (as mentioned), if the
>    length is '0' it will be calculated at any write
>  - get frequency: the driver reports the frequency. If userpace
>    doesn't set the frequency, the driver will use a default value
>    of 38000Hz.

This interface is not compatible with other lirc devices; there is no
way of determining whether this is a regular lirc device or this new
flavour you've invented.

Also I don't see what justifies this new interface. This can be 
implemented in rc-core in less lines of code and it will be entirely 
compatible with existing user-space.


Sean
