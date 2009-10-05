Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([213.240.235.226]:38290 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754119AbZJEUP0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Oct 2009 16:15:26 -0400
Subject: RE: Mem2Mem V4L2 devices [RFC]
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	Tomasz Fujak <t.fujak@samsung.com>,
	Pawel Osciak <p.osciak@samsung.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE401553E952D@dlee06.ent.ti.com>
References: <E4D3F24EA6C9E54F817833EAE0D912AC077151C64F@bssrvexch01.BS.local>
	 <1254500705.16625.35.camel@iivanov.int.mm-sol.com>
	 <A69FA2915331DC488A831521EAE36FE401553E952D@dlee06.ent.ti.com>
Content-Type: text/plain
Date: Mon, 05 Oct 2009 23:14:13 +0300
Message-Id: <1254773653.10214.31.camel@violet.int.mm-sol.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, 


On Mon, 2009-10-05 at 15:02 -0500, Karicheri, Muralidharan wrote:
> 
> >>
> >> 1. How to set different color space or size for input and output buffer
> >> each? It could be solved by adding a set of ioctls to get/set source
> >> image format and size, while the existing v4l2 ioctls would only refer
> >> to the output buffer. Frankly speaking, we don't like this idea.
> >
> >I think that is not unusual one video device to define that it can
> >support at the same time input and output operation.
> >
> >Lets take as example resizer device. it is always possible that it
> >inform user space application that
> >
> >struct v4l2_capability.capabilities ==
> >		(V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT)
> >
> >User can issue S_FMT ioctl supplying
> >
> >struct v4l2_format.type = V4L2_BUF_TYPE_VIDEO_CAPTURE
> >		  .pix  = width x height
> >
> >which will instruct this device to prepare its output for this
> >resolution. after that user can issue S_FMT ioctl supplying
> >
> >struct v4l2_format.type = V4L2_BUF_TYPE_VIDEO_OUTPUT
> >   		  .pix  = width x height
> >
> >using only these ioctls should be enough to device driver
> >to know down/up scale factor required.
> >
> >regarding color space struct v4l2_pix_format have field 'pixelformat'
> >which can be used to define input and output buffers content.
> >so using only existing ioctl's user can have working resizer device.
> >
> >also please note that there is VIDIOC_S_CROP which can add additional
> >flexibility of adding cropping on input or output.
> >
> >last thing which should be done is to QBUF 2 buffers and call STREAMON.
> >
> >i think this will simplify a lot buffer synchronization.
> >
> 
> Ivan,
> 
> There is another use case where there are two Resizer hardware working on the same input frame and give two different output frames of different resolution. How do we handle this using the one video device approach you
> just described here?

 what is the difference?
 
- you can have only one resizer device driver which will hide that 
  they are actually 2 hardware resizers. just operations will be
  faster ;).

- they are two device drivers (nodes) with similar characteristics.

in both cases input buffer can be the same. 

iivanov



> 
> Murali

