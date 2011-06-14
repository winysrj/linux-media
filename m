Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:58196 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864Ab1FNOXf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2011 10:23:35 -0400
Date: Tue, 14 Jun 2011 08:23:33 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Kassey Lee <kassey1216@gmail.com>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	Kassey Lee <ygli@marvell.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Daniel Drake <dsd@laptop.org>, ytang5@marvell.com,
	qingx@marvell.com, leiwen@marvell.com
Subject: Re: [PATCH 1/8] marvell-cam: Move cafe-ccic into its own directory
Message-ID: <20110614082333.43098c95@bike.lwn.net>
In-Reply-To: <BANLkTikXATbgOZQbzaj4sQEmELsdpNobfQ@mail.gmail.com>
References: <1307814409-46282-1-git-send-email-corbet@lwn.net>
	<1307814409-46282-2-git-send-email-corbet@lwn.net>
	<BANLkTikXATbgOZQbzaj4sQEmELsdpNobfQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 14 Jun 2011 10:23:58 +0800
Kassey Lee <kassey1216@gmail.com> wrote:

> Jon, Here is my comments.

Thanks for having a look.

> > +config VIDEO_CAFE_CCIC
> > +       tristate "Marvell 88ALP01 (Cafe) CMOS Camera Controller support"
> > +       depends on PCI && I2C && VIDEO_V4L2
> > +       select VIDEO_OV7670
> >
>  why need binds with sensor ? suppose CCIC driver and sensor driver are
> independent, even if your hardware only support OV7670

We all agree that needs to change.  This particular patch, though, is
concerned with moving a working driver into a new directory; making that
sort of functional change would not be appropriate here.

> > +#include <media/ov7670.h>
> >
>      ccic would not be aware of the sensor name.

Ditto.

Thanks,

jon
