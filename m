Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:57415 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbZJES2T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Oct 2009 14:28:19 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	"'Ivan T. Ivanov'" <iivanov@mm-sol.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	Tomasz Fujak <t.fujak@samsung.com>,
	Pawel Osciak <p.osciak@samsung.com>
Date: Mon, 5 Oct 2009 23:57:28 +0530
Subject: RE: Mem2Mem V4L2 devices [RFC]
Message-ID: <19F8576C6E063C45BE387C64729E73940436CF8FE8@dbde02.ent.ti.com>
References: <E4D3F24EA6C9E54F817833EAE0D912AC077151C64F@bssrvexch01.BS.local>
 <1254500705.16625.35.camel@iivanov.int.mm-sol.com>
 <19F8576C6E063C45BE387C64729E73940436CF8DCB@dbde02.ent.ti.com>
 <001801ca45c3$a14826c0$e3d87440$%szyprowski@samsung.com>
In-Reply-To: <001801ca45c3$a14826c0$e3d87440$%szyprowski@samsung.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> -----Original Message-----
> From: Marek Szyprowski [mailto:m.szyprowski@samsung.com]
> Sent: Monday, October 05, 2009 7:26 PM
> To: Hiremath, Vaibhav; 'Ivan T. Ivanov'; linux-media@vger.kernel.org
> Cc: kyungmin.park@samsung.com; Tomasz Fujak; Pawel Osciak; Marek
> Szyprowski
> Subject: RE: Mem2Mem V4L2 devices [RFC]
> 
> Hello,
> 
> On Monday, October 05, 2009 7:59 AM Hiremath, Vaibhav wrote:
> 
> > -----Original Message-----
> > From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of
> > Hiremath, Vaibhav
> > Sent: Monday, October 05, 2009 7:59 AM
> > To: Ivan T. Ivanov; Marek Szyprowski
> > Cc: linux-media@vger.kernel.org; kyungmin.park@samsung.com; Tomasz
> Fujak; Pawel Osciak
> > Subject: RE: Mem2Mem V4L2 devices [RFC]
> >
> >
> > > -----Original Message-----
> > > From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> > > owner@vger.kernel.org] On Behalf Of Ivan T. Ivanov
> > > Sent: Friday, October 02, 2009 9:55 PM
> > > To: Marek Szyprowski
> > > Cc: linux-media@vger.kernel.org; kyungmin.park@samsung.com;
> Tomasz
> > > Fujak; Pawel Osciak
> > > Subject: Re: Mem2Mem V4L2 devices [RFC]
> > >
> > >
> > > Hi Marek,
> > >
> > >
> > > On Fri, 2009-10-02 at 13:45 +0200, Marek Szyprowski wrote:
> > > > Hello,
> > > >
> > <snip>
> >
> > > > image format and size, while the existing v4l2 ioctls would
> only
> > > refer
> > > > to the output buffer. Frankly speaking, we don't like this
> idea.
> > >
> > > I think that is not unusual one video device to define that it
> can
> > > support at the same time input and output operation.
> > >
> > > Lets take as example resizer device. it is always possible that
> it
> > > inform user space application that
> > >
> > > struct v4l2_capability.capabilities ==
> > > 		(V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT)
> > >
> > > User can issue S_FMT ioctl supplying
> > >
> > > struct v4l2_format.type = V4L2_BUF_TYPE_VIDEO_CAPTURE
> > > 		  .pix  = width x height
> > >
> > > which will instruct this device to prepare its output for this
> > > resolution. after that user can issue S_FMT ioctl supplying
> > >
> > > struct v4l2_format.type = V4L2_BUF_TYPE_VIDEO_OUTPUT
> > >    		  .pix  = width x height
> > >
> > > using only these ioctls should be enough to device driver
> > > to know down/up scale factor required.
> > >
> > > regarding color space struct v4l2_pix_format have field
> > > 'pixelformat'
> > > which can be used to define input and output buffers content.
> > > so using only existing ioctl's user can have working resizer
> device.
> > >
> > > also please note that there is VIDIOC_S_CROP which can add
> > > additional
> > > flexibility of adding cropping on input or output.
> > >
> > [Hiremath, Vaibhav] I think this makes more sense in capture
> pipeline, for example,
> >
> > Sensor/decoder -> previewer -> resizer -> /dev/videoX
> >
> 
> I don't get this. In strictly capture pipeline we will get one video
> node anyway.
> 
> However the question is how we should support a bit more complicated
> pipeline.
> 
> Just consider a resizer module and the pipeline:
> 
> sensor/decoder -[bus]-> previewer -> [memory] -> resizer -> [memory]
> 
[Hiremath, Vaibhav] For me this is not single pipeline, it has two separate links - 

