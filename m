Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:33571 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754086Ab3IJHhK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Sep 2013 03:37:10 -0400
From: Hugues FRUCHET <hugues.fruchet@st.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Oliver Schinagl <oliver+list@schinagl.nl>,
	media-workshop <media-workshop@linuxtv.org>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 10 Sep 2013 09:36:00 +0200
Subject: RE: [media-workshop] Agenda for the Edinburgh mini-summit
Message-ID: <7020EDD3BA6FF244B3C070FA4F02B1D8014BF8852674@SAFEX1MAIL2.st.com>
References: <201308301501.25164.hverkuil@xs4all.nl>
 <1440169.4erfBAv8If@avalon>
 <CACHYQ-qDD5S5FJvzT-oUBe+Y+S=CB_ZN+QNQPpu+BFE-ZPr45g@mail.gmail.com>
 <1590738.js4VoLrYFn@avalon>
 <CA+M3ks7whrGtkboVcstoEQBRTkiLGF7Hf9nEsYEkyUD6=QPG9w@mail.gmail.com>
 <20130904074829.7ea2bfa6@samsung.com>
 <7020EDD3BA6FF244B3C070FA4F02B1D8014BF87CBC46@SAFEX1MAIL2.st.com>
 <522DA3D5.100@xs4all.nl>
In-Reply-To: <522DA3D5.100@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks Hans,

Have you some implementation based on meta that we can check to see code details ?
It would be nice to have one with noticeable amount of code/processing made on user-land side.
I'm wondering also how libv4l is selecting each driver specific user-land plugin and how they are loaded.

BR.
-----Original Message-----
From: Hans Verkuil [mailto:hverkuil@xs4all.nl] 
Sent: lundi 9 septembre 2013 12:33
To: Hugues FRUCHET
Cc: Mauro Carvalho Chehab; Oliver Schinagl; media-workshop; Benjamin Gaignard; linux-media@vger.kernel.org
Subject: Re: [media-workshop] Agenda for the Edinburgh mini-summit

Hi Hugues,

On 09/05/2013 01:37 PM, Hugues FRUCHET wrote:
> Hi Mauro,
> 
> For floating point issue, we have not encountered such issue while
> integrating various codec (currently H264, MPEG4, VP8 of both Google
> G1 IP & ST IPs), could you precise which codec you experienced which
> required FP support ?
> 
> For user-space library, problem we encountered is that interface
> between parsing side (for ex. H264 SPS/PPS decoding, slice header
> decoding, references frame list management, ...moreover all that is
> needed to prepare hardware IPs call) and decoder side (hardware IPs
> handling) is not standardized and differs largely regarding IPs or
> CPU/copro partitioning. This means that even if we use the standard
> V4L2 capture interface to inject video bitstream (H264 access units
> for ex), some proprietary meta are needed to be attached to each
> buffers, making de facto "un-standard" the V4L2 interface for this
> driver.

There are lots of drivers (mostly camera drivers) that have non-standard
video formats. That's perfectly fine, as long as libv4l plugins/conversions
exist to convert it to something that's standardized.

Any application using libv4l doesn't notice the work going on under the
hood and it will look like a standard v4l2 driver.

The multiplanar API seems to me to be very suitable for these sort of devices.

> Exynos S5P MFC is not attaching any meta to capture input
> buffers, keeping a standard video bitstream injection interface (what
> is output naturally by well-known standard demuxers such as gstreamer
> ones or Android Stagefright ones). This is the way we want to go, we
> will so keep hardware details at kernel driver side. On the other
> hand, this simplify drastically the integration of our video drivers
> on user-land multimedia middleware, reducing the time to market and
> support needed when reaching our end-customers. Our target is to
> create a unified gstreamer V4L2 decoder(encoder) plugin and a unified
> OMX V4L2 decoder(encoder) to fit Android, based on a single V4L2 M2M
> API whatever hardware IP is.
> 
> About mini summit, Benjamin and I are checking internally how to
> attend to discuss this topic. We think that about half a day is
> needed to discuss this, we can so share our code and discuss about
> other codebase you know dealing with video codecs.> 

We are getting a lot of topics for the agenda and half a day for one topic
seems problematic to me.

One option is to discuss this in a smaller group a day earlier (October 22).
We might be able to get a room, or we can discuss it in the hotel lounge or
pub :-) or something.

Another option is that ST organizes a separate brainstorm session with a
few core developers. We done that in the past quite successfully.

Regards,

	Hans
