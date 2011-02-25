Return-path: <mchehab@pedra>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:54805 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752724Ab1BYGdU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Feb 2011 01:33:20 -0500
Received: by mail-vx0-f176.google.com with SMTP id 41so1351189vxc.7
        for <linux-media@vger.kernel.org>; Thu, 24 Feb 2011 22:33:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1298578789.821.54.camel@deumeu>
References: <AANLkTik=Yc9cb9r7Ro=evRoxd61KVE=8m7Z5+dNwDzVd@mail.gmail.com>
	<AANLkTinDFMMDD-F-FsccCTvUvp6K3zewYsGT1BH9VP1F@mail.gmail.com>
	<201102100847.15212.hverkuil@xs4all.nl>
	<201102171448.09063.laurent.pinchart@ideasonboard.com>
	<AANLkTikg0Oj6nq6h_1-d7AQ4NQr2UyMuSemyniYZBLu3@mail.gmail.com>
	<1298578789.821.54.camel@deumeu>
Date: Fri, 25 Feb 2011 00:33:19 -0600
Message-ID: <AANLkTi=zdCb4dYPgiKhcK5Tximv5CQQOi6g5hmRzs2ie@mail.gmail.com>
Subject: Re: [st-ericsson] v4l2 vs omx for camera
From: "Clark, Rob" <rob@ti.com>
To: Discussion of the development of and with GStreamer
	<gstreamer-devel@lists.freedesktop.org>
Cc: Edward Hervey <bilboed@gmail.com>,
	"linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
	Harald Gustafsson <harald.gustafsson@ericsson.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	ST-Ericsson LT Mailing List <st-ericsson@lists.linaro.org>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Feb 24, 2011 at 2:19 PM, Edward Hervey <bilboed@gmail.com> wrote:
>
>  What *needs* to be solved is an API for data allocation/passing at the
> kernel level which v4l2,omx,X,GL,vdpau,vaapi,... can use and that
> userspace (like GStreamer) can pass around, monitor and know about.

yes yes yes yes!!

vaapi/vdpau is half way there, as they cover sharing buffers with
X/GL..  but sadly they ignore camera.  There are a few other
inconveniences with vaapi and possibly vdpau.. at least we'd prefer to
have an API the covered decoding config data like SPS/PPS and not just
slice data since config data NALU's are already decoded by our
accelerators..

>  That is a *massive* challenge on its own. The choice of using
> GStreamer or not ... is what you want to do once that challenge is
> solved.
>
>  Regards,
>
>    Edward
>
> P.S. GStreamer for Android already works :
> http://www.elinux.org/images/a/a4/Android_and_Gstreamer.ppt
>

yeah, I'm aware of that.. someone please convince google to pick it up
and drop stagefright so we can only worry about a single framework
between android and linux  (and then I look forward to playing with
pitivi on an android phone :-))

BR,
-R

> _______________________________________________
> gstreamer-devel mailing list
> gstreamer-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/gstreamer-devel
>
