Return-path: <mchehab@localhost.localdomain>
Received: from perceval.irobotique.be ([92.243.18.41]:55044 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab0IMHDk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Sep 2010 03:03:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH] Illuminators and status LED controls
Date: Mon, 13 Sep 2010 09:04:18 +0200
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Peter Korsgaard <jacmet@sunsite.dk>,
	"Jean-Francois Moine" <moinejf@free.fr>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Andy Walls <awalls@md.metrocast.net>,
	eduardo.valentin@nokia.com,
	"ext Eino-Ville Talvala" <talvala@stanford.edu>
References: <b7de5li57kosi2uhdxrgxyq9.1283891610189@email.android.com> <7aa9b3413bccf5418bb2deb0c7529969.squirrel@webmail.xs4all.nl> <4C88C9AA.2060405@redhat.com>
In-Reply-To: <4C88C9AA.2060405@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009130904.19143.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@localhost.localdomain>

Hi Hans,

On Thursday 09 September 2010 13:48:58 Hans de Goede wrote:
> On 09/09/2010 03:29 PM, Hans Verkuil wrote:
> >> On 09/09/2010 08:55 AM, Peter Korsgaard wrote:
> >>> "Hans" == Hans Verkuil<hverkuil@xs4all.nl>   writes:
> >>> 
> >>> I originally was in favor of controlling these through v4l as well, but
> >>> people made some good arguments against that. The main one being: why
> >>> would you want to show these as a control? What is the end user supposed
> >>> to do with them? It makes little sense.

Status LEDs reflect in glasses, making annoying color dots on webcam pictures. 
That's why Logitech allows to turn the status LED off on its webcams.

[snip]

> >> Reading this whole thread I have to agree that if we are going to expose
> >> camera status LEDs it would be done through the sysfs API. I think this
> >> can be done nicely for gspca based drivers (as we can put all the "crud"
> >> in the gspca core having to do it only once), but that is a low priority
> >> nice to have thingy.
> >> 
> >> This does leave us with the problem of logitech uvc cams where the LED
> >> currently is exposed as a v4l2 control.
> > 
> > Is it possible for the uvc driver to detect and use a LED control? That's
> > how I would expect this to work, but I know that uvc is a bit of a
> > strange beast.
> 
> Unfortunately no, some uvc cameras have "proprietary" controls. The uvc
> driver knows nothing about these but offers an API to map these to v4l2
> controls (where userspace tells it the v4l2 cid, type, min, max, etc.).
> 
> Currently on logitech cameras the userspace tools if installed will map
> the led control to a private v4l2 menu control with the following options:
> On
> Off
> Auto
> Blink
> 
> The cameras default to auto, where the led is turned on when video
> is being streamed and off when there is no streaming going on.

I confirm this. If the UVC LED controls were standard the driver could expose 
them through a LED-specific API. As UVC allows devices to implement private 
controls, the driver needs to expose all those private controls (both LED and 
non-LED) through the same API.

-- 
Regards,

Laurent Pinchart
