Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:41410 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101AbaLUVVk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Dec 2014 16:21:40 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 0/3] Deprecate drivers
Date: Sun, 21 Dec 2014 22:21:05 +0100
Cc: linux-media@vger.kernel.org
References: <1417534833-46844-1-git-send-email-hverkuil@xs4all.nl> <201412121530.00085.linux@rainbow-software.org> <548AFC83.6000803@xs4all.nl>
In-Reply-To: <548AFC83.6000803@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201412212221.05921.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 12 December 2014 15:32:35 Hans Verkuil wrote:
> On 12/12/2014 03:29 PM, Ondrej Zary wrote:
> > On Wednesday 10 December 2014, Hans Verkuil wrote:
> >> On 12/02/14 23:42, Ondrej Zary wrote:
> >>> On Tuesday 02 December 2014 16:40:30 Hans Verkuil wrote:
> >>>> This patch series deprecates the vino/saa7191 video driver (ancient
> >>>> SGI Indy computer), the parallel port webcams bw-qcam, c-qcam and
> >>>> w9966, the ISA video capture driver pms and the USB video capture
> >>>> tlg2300 driver.
> >>>>
> >>>> Hardware for these devices is next to impossible to obtain, these
> >>>> drivers haven't seen any development in ages, they often use
> >>>> deprecated APIs and without hardware that's very difficult to port.
> >>>> And cheap alternative products are easily available today.
> >>>
> >>> Just bought a QuickCam Pro parallel and some unknown parallel port
> >>> webcam. Will you accept patches? :)
> >>
> >> OK, so there is some confusion here. You aren't offering to work on any
> >> of the deprecated drivers, are you?
> >>
> >> I'm sure you meant this email as a joke, but before the drivers are
> >> deprecated it is good to get that confirmed.
> >
> > (Sorry for the delay, I somehow missed this e-mail.)
> >
> > I'll try to fix c-qcam driver (I suppose that it should work with
> > QuickCam Pro). The webcams are still on the way so I don't know what's
> > inside the unknown one.
>
> I'm pretty sure the QuickCam Pro won't work with the c-qcam driver, but
> I'll postpone moving these drivers to staging for the moment.

The cameras arrived and you were right: QuickCam Pro really does not work with 
c-qcam driver. The protocol is probably completely different. The camera 
supports PnP (Windows detects it and it's visible in Device Manager).
According to some web pages, the protocol should be similar to QuickCam VC 
(available with parallel or USB port). There is a qcamvc out-of-tree driver 
for that (even updated last year) but support for QuickCam Pro is missing. 
Maybe it wouldn't be hard to add it.

The other camera is marked "Rookey Z" and is probably the same as "Todai 
TDC-01". It works in Windows 98 with wcah204e.exe software (probably 16-bit). 
There's no PnP support (Windows does not detect any device). Almost all chips 
inside are made by NEC, the biggest one is marked "CAME3". This one probably 
never worked with Linux.

-- 
Ondrej Zary
