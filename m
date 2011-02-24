Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52019 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab1BXM36 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Feb 2011 07:29:58 -0500
Received: by iwn34 with SMTP id 34so264657iwn.19
        for <linux-media@vger.kernel.org>; Thu, 24 Feb 2011 04:29:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTin0GZxLqtPjNx9AEOPQKRkJ6hf2mXMOqp+LvNw0@mail.gmail.com>
References: <AANLkTik=Yc9cb9r7Ro=evRoxd61KVE=8m7Z5+dNwDzVd@mail.gmail.com>
	<AANLkTinDFMMDD-F-FsccCTvUvp6K3zewYsGT1BH9VP1F@mail.gmail.com>
	<201102100847.15212.hverkuil@xs4all.nl>
	<201102171448.09063.laurent.pinchart@ideasonboard.com>
	<AANLkTikg0Oj6nq6h_1-d7AQ4NQr2UyMuSemyniYZBLu3@mail.gmail.com>
	<AANLkTik89=g4fR=wC2rkpBero2e-jDVhjmUVNzKKwNjF@mail.gmail.com>
	<AANLkTin0GZxLqtPjNx9AEOPQKRkJ6hf2mXMOqp+LvNw0@mail.gmail.com>
Date: Thu, 24 Feb 2011 13:29:56 +0100
Message-ID: <AANLkTinvDR9SAiBOVOxMXGANpSq8w22ObjPEbdaRcj3R@mail.gmail.com>
Subject: Re: [st-ericsson] v4l2 vs omx for camera
From: Linus Walleij <linus.walleij@linaro.org>
To: Sachin Gupta <sachin.gupta@linaro.org>
Cc: "Clark, Rob" <rob@ti.com>,
	Robert Fekete <robert.fekete@linaro.org>,
	"linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
	Harald Gustafsson <harald.gustafsson@ericsson.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	ST-Ericsson LT Mailing List <st-ericsson@lists.linaro.org>,
	linux-media@vger.kernel.org, gstreamer-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

2011/2/23 Sachin Gupta <sachin.gupta@linaro.org>:

> The imaging coprocessor in today's platforms have a general purpose DSP
> attached to it I have seen some work being done to use this DSP for
> graphics/audio processing in case the camera use case is not being tried or
> also if the camera usecases does not consume the full bandwidth of this
> dsp.I am not sure how v4l2 would fit in such an architecture,

Earlier in this thread I discussed TI:s DSPbridge.

In drivers/staging/tidspbridge
http://omappedia.org/wiki/DSPBridge_Project
you find the TI hackers happy at work with providing a DSP accelerator
subsystem.

Isn't it possible for a V4L2 component to use this interface (or something
more evolved, generic) as backend for assorted DSP offloading?

So using one kernel framework does not exclude using another one
at the same time. Whereas something like DSPbridge will load firmware
into DSP accelerators and provide control/datapath for that, this can
in turn be used by some camera or codec which in turn presents a
V4L2 or ALSA interface.

Yours,
Linus Walleij
