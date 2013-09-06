Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54196 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab3IFNp4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Sep 2013 09:45:56 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hugues FRUCHET <hugues.fruchet@st.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Pawel Osciak <posciak@chromium.org>,
	media-workshop <media-workshop@linuxtv.org>,
	Oliver Schinagl <oliver+list@schinagl.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: Re: [media-workshop] Agenda for the Edinburgh mini-summit
Date: Fri, 06 Sep 2013 15:45:59 +0200
Message-ID: <4141987.vP8rY59Aji@avalon>
In-Reply-To: <7020EDD3BA6FF244B3C070FA4F02B1D8014BF87CBC46@SAFEX1MAIL2.st.com>
References: <201308301501.25164.hverkuil@xs4all.nl> <20130904074829.7ea2bfa6@samsung.com> <7020EDD3BA6FF244B3C070FA4F02B1D8014BF87CBC46@SAFEX1MAIL2.st.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hugues,

On Thursday 05 September 2013 13:37:49 Hugues FRUCHET wrote:
> Hi Mauro,
> 
> For floating point issue, we have not encountered such issue while
> integrating various codec (currently H264, MPEG4, VP8 of both Google G1 IP &
> ST IPs), could you precise which codec you experienced which required FP
> support ?
> 
> For user-space library, problem we encountered is that interface between
> parsing side (for ex. H264 SPS/PPS decoding, slice header decoding,
> references frame list management, ...moreover all that is needed to prepare
> hardware IPs call) and decoder side (hardware IPs handling) is not
> standardized and differs largely regarding IPs or CPU/copro partitioning.
> This means that even if we use the standard V4L2 capture interface to inject
> video bitstream (H264 access units for ex), some proprietary meta are needed
> to be attached to each buffers, making de facto "un-standard" the V4L2
> interface for this driver.

We're working on APIs to pass meta data from/to the kernel. The necessary 
infrastructure is more or less there already, we "just" need to agree on 
guidelines and standardize the process. One option that will likely be 
implemented is to store meta-data in a plane, using the multiplanar API.

The resulting plane format will be driver-specific, so we'll loose part of the 
benefits that the V4L2 API provides. We could try to solve this by writing a 
libv4l plugin, specific to your driver, that would handle bitstream parsing 
and fill the meta-data planes correctly. Applications using libv4l would thus 
only need to pass encoded frames to the library, which would create 
multiplanar buffers with video data and meta-data, and pass them to the 
driver. This would be fully transparent for the application.

> Exynos S5P MFC is not attaching any meta to capture input buffers, keeping a
> standard video bitstream injection interface (what is output naturally by
> well-known standard demuxers such as gstreamer ones or Android Stagefright
> ones). This is the way we want to go, we will so keep hardware details at
> kernel driver side. On the other hand, this simplify drastically the
> integration of our video drivers on user-land multimedia middleware,
> reducing the time to market and support needed when reaching our end-
> customers. Our target is to create a unified gstreamer V4L2 decoder(encoder)
> plugin and a unified OMX V4L2 decoder(encoder) to fit Android, based on a
> single V4L2 M2M API whatever hardware IP is.
> 
> About mini summit, Benjamin and I are checking internally how to attend to
> discuss this topic. We think that about half a day is needed to discuss
> this, we can so share our code and discuss about other codebase you know
> dealing with video codecs.

-- 
Regards,

Laurent Pinchart

