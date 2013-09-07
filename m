Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f182.google.com ([209.85.216.182]:51067 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab3IGJcA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Sep 2013 05:32:00 -0400
Received: by mail-qc0-f182.google.com with SMTP id k18so1906423qcv.41
        for <linux-media@vger.kernel.org>; Sat, 07 Sep 2013 02:31:59 -0700 (PDT)
Received: by mail-qa0-f41.google.com with SMTP id hu16so970247qab.14
        for <linux-media@vger.kernel.org>; Sat, 07 Sep 2013 02:31:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4141987.vP8rY59Aji@avalon>
References: <201308301501.25164.hverkuil@xs4all.nl> <20130904074829.7ea2bfa6@samsung.com>
 <7020EDD3BA6FF244B3C070FA4F02B1D8014BF87CBC46@SAFEX1MAIL2.st.com> <4141987.vP8rY59Aji@avalon>
From: Pawel Osciak <posciak@chromium.org>
Date: Sat, 7 Sep 2013 18:31:17 +0900
Message-ID: <CACHYQ-pPNx7WokQhALEdXaG0+Fv-sK2E0QVkSxvte6UxUHypeg@mail.gmail.com>
Subject: Re: [media-workshop] Agenda for the Edinburgh mini-summit
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hugues FRUCHET <hugues.fruchet@st.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	media-workshop <media-workshop@linuxtv.org>,
	Oliver Schinagl <oliver+list@schinagl.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 6, 2013 at 10:45 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> Hi Hugues,
>
> On Thursday 05 September 2013 13:37:49 Hugues FRUCHET wrote:
> > Hi Mauro,
> >
> > For floating point issue, we have not encountered such issue while
> > integrating various codec (currently H264, MPEG4, VP8 of both Google G1 IP &
> > ST IPs), could you precise which codec you experienced which required FP
> > support ?
> >
> > For user-space library, problem we encountered is that interface between
> > parsing side (for ex. H264 SPS/PPS decoding, slice header decoding,
> > references frame list management, ...moreover all that is needed to prepare
> > hardware IPs call) and decoder side (hardware IPs handling) is not
> > standardized and differs largely regarding IPs or CPU/copro partitioning.
> > This means that even if we use the standard V4L2 capture interface to inject
> > video bitstream (H264 access units for ex), some proprietary meta are needed
> > to be attached to each buffers, making de facto "un-standard" the V4L2
> > interface for this driver.
>
> We're working on APIs to pass meta data from/to the kernel. The necessary
> infrastructure is more or less there already, we "just" need to agree on
> guidelines and standardize the process. One option that will likely be
> implemented is to store meta-data in a plane, using the multiplanar API.


What API is that? Is there an RFC somewhere?

> The resulting plane format will be driver-specific, so we'll loose part of the
> benefits that the V4L2 API provides. We could try to solve this by writing a
> libv4l plugin, specific to your driver, that would handle bitstream parsing
> and fill the meta-data planes correctly. Applications using libv4l would thus
> only need to pass encoded frames to the library, which would create
> multiplanar buffers with video data and meta-data, and pass them to the
> driver. This would be fully transparent for the application.

If V4L2 API is not hardware-independent, it's a big loss. If this
happens, there will be need for another, middleware API, like OMX IL.
This makes V4L2 by itself impractical for real world applications. And
the incentives of using V4L2 are gone, because it's much easier to
write a custom DRM driver and add any userspace API on top of it.
Perhaps this is inevitable, given differences in hardware, but a
plugin approach would be a way to keep V4L2 abstract and retain the
ability to do the bulk of processing in userspace...
