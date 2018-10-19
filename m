Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:57337 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726903AbeJSRvN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Oct 2018 13:51:13 -0400
Message-ID: <1539942351.3395.6.camel@pengutronix.de>
Subject: Re: i.MX6 IPU CSI analog video input on Ventana
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Tim Harvey <tharvey@gateworks.com>,
        Krzysztof =?UTF-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>
Cc: linux-media <linux-media@vger.kernel.org>
Date: Fri, 19 Oct 2018 11:45:51 +0200
In-Reply-To: <57dfdc0b-5f04-e10a-2ffd-c7ba561fe7ce@gmail.com>
References: <m37eobudmo.fsf@t19.piap.pl> <m3tvresqfw.fsf@t19.piap.pl>
         <08726c4a-fb60-c37a-75d3-9a0ca164280d@gmail.com>
         <m3fu2oswjh.fsf@t19.piap.pl> <m3603hsa4o.fsf@t19.piap.pl>
         <db162792-22c2-7225-97a9-d18b0d2a5b9c@gmail.com>
         <m3h8mxqc7t.fsf@t19.piap.pl>
         <e7485d6e-d8e7-8111-c318-083228bf2a5c@gmail.com>
         <1527229949.4938.1.camel@pengutronix.de> <m3y3g8p5j3.fsf@t19.piap.pl>
         <1e11fa9a-8fa6-c746-7ee1-a64666bfc44e@gmail.com>
         <m3lgc2q5vl.fsf@t19.piap.pl>
         <06b9dd3d-3b7d-d34d-5263-411c99ab1a8b@gmail.com>
         <m38t81plry.fsf@t19.piap.pl>
         <4f49cf44-431d-1971-e5c5-d66381a6970e@gmail.com>
         <m336y9ouc4.fsf@t19.piap.pl>
         <6923fcd4-317e-d6a6-7975-47a8c712f8f9@gmail.com>
         <m3sh66omdk.fsf@t19.piap.pl> <1527858788.5913.2.camel@pengutronix.de>
         <05703b20-3280-3bdd-c438-dfce8e475aaa@gmail.com>
         <1528102047.5808.11.camel@pengutronix.de> <m3zi0blyhh.fsf@t19.piap.pl>
         <CAJ+vNU06QEOEBMfz3+CRG=J=C-wpFxwWCarRLs-c2gdspsfLpQ@mail.gmail.com>
         <57dfdc0b-5f04-e10a-2ffd-c7ba561fe7ce@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2018-10-17 at 14:33 -0700, Steve Longerbeam wrote:
[...]
> > I'm also interested in looking at Philipps' 'i.MX media mem2mem
> > scaler' series (https://patchwork.kernel.org/cover/10603881/) and am
> > wondering if anyone has some example pipelines showing that in use.
> > I'm hoping that is what is needed to be able to use hardware
> > scaling/CSC and coda based encoding on streams from v4l2 PCI capture
> > devices.
> 
> Yes exactly, I'll let Philipp answer. I'm also interested in the gstreamer
> element needed to make use of h/w scaling/CSC from the mem2mem
> device.

GStreamer should create a GstV4l2Transform element "v4l2videoXconvert"
for the /dev/videoX mem2mem scaler device.

> For coda encode, my understanding is that the v4l2h264enc element will
> make use of coda h/w encode, something like this example which encodes to
> a h.264 file (I haven't verified this works, still need to build a later 
> version of gst-plugins-good that has the vl2h264enc support):
> 
> gst-launch-1.0 v4l2src io-mode=dmabuf device=/dev/video$dev !\ "video/x-raw,format=$fmt,width=$w,height=$h"  ! \
> v4l2h264enc output-io-mode=dmabuf-import  ! queue ! matroskamux ! \
> filesink location=$filename

With GStreamer 1.14 the capture side io-mode parameter is not necessary
anymore to export dmabufs.
The output-io-mode parameter is currently still needed though, as the
V4L2 elements don't support negotiating dmabuf using caps via
video/x-raw(memory:DMABuf) yet.

Also there's a h264parse missing to convert the video/x-h264,stream-
format=byte-stream from v4l2h264enc to video/x-h264,stream-format=avc as
required by matroskamux:

gst-launch-1.0 \
	v4l2src ! \
	v4l2video10convert output-io-mode=dmabuf-import ! \
	v4l2h264enc output-io-mode=dmabuf-import ! \
	h264parse ! \
	matroskamux ! \
	filesink

> > Lastly, is there any hope to use IMX6 hardware compositing to say
> > stitch together multiple streams from a v4l2 PCI capture device into a
> > single stream for coda based hw encoding?
> 
> The IPUv3 Image Converter has a combining unit that can combine pixels from
> two images, but there is no support for that in mainline AFAIK.

I don't think there is any V4L2 API for compositing yet.

regards
Philipp
