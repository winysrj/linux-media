Return-path: <mchehab@pedra>
Received: from na3sys009aog106.obsmtp.com ([74.125.149.77]:48228 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751645Ab1BYGsy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Feb 2011 01:48:54 -0500
Received: by mail-vx0-f180.google.com with SMTP id 38so1422592vxc.11
        for <linux-media@vger.kernel.org>; Thu, 24 Feb 2011 22:48:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201102241417.12586.hverkuil@xs4all.nl>
References: <AANLkTik=Yc9cb9r7Ro=evRoxd61KVE=8m7Z5+dNwDzVd@mail.gmail.com>
	<AANLkTikg0Oj6nq6h_1-d7AQ4NQr2UyMuSemyniYZBLu3@mail.gmail.com>
	<AANLkTik89=g4fR=wC2rkpBero2e-jDVhjmUVNzKKwNjF@mail.gmail.com>
	<201102241417.12586.hverkuil@xs4all.nl>
Date: Fri, 25 Feb 2011 00:48:53 -0600
Message-ID: <AANLkTinSKfnvZ0wpGkyChJ6uBxpaW4qzs+W4ebXbmEpP@mail.gmail.com>
Subject: Re: [st-ericsson] v4l2 vs omx for camera
From: "Clark, Rob" <rob@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Robert Fekete <robert.fekete@linaro.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
	Harald Gustafsson <harald.gustafsson@ericsson.com>,
	gstreamer-devel@lists.freedesktop.org,
	ST-Ericsson LT Mailing List <st-ericsson@lists.linaro.org>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Feb 24, 2011 at 7:17 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> There are two parts to this: first of all you need a way to allocate large
> buffers. The CMA patch series is available (but not yet merged) that does this.
> I'm not sure of the latest status of this series.
>
> The other part is that everyone can use and share these buffers. There isn't
> anything for this yet. We have discussed this in the past and we need something
> generic for this that all subsystems can use. It's not a good idea to tie this
> to any specific framework like GEM. Instead any subsystem should be able to use
> the same subsystem-independent buffer pool API.

yeah, doesn't need to be GEM.. but should at least inter-operate so we
can share buffers with the display/gpu..

[snip]
>> But maybe it would be nice to have a way to have sensor driver on the
>> linux side, pipelined with hw and imaging drivers on a co-processor
>> for various algorithms and filters with configuration all exposed to
>> userspace thru MCF.. I'm not immediately sure how this would work, but
>> it sounds nice at least ;-)
>
> MCF? What does that stand for?
>

sorry, v4l2 media controller framework

BR,
-R
