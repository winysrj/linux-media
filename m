Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41888 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab2FKIFP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jun 2012 04:05:15 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [Q] Why is it needed to add an alsa module to v4l audio capture devices?
Date: Mon, 11 Jun 2012 10:05:20 +0200
Message-ID: <2041118.ct8h3d9SmG@avalon>
In-Reply-To: <CALF0-+VmR6izw6zXj+kOsrQDPN94v8jqhoRmeYp1vvexuoFJ1Q@mail.gmail.com>
References: <CALF0-+VmR6izw6zXj+kOsrQDPN94v8jqhoRmeYp1vvexuoFJ1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ezequiel,

On Thursday 07 June 2012 15:26:04 Ezequiel Garcia wrote:
> Hi all,
> 
> (I hope this is a genuine question, and I'm not avoiding my own homework
> here.)
> 
> I'm trying to support the audio part of the stk1160 usb bridge (similar to
> em28xx). Currently, the snd-usb-audio module is being loaded when I
> physically plug my device, but I can't seem to capture any sound with vlc.
> 
> I still have to research and work a lot to understand the connection between
> my device and alsa, and altough I could write a working module similar to
> em28xx-alsa.ko, I still can't figure out why do I need to write one in the
> first place.
> 
> Why is this module suffficient for gspca microphone devices (gspca, to name
> one) and why is a new alsa driver needed for em28xx (or stk1160)?

Some devices expose audio functionality by implementing the UAC (USB Audio 
Class) specification. The snd-usb-audio module is all you should need for 
those devices.

Other vendors support audio by using their own proprietary protocol. In those 
cases you will need a device-specific kernel module.

-- 
Regards,

Laurent Pinchart

