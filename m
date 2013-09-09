Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4117 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab3IIKdU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Sep 2013 06:33:20 -0400
Message-ID: <522DA3D5.100@xs4all.nl>
Date: Mon, 09 Sep 2013 12:32:53 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Hugues FRUCHET <hugues.fruchet@st.com>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Oliver Schinagl <oliver+list@schinagl.nl>,
	media-workshop <media-workshop@linuxtv.org>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [media-workshop] Agenda for the Edinburgh mini-summit
References: <201308301501.25164.hverkuil@xs4all.nl> <1440169.4erfBAv8If@avalon> <CACHYQ-qDD5S5FJvzT-oUBe+Y+S=CB_ZN+QNQPpu+BFE-ZPr45g@mail.gmail.com> <1590738.js4VoLrYFn@avalon> <CA+M3ks7whrGtkboVcstoEQBRTkiLGF7Hf9nEsYEkyUD6=QPG9w@mail.gmail.com> <20130904074829.7ea2bfa6@samsung.com> <7020EDD3BA6FF244B3C070FA4F02B1D8014BF87CBC46@SAFEX1MAIL2.st.com>
In-Reply-To: <7020EDD3BA6FF244B3C070FA4F02B1D8014BF87CBC46@SAFEX1MAIL2.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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
