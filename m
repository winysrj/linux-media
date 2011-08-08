Return-path: <linux-media-owner@vger.kernel.org>
Received: from april.london.02.net ([87.194.255.143]:57287 "EHLO
	april.london.02.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704Ab1HHUY7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Aug 2011 16:24:59 -0400
From: Adam Baker <linux@baker-net.org.uk>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [Workshop-2011] Media Subsystem Workshop 2011
Date: Mon, 8 Aug 2011 21:24:47 +0100
Cc: Theodore Kilgore <kilgota@banach.math.auburn.edu>,
	Hans de Goede <hdegoede@redhat.com>,
	workshop-2011@linuxtv.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4E398381.4080505@redhat.com> <alpine.LNX.2.00.1108081423020.21636@banach.math.auburn.edu> <4E4041EF.8020702@redhat.com>
In-Reply-To: <4E4041EF.8020702@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108082124.47789.linux@baker-net.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 08 August 2011, Mauro Carvalho Chehab wrote:
> > 
> >
> > Well, in practice the "fork" would presumably be carried out by yours 
> > truly. Presumably with the advice and help of concerned parties. too. 
> > Since I am involved on both the kernel side and the libgphoto2 side of
> > the  support for the same cameras, it would certainly shorten the lines
> > of communication at the very least. Therefore this is not infeasible.
> 
> Forking the code just because we have something "special" is the wrong
> thing to do (TM). I would not like to fork V4L core code due to some
> special need, but instead to add some glue there to cover the extra case.
> Maintaining a fork is bad in long term, as the same fixes/changes will
> likely be needed on both copies.

Unfortunately there is some difficulty with libusb in that respect. libgphoto 
relies upon libusb-0.1 becuase it  is cross platform and Win32 support in 
libusb-1.0 is only just being integrated. The libusb developers consider the 
libusb-0.1 API frozen and are not willing to extend it to address our problem. 
libusb doesn't expose the file descriptor it uses to talk to the underlying 
device so it is hard to extend the interface without forking libusb (The best 
hope I can think of at the moment is to get the distros to accept a patch for 
it to add the extra required API call(s) and for libgphoto to use the extra 
features in that patch if it detects it is supported at compile time).

Adam Baker
