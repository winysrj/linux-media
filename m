Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f196.google.com ([209.85.221.196]:45302 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbZGaHWX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jul 2009 03:22:23 -0400
Received: by qyk34 with SMTP id 34so1400728qyk.33
        for <linux-media@vger.kernel.org>; Fri, 31 Jul 2009 00:22:23 -0700 (PDT)
MIME-Version: 1.0
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
Date: Fri, 31 Jul 2009 16:22:03 +0900
Message-ID: <5e9665e10907310022p45d32698pc9f10b1af0626b65@mail.gmail.com>
Subject: [RFC] Need comments for supplementing a new pixelformat in
	videodev2.h
To: v4l2_linux <linux-media@vger.kernel.org>
Cc: bill@thedirks.org, "Verkuil, Hans" <hverkuil@xs4all.nl>,
	dongsoo45.kim@samsung.com, jonghun.han@samsung.com,
	Jinsung Yang <jsgood.yang@samsung.com>,
	=?UTF-8?B?67CVLCDqsr3rr7w=?= <kyungmin.park@samsung.com>,
	=?UTF-8?B?6rmALCDtmJXspIA=?= <riverful.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

As the codec device of my new H/W I'm is giving output with Y and CbCr
as separated components which means it's just like other NV
pixelformats described in videodev2.h. However, there is a significant
difference in aligning each Y and CbCr components in memory.

Picking up the description from the user manual, it says

"Reference picture is always made in the tile mode memory structure.
Decoding reconstruction image is made in 64
pixels x 32 lines tiled mode. Encoding reconstruction image is made in
16 pixels x 16 lines tiled mode."

Besides that, it totally looks like NV12 pixelformat.
S/W engineer from the vendor wants to call this as "NV12 tiled" which
can be considered as a tiled alignment of 64pixel X 32 lines of macro
blocks of each components.

So, is that just a NV12 or should be called as a new pixelformat?

If that should be considered as a new pixelformat, how about the way like this:

#define V4L2_PIX_FMT_NV12T    v4l2_fourcc('T', 'V', '1', '2') /* 12
Y/CbCr 4:2:0 */

Any comment will be appreciated.
Cheers,

Nate

-- 
=
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
