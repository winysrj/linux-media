Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:62594 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbZJEOJE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Oct 2009 10:09:04 -0400
Received: from epmmp1 (mailout2.samsung.com [203.254.224.25])
 by mailout1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KR100HDIO4LT9@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 05 Oct 2009 22:57:58 +0900 (KST)
Received: from AMDC159 ([106.116.37.153])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0KR1005XTO4B8B@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 05 Oct 2009 22:57:57 +0900 (KST)
Date: Mon, 05 Oct 2009 15:56:21 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: Mem2Mem V4L2 devices [RFC]
In-reply-to: <19F8576C6E063C45BE387C64729E73940436CF8DCB@dbde02.ent.ti.com>
To: "'Hiremath, Vaibhav'" <hvaibhav@ti.com>,
	"'Ivan T. Ivanov'" <iivanov@mm-sol.com>,
	linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, Tomasz Fujak <t.fujak@samsung.com>,
	Pawel Osciak <p.osciak@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <001801ca45c3$a14826c0$e3d87440$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <E4D3F24EA6C9E54F817833EAE0D912AC077151C64F@bssrvexch01.BS.local>
 <1254500705.16625.35.camel@iivanov.int.mm-sol.com>
 <19F8576C6E063C45BE387C64729E73940436CF8DCB@dbde02.ent.ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Monday, October 05, 2009 7:59 AM Hiremath, Vaibhav wrote:

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-owner@vger.kernel.org] On Behalf Of
> Hiremath, Vaibhav
> Sent: Monday, October 05, 2009 7:59 AM
> To: Ivan T. Ivanov; Marek Szyprowski
> Cc: linux-media@vger.kernel.org; kyungmin.park@samsung.com; Tomasz Fujak; Pawel Osciak
> Subject: RE: Mem2Mem V4L2 devices [RFC]
> 
> 
> > -----Original Message-----
> > From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> > owner@vger.kernel.org] On Behalf Of Ivan T. Ivanov
> > Sent: Friday, October 02, 2009 9:55 PM
> > To: Marek Szyprowski
> > Cc: linux-media@vger.kernel.org; kyungmin.park@samsung.com; Tomasz
> > Fujak; Pawel Osciak
> > Subject: Re: Mem2Mem V4L2 devices [RFC]
> >
> >
> > Hi Marek,
> >
> >
> > On Fri, 2009-10-02 at 13:45 +0200, Marek Szyprowski wrote:
> > > Hello,
> > >
> <snip>
> 
> > > image format and size, while the existing v4l2 ioctls would only
> > refer
> > > to the output buffer. Frankly speaking, we don't like this idea.
> >
> > I think that is not unusual one video device to define that it can
> > support at the same time input and output operation.
> >
> > Lets take as example resizer device. it is always possible that it
> > inform user space application that
> >
> > struct v4l2_capability.capabilities ==
> > 		(V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT)
> >
> > User can issue S_FMT ioctl supplying
> >
> > struct v4l2_format.type = V4L2_BUF_TYPE_VIDEO_CAPTURE
> > 		  .pix  = width x height
> >
> > which will instruct this device to prepare its output for this
> > resolution. after that user can issue S_FMT ioctl supplying
> >
> > struct v4l2_format.type = V4L2_BUF_TYPE_VIDEO_OUTPUT
> >    		  .pix  = width x height
> >
> > using only these ioctls should be enough to device driver
> > to know down/up scale factor required.
> >
> > regarding color space struct v4l2_pix_format have field
> > 'pixelformat'
> > which can be used to define input and output buffers content.
> > so using only existing ioctl's user can have working resizer device.
> >
> > also please note that there is VIDIOC_S_CROP which can add
> > additional
> > flexibility of adding cropping on input or output.
> >
> [Hiremath, Vaibhav] I think this makes more sense in capture pipeline, for example,
> 
> Sensor/decoder -> previewer -> resizer -> /dev/videoX
> 

I don't get this. In strictly capture pipeline we will get one video node anyway. 

However the question is how we should support a bit more complicated pipeline.

Just consider a resizer module and the pipeline:

sensor/decoder -[bus]-> previewer -> [memory] -> resizer -> [memory]

([bus] means some kind of internal bus that is completely interdependent from the system memory)

Mapping to video nodes is not so trivial. In fact this pipeline consist of 2 independent (sub)pipelines connected by user space
application:

sensor/decoder -[bus]-> previewer -> [memory] -[user application]-> [memory] -> resizer -> [memory]

For further analysis it should be cut into 2 separate pipelines: 

a. sensor/decoder -[bus]-> previewer -> [memory]
b. [memory] -> resizer -> [memory]

Again, mapping the first subpipeline is trivial:

sensor/decoder -[bus]-> previewer -> /dev/video0

But the last, can be mapped either as:

/dev/video1 -> resizer -> /dev/video1
(one video node approach)

or

/dev/video1 -> resizer -> /dev/video2
(2 video nodes approach).


So at the end the pipeline would look like this:

sensor/decoder -[bus]-> previewer -> /dev/video0 -[user application]-> /dev/video1 -> resizer -> /dev/video2

or 

sensor/decoder -[bus]-> previewer -> /dev/video0 -[user application]-> /dev/video1 -> resizer -> /dev/video1

> > last thing which should be done is to QBUF 2 buffers and call
> > STREAMON.
> >
> [Hiremath, Vaibhav] IMO, this implementation is not streaming model, we are trying to fit mem-to-mem
> forcefully to streaming.

Why this does not fit streaming? I see no problems with streaming over mem2mem device with only one video node. You just queue input
and output buffers (they are distinguished by 'type' parameter) on the same video node.

> We have to put some constraints -
> 
> 	- Driver will treat index 0 as input always, irrespective of number of buffers queued.
> 	- Or, application should not queue more that 2 buffers.
> 	- Multi-channel use-case????
> 
> I think we have to have 2 device nodes which are capable of streaming multiple buffers, both are
> queuing the buffers.

In one video node approach there can be 2 buffer queues in one video node, for input and output respectively.

> The constraint would be the buffers must be mapped one-to-one.

Right, each queued input buffer must have corresponding output buffer.

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center


