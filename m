Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:40991 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752100Ab2EAUVR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 1 May 2012 16:21:17 -0400
Received: by qafi31 with SMTP id i31so1817880qaf.8
        for <linux-media@vger.kernel.org>; Tue, 01 May 2012 13:21:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FA042D8.207@gmail.com>
References: <CAKnK67T3q7Qpv0YUFQT4cvGGtdRtZr=8oiVk57m0McJmJXaFrw@mail.gmail.com>
 <4FA042D8.207@gmail.com>
From: "Aguirre, Sergio" <saaguirre@ti.com>
Date: Tue, 1 May 2012 15:20:53 -0500
Message-ID: <CAKnK67TzrMe1S=9KvVzr7jxcFkA7RknOvpSbFyjjeepxVah9Pw@mail.gmail.com>
Subject: Re: [Query] About V4L2_CAP_VIDEO_CAPTURE_MPLANE device types
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Thanks for the very informative reply!

On Tue, May 1, 2012 at 3:08 PM, Sylwester Nawrocki <snjw23@gmail.com> wrote:
> Hi Sergio,
>
> On 05/01/2012 09:08 PM, Aguirre, Sergio wrote:
>> Hi all,
>>
>> I wonder if there's an example app for v4l2 devices with
>> V4L2_CAP_VIDEO_CAPTURE_MPLANE capability?
>> (like capture.c in V4L2 API docs)
>
> There isn't at the V4L2 API docs, it probably makes sense to add one though.
> I'll try to find a time to prepare a patch for that. A very simple application
> with V4L2_CAP_VIDEO_CAPTURE_MPLANE support can be found here:
> http://thread.gmane.org/gmane.comp.video.dri.devel/65997
>
> It might be not that straightforward since there is the DMABUF memory type
> used. Some more applications using multi-plane API are available at:
> http://git.infradead.org/users/kmpark/public-apps
>
> An MMAP memory example can be found here:
> http://git.infradead.org/users/kmpark/public-apps/blob/9c057b001e8873861a70f7025214003837a0860b:/v4l2-mfc-example/mfc.c
>
> Please see mfc_dec_setup_capture function.

Thanks. I'll check these links in detail.

>
>> Also, does it have to be mutually exclusive with a
>> V4L2_CAP_VIDEO_CAPTURE device?
>
> No, the driver could support both. But it generally makes sense to implement
> only _mplane ioctls at drivers. The multi/single-plane conversion should be
> done in user space. There were some patches for libv4l to support that
> (http://www.spinics.net/lists/linux-media/msg35080.html), but such conversions
> are not yet supported in the v4l libraries yet AFAIK.

Ok. Got it.

>
> I'm also not sure how is V4L2_CAP_VIDEO_CAPTURE_MPLANE handled in standard
> GStreamer plugins like v4l2src at the moment, having only multi-plane
> interface at the driver might cause additional problems there.

Ok. I guess that's why i was concerned on keeping the non-mplane
support coexisting with this.

Thanks again for your time!

Regards,
Sergio

>
> --
>
> Regards,
> Sylwester
