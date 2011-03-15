Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:41059 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756929Ab1COKwx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Mar 2011 06:52:53 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Received: from spt2.w1.samsung.com ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LI30098JI82BS60@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 15 Mar 2011 10:52:50 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LI300E2DI815Y@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 15 Mar 2011 10:52:50 +0000 (GMT)
Date: Tue, 15 Mar 2011 11:52:49 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [Query] VIDIOC_QBUF and VIDIOC_STREAMON order
In-reply-to: <AANLkTikBkPjy4jui1EjGULPFbUZxKK_ydaUqk7niFDxQ@mail.gmail.com>
To: subash.rp@gmail.com
Cc: Pawel Osciak <pawel@osciak.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Message-id: <4D7F4501.2010009@samsung.com>
References: <4D7DEA68.2050604@samsung.com>
 <AANLkTikBkPjy4jui1EjGULPFbUZxKK_ydaUqk7niFDxQ@mail.gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Subash,

thanks for your comments.

On 03/14/2011 11:44 AM, Subash Patel wrote:
> VIDIOC_STREAMON expects buffers to be queued before hardware part of
> image/video pipe is enabled. From my experience of V4L2 user space, I have
> always QBUFfed before invoking the STREAMON. Below is the API specification
> which also speaks something same:
>  
> http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-streamon.html
>  

It seems pretty reasonable thing to do in the application, i.e. queue buffer(s)
first. If the device needs buffers to work what STREAMON before QBUF would be
supposed to mean? The application must be aware then that real start of data flow
in the hardware pipeline is being done at the first QBUF. This is not obvious at
all from the current specification.

> I think its better to return EINVAL if there are no queued buffers
> when VIDIOC_STREAMON is invoked.

Unfortunately, as Pawel pointed out the are are some further logic implications
of such approach. Anyway we can handle both QBUF, STREAMON orders in the kernel,
it just makes life a bit harder. 

Adhering exactly to current videobuf2 rules it is not possible to return EINVAL
if there is no buffers QBUFed when invoking STREAMON. And we are going to need
to be able to return an error in buf_queue which could be then propagated up
to the STREAMON caller. This has already been raised in 
"[RFC/PATCH 1/2] v4l: videobuf2: Handle buf_queue errors" from Laurent.

Regards,
Sylwester

>  
> Regards,
> Subash
> 
> On Mon, Mar 14, 2011 at 3:44 PM, Sylwester Nawrocki <s.nawrocki@samsung.com
> <mailto:s.nawrocki@samsung.com>> wrote:
> 
>     Hello,
> 
>     As far as I know V4L2 applications are allowed to call VIDIOC_STREAMON before
>     queuing buffers with VIDIOC_QBUF.
> 
>     This leads to situation that a H/W is attempted to be enabled by the driver
>     when it has no any buffer ownership.
> 
>     Effectively actual activation of the data pipeline has to be deferred
>     until first buffer arrived in the driver. Which makes it difficult
>     to signal any errors to user during enabling the data pipeline.
> 
>     Is this allowed to force applications to queue some buffers before calling
>     STREAMON, by returning an error in vidioc_streamon from the driver, when
>     no buffers have been queued at this time?
> 
>     I suppose this could render some applications to stop working if this kind
>     of restriction is applied e.g. in camera capture driver.
> 
>     What the applications really expect?
> 
>     With the above I refer mostly to a snapshot mode where we have to be careful
>     not to lose any frame, as there could be only one..
> 
> 
>     Please share you opinions.
