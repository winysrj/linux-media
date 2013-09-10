Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52394 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab3IJJoi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Sep 2013 05:44:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Pawel Osciak <posciak@chromium.org>
Cc: Hugues FRUCHET <hugues.fruchet@st.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	media-workshop <media-workshop@linuxtv.org>,
	Oliver Schinagl <oliver+list@schinagl.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: Re: [media-workshop] Agenda for the Edinburgh mini-summit
Date: Tue, 10 Sep 2013 11:44:35 +0200
Message-ID: <20279051.9lvO0TtBRq@avalon>
In-Reply-To: <CACHYQ-pPNx7WokQhALEdXaG0+Fv-sK2E0QVkSxvte6UxUHypeg@mail.gmail.com>
References: <201308301501.25164.hverkuil@xs4all.nl> <4141987.vP8rY59Aji@avalon> <CACHYQ-pPNx7WokQhALEdXaG0+Fv-sK2E0QVkSxvte6UxUHypeg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pawel,

On Saturday 07 September 2013 18:31:17 Pawel Osciak wrote:
> On Fri, Sep 6, 2013 at 10:45 PM, Laurent Pinchart wrote:
> > On Thursday 05 September 2013 13:37:49 Hugues FRUCHET wrote:
> > > Hi Mauro,
> > > 
> > > For floating point issue, we have not encountered such issue while
> > > integrating various codec (currently H264, MPEG4, VP8 of both Google G1
> > > IP & ST IPs), could you precise which codec you experienced which
> > > required FP support ?
> > > 
> > > For user-space library, problem we encountered is that interface between
> > > parsing side (for ex. H264 SPS/PPS decoding, slice header decoding,
> > > references frame list management, ...moreover all that is needed to
> > > prepare hardware IPs call) and decoder side (hardware IPs handling) is
> > > not standardized and differs largely regarding IPs or CPU/copro
> > > partitioning. This means that even if we use the standard V4L2 capture
> > > interface to inject video bitstream (H264 access units for ex), some
> > > proprietary meta are needed to be attached to each buffers, making de
> > > facto "un-standard" the V4L2 interface for this driver.
> > 
> > We're working on APIs to pass meta data from/to the kernel. The necessary
> > infrastructure is more or less there already, we "just" need to agree on
> > guidelines and standardize the process. One option that will likely be
> > implemented is to store meta-data in a plane, using the multiplanar API.
> 
> What API is that? Is there an RFC somewhere?

It has been discussed recently as part of the frame descriptors RFC 
(http://www.spinics.net/lists/linux-media/msg67295.html).

> > The resulting plane format will be driver-specific, so we'll loose part of
> > the benefits that the V4L2 API provides. We could try to solve this by
> > writing a libv4l plugin, specific to your driver, that would handle
> > bitstream parsing and fill the meta-data planes correctly. Applications
> > using libv4l would thus only need to pass encoded frames to the library,
> > which would create multiplanar buffers with video data and meta-data, and
> > pass them to the driver. This would be fully transparent for the
> > application.
> 
> If V4L2 API is not hardware-independent, it's a big loss. If this happens,
> there will be need for another, middleware API, like OMX IL. This makes V4L2
> by itself impractical for real world applications. And the incentives of
> using V4L2 are gone, because it's much easier to write a custom DRM driver
> and add any userspace API on top of it. Perhaps this is inevitable, given
> differences in hardware, but a plugin approach would be a way to keep V4L2
> abstract and retain the ability to do the bulk of processing in userspace...

I believe we can reach that goal with libv4l. The V4L2 kernel API can't 
abstract all hardware features, as this would require an API level that can't 
be properly implemented in kernel space, but with libv4l to the rescue we 
should be pretty good.

-- 
Regards,

Laurent Pinchart

