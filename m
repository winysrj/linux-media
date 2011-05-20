Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:35396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933931Ab1ETPcv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 May 2011 11:32:51 -0400
Message-ID: <4DD6899D.5020004@redhat.com>
Date: Fri, 20 May 2011 12:32:45 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [GIT PATCH FOR 2.6.40] uvcvideo patches
References: <201105150948.24956.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201105150948.24956.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 15-05-2011 04:48, Laurent Pinchart escreveu:
> Hi Mauro,
> 
> The following changes since commit f9b51477fe540fb4c65a05027fdd6f2ecce4db3b:
> 
>   [media] DVB: return meaningful error codes in dvb_frontend (2011-05-09 05:47:20 +0200)
> 
> are available in the git repository at:
>   git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-next
> 
> They replace the git pull request I've sent on Thursday with the same subject.
> 
> Bob Liu (2):
>       Revert "V4L/DVB: v4l2-dev: remove get_unmapped_area"
>       uvcvideo: Add support for NOMMU arch

IMO, such fixes should happen inside the arch bits, and not on each driver. If this fix
is needed for uvc video, the same fix should probably needed to all other USB drivers, in
order to work on NOMMU arch.

For now, I'm accepting this as a workaround, but please work on a generic solution
for it.

> Hans de Goede (2):
>       v4l: Add M420 format definition
>       uvcvideo: Add M420 format support

OK.

> Laurent Pinchart (4):
>       v4l: Release module if subdev registration fails
>       uvcvideo: Register a v4l2_device
>       uvcvideo: Register subdevices for each entity
>       uvcvideo: Connect video devices to media entities   


We've discussed already about using the media controller for uvcvideo, but I can't remember
anymore what where your aguments in favor of merging it (and, even if I've remembered it right
now, the #irc channel log is not the proper way to document the rationale to apply a patch).

The thing is: it is clear that SoC embedded devices need the media controller, as they have
IP blocks that do weird things, and userspace may need to access those, as it is not possible
to control such IP blocks using the V4L2 API.

However, I have serious concerns about media_controller API usage on generic drivers, as 
it is required that all drivers should be fully configurable via V4L2 API alone, otherwise
we'll have regressions, as no generic applications use the media_controller.

In other words, if you have enough arguments about why we should add media_controller support
at the uvcvideo, please clearly provide them at the patch descriptions, as this is not obvious.
It would equally important do document, at the uvcvideo doc, what kind of information is
provided via the media_controller and why an userspace application should care to use it.

Thanks,
Mauro.
