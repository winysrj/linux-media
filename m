Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39499 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbaDDL1b (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Apr 2014 07:27:31 -0400
Date: Fri, 4 Apr 2014 14:27:17 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Subject: Re: [media] V4L: Add driver for S3C24XX/S3C64XX SoC series camera
 interface
Message-ID: <20140404112717.GR18506@mwanda>
References: <20130823094647.GO31293@elgon.mountain>
 <5219F736.2010706@gmail.com>
 <20130827141914.GD19256@mwanda>
 <521CB6FF.70401@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521CB6FF.70401@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Whatever happened with this btw?  Also are you sure we don't need a
second check after line 457?

regards,
dan carpenter

On Tue, Aug 27, 2013 at 04:26:07PM +0200, Sylwester Nawrocki wrote:
> On 08/27/2013 04:19 PM, Dan Carpenter wrote:
> > On Sun, Aug 25, 2013 at 02:23:18PM +0200, Sylwester Nawrocki wrote:
> >> On 08/23/2013 11:46 AM, Dan Carpenter wrote:
> >>> [ Going through some old warnings... ]
> >>>
> >>> Hello Sylwester Nawrocki,
> >>>
> >>> This is a semi-automatic email about new static checker warnings.
> >>>
> >>> The patch babde1c243b2: "[media] V4L: Add driver for S3C24XX/S3C64XX
> >>> SoC series camera interface" from Aug 22, 2012, leads to the
> >>> following Smatch complaint:
> >>>
> >>> drivers/media/platform/s3c-camif/camif-capture.c:463 queue_setup()
> >>> 	 warn: variable dereferenced before check 'fmt' (see line 460)
> >>>
> >>> drivers/media/platform/s3c-camif/camif-capture.c
> >>>    455          if (pfmt) {
> >>>    456                  pix =&pfmt->fmt.pix;
> >>>    457                  fmt = s3c_camif_find_format(vp,&pix->pixelformat, -1);
> >>>    458                  size = (pix->width * pix->height * fmt->depth) / 8;
> >>>                                                            ^^^^^^^^^^
> >>> Dereference.
> >>>
> >>>    459		} else {
> >>>    460			size = (frame->f_width * frame->f_height * fmt->depth) / 8;
> >>>                                                                    ^^^^^^^^^^
> >>> Dereference.
> >>>
> >>>    461		}
> >>>    462	
> >>>    463		if (fmt == NULL)
> >>>                     ^^^^^^^^^^^
> >>> Check.
> >>
> >> Thanks for the bug report. This check of course should be before line 455.
> >> Would you like to sent a patch for this or should I handle that ?
> > 
> > Could you handle it and give me the Reported-by tag?
> 
> Sure, will do.
> 
> --
> Regards,
> Sylwester
