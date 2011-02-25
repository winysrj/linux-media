Return-path: <mchehab@pedra>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:47913 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932573Ab1BYRWw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Feb 2011 12:22:52 -0500
Received: by pvg12 with SMTP id 12so284535pvg.19
        for <linux-media@vger.kernel.org>; Fri, 25 Feb 2011 09:22:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1298578789.821.54.camel@deumeu>
References: <AANLkTik=Yc9cb9r7Ro=evRoxd61KVE=8m7Z5+dNwDzVd@mail.gmail.com>
	<AANLkTinDFMMDD-F-FsccCTvUvp6K3zewYsGT1BH9VP1F@mail.gmail.com>
	<201102100847.15212.hverkuil@xs4all.nl>
	<201102171448.09063.laurent.pinchart@ideasonboard.com>
	<AANLkTikg0Oj6nq6h_1-d7AQ4NQr2UyMuSemyniYZBLu3@mail.gmail.com>
	<1298578789.821.54.camel@deumeu>
Date: Fri, 25 Feb 2011 18:22:51 +0100
Message-ID: <AANLkTi=Twg-hzngyrpU_=o1yxQ3qVtiJf-Qhj--OubPu@mail.gmail.com>
Subject: Re: [st-ericsson] v4l2 vs omx for camera
From: Linus Walleij <linus.walleij@linaro.org>
To: Edward Hervey <bilboed@gmail.com>, johan.mossberg.lml@gmail.com
Cc: Discussion of the development of and with GStreamer
	<gstreamer-devel@lists.freedesktop.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
	Harald Gustafsson <harald.gustafsson@ericsson.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	ST-Ericsson LT Mailing List <st-ericsson@lists.linaro.org>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

2011/2/24 Edward Hervey <bilboed@gmail.com>:

>  What *needs* to be solved is an API for data allocation/passing at the
> kernel level which v4l2,omx,X,GL,vdpau,vaapi,... can use and that
> userspace (like GStreamer) can pass around, monitor and know about.

I think the patches sent out from ST-Ericsson's Johan Mossberg to
linux-mm for "HWMEM" (hardware memory) deals exactly with buffer
passing, pinning of buffers and so on. The CMA (Contigous Memory
Allocator) has been slightly modified to fit hand-in-glove with HWMEM,
so CMA provides buffers, HWMEM pass them around.

Johan, when you re-spin the HWMEM patchset, can you include
linaro-dev and linux-media in the CC? I think there is *much* interest
in this mechanism, people just don't know from the name what it
really does. Maybe it should be called mediamem or something
instead...

Yours,
Linus Walleij
