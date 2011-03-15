Return-path: <mchehab@pedra>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4136 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab1COHvF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Mar 2011 03:51:05 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Pawel Osciak <pawel@osciak.com>
Subject: Re: [Query] VIDIOC_QBUF and VIDIOC_STREAMON order
Date: Tue, 15 Mar 2011 08:50:45 +0100
Cc: subash.rp@gmail.com, Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Subash Patel <subashrp@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <4D7DEA68.2050604@samsung.com> <AANLkTimA070CdJxDR5A7Yq_e6cRG_0TUFG3Cf1VCBbCh@mail.gmail.com> <AANLkTinE_Z3QDWDB1+w1ih0bQ2dC15ynkprqB-nFPeqd@mail.gmail.com>
In-Reply-To: <AANLkTinE_Z3QDWDB1+w1ih0bQ2dC15ynkprqB-nFPeqd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103150850.45961.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday, March 15, 2011 04:21:05 Pawel Osciak wrote:
> Hi,
> 
> On Mon, Mar 14, 2011 at 03:49, Subash Patel <subashrp@gmail.com> wrote:
> > VIDIOC_STREAMON expects buffers to be queued before hardware part of
> > image/video pipe is enabled. From my experience of V4L2 user space, I
> > have always QBUFfed before invoking the STREAMON. Below is the API
> > specification which also speaks something same:
> >
> 
> Not exactly. It says that the API requires buffers to be queued for
> output devices. It does not require any buffers to be queued for input
> devices. Sylwester is right here.
> 
> This feature of not having to queue input buffers before STREAMON
> introduces problems to driver implementations and I am personally not
> a big fan of it either. But I'm seeing some additional problems here.
> Suppose we forced QBUF to be done before STREAMON. This would work,
> but what happens next? What should happen when we want to DQBUF the
> last buffer? If the device couldn't start without any buffers queued,
> can it continue streaming with all of them dequeued? I would guess
> not. So we'd either have to deny DQBUF of the last buffer (which for
> me personally is almost unacceptable) or have the last DQBUF
> automatically cause a STREAMOFF. So, for the latter, should
> applications, after they get all the data they wanted, be made to
> always have one more buffer queued as a "throwaway" buffer? This is
> probably the only reasonable solution here, but the applications would
> have to keep count of their queued buffers and be aware of this.
> Also, there might still be situations where being able to STREAMON
> without buffers queued would be beneficial. For example, enabling the
> device might be a slow/expensive operation and we might prefer to keep
> it running even if we don't want any data at the moment. Even for
> faster devices, being able to keep them on and periodically take a
> snapshot would be faster without having to call STREAMON anyway...

The problem is that what is possible is highly hardware dependent. All video
capture device I know of (composite in, HDMI in, etc) require that buffers
are queued and they won't release that buffer to userspace until a new free
buffer is available. They DMA continuously and stopping the DMA at the last
buffer and restarting it when a new one appears tends to be too expensive
and leads to additional loss of frames.

In part how this should act depends on the use-case: if you are streaming
video, then requiring buffers to be present before STREAMON and holding on
to a buffer if userspace can't keep up seems quite reasonable to me.

But for snapshot and codec type streams this behavior doesn't make sense.
The main difference is that in this case the DMA is not driven by an external
input, but by internal (userspace) demand.

Something for our meeting to discuss.

Regards,

	Hans

> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
