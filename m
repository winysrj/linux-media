Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2355 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbZBUMBV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Feb 2009 07:01:21 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Minimum kernel version supported by v4l-dvb
Date: Sat, 21 Feb 2009 13:01:16 +0100
Cc: Laurent Pinchart <laurent.pinchart@skynet.be>,
	Jean Delvare <khali@linux-fr.org>, linux-media@vger.kernel.org
References: <20090217142327.1678c1a6@hyperion.delvare> <200902180006.38763.hverkuil@xs4all.nl> <20090221085046.3ebfccb3@pedra.chehab.org>
In-Reply-To: <20090221085046.3ebfccb3@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902211301.16677.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 21 February 2009 12:50:46 Mauro Carvalho Chehab wrote:
> On Wed, 18 Feb 2009 00:06:38 +0100
>
> Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > Especially companies like Texas Instruments that
> > are working on new v4l2 drivers for the embedded space (omap, davinci)
> > are quite annoyed and confused by all the backwards compatibility stuff
> > that we're dragging along. I find it much more important to cater to
> > their needs than to support a driver on an ancient kernel for some
> > anonymous company.
>
> The i2c code or any other backported code shouldn't affect any new
> driver.
>
> For new drivers, they can just use 2.6.29-rc as reference and mark
> that the minimum required version for it is 2.6.30, at v4l/versions.txt.
>
> If the driver is for x86/x86_64, it generally makes sense to preserve the
> backward compat bits, to help users.
>
> However, in the specific case of TI development, for OMAP and similar
> drivers that are specific to some embedded architecture, and where a
> normal user will never need to test it for us, since the vendor is
> responsible for the driver, it is perfectly fine to update
> v4l/versions.txt for each new version that needs something for a newer
> API.

Not quite true, certainly not in the generic case. If you come from the 
outside and start developing v4l i2c drivers, then it is simply confusing 
when you look at existing drivers in the git tree to use as a model. It's 
not clear at all why we do things the way we do. That's bad.

Secondly, i2c modules developed for embedded systems are perfectly usable in 
e.g. webcams which you might want to support for older kernels. It's not an 
issue right now though, as long as soc-camera and int-dev aren't converted 
to use v4l2_subdev as that prevents them from being used this way.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