1) sensor/decoder -[bus]-> previewer -> [memory]

2) [memory] -> resizer -> [memory]


> ([bus] means some kind of internal bus that is completely
> interdependent from the system memory)
> 
> Mapping to video nodes is not so trivial. In fact this pipeline
> consist of 2 independent (sub)pipelines connected by user space
> application:
> 
> sensor/decoder -[bus]-> previewer -> [memory] -[user application]->
> [memory] -> resizer -> [memory]
> 
> For further analysis it should be cut into 2 separate pipelines:
> 
> a. sensor/decoder -[bus]-> previewer -> [memory]
> b. [memory] -> resizer -> [memory]
> 
[Hiremath, Vaibhav] Correct, I wouldn't call them as sub-pipeline. Application is linking them, so from driver point of view they are completely separate.

> Again, mapping the first subpipeline is trivial:
> 
> sensor/decoder -[bus]-> previewer -> /dev/video0
> 
[Hiremath, Vaibhav] Correct, it is separate streaming device.

> But the last, can be mapped either as:
> 
> /dev/video1 -> resizer -> /dev/video1
> (one video node approach)
> 
[Hiremath, Vaibhav] Please go through my last response where I have mentioned about buffer queuing constraints with this approach.

> or
> 
> /dev/video1 -> resizer -> /dev/video2
> (2 video nodes approach).
> 
> 
> So at the end the pipeline would look like this:
> 
> sensor/decoder -[bus]-> previewer -> /dev/video0 -[user
> application]-> /dev/video1 -> resizer -> /dev/video2
> 
> or
> 
> sensor/decoder -[bus]-> previewer -> /dev/video0 -[user
> application]-> /dev/video1 -> resizer -> /dev/video1
> 
> > > last thing which should be done is to QBUF 2 buffers and call
> > > STREAMON.
> > >
> > [Hiremath, Vaibhav] IMO, this implementation is not streaming
> model, we are trying to fit mem-to-mem
> > forcefully to streaming.
> 
> Why this does not fit streaming? I see no problems with streaming
> over mem2mem device with only one video node. You just queue input
> and output buffers (they are distinguished by 'type' parameter) on
> the same video node.
> 
[Hiremath, Vaibhav] Do we create separate queue of buffers based on type? I think we don't. 

App1		App2		App3		...		AppN
  |		 |		|		|		  |
   -----------------------------------------------
				|
			/dev/video0
				|
			Resizer Driver

Everyone will be doing streamon, and in normal use case every application must be getting buffers from another module (another driver, codecs, DSP, etc...) in multiple streams, 0, 1,2,3,4....N

Every application will start streaming with (mostly) fixed scaling factor which mostly never changes. This one video node approach is possible only with constraint that, the application will always queue only 2 buffers with one CAPTURE and one with OUTPUT type. He has to wait till first/second gets finished, you can't queue multiple buffers (input and output) simultaneously.

I do agree here with you that we need to investigate on whether we really have such use-case. Does it make sense to put such constraint on application? What is the impact? Again in case of down-scaling, application may want to use same buffer as input, which is easily possible with single node approach.

Thanks,
Vaibhav

> > We have to put some constraints -
> >
> > 	- Driver will treat index 0 as input always, irrespective of
> number of buffers queued.
> > 	- Or, application should not queue more that 2 buffers.
> > 	- Multi-channel use-case????
> >
> > I think we have to have 2 device nodes which are capable of
> streaming multiple buffers, both are
> > queuing the buffers.
> 
> In one video node approach there can be 2 buffer queues in one video
> node, for input and output respectively.
> 
> > The constraint would be the buffers must be mapped one-to-one.
> 
> Right, each queued input buffer must have corresponding output
> buffer.
> 
> Best regards
> --
> Marek Szyprowski
> Samsung Poland R&D Center
> 
> 

