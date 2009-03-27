Return-path: <linux-media-owner@vger.kernel.org>
Received: from mk-outboundfilter-6.mail.uk.tiscali.com ([212.74.114.14]:59781
	"EHLO mk-outboundfilter-6.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764049AbZC0Xgp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2009 19:36:45 -0400
From: Adam Baker <linux@baker-net.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [RFC][PATCH 1/2] Sensor orientation reporting
Date: Fri, 27 Mar 2009 23:36:25 +0000
Cc: linux-media@vger.kernel.org, kilgota@banach.math.auburn.edu,
	Hans de Goede <j.w.r.degoede@hhs.nl>,
	"Jean-Francois Moine" <moinejf@free.fr>,
	Hans Verkuil <hverkuil@xs4all.nl>
References: <200903152224.29388.linux@baker-net.org.uk> <200903152229.48761.linux@baker-net.org.uk> <20090327143154.67102e2f@pedra.chehab.org>
In-Reply-To: <20090327143154.67102e2f@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903272336.25781.linux@baker-net.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 27 Mar 2009, Mauro Carvalho Chehab wrote:
> On Sun, 15 Mar 2009 22:29:48 +0000
>
> Adam Baker <linux@baker-net.org.uk> wrote:
> > Add support to the SQ-905 driver to pass back to user space the
> > sensor orientation information obtained from the camera during init.
> > Modifies gspca and the videodev2.h header to create the necessary
> > API.
>
> Please provide also the V4L2 specs change to include those new controls.

I hadn't forgotten this, it was just taking rather longer than expected to put 
together a working build system for the documentation (In the end I concluded 
the quickest approach was a complete OS upgrade to get working versions of the 
docbook tools and config files).

Adam
