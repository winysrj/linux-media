Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48498 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbbCSQJk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Mar 2015 12:09:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Oliver Lehmann <lehmann@ans-netz.de>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: capture high resolution images from webcam
Date: Thu, 19 Mar 2015 18:09:50 +0200
Message-ID: <2540710.k9cj0VyRUW@avalon>
In-Reply-To: <20150319065724.Horde.sIjlxBtAFM5dtBircS5DFw1@avocado.salatschuessel.net>
References: <20150317223529.Horde.S4cQ0yA7NJaIix7vWKABGA9@avocado.salatschuessel.net> <Pine.LNX.4.64.1503182220410.15761@axis700.grange> <20150319065724.Horde.sIjlxBtAFM5dtBircS5DFw1@avocado.salatschuessel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Oliver,

On Thursday 19 March 2015 06:57:24 Oliver Lehmann wrote:
> Hi Guennadi,
> 
> Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> > As for the actual question, I have no idea how they implement still
> > images: the UVC standard defines two methods for higher-resolution still
> > image capture: either using the "still image trigger control" or a
> > dedicated bulk pipeline (and a hardware button if there is one on your
> > camera?) FWIW, in either case I'm not sure whether the driver supports any
> > of those methods. I think bulk pipe support has been added to it at some
> > point, but what concerns switching... Not sure really, sorry.
> 
> The cam has a button but it is labled with a phone receiver so I guess it
> is not there for taking still images. The MS-Software on Windows has two
> buttons - one for taking a photo and one for recording a video. If you
> switch the resolution to 1080p or "8MP", the video button gets disabled and
> all someone can do is capturing a photo. More informations about the cam:
> 
> root@reis /root> v4l2-ctl --info
> Driver Info (not using libv4l2):
>          Driver name   : uvcvideo
>          Card type     : Microsoft LifeCam Studio(TM)
>          Bus info      : usb-/dev/usb-/dev/usb
>          Driver version: 2.6.38
>          Capabilities  : 0x84000001
>                  Video Capture
>                  Streaming
> root@reis /root> v4l2-ctl -L
>                       brightness (int)    : min=30 max=255 step=1
> default=133 value=85
>                         contrast (int)    : min=0 max=10 step=1
> default=5 value=5
>                       saturation (int)    : min=0 max=200 step=1
> default=103 value=100
>   white_balance_temperature_auto (bool)   : default=1 value=1
>             power_line_frequency (menu)   : min=0 max=2 default=2 value=2
>                                  0: Disabled
>                                  1: 50 Hz
>                                  2: 60 Hz
>        white_balance_temperature (int)    : min=2500 max=10000 step=1
> default=4500 value=2500 flags=inactive
>                        sharpness (int)    : min=0 max=50 step=1
> default=25 value=25
>           backlight_compensation (int)    : min=0 max=10 step=1
> default=0 value=0
>                    exposure_auto (menu)   : min=0 max=3 default=3 value=3
>                                  1: Manual Mode
>                                  3: Aperture Priority Mode
>                exposure_absolute (int)    : min=1 max=10000 step=1
> default=156 value=156 flags=inactive
>                     pan_absolute (int)    : min=-529200 max=529200
> step=3600 default=0 value=0
>                    tilt_absolute (int)    : min=-432000 max=432000
> step=3600 default=0 value=0
>                   focus_absolute (int)    : min=0 max=40 step=1
> default=0 value=28
>                       focus_auto (bool)   : default=1 value=0
>                    zoom_absolute (int)    : min=0 max=317 step=1
> default=0 value=0
> root@reis /root>

Could you please post the output of "lsusb -v" for your camera (running as 
root if possible) ?

> The "nice" part is, that it has a real hardware focus which is fantastic
> for my needs. The autofocus mode does not work with v4l2 somehow (image
> gets not focused), but for my needs, a manual focus is OK. Thats why I
> have autofocus disabled. I never tested capturing a video - maybe
> autofocus works there when taking more than one frame because it needs
> some time to focus ;)
> 
> > But if you just try to be opportunistic and try cheese - it has a separate
> > setting for still images, so, maybe I'm way behind the time and everything
> > is working already?
> 
> The problem is:- The system is a headless system - so no monitor and no Xorg
> installation (some X11 dependencies are installed tho) and I guess cheese
> has no commandline interface?

-- 
Regards,

Laurent Pinchart

