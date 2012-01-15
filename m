Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:37554 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022Ab2AOU0N (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jan 2012 15:26:13 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1RmWea-0003cj-2Y
	for linux-media@vger.kernel.org; Sun, 15 Jan 2012 21:26:12 +0100
Received: from p54990898.dip0.t-ipconnect.de ([84.153.8.152])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sun, 15 Jan 2012 21:26:12 +0100
Received: from aurel by p54990898.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sun, 15 Jan 2012 21:26:12 +0100
To: linux-media@vger.kernel.org
From: Aurel <aurel@gmx.de>
Subject: Re: White Balance Temperature
Date: Sun, 15 Jan 2012 20:25:53 +0000 (UTC)
Message-ID: <loom.20120115T210838-546@post.gmane.org>
References: <loom.20120115T110626-849@post.gmane.org> <201201151901.31380.laurent.pinchart@ideasonboard.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart <laurent.pinchart <at> ideasonboard.com> writes:

> 
> Hi Aurel,
> 
> On Sunday 15 January 2012 11:16:30 Aurel wrote:
> > Hi there
> > 
> > my "Live! Cam Socialize HD VF0610", Device ID: 041e:4080, Driver: uvcvideo
> > is running perfectly on Fedora 16 Linux, except one thing:
> > When I try to switch on "White Balance Temperature, Auto" or just try to
> > change "White Balance Temperature" slider I get a failure message and it
> > won't work. All other controls, like contrast, gamma, etc. are working.
> > "v4l2-ctl -d 1 --set-ctrl=white_balance_temperature_auto=1" produces an
> > error message:
> > "VIDIOC_S_CTRL: failed: Input/output error
> > white_balance_temperature_auto: Input/output error"
> > 
> > As soon as I boot Windows (inside Linux out of a Virtual Box), start the
> > camera there and go back to Linux, I am able to adjust and switch on the
> > White Balance things in Linux.
> > "v4l2-ctl -d 1 --set-ctrl=white_balance_temperature_auto=1" working fine
> > after running the camera in Windows.
> > 
> > Everytime I switch off my computer or disconnect the camera, I have to run
> > the camera in Windows again, bevor I can adjust White Balance in Linux.
> > 
> > What can I do to get White Balance controls working in Linux, without
> > having to run the camera in Windows every time?
> > Is there a special command I have to send to the camera for initializing or
> > so?
> 
> Not that I know of. If you use the stock UVC driver in Windows, without having 
> installed a custom driver for your device, that's quite unlikely.
> 
> Could you dump the value of all controls in Linux before and after booting 
> Windows ?
> 
Many thanks for your quick reply Laurent!

Here are the values before...
[aurel@DualCore ~]$ v4l2-ctl -d 1 -L
                     brightness (int)    : min=-128 max=127 step=1 default=0
value=0
                       contrast (int)    : min=64 max=255 step=1 default=128
value=128
                     saturation (int)    : min=0 max=255 step=1 default=128
value=128
                            hue (int)    : min=-128 max=127 step=1 default=0
value=0
 white_balance_temperature_auto (bool)   : default=1 value=0
                          gamma (int)    : min=72 max=500 step=1 default=100
value=128
                           gain (int)    : min=0 max=2 step=1 default=0 value=0
           power_line_frequency (menu)   : min=0 max=2 default=2 value=1
                                0: Disabled
                                1: 50 Hz
                                2: 60 Hz
      white_balance_temperature (int)    : min=2800 max=6500 step=1
 default=4600 value=4600
                      sharpness (int)    : min=0 max=100 step=1 default=0
value=0
         backlight_compensation (int)    : min=0 max=4 step=1 default=1 value=1
                               
                  exposure_auto (menu)   : min=0 max=3 default=1 value=3
                                1: Manual Mode
                                3: Aperture Priority Mode
              exposure_absolute (int)    : min=2 max=20000 step=1 default=156
value=16777372
[aurel@DualCore ~]$
...and after Windows...
[aurel@DualCore ~]$ v4l2-ctl -d 1 -L
                     brightness (int)    : min=-128 max=127 step=1 default=0
value=0
                       contrast (int)    : min=64 max=255 step=1 default=128
value=128
                     saturation (int)    : min=0 max=255 step=1 default=128
value=137
                            hue (int)    : min=-128 max=127 step=1 default=0
value=0
 white_balance_temperature_auto (bool)   : default=1 value=0
                          gamma (int)    : min=72 max=500 step=1 default=100
value=100
                           gain (int)    : min=0 max=2 step=1 default=0 value=0
           power_line_frequency (menu)   : min=0 max=2 default=2 value=1
                                0: Disabled
                                1: 50 Hz
                                2: 60 Hz
      white_balance_temperature (int)    : min=2800 max=6500 step=1
default=4600 value=4600
                      sharpness (int)    : min=0 max=100 step=1 default=0
value=0
         backlight_compensation (int)    : min=0 max=4 step=1 default=1 value=1
                  exposure_auto (menu)   : min=0 max=3 default=1 value=3
                                1: Manual Mode
                                3: Aperture Priority Mode
              exposure_absolute (int)    : min=2 max=20000 step=1 default=156
value=16777372
[aurel@DualCore ~]$ 
...not so much difference. 

And may be I didn't tell right before: I did install the original Live! Central
3 software by Creative in Windows. All I do is just start it and switch off
again. 
The interesting thing here is the "exposure_absolute" value. Much too high, but
can also be changed before Windows.

Regards
Aurel




