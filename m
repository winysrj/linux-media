Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:4282 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbZFAQEk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Jun 2009 12:04:40 -0400
Received: by qw-out-2122.google.com with SMTP id 5so5113060qwd.37
        for <linux-media@vger.kernel.org>; Mon, 01 Jun 2009 09:04:41 -0700 (PDT)
Date: Mon, 1 Jun 2009 13:04:33 -0300
From: Douglas Schilling Landgraf <dougsland@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Markus Rechberger <mrechberger@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] em28xx device mode detection based on endpoints
Message-ID: <20090601130433.66c34e32@gmail.com>
In-Reply-To: <829197380906010819s8cfdfedn9d47dbfef0ca1d04@mail.gmail.com>
References: <d9def9db0905230704n4f8b725aj3dc3021187d5ae12@mail.gmail.com>
	<d9def9db0905230749r3e39de5m3f4e1c28c1d596bd@mail.gmail.com>
	<d9def9db0905230805h5258a9b6h7920a5bd4ce62e7c@mail.gmail.com>
	<829197380906010819s8cfdfedn9d47dbfef0ca1d04@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Devin,

On Mon, 1 Jun 2009 11:19:22 -0400
Devin Heitmueller <dheitmueller@kernellabs.com> wrote:

> On Sat, May 23, 2009 at 11:05 AM, Markus Rechberger
> <mrechberger@gmail.com> wrote:
> > Hi,
> >
> > On Sat, May 23, 2009 at 4:49 PM, Markus Rechberger
> > <mrechberger@gmail.com> wrote:
> >> On Sat, May 23, 2009 at 4:04 PM, Markus Rechberger
> >> <mrechberger@gmail.com> wrote:
> >>> Hi,
> >>>
> >>> for em28xx devices the device node detection can be based on the
> >>> encoded endpoint address, for example EP 0x81 (USB IN, Interrupt),
> >>> 0x82 (analog video EP), 0x83 (analog audio ep), 0x84 (mpeg-ts
> >>> input EP).
> >>> It is not necessary that digital TV devices have a frontend, the
> >>> em28xx chip only specifies an MPEG-TS input EP.
> >>>
> >>> Following patch adds a check based on the Endpoints, although it
> >>> might be extended that all devices match the possible devicenodes
> >>> based on the endpoints, currently the driver registers an analog
> >>> TV node by default for all unknown devices which is not
> >>> necessarily correct, this patch disables the ATV node if no
> >>> analog TV endpoint is available.
> >>>
> >>
> >
> > attached patch fixes the deregistration, as well loads the
> > em28xx-dvb module automatically as soon as an MPEG-TS endpoint was
> > found.
> >
> > Signed-off-by: Markus Rechberger <mrechberger@gmail.com>
> >
> > best regards,
> > Markus
> >
> 
> Hello Markus,
> 
> I spent some time reviewing this patch, and the patch's content does
> not seem to match your description of its functionality.  Further,
> this patch appears to be a combination of a number of several
> different changes, rather than being broken into separate patches.
> 
> First off, I totally agree that the analog subsystem should not be
> loaded on devices such as em287[0-4].  I was going to do this work
> (using the chip id to determine analog support) but just had not had a
> chance to doing the necessary testing to ensure it did not break
> anything.
> 
> The patch appears to be primarily for devices that are not supported
> in the kernel.  In fact, the logic as written *only* gets used for
> unknown devices.  Further, the code that doesn't create the frontend
> device has no application in the kernel.  All devices currently in the
> kernel make use of the dvb frontend interface, so there is no
> practical application to loading the driver and setting up the isoc
> handlers but blocking access to the dvb frontend device.
> 
> Aside from the code that selectively disables analog support, the
> patch only seems to advance compatibility with your userland em28xx
> framework while providing no benefit to the in-kernel driver.
>
> Regarding the possibility of custom firmware, we currently do not have
> any devices in the in-kernel driver that make use of custom firmware.
> If you could tell me how to check for custom firmware versus the
> default vendor firmware, I could potentially do a patch that uses the
> vendor registers unless custom firmware is installed, at which point
> we could have custom logic (such as using the endpoint definition).
> However, given there are no such devices in-kernel, this is not a high
> priority as far as I am concerned.
> 
> For what it's worth, I did add an additional patch to allow the user
> to disable the 480Mbps check via a modprobe option (to avoid a
> regression for any of your existing customers), and I will be checking
> in the code to properly compute the isoc size for em2874/em2884 based
> on the vendor registers (even though there are currently no supported
> devices in the kernel that require it currently).  However, I do not
> believe the patch you have proposed is appropriate for inclusion in
> the mainline kernel.

Agree with you Devin. 

Also, the patch does a lot of changes instead of break it in several
patches.

Cheers,
Douglas
