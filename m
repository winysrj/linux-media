Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47411 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab3HWJqo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Aug 2013 05:46:44 -0400
Date: Fri, 23 Aug 2013 12:46:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: sylvester.nawrocki@gmail.com
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Subject: re: [media] V4L: Add driver for S3C24XX/S3C64XX SoC series camera
 interface
Message-ID: <20130823094647.GO31293@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[ Going through some old warnings... ]

Hello Sylwester Nawrocki,

This is a semi-automatic email about new static checker warnings.

The patch babde1c243b2: "[media] V4L: Add driver for S3C24XX/S3C64XX 
SoC series camera interface" from Aug 22, 2012, leads to the 
following Smatch complaint:

drivers/media/platform/s3c-camif/camif-capture.c:463 queue_setup()
	 warn: variable dereferenced before check 'fmt' (see line 460)

drivers/media/platform/s3c-camif/camif-capture.c
   455          if (pfmt) {
   456                  pix = &pfmt->fmt.pix;
   457                  fmt = s3c_camif_find_format(vp, &pix->pixelformat, -1);
   458                  size = (pix->width * pix->height * fmt->depth) / 8;
                                                           ^^^^^^^^^^
Dereference.

   459		} else {
   460			size = (frame->f_width * frame->f_height * fmt->depth) / 8;
                                                                   ^^^^^^^^^^
Dereference.

   461		}
   462	
   463		if (fmt == NULL)
                    ^^^^^^^^^^^
Check.

   464			return -EINVAL;
   465		*num_planes = 1;

regards,
dan carpenter
