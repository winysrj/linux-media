Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.239]:55870 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbZE1XbI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2009 19:31:08 -0400
Received: by rv-out-0506.google.com with SMTP id f6so14341rvb.5
        for <linux-media@vger.kernel.org>; Thu, 28 May 2009 16:31:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200905282321.17931.hverkuil@xs4all.nl>
References: <5e9665e10905280420x73ebc7ean5c029b131e6b7e8c@mail.gmail.com>
	 <200905282321.17931.hverkuil@xs4all.nl>
Date: Fri, 29 May 2009 08:31:10 +0900
Message-ID: <5e9665e10905281631t5bd844btbba5f744f3fb8c30@mail.gmail.com>
Subject: Re: About s_stream in v4l2-subdev
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"dongsoo45.kim@samsung.com" <dongsoo45.kim@samsung.com>,
	=?EUC-KR?B?uc66tMij?= <bhmin@samsung.com>,
	=?EUC-KR?B?sejH/MHYILHo?= <riverful.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thank you Hans,
Regards,

Nate

On Fri, May 29, 2009 at 6:21 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Thursday 28 May 2009 13:20:15 Dongsoo, Nathaniel Kim wrote:
>> Hello everyone,
>>
>> I'm doing my driver job with kernel 2.6.30-rc6, trying to figure out
>> how to convert my old drivers to v4l2-subdev framework. Looking into
>> the v4l2-subdev.h file an interesting API popped up and can't find any
>> precise comment about that. It is "s_stream" in v4l2_subdev_video_ops.
>> I think I found this api in the very nick of time, if the purpose of
>> that api  is exactly what I need. Actually, I was trying to make my
>> sub device to get streamon and streamoff command from the device side,
>> and I wish the "s_stream" is that for. Because in case of camera
>> module with embedded JPEG encoder, it is necessary to make the camera
>> module be aware of the exact moment of streamon to pass the encoded
>> data to camera interface. (many of camera ISPs can't stream out
>> continuous frame of JPEG data, so we have only one chance  of shot).
>> Is the s_stream for streamon purpose in subdev? (I hope so...finger
>> crossed) Cheers,
>
> Yes it is. It is for subdevs that need to implement VIDIOC_STREAMON and
> VIDIOC_STREAMOFF.
>
> Regards,
>
>        Hans
>
>
> --
> Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
>



-- 
=
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
