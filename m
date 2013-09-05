Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:44075 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934435Ab3IELiV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Sep 2013 07:38:21 -0400
From: Hugues FRUCHET <hugues.fruchet@st.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pawel Osciak <posciak@chromium.org>,
	media-workshop <media-workshop@linuxtv.org>,
	Oliver Schinagl <oliver+list@schinagl.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>
Date: Thu, 5 Sep 2013 13:37:49 +0200
Subject: RE: [media-workshop] Agenda for the Edinburgh mini-summit
Message-ID: <7020EDD3BA6FF244B3C070FA4F02B1D8014BF87CBC46@SAFEX1MAIL2.st.com>
References: <201308301501.25164.hverkuil@xs4all.nl>
 <1440169.4erfBAv8If@avalon>
 <CACHYQ-qDD5S5FJvzT-oUBe+Y+S=CB_ZN+QNQPpu+BFE-ZPr45g@mail.gmail.com>
 <1590738.js4VoLrYFn@avalon>
 <CA+M3ks7whrGtkboVcstoEQBRTkiLGF7Hf9nEsYEkyUD6=QPG9w@mail.gmail.com>
 <20130904074829.7ea2bfa6@samsung.com>
In-Reply-To: <20130904074829.7ea2bfa6@samsung.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

For floating point issue, we have not encountered such issue while integrating various codec (currently H264, MPEG4, VP8 of both Google G1 IP & ST IPs), could you precise which codec you experienced which required FP support ?

For user-space library, problem we encountered is that interface between parsing side (for ex. H264 SPS/PPS decoding, slice header decoding, references frame list management, ...moreover all that is needed to prepare hardware IPs call) and decoder side (hardware IPs handling) is not standardized and differs largely regarding IPs or CPU/copro partitioning.
This means that even if we use the standard V4L2 capture interface to inject video bitstream (H264 access units for ex), some proprietary meta are needed to be attached to each buffers, making de facto "un-standard" the V4L2 interface for this driver.
Exynos S5P MFC is not attaching any meta to capture input buffers, keeping a standard video bitstream injection interface (what is output naturally by well-known standard demuxers such as gstreamer ones or Android Stagefright ones).
This is the way we want to go, we will so keep hardware details at kernel driver side. 
On the other hand, this simplify drastically the integration of our video drivers on user-land multimedia middleware, reducing the time to market and support needed when reaching our end-customers. Our target is to create a unified gstreamer V4L2 decoder(encoder) plugin and a unified OMX V4L2 decoder(encoder) to fit Android, based on a single V4L2 M2M API whatever hardware IP is.

About mini summit, Benjamin and I are checking internally how to attend to discuss this topic. We think that about half a day is needed to discuss this, we can so share our code and discuss about other codebase you know dealing with video codecs.


Best regards,
Hugues.
