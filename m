Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41658 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab1BZNNC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Feb 2011 08:13:02 -0500
Received: by fxm17 with SMTP id 17so2544401fxm.19
        for <linux-media@vger.kernel.org>; Sat, 26 Feb 2011 05:13:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTikg0Oj6nq6h_1-d7AQ4NQr2UyMuSemyniYZBLu3@mail.gmail.com>
References: <AANLkTik=Yc9cb9r7Ro=evRoxd61KVE=8m7Z5+dNwDzVd@mail.gmail.com>
	<AANLkTinDFMMDD-F-FsccCTvUvp6K3zewYsGT1BH9VP1F@mail.gmail.com>
	<201102100847.15212.hverkuil@xs4all.nl>
	<201102171448.09063.laurent.pinchart@ideasonboard.com>
	<AANLkTikg0Oj6nq6h_1-d7AQ4NQr2UyMuSemyniYZBLu3@mail.gmail.com>
Date: Sat, 26 Feb 2011 15:13:01 +0200
Message-ID: <AANLkTi=OC28M2eAyMWRsAjdZsxDTfh=H7kdk9GDbaF2p@mail.gmail.com>
Subject: Re: [st-ericsson] v4l2 vs omx for camera
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Discussion of the development of and with GStreamer
	<gstreamer-devel@lists.freedesktop.org>
Cc: Robert Fekete <robert.fekete@linaro.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
	Harald Gustafsson <harald.gustafsson@ericsson.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	ST-Ericsson LT Mailing List <st-ericsson@lists.linaro.org>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On Fri, Feb 18, 2011 at 6:39 PM, Robert Fekete <robert.fekete@linaro.org> wrote:
> To make a long story short:
> Different vendors provide custom OpenMax solutions for say Camera/ISP. In
> the Linux eco-system there is V4L2 doing much of this work already and is
> evolving with mediacontroller as well. Then there is the integration in
> Gstreamer...Which solution is the best way forward. Current discussions so
> far puts V4L2 greatly in favor of OMX.
> Please have in mind that OpenMAX as a concept is more like GStreamer in many
> senses. The question is whether Camera drivers should have OMX or V4L2 as
> the driver front end? This may perhaps apply to video codecs as well. Then
> there is how to in best of ways make use of this in GStreamer in order to
> achieve no copy highly efficient multimedia pipelines. Is gst-omx the way
> forward?
>
> Let the discussion continue...

We are talking about 3 different layers here which don't necessarily
overlap. You could have a v4l2 driver, which is wrapped in an OpenMAX
IL library, which is wrapped again by gst-openmax. Each layer is
different. The problem here is the OMX layer, which is often
ill-conceived.

First of all, you have to remember that whatever OMX is supposed to
provide, that doesn't apply to camera; you can argue that there's some
value in audio/video encoding/decoding, as the interfaces are very
simple and easy to standardize, but that's not the case with camera. I
haven't worked with OMX camera interfaces, but AFAIK it's very
incomplete and vendors have to implement their own interfaces, which
defeats the purpose of OMX. So OMX provides nothing in the camera
case.

Secondly, there's no OMX kernel interface. You still need something
between kernel to user-space, the only established interface is v4l2.
So, even if you choose OMX in user-space, the sensible choice in
kernel-space is v4l2, otherwise you would end up with some custom
interface which is never good.

And third, as Laurent already pointed out; OpenMAX is _not_ open. The
community has no say in what happens, everything is decided by a
consortium, you need to pay money to be in it, to access their
bugzilla, to subscribe to their mailing lists, and to get access to
their conformance test.

If you forget all the marketing mumbo jumbo about OMX, at the of the
day what is provided is a bunch of headers (and a document explaining
how to use them). We (the linux community) can come up with a bunch of
headers too, in fact, we already do much more than that with v4l2, the
only part missing is encoders/decoders, which if needed could be added
very easily (Samsung already does AFAIK). Right?

Cheers.

-- 
Felipe Contreras
