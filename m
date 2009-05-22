Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:8652 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbZEVCFq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2009 22:05:46 -0400
Received: by wf-out-1314.google.com with SMTP id 26so503890wfd.4
        for <linux-media@vger.kernel.org>; Thu, 21 May 2009 19:05:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200905211407.05354.hverkuil@xs4all.nl>
References: <5e9665e10905200448n1ffc9d8s20317bbbba745e6a@mail.gmail.com>
	 <200905211407.05354.hverkuil@xs4all.nl>
Date: Fri, 22 May 2009 11:05:47 +0900
Message-ID: <5e9665e10905211905t43ae195cv7a0fe243077887c9@mail.gmail.com>
Subject: Re: About VIDIOC_G_OUTPUT/S_OUTPUT ?
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Shah, Hardik" <hardik.shah@ti.com>,
	"dongsoo45.kim@samsung.com" <dongsoo45.kim@samsung.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	=?EUC-KR?B?sejH/MHY?= <riverful.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,


On Thu, May 21, 2009 at 9:07 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Wednesday 20 May 2009 13:48:08 Dongsoo, Nathaniel Kim wrote:
>> Hello everyone,
>>
>> Doing a new camera interface driver job of new AP from Samsung, a
>> single little question doesn't stop making me confused.
>> The camera IP in Samsung application processor supports for two of
>> output paths, like "to memory" and "to LCD FIFO".
>> It seems to be VIDIOC_G_OUTPUT/S_OUTPUT which I need to use (just
>> guessing), but according to Hans's ivtv driver the "output" of
>> G_OUTPUT/S_OUTPUT is supposed to mean an actually and physically
>> separated real output path like Composite, S-Video and so on.
>>
>> Do you think that memory or LCD FIFO can be an "output" device in this
>> case? Because in earlier version of my driver, I assumed that the "LCD
>> FIFO" is a kind of "OVERLAY" device, so I didn't even need to use
>> G_OUTPUT and S_OUTPUT to route output device. I'm just not sure about
>> which idea makes sense. or maybe both of them could make sense
>> indeed...
>
> When you select "to memory", then the video from the camera is DMAed to the
> CPU, right? But selecting "to LCD" means that the video is routed
> internally to the LCD without any DMA to the CPU taking place, right?
>

Yes definitely right.


> This is similar to the "passthrough" mode of the ivtv driver.
>
> This header: linux/dvb/video.h contains an ioctl called VIDEO_SELECT_SOURCE,
> which can be used to select either memory or a demuxer (or in this case,
> the camera) as the source of the output (the LCD in this case). It is
> probably the appropriate ioctl to implement for this.
>

So, in user space we should call  VIDIO_SELECT_SOURCE ioctl?


> The video.h header is shared between v4l and dvb and contains several ioctls
> meant to handle output. It is poorly documented and I think it should be
> merged into the v4l2 API and properly documented/cleaned up.
>

I agree with you. Anyway, camera interface is not a DVB device but
supporting this source routing feature means that we also need this
API in v4l2.

> Note that overlays are meant for on-screen displays. Usually these are
> associated with a framebuffer device. Your hardware may implement such an
> OSD as well, but that is different from this passthrough feature.
>

Sorry Hans, I'm not sure that I'm following this part. Can I put it in
the way like this?
The OSD feature in Samsung AP should be handled separated with the
selecting source feature (camera-to-FB and camera-to-memory). So that
I should implement both of them. (overlay feature and select source
feature)
Am I following? Please let me know if there is something wrong.

BTW, my 5M camera driver which is including the new V4L2 API proposal
I gave a talk in SF couldn't have approval from my bosses to be opened
to the public. But I'll try to make another camera device driver which
can cover must of the API I proposed.
Cheers,

Nate

> Regards,
>
>        Hans
>
> --
> Hans Verkuil - video4linux developer - sponsored by TANDBERG
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
