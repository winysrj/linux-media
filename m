Return-path: <linux-media-owner@vger.kernel.org>
Received: from april.london.02.net ([87.194.255.143]:58109 "EHLO
	april.london.02.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab1HHUdF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Aug 2011 16:33:05 -0400
From: Adam Baker <linux@baker-net.org.uk>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [Workshop-2011] Media Subsystem Workshop 2011
Date: Mon, 8 Aug 2011 21:33:00 +0100
Cc: Theodore Kilgore <kilgota@banach.math.auburn.edu>,
	Hans de Goede <hdegoede@redhat.com>,
	workshop-2011@linuxtv.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4E398381.4080505@redhat.com> <alpine.LNX.2.00.1108072103200.20613@banach.math.auburn.edu> <4E3FE86A.5030908@redhat.com>
In-Reply-To: <4E3FE86A.5030908@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108082133.00340.linux@baker-net.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 08 August 2011, Mauro Carvalho Chehab wrote:
> > I will send a second reply to this message, which deals in particular
> > with  the list of abilities you outlined above. The point is, the
> > situation as to that list of abilities is more chaotic than is generally
> > realized. And when people are laying plans they really need to be aware
> > of that.
> 
> From what I understood from your proposal, "/dev/camX" would be providing a
> libusb-like interface, right?
> 
> If so, then, I'd say that we should just use the current libusb
> infrastructure. All we need is a way to lock libusb access when another
> driver is using the same USB interface.
> 

I think adding the required features to libusb is in general the correct 
approach however some locking may be needed in the kernel regardless to ensure 
a badly behaved libusb or libusb user can't corrupt kernel state.

> Hans and Adam's proposal is to actually create a "/dev/camX" node that will
> give fs-like access to the pictures. As the data access to the cameras
> generally use PTP (or a PTP-like protocol), probably one driver will
> handle several different types of cameras, so, we'll end by having one
> different driver for PTP than the V4L driver.

I'm not advocating this approach, my post was intended as a "straw man" to 
allow the advantages and disadvantages of such an approach to be considered by 
all concerned. I suspected it would be excessively complex but I don't know 
enough about the various cameras to be certain.

Adam
