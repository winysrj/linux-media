Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:44281 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001AbZBUO0k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Feb 2009 09:26:40 -0500
Date: Sat, 21 Feb 2009 15:26:28 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, urishk@yahoo.com,
	linux-media@vger.kernel.org
Subject: Re: Minimum kernel version supported by v4l-dvb
Message-ID: <20090221152628.196f5cb1@hyperion.delvare>
In-Reply-To: <200902211345.40411.hverkuil@xs4all.nl>
References: <43235.62.70.2.252.1234947353.squirrel@webmail.xs4all.nl>
	<200902210828.50666.hverkuil@xs4all.nl>
	<20090221085801.5954e00b@pedra.chehab.org>
	<200902211345.40411.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 21 Feb 2009 13:45:40 +0100, Hans Verkuil wrote:
> On Saturday 21 February 2009 12:58:01 Mauro Carvalho Chehab wrote:
> > On Sat, 21 Feb 2009 08:28:50 +0100
> > Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > > OK, once more: there are two types of legacy code: one is that drivers
> > > have to be switched to use the new i2c API. That's what I've been
> > > working on all these months since Plumbers 2008. When all drivers that
> > > use i2c modules have been converted, then we can drop
> > > v4l2-i2c-drv-legacy.h and Jean can drop the autoprobing code in the i2c
> > > core.
> >
> > This will be great, provided that we can do the autoprobing for the audio
> > modules as required by a few drivers like bttv.
> 
> You cannot expect that a user can modprobe an i2c driver and it will 
> magically appear. That's going away. You can change the driver so that it 
> will load the module and let it probe for a series of i2c addresses. There 
> is also an option to let the i2c driver do additional checks (Jean knows 
> more about the details).

Actually with the new I2C binding model, you have quite a few options
depending of what you know and what you need.

* If you know that a given chip is at a given address, you call
  i2c_new_device() from the adapter driver's code.

* If you know a given chip is there but don't know the exact address,
  or if the chip may or may not be there, you call
  i2c_new_probed_device() from the adapter driver's code.

* If you know a given chip is there but don't know the address, or if
  the chip may or may not be there, and the device in question can be
  detected (ID registers you can read), you implement the detect()
  method in the I2C chip driver, which will test a number of addresses
  to find out if a supported chip is there or not. In the adapter driver,
  you define an I2C bus class (e.g. I2C_CLASS_TV_ANALOG) to allow the
  I2C chip driver to probe that specific bus.

* An alternative approach, if letting the I2C chip driver probe for the
  device is too dangerous, is to add custom detection code to the adapter
  driver. Imagine that different versions of the adapter have either
  I2C chip A or chip B at a given address, and the only way to
  differentiate is to write to a given register and read a value back
  from the chip. You can't do that on all I2C buses (writing to
  arbitrary registers is bad) but you can do it on your specific
  adapter. Depending on the result you then call i2c_new_device(A) or
  i2c_new_device(B).

The 3rd method is very similar to the legacy i2c binding model.

-- 
Jean Delvare
