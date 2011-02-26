Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57547 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab1BZNix (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Feb 2011 08:38:53 -0500
Received: by fxm17 with SMTP id 17so2554231fxm.19
        for <linux-media@vger.kernel.org>; Sat, 26 Feb 2011 05:38:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201102241427.10988.laurent.pinchart@ideasonboard.com>
References: <AANLkTik=Yc9cb9r7Ro=evRoxd61KVE=8m7Z5+dNwDzVd@mail.gmail.com>
	<AANLkTikg0Oj6nq6h_1-d7AQ4NQr2UyMuSemyniYZBLu3@mail.gmail.com>
	<AANLkTik89=g4fR=wC2rkpBero2e-jDVhjmUVNzKKwNjF@mail.gmail.com>
	<201102241427.10988.laurent.pinchart@ideasonboard.com>
Date: Sat, 26 Feb 2011 15:38:50 +0200
Message-ID: <AANLkTikZ1Z=h4ZDmZ2sUizP328auoW=6CgTdf8vuqVDd@mail.gmail.com>
Subject: Re: [st-ericsson] v4l2 vs omx for camera
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "Clark, Rob" <rob@ti.com>,
	Robert Fekete <robert.fekete@linaro.org>,
	"linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
	Harald Gustafsson <harald.gustafsson@ericsson.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	gstreamer-devel@lists.freedesktop.org,
	ST-Ericsson LT Mailing List <st-ericsson@lists.linaro.org>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Feb 24, 2011 at 3:27 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>> > Perhaps GStreamer experts would like to comment on the future plans ahead
>> > for zero copying/IPC and low power HW use cases? Could Gstreamer adapt
>> > some ideas from OMX IL making OMX IL obsolete?
>>
>> perhaps OMX should adapt some of the ideas from GStreamer ;-)
>
> I'd very much like to see GStreamer (or something else, maybe lower level, but
> community-maintainted) replace OMX.

Yes, it would be great to have something that wraps all the hardware
acceleration and could have support for software codecs too, all in a
standard interface. It would also be great if this interface would be
used in the upper layers like GStreamer, VLC, etc. Kind of what OMX
was supposed to be, but open [1].

Oh wait, I'm describing FFmpeg :) (supports vl42, VA-API, VDPAU,
DirectX, and soon OMAP3 DSP)

Cheers.

[1] http://freedesktop.org/wiki/GstOpenMAX?action=AttachFile&do=get&target=gst-openmax.png

-- 
Felipe Contreras
