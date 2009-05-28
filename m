Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:32778 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbZE1LUN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2009 07:20:13 -0400
Received: by wf-out-1314.google.com with SMTP id 26so1804850wfd.4
        for <linux-media@vger.kernel.org>; Thu, 28 May 2009 04:20:15 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 28 May 2009 20:20:15 +0900
Message-ID: <5e9665e10905280420x73ebc7ean5c029b131e6b7e8c@mail.gmail.com>
Subject: About s_stream in v4l2-subdev
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	"dongsoo45.kim@samsung.com" <dongsoo45.kim@samsung.com>,
	=?EUC-KR?B?uc66tMij?= <bhmin@samsung.com>,
	=?EUC-KR?B?sejH/MHYILHo?= <riverful.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everyone,

I'm doing my driver job with kernel 2.6.30-rc6, trying to figure out
how to convert my old drivers to v4l2-subdev framework. Looking into
the v4l2-subdev.h file an interesting API popped up and can't find any
precise comment about that. It is "s_stream" in v4l2_subdev_video_ops.
I think I found this api in the very nick of time, if the purpose of
that api  is exactly what I need. Actually, I was trying to make my
sub device to get streamon and streamoff command from the device side,
and I wish the "s_stream" is that for. Because in case of camera
module with embedded JPEG encoder, it is necessary to make the camera
module be aware of the exact moment of streamon to pass the encoded
data to camera interface. (many of camera ISPs can't stream out
continuous frame of JPEG data, so we have only one chance  of shot).
Is the s_stream for streamon purpose in subdev? (I hope so...finger crossed)
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
