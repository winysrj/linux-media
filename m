Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:50558 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029AbZJEGAG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Oct 2009 02:00:06 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	Tomasz Fujak <t.fujak@samsung.com>,
	Pawel Osciak <p.osciak@samsung.com>
Date: Mon, 5 Oct 2009 11:29:18 +0530
Subject: RE: Mem2Mem V4L2 devices [RFC]
Message-ID: <19F8576C6E063C45BE387C64729E73940436CF8DCB@dbde02.ent.ti.com>
References: <E4D3F24EA6C9E54F817833EAE0D912AC077151C64F@bssrvexch01.BS.local>
 <1254500705.16625.35.camel@iivanov.int.mm-sol.com>
In-Reply-To: <1254500705.16625.35.camel@iivanov.int.mm-sol.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Ivan T. Ivanov
> Sent: Friday, October 02, 2009 9:55 PM
> To: Marek Szyprowski
> Cc: linux-media@vger.kernel.org; kyungmin.park@samsung.com; Tomasz
> Fujak; Pawel Osciak
> Subject: Re: Mem2Mem V4L2 devices [RFC]
> 
> 
> Hi Marek,
> 
> 
> On Fri, 2009-10-02 at 13:45 +0200, Marek Szyprowski wrote:
> > Hello,
> >
<snip>

> > image format and size, while the existing v4l2 ioctls would only
> refer
> > to the output buffer. Frankly speaking, we don't like this idea.
> 
> I think that is not unusual one video device to define that it can
> support at the same time input and output operation.
> 
> Lets take as example resizer device. it is always possible that it
> inform user space application that
> 
> struct v4l2_capability.capabilities ==
> 		(V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT)
> 
> User can issue S_FMT ioctl supplying
> 
> struct v4l2_format.type = V4L2_BUF_TYPE_VIDEO_CAPTURE
> 		  .pix  = width x height
> 
> which will instruct this device to prepare its output for this
> resolution. after that user can issue S_FMT ioctl supplying
> 
> struct v4l2_format.type = V4L2_BUF_TYPE_VIDEO_OUTPUT
>    		  .pix  = width x height
> 
> using only these ioctls should be enough to device driver
> to know down/up scale factor required.
> 
> regarding color space struct v4l2_pix_format have field
> 'pixelformat'
> which can be used to define input and output buffers content.
> so using only existing ioctl's user can have working resizer device.
> 
> also please note that there is VIDIOC_S_CROP which can add
> additional
> flexibility of adding cropping on input or output.
> 
[Hiremath, Vaibhav] I think this makes more sense in capture pipeline, for example,

Sensor/decoder -> previewer -> resizer -> /dev/videoX


> last thing which should be done is to QBUF 2 buffers and call
> STREAMON.
> 
[Hiremath, Vaibhav] IMO, this implementation is not streaming model, we are trying to fit mem-to-mem forcefully to streaming. We have to put some constraints - 

	- Driver will treat index 0 as input always, irrespective of number of buffers queued.
	- Or, application should not queue more that 2 buffers.
	- Multi-channel use-case????

I think we have to have 2 device nodes which are capable of streaming multiple buffers, both are queuing the buffers. The constraint would be the buffers must be mapped one-to-one.

User layer library would be important here to play major role in supporting multi-channel feature. I think we need to do some more investigation on this.

Thanks,
Vaibhav

> i think this will simplify a lot buffer synchronization.
> 
> iivanov
> 
> 
> >
> > 2. Input and output in the same video node would not be compatible
> with
> > the upcoming media controller, with which we will get an ability
> to
> > arrange devices into a custom pipeline. Piping together two
> separate
> > input-output nodes to create a new mem2mem device would be
> difficult and
> > unintuitive. And that not even considering multi-output devices.
> >
> > My idea is to get back to the "2 video nodes per device" approach
> and
> > introduce a new ioctl for matching input and output instances of
> the
> > same device. When such an ioctl could be called is another
> question. I
> > like the idea of restricting such a call to be issued after
> opening
> > video nodes and before using them. Using this ioctl, a user
> application
> > would be able to match output instance to an input one, by
> matching
> > their corresponding file descriptors.
> >
> > What do you think of such a solution?
> >
> > Best regards
> > --
> > Marek Szyprowski
> > Samsung Poland R&D Center
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-
> media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-
> media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

