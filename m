Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:35875 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967484AbaLLOaR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Dec 2014 09:30:17 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 0/3] Deprecate drivers
Date: Fri, 12 Dec 2014 15:29:59 +0100
Cc: linux-media@vger.kernel.org
References: <1417534833-46844-1-git-send-email-hverkuil@xs4all.nl> <201412022342.19472.linux@rainbow-software.org> <54881139.5030303@xs4all.nl>
In-Reply-To: <54881139.5030303@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201412121530.00085.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 10 December 2014, Hans Verkuil wrote:
> On 12/02/14 23:42, Ondrej Zary wrote:
> > On Tuesday 02 December 2014 16:40:30 Hans Verkuil wrote:
> >> This patch series deprecates the vino/saa7191 video driver (ancient SGI
> >> Indy computer), the parallel port webcams bw-qcam, c-qcam and w9966, the
> >> ISA video capture driver pms and the USB video capture tlg2300 driver.
> >>
> >> Hardware for these devices is next to impossible to obtain, these
> >> drivers haven't seen any development in ages, they often use deprecated
> >> APIs and without hardware that's very difficult to port. And cheap
> >> alternative products are easily available today.
> >
> > Just bought a QuickCam Pro parallel and some unknown parallel port
> > webcam. Will you accept patches? :)
>
> OK, so there is some confusion here. You aren't offering to work on any of
> the deprecated drivers, are you?
>
> I'm sure you meant this email as a joke, but before the drivers are
> deprecated it is good to get that confirmed.

(Sorry for the delay, I somehow missed this e-mail.)

I'll try to fix c-qcam driver (I suppose that it should work with QuickCam 
Pro). The webcams are still on the way so I don't know what's inside the 
unknown one.

-- 
Ondrej Zary
