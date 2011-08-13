Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:58446 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab1HMU7F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Aug 2011 16:59:05 -0400
Date: Sat, 13 Aug 2011 23:59:01 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Veda N <veda74@gmail.com>
Cc: Paulo Assis <pj.assis@gmail.com>, linux-media@vger.kernel.org
Subject: Re: size of raw bayer data
Message-ID: <20110813205901.GB7436@valkosipuli.localdomain>
References: <CAOO8FEfvJWvxDxL5VnXwsWRgKSMsEq8w3zc9K1M=TjypU431Ww@mail.gmail.com>
 <CAPueXH4QysAb=hsA12TQHe7Uumb0gOCBzkNkyExVGept8pa2+w@mail.gmail.com>
 <CAOO8FEcJZkyawy0acpQndsZCmw9mBNMCMEd3s6o05CrRXy-rNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOO8FEcJZkyawy0acpQndsZCmw9mBNMCMEd3s6o05CrRXy-rNQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Aug 14, 2011 at 12:37:10AM +0530, Veda N wrote:
> On Sat, Aug 13, 2011 at 11:56 PM, Paulo Assis <pj.assis@gmail.com> wrote:
> > Hi,
> >
> > 2011/8/13 Veda N <veda74@gmail.com>:
> >> what should be the size of a raw bayer data from the driver.
> >>
> >> for 640x480 = i get 640x480x2.
> >
> > Is this in bytes?
> >
> >>
> >> Shouldnt i get more? It shoule be more than yuv422/rgb565
> >>
> >
> > No, that depends on the pixel size, so for 8 bit pixel you should get
> > 640x480 bytes, for 12 bit you should get 640x480x3/2 and so on.
> >
> > 640x480x2 is equivalent to a 16 bit pixel, this is a bit unusual I
> > think, the most common is 8 bit pixel, what device/driver are you
> > using ?
> 
> If it is V4L2_PIX_FMT_SGRBG10 - it is 10 bits/color.
> If it is V4L2_PIX_FMT_SGRBG8 -   it is 8 bits/color

These formats are byte aligned.

> Shouldnt it be more? raw data is supposed to be large in size when
> compared to processed data pixel size.

No. At VGA size you still have as many pixels as you can guess but any
single pixel is either red, green or blue.

-- 
Sakari Ailus
sakari.ailus@iki.fi
