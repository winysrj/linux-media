Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45744 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbZALGsF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jan 2009 01:48:05 -0500
Date: Mon, 12 Jan 2009 04:47:33 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Trilok Soni <soni.trilok@gmail.com>
Cc: Tobias Lorenz <tobias.lorenz@gmx.net>, linux-media@vger.kernel.org,
	Eduardo Valentin <eduardo.valentin@indt.org.br>
Subject: Re: FM transmitter support under v4l2?
Message-ID: <20090112044733.23dbe55e@pedra.chehab.org>
In-Reply-To: <5d5443650901112220x12827f8fre801c7e8d23d7479@mail.gmail.com>
References: <5d5443650811282312w508c0804qf962f6cf5e859e2@mail.gmail.com>
	<200811291506.11758.tobias.lorenz@gmx.net>
	<5d5443650901112220x12827f8fre801c7e8d23d7479@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 12 Jan 2009 11:50:28 +0530
Trilok Soni <soni.trilok@gmail.com> wrote:

> Hi Tobias,
> 
> On Sat, Nov 29, 2008 at 7:36 PM, Tobias Lorenz <tobias.lorenz@gmx.net> wrote:
> > Hi Trilok,
> >
> >> Anybody working on FM transmitter related drivers support under v4l2?
> >
> >> If no, what parts of v4l2 which could be tweaked in right order to
> >
> >> support such devices? I see that SI471x series seem to have FM
> >
> >> transmitters too.
> >
> > right, there are several Si47xx series:
> >
> > Si470x: receivers only
> >
> > Si471x: transmitter only
> 
> FYI..now maemo kernel team seems to have written Si4713 FM transmitter
> driver interfaced over I2C. It is available in the kernel diff here.
> 
> http://repository.maemo.org/pool/maemo5.0/free/k/kernel/kernel_2.6.27-20084805r03.diff.gz
> 
> Please download and unzip it and search for
> 
> radio-si4713.c

Hi Trilok. Thanks for pointing us for the driver.

The driver seems interesting, but I see a few issues with their approach:

1) it is creating a sysfs API for controlling some of the characteristics of
the radio. Public API's should be discussed with enough care at
linux-media@vger.kernel.org before their addition on a driver, and properly
documented. Also, IMO, the better would be to use VIDIOC_[G|C]_CTRL calls for
this, or to create another ioctl for handling FM transmission;

2) a V4L2 application has no means to determine that the device is a FM
transmission device. We need to add some capability flags to inform this to userspace.

While there, I noticed also a driver for radio-tea5761 and a patch for
common/tuners/tea5761.c. This also deserves review at linux-media@vger.kernel.org.

Cheers,
Mauro
