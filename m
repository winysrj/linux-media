Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr3.xs4all.nl ([194.109.24.23]:4852 "EHLO
	smtp-vbr3.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbZGaLlE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jul 2009 07:41:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
Subject: Re: [RFC] Need comments for supplementing a new pixelformat in  videodev2.h
Date: Fri, 31 Jul 2009 13:40:47 +0200
Cc: v4l2_linux <linux-media@vger.kernel.org>, bill@thedirks.org,
	dongsoo45.kim@samsung.com, jonghun.han@samsung.com,
	Jinsung Yang <jsgood.yang@samsung.com>,
	=?utf-8?q?=EA=B2=BD=EB=AF=BC?= <kyungmin.park@samsung.com>,
	=?utf-8?q?=ED=98=95=EC=A4=80?= <riverful.kim@samsung.com>
References: <5e9665e10907310022p45d32698pc9f10b1af0626b65@mail.gmail.com>
In-Reply-To: <5e9665e10907310022p45d32698pc9f10b1af0626b65@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907311340.47400.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 31 July 2009 09:22:03 Dongsoo, Nathaniel Kim wrote:
> Hello,
> 
> As the codec device of my new H/W I'm is giving output with Y and CbCr
> as separated components which means it's just like other NV
> pixelformats described in videodev2.h. However, there is a significant
> difference in aligning each Y and CbCr components in memory.
> 
> Picking up the description from the user manual, it says
> 
> "Reference picture is always made in the tile mode memory structure.
> Decoding reconstruction image is made in 64
> pixels x 32 lines tiled mode. Encoding reconstruction image is made in
> 16 pixels x 16 lines tiled mode."
> 
> Besides that, it totally looks like NV12 pixelformat.
> S/W engineer from the vendor wants to call this as "NV12 tiled" which
> can be considered as a tiled alignment of 64pixel X 32 lines of macro
> blocks of each components.
> 
> So, is that just a NV12 or should be called as a new pixelformat?

No, that's a new pixelformat. It sounds very similar to the HM12 format
which is also a tiled format. That format is described here:

Documentation/video4linux/cx2341x/README.hm12

If I understand correctly then you actually have two different formats:
one for encoding, one for decoding. In that case you also need to make
two different pixelformats. Each pixelformat must map unambiguously to
a specific format.

> If that should be considered as a new pixelformat, how about the way like this:
> 
> #define V4L2_PIX_FMT_NV12T    v4l2_fourcc('T', 'V', '1', '2') /* 12
> Y/CbCr 4:2:0 */

Note that for each pixelformat you add you also need to add an entry to
the v4l2 spec. Either make a new pixfmt-tv12.sgml file to document the format
precisely (recommended if customers will need to know this information)
or add a short entry to pixfmt.sgml that just refers to your driver.

This is needed to make sure that the spec still can be build, otherwise
you get an unresolved reference to the new pixelformat define.

You can also consider adding support for converting this format to something
more common to libv4lconvert. The tiled hm12 format is already handled there,
so that code can be used as reference code (or even reused).

Finally note that we do not add new pixel formats unless we also merge the
driver that uses it at the same time or very soon afterwards.

> 
> Any comment will be appreciated.

No problem!

Regards,

        Hans

> Cheers,
> 
> Nate
> 



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
