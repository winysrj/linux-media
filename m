Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:65516 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab2EAUI7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 May 2012 16:08:59 -0400
Received: by bkcji2 with SMTP id ji2so1171251bkc.19
        for <linux-media@vger.kernel.org>; Tue, 01 May 2012 13:08:57 -0700 (PDT)
Message-ID: <4FA042D8.207@gmail.com>
Date: Tue, 01 May 2012 22:08:56 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: "Aguirre, Sergio" <saaguirre@ti.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [Query] About V4L2_CAP_VIDEO_CAPTURE_MPLANE device types
References: <CAKnK67T3q7Qpv0YUFQT4cvGGtdRtZr=8oiVk57m0McJmJXaFrw@mail.gmail.com>
In-Reply-To: <CAKnK67T3q7Qpv0YUFQT4cvGGtdRtZr=8oiVk57m0McJmJXaFrw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergio,

On 05/01/2012 09:08 PM, Aguirre, Sergio wrote:
> Hi all,
> 
> I wonder if there's an example app for v4l2 devices with
> V4L2_CAP_VIDEO_CAPTURE_MPLANE capability?
> (like capture.c in V4L2 API docs)
 
There isn't at the V4L2 API docs, it probably makes sense to add one though.
I'll try to find a time to prepare a patch for that. A very simple application
with V4L2_CAP_VIDEO_CAPTURE_MPLANE support can be found here:
http://thread.gmane.org/gmane.comp.video.dri.devel/65997

It might be not that straightforward since there is the DMABUF memory type
used. Some more applications using multi-plane API are available at:
http://git.infradead.org/users/kmpark/public-apps

An MMAP memory example can be found here:
http://git.infradead.org/users/kmpark/public-apps/blob/9c057b001e8873861a70f7025214003837a0860b:/v4l2-mfc-example/mfc.c

Please see mfc_dec_setup_capture function.

> Also, does it have to be mutually exclusive with a
> V4L2_CAP_VIDEO_CAPTURE device?

No, the driver could support both. But it generally makes sense to implement
only _mplane ioctls at drivers. The multi/single-plane conversion should be 
done in user space. There were some patches for libv4l to support that
(http://www.spinics.net/lists/linux-media/msg35080.html), but such conversions
are not yet supported in the v4l libraries yet AFAIK.

I'm also not sure how is V4L2_CAP_VIDEO_CAPTURE_MPLANE handled in standard 
GStreamer plugins like v4l2src at the moment, having only multi-plane
interface at the driver might cause additional problems there.

--

Regards,
Sylwester
