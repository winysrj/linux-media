Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:60735 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932284AbeDXM6H (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 08:58:07 -0400
Message-ID: <1524574683.4231.11.camel@pengutronix.de>
Subject: Re: [DE] Re: [CN] Re: [DE] Re: coda: i.MX6 decoding performance
 issues for multi-streaming
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Javier Martin <javiermartin@by.com.es>,
        linux-media <linux-media@vger.kernel.org>
Cc: Fabio Estevam <festevam@gmail.com>
Date: Tue, 24 Apr 2018 14:58:03 +0200
In-Reply-To: <f62b540f-35d2-2d8d-e290-03540b6baf3e@by.com.es>
References: <c18549be-d55e-54d2-1524-1c51d05807ec@by.com.es>
         <1520940054.3965.10.camel@pengutronix.de>
         <dfd0fe98-4e5e-bc28-c325-6c52f1964a03@by.com.es>
         <1521035853.4490.7.camel@pengutronix.de>
         <2df2ad29-6173-08ea-e0d1-bf54c93ee456@by.com.es>
         <1521040308.4490.10.camel@pengutronix.de>
         <69970910-28ae-91a8-a7e8-04f0e6a397b1@by.com.es>
         <f62b540f-35d2-2d8d-e290-03540b6baf3e@by.com.es>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On Mon, 2018-04-23 at 11:29 +0200, Javier Martin wrote:
>   Sorry for resurrecting this thread but I'm still quite interested on 
> making this scenario work:
> 
>  > OK, I've performed some tests with several resolutions and gop sizes, 
> here is the table with the results:
>  >
>  > Always playing 3 streams
>  >
>  > | Resolution   |  QP   | GopSize   |  Kind of content |  Result 
>                  |
>  > | 640x368      |  25   |    16     |   Waving hands   |   time 
> shifts, no DEC_PIC_SUCCESS       |
>  > | 640x368      |  25   |    0      |   Waving hands   |   time 
> shifts, no DEC_PIC_SUCCESS    |
>  > | 320x192      |  25   |    0      |   Waving hands   |   time 
> shifts, no DEC_PIC_SUCCESS     |
>  > | 320x192      |  25   |    16     |   Waving hands   |   time 
> shifts, no DEC_PIC_SUCCESS     |
>  > | 1280x720     |  25   |    16     |   Waving hands   |   macroblock 
> artifacts and lots of DEC_PIC_SUCCESS messages |
>  > | 1280x720     |  25   |    0      |   Waving hands   | 
> Surprisingly smooth, no artifacts, time shifts nor DEC_PIC_SUCCESS|
>  >
>  > * The issues always happens in the first stream, the other 2 streams 
> are fine.
>  > * With GopSize = 0 I can even decode 4 720p streams with no artifacts
>  >
>  > It looks like for small resolutions it suffers from time shifts when 
> multi-streaming, always affecting the first stream for some reason. In 
> this case gop size doesn't seem to make any difference.
>  >
>  > For higher resolutions like 720p using GopSize = 0 seems to improve 
> things a lot.
>  >

I've tried to reproduce this with GStreamer 1.14.0:

gst-launch-1.0 filesrc location=test_720p.mp4 ! qtdemux ! h264parse ! tee name=t \
  t. ! v4l2h264dec ! fakesink \
  t. ! v4l2h264dec ! fakesink \
  t. ! v4l2h264dec ! fakesink \
  t. ! v4l2h264dec ! fakesink

with sync=false and sync=true, and with waylandsink instead of fakesink,
with various streams, all the same or all different:

gst-launch-1.0 \
  filesrc location=a.mp4 ! qtdemux ! h264parse !
v4l2h264dec ! fakesink \
  filesrc location=b.mp4 ! qtdemux ! h264parse !
v4l2h264dec ! fakesink \
  filesrc location=c.mp4 ! qtdemux ! h264parse !
v4l2h264dec ! fakesink \
  filesrc location=d.mp4 ! qtdemux ! h264parse !
v4l2h264dec ! fakesink

I can't seem to cause the DEC_PIC_SUCCESS issue with this setup, with
CODA-preencoded files. Same when I split this into an UDP sender and
receiver via RTP:

gst-launch-1.0 filesrc location=test_720p.mp4 ! qtdemux ! h264parse ! rtph264pay ! udpsink host=10.0.0.1 port=12345

gst-launch-1.0 udpsrc port=12345 ! application/x-rtp,payload=96 ! rtph264depay ! h264parse ! tee name=t \
  t. ! v4l2h264dec ! fakesink \
  t. ! v4l2h264dec ! fakesink \
  t. ! v4l2h264dec ! fakesink \
  t. ! v4l2h264dec ! fakesink

Could you try to either recreate the issue with GStreamer or with a
simple test program that I can see, or maybe provide a test stream
somewhere that causes the issue for me to download?

> Philipp, you mentioned some possible issue with context switches in a 
> previous e-mail:
>  > I fear this may be some interaction between coda context switches and
>  > bitstream reader unit state.
>
> Philipp, do these results confirm your theory? Are there any more tests 
> I could prepare to help get to the bottom of this or this is something 
> that belongs entirely to the coda firmware domain? Does anyone know if 
> the official BSP from NXP is able to decode 4 flows without issues?

I still have no idea. Maybe print coda_get_bitstream_payload(ctx) when
the DEC_PIC_SUCCESS error is emitted, to check whether this could be
some kind of buffer underrun issue. I assume you are not dropping any
buffers.

regards
Philipp
