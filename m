Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:51610 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbaEOPR3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 May 2014 11:17:29 -0400
From: Kamil Debski <k.debski@samsung.com>
To: 'Arun Kumar K' <arun.kk@samsung.com>,
	'Hans Verkuil' <hverkuil@xs4all.nl>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	sachin.kamat@linaro.org, arunkk.samsung@gmail.com
References: <1400048996-726-1-git-send-email-arun.kk@samsung.com>
 <53731693.80002@xs4all.nl> <537324E5.3030704@samsung.com>
In-reply-to: <537324E5.3030704@samsung.com>
Subject: RE: [PATCH v2] [media] s5p-mfc: Dequeue sequence header after STREAMON
Date: Thu, 15 May 2014 17:17:42 +0200
Message-id: <047d01cf7050$d1943780$74bca680$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Arun Kumar K
> Sent: Wednesday, May 14, 2014 10:10 AM
> 
> Hi Hans,
> 
> On 05/14/14 12:39, Hans Verkuil wrote:
> > On 05/14/2014 08:29 AM, Arun Kumar K wrote:
> >> MFCv6 encoder needs specific minimum number of buffers to be queued
> >> in the CAPTURE plane. This minimum number will be known only when
> the
> >> sequence header is generated.
> >> So we used to allow STREAMON on the CAPTURE plane only after
> sequence
> >> header is generated and checked with the minimum buffer requirement.
> >>
> >> But this causes a problem that we call a vb2_buffer_done for the
> >> sequence header buffer before doing a STREAON on the CAPTURE plane.
> >
> > How could this ever have worked? Buffers aren't queued to the driver
> > until STREAMON is called, and calling vb2_buffer_done for a buffer
> > that is not queued first to the driver will mess up internal data (q-
> >queued_count for one).
> >
> 
> This worked till now because __enqueue_in_driver is called first and
> then start_streaming qop is called. In MFCv6, the start_streaming
> driver callback used to wait till sequence header interrupt is received
> and it used to do vb2_buffer_done in that interrupt context. So it
> happened after buffers are enqueued in driver and before completing the
> vb2_streamon.
> 
> >> This used to still work fine until this patch was merged -
> >> b3379c6 : vb2: only call start_streaming if sufficient buffers are
> >> queued
> >
> > Are you testing with CONFIG_VIDEO_ADV_DEBUG set? If not, you should
> do
> > so. That will check whether all the vb2 calls are balanced.
> >
> > BTW, that's a small typo in s5p_mfc_enc.c (search for 'inavlid').
> >
> 
> I got it. Will post a patch fixing them. Thanks for spotting this.
> 
> >> This problem should also come in earlier MFC firmware versions if
> the
> >> application calls STREAMON on CAPTURE with some delay after doing
> >> STREAMON on OUTPUT.
> >
> > You can also play around with the min_buffers_needed field. My
> > rule-of-thumb is that when start_streaming is called everything
> should
> > be ready to stream. It is painful for drivers to have to keep track
> of the 'do I have enough buffers' status.
> >
> > For that reason I introduced the min_buffers_needed field. What I
> > believe you can do here is to set it initially to a large value,
> > preventing start_streaming from being called, and once you really
> know
> > the minimum number of buffers that you need it can be updated again
> to the actual value.
> 
> If a large value is kept in min_buffers_needed, there will be some
> unnecessary memory initialization needed for say 16 full HD raw YUV
> buffers when actual needed is only 4. And once the encoding is started,
> updating the min_buffers_needed to actual value doesnt give any
> advantage as nobody checks for it after that.
> So the whole idea is to not enforce a worst case buffer allocation
> requirement beforehand itself. I hope the current scheme of things
> works well for the requirement.

I was looking in the code of the MFC encoder and handling of this situation
seems wrong to me.

You say that a minimum number of buffers has to be queued for MFC encoder to
work. But this number is not checked in s5p_mfc_ctx_ready in s5p_mfc_enc.c.

It is only checked during reqbufs. This way it does not ensure that there is
a minimum number of buffers queued.

Also there is a control V4L2_CID_MIN_BUFFERS_FOR_CAPTURE, maybe it could be
used
in this context?

Another thing - you say that header is generated to a CAPTURE buffer before
STREAMON on CAPTURE was done. Is this correct? Can the hardware/driver write
to a queued buffer without streaming enabled? Hans, Sylwester?

Arun, is there a way to guess the needed number of buffers from controls?
Isn't this
related with number of B frames? I understand how this affects the number of
buffers for OUTPUT, but I thought that a single CAPTURE buffer is always
enough.
I understood that a generated compressed stream is no longer used after it
was
created and its processing is finished.

I think we need some discussion on this patch.
 
Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland



