Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37658 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600AbaIYMf3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Sep 2014 08:35:29 -0400
Date: Thu, 25 Sep 2014 09:35:24 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Media Workshop <media-workshop@linuxtv.org>,
	linux-media@vger.kernel.org
Subject: Re: [media-workshop] [ANN] First tentative agenda
Message-ID: <20140925093524.62e827a7@recife.lan>
In-Reply-To: <54200B34.20103@xs4all.nl>
References: <54200B34.20103@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 22 Sep 2014 13:42:44 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Hi all,
> 
> I have collected all suggested topics. If I missed any, then let me know.
> 
> There seem to be three groups of topics: one has general topics, one is
> related to the compound controls, per frame configuration and Android, and
> one topic is about complex video pipelines.
> 
> Note that there are currently no DVB topics at all.

I have a few topics for DVB:

- I'd like to talk about the libdvbv5 - this will be a sort of
  presentation (about 30 mins is likely enough);

- The new tuner binding model and how to couple it to the media
  controller API for DVB (30 mins to 50 mins);

- I also would like to get suggestions about DVB API improvements,
  in special related to the demod API, but we may also need to discuss
  other improvements, like, for example, the support for DVB-C2
  (I would reserve about 50 mins, as those discussions tend to take
   some time).

Btw, we also need to get a list of attendees, as we might need to
request a bigger room depending on the number of people.

Regards,
Mauro


> 
> I have grouped the suggestions into those three high-level topics. If you
> disagree with where I put it, then let me know.
> 
> Also let me know your estimate of how long you think the discussion will take.
> I know it can be hard to pick a time, but it tends to average out anyway.
> 
> If you put up a topic, then you are expected to prepare for it, either by
> making a small presentation, or at least to think about what you want to
> say. We have only two days and I don't want to waste any time.
> 
> Speaking for myself: on one of the two days I have to give a lightning talk
> in the gstreamer conference and I want to attend Nicolas' gstreamer presentation
> as well. I don't know the times and dates yet.

I'm also thinking on giving a lightning talk at gst conf about libdvbv5.

> 
> If you have suggested a topic and you also have specific times you won't be
> available, then let me know as soon as you have the details.
> 
> The plan is to start each day at 9 am and go on to 5 pm or so, depending on
> how things work out.
> 
> Regards,
> 
> 	Hans
> 
> 
> 
> ============= General Topics ==================
> 
> Hans Verkuil:
> 
> - A presentation on colorspaces (Do *you* know what to put in the v4l2_pix_format
>   colorspace field? And why should it matter?)
>   30 min
> - media development process: what works, what doesn't
>   10-15 min
> 
> Ricardo:
> - multiple timestamps per buffer
> 
> 
> ============== Per-frame configuration/camera HAL v3/Compound control types ============
> 
> Ricardo:
> - multi selections and dead pixel api
> 
> Hans Verkuil:
> 
> - update on configure stores for the control framework
>   15 min
> 
> Sakari:
> - Android camera HAL API v3 and what kind of
>   requirements it brings to V4L2.
> 
> Pawel:
> 
> - Existing codec API ambiguities (does this belong to this topic?)
> - A proposal for a new codec API extension/mode for HW codecs that
> can't parse elementary streams
> 
> Guennadi:
> - camera support in Android (does this belong to this topic?)
> 
> 
> =========== Complex video pipeline drivers topic ===================
> 
> Hans Verkuil:
> - create virtual complex omap3-like driver: what is needed
>   15 min
> 
> Laurent & Chris Kohn:
> - runtime reconfiguration of pipelines
> 
> Philip Zabel:
> - Helping userspace to use mem2mem devices; clarification of
>   encoder/decoder handling, clarification of format/size setting
>   in case of dependencies between input and output formats,
>   possibly broad categorisation of mem2mem devices (encoder,
>   decoder, scaler, rotator, csc/filter, ...)
> 
> - Hierarchical media devices - what if you have a lot of media
>   entities and some of them are more closely related to each
>   other than others.
> 
> Julien Beraud:
> -Highly reconfigureable hardware devices and the possibility to create 
> media-links and virtual subdevices in order to simplify userland vision.
> 
> Nicolas Dufresne:
> - I'll like to discuss frame size enumeration 
>   for scaling m2m (e.g. fimc/gscaler and CUDA decoder).
> 
> 
> _______________________________________________
> media-workshop mailing list
> media-workshop@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/media-workshop
