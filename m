Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:36851 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933382AbZHEDGk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Aug 2009 23:06:40 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Magnus Damm <magnus.damm@gmail.com>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"eduardo.valentin@nokia.com" <eduardo.valentin@nokia.com>,
	"Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
Date: Wed, 5 Aug 2009 08:36:13 +0530
Subject: RE: Linux Plumbers Conference 2009: V4L2 API discussions
Message-ID: <19F8576C6E063C45BE387C64729E73940432AF3AA3@dbde02.ent.ti.com>
References: <200908040912.24718.hverkuil@xs4all.nl>
	 <19F8576C6E063C45BE387C64729E73940432AF3A5D@dbde02.ent.ti.com>
	 <A69FA2915331DC488A831521EAE36FE401451814F8@dlee06.ent.ti.com>
 <aec7e5c30908041931m2113cecerec2c732f8b5927ea@mail.gmail.com>
In-Reply-To: <aec7e5c30908041931m2113cecerec2c732f8b5927ea@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: Magnus Damm [mailto:magnus.damm@gmail.com]
> Sent: Wednesday, August 05, 2009 8:01 AM
> To: Karicheri, Muralidharan
> Cc: Hiremath, Vaibhav; Hans Verkuil; linux-media@vger.kernel.org;
> davinci-linux-open-source@linux.davincidsp.com; linux-
> omap@vger.kernel.org; eduardo.valentin@nokia.com; Dongsoo, Nathaniel
> Kim
> Subject: Re: Linux Plumbers Conference 2009: V4L2 API discussions
> 
> On Wed, Aug 5, 2009 at 5:14 AM, Karicheri,
> Muralidharan<m-karicheri2@ti.com> wrote:
> > 2) Previewer & Resizer driver. I am working with Vaibhav who had
> worked on an RFC for this. The previewer and resizer devices are
> doing memory to memory operations. Also should be flexible to use
> these hardware with capture driver to do on the fly preview and
> resize. The TI hardware is parameter intensive. We believe these
> parameters are to be exported to user space through IOCTLs and would
> require addition of new IOCTLs and extension of control IDs. We will
> be working with you on this as well.
> 
> FWIW, for our SuperH Mobile devices we make use of UIO and user
> space
> libraries to support for our on-chip multimedia blocks. These blocks
> do scaling, rotation, color space conversion and hardware
> encode/decode of various formats including h264 and mpeg4 in HD
> resolution.
> 
> Apart from UIO we use V4L2 for the camera capture interface driver
> sh_mobile_ceu_camera.c. It has support for on the fly color space
> conversion and scaling/cropping. The CEU driver is making use of
> videobuf-dma-contig.c and the USERPTR changes included in 2.6.31-rc
> gives the driver zero copy frame capture support.
> 
> All of this is of course available upstream.
[Hiremath, Vaibhav] Thanks Magnus,

I will definitely take reference from this device and driver code. I think now I have one more device which has similar capabilities. Can you please share or point me to the spec/TRM for SuperH Mobile device for my reference? 

Currently we are referring to Davinci, OMAP and Samsung S3C6400X devices, the user configurable/exported parameters are very different.

Thanks
Vaibhav

> 
> Cheers,
> 
> / magnus

