Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58407 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960Ab2AQK4s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jan 2012 05:56:48 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Aurel <aurel@gmx.de>
Subject: Re: White Balance Temperature
Date: Tue, 17 Jan 2012 11:56:56 +0100
Cc: linux-media@vger.kernel.org
References: <loom.20120115T110626-849@post.gmane.org> <201201151901.31380.laurent.pinchart@ideasonboard.com> <loom.20120115T210838-546@post.gmane.org>
In-Reply-To: <loom.20120115T210838-546@post.gmane.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201171156.56692.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Aurel,

On Sunday 15 January 2012 21:25:53 Aurel wrote:
> Laurent Pinchart <laurent.pinchart <at> ideasonboard.com> writes:
> > On Sunday 15 January 2012 11:16:30 Aurel wrote:
> > > Hi there
> > > 
> > > my "Live! Cam Socialize HD VF0610", Device ID: 041e:4080, Driver:
> > > uvcvideo is running perfectly on Fedora 16 Linux, except one thing:
> > > When I try to switch on "White Balance Temperature, Auto" or just try
> > > to change "White Balance Temperature" slider I get a failure message
> > > and it won't work. All other controls, like contrast, gamma, etc. are
> > > working. "v4l2-ctl -d 1 --set-ctrl=white_balance_temperature_auto=1"
> > > produces an error message:
> > > "VIDIOC_S_CTRL: failed: Input/output error
> > > white_balance_temperature_auto: Input/output error"
> > > 
> > > As soon as I boot Windows (inside Linux out of a Virtual Box), start
> > > the camera there and go back to Linux, I am able to adjust and switch
> > > on the White Balance things in Linux.
> > > "v4l2-ctl -d 1 --set-ctrl=white_balance_temperature_auto=1" working
> > > fine after running the camera in Windows.
> > > 
> > > Everytime I switch off my computer or disconnect the camera, I have to
> > > run the camera in Windows again, bevor I can adjust White Balance in
> > > Linux.
> > > 
> > > What can I do to get White Balance controls working in Linux, without
> > > having to run the camera in Windows every time?
> > > Is there a special command I have to send to the camera for
> > > initializing or so?
> > 
> > Not that I know of. If you use the stock UVC driver in Windows, without
> > having installed a custom driver for your device, that's quite unlikely.
> > 
> > Could you dump the value of all controls in Linux before and after
> > booting Windows ?

[snip]

> Here are the values before...
[snip]
>            saturation (int)    : min=0 max=255 step=1 default=128 value=128
>                 gamma (int)    : min=72 max=500 step=1 default=100 value=128
[snip]
> ...and after Windows...
[snip]
>            saturation (int)    : min=0 max=255 step=1 default=128 value=137
>                 gamma (int)    : min=72 max=500 step=1 default=100 value=100
[snip]
> ...not so much difference.

Indeed, only saturation and gamma differ. Have you tried setting saturation to 
137 and gamma to 100 in Linux (without booting Windows) and then changing the 
white balance controls ? I don't expect that to make any difference, but just 
in case...

> And may be I didn't tell right before: I did install the original Live!
> Central 3 software by Creative in Windows. All I do is just start it and
> switch off again.

Ah, that can play a role. The software might configure the camera when you 
plug it in using vendor-specific requests or extension units. Sniffing USB 
traffic in Windows could help verifying that.

> The interesting thing here is the "exposure_absolute" value. Much too high,
> but can also be changed before Windows.

-- 
Regards,

Laurent Pinchart
