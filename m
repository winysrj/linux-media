Return-path: <mchehab@pedra>
Received: from mailout1.samsung.com ([203.254.224.24]:23854 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755125Ab1CVX6y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2011 19:58:54 -0400
Received: from epmmp1 (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LIH00AHLHA4E900@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 Mar 2011 08:58:52 +0900 (KST)
Received: from JONGHUNHA11 ([12.23.103.140])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LIH002LWH9YTR@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 Mar 2011 08:58:52 +0900 (KST)
Date: Wed, 23 Mar 2011 08:58:45 +0900
From: Jonghun Han <jonghun.han@samsung.com>
Subject: RE: [Query] VIDIOC_QBUF and VIDIOC_STREAMON order
In-reply-to: <201103221153.43729.laurent.pinchart@ideasonboard.com>
To: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	'Hans Verkuil' <hverkuil@xs4all.nl>
Cc: 'Pawel Osciak' <pawel@osciak.com>, subash.rp@gmail.com,
	'Sylwester Nawrocki' <s.nawrocki@samsung.com>,
	'Subash Patel' <subashrp@gmail.com>,
	linux-media@vger.kernel.org
Message-id: <000001cbe8ed$1a95cff0$4fc16fd0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
References: <4D7DEA68.2050604@samsung.com>
 <AANLkTinE_Z3QDWDB1+w1ih0bQ2dC15ynkprqB-nFPeqd@mail.gmail.com>
 <201103150850.45961.hverkuil@xs4all.nl>
 <201103221153.43729.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi all,

On Tuesday, March 22, 2011 7:54 PM Laurent Pinchart wrote:
> On Tuesday 15 March 2011 08:50:45 Hans Verkuil wrote:
> > On Tuesday, March 15, 2011 04:21:05 Pawel Osciak wrote:
> > > On Mon, Mar 14, 2011 at 03:49, Subash Patel <subashrp@gmail.com>
wrote:
> > > > VIDIOC_STREAMON expects buffers to be queued before hardware part
> > > > of image/video pipe is enabled. From my experience of V4L2 user
> > > > space, I have always QBUFfed before invoking the STREAMON. Below
> > > > is the API
> > >
> > > > specification which also speaks something same:
> > > Not exactly. It says that the API requires buffers to be queued for
> > > output devices. It does not require any buffers to be queued for
> > > input devices. Sylwester is right here.
> > >
> > > This feature of not having to queue input buffers before STREAMON
> > > introduces problems to driver implementations and I am personally
> > > not a big fan of it either. But I'm seeing some additional problems
here.
> > > Suppose we forced QBUF to be done before STREAMON. This would work,
> > > but what happens next? What should happen when we want to DQBUF the
> > > last buffer? If the device couldn't start without any buffers
> > > queued, can it continue streaming with all of them dequeued? I would
> > > guess not. So we'd either have to deny DQBUF of the last buffer
> > > (which for me personally is almost unacceptable) or have the last
> > > DQBUF automatically cause a STREAMOFF. So, for the latter, should
> > > applications, after they get all the data they wanted, be made to
> > > always have one more buffer queued as a "throwaway" buffer? This is
> > > probably the only reasonable solution here, but the applications
> > > would have to keep count of their queued buffers and be aware of this.
> > > Also, there might still be situations where being able to STREAMON
> > > without buffers queued would be beneficial. For example, enabling
> > > the device might be a slow/expensive operation and we might prefer
> > > to keep it running even if we don't want any data at the moment.
> > > Even for faster devices, being able to keep them on and periodically
> > > take a snapshot would be faster without having to call STREAMON
anyway...
> >
> > The problem is that what is possible is highly hardware dependent. All
> > video capture device I know of (composite in, HDMI in, etc) require
> > that buffers are queued and they won't release that buffer to
> > userspace until a new free buffer is available.
> 
> That's funny, all video capture devices I know of behave the opposite way
:-)
> They either pause the stream when they run out of buffers and resume it
when
> a new buffer gets queued, or they throw away the data when intermediate
> buffers are used (such as with USB devices).
> 

Laurent,
Exynos capture device is the same with your example.
It should pause the stream not to overwrite
when they run out of buffers and resume it when a new buffer gets queued.

Hans,
Do you mean that the buffer is overwritten without pause and resume
until a new free buffer is coming ?

> > They DMA continuously and stopping the DMA at the last buffer and
> > restarting it when a new one appears tends to be too expensive and
> > leads to additional loss of frames.
> >
> > In part how this should act depends on the use-case: if you are
> > streaming video, then requiring buffers to be present before STREAMON
> > and holding on to a buffer if userspace can't keep up seems quite
> reasonable to me.
> >
> > But for snapshot and codec type streams this behavior doesn't make
sense.
> > The main difference is that in this case the DMA is not driven by an
> > external input, but by internal (userspace) demand.
> >
> > Something for our meeting to discuss.
> 
> --
> Regards,
> 
> Laurent Pinchart
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html

Best regards,

Jonghun Han


