Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f109.google.com ([209.85.222.109]:34370 "EHLO
	mail-pz0-f109.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbZEZG7B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2009 02:59:01 -0400
Received: by pzk7 with SMTP id 7so2845321pzk.33
        for <linux-media@vger.kernel.org>; Mon, 25 May 2009 23:59:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200905260843.15978.hverkuil@xs4all.nl>
References: <5e9665e10905200448n1ffc9d8s20317bbbba745e6a@mail.gmail.com>
	 <C4B8C637-2C21-4955-8C6A-0600C11D3B09@gmail.com>
	 <5e9665e10905252332g496c5873vc59a39f6607f80ee@mail.gmail.com>
	 <200905260843.15978.hverkuil@xs4all.nl>
Date: Tue, 26 May 2009 15:59:03 +0900
Message-ID: <5e9665e10905252359k3b1a16d2v8baede02de8e4e99@mail.gmail.com>
Subject: Re: About VIDIOC_G_OUTPUT/S_OUTPUT ?
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Shah, Hardik" <hardik.shah@ti.com>,
	"dongsoo45.kim@samsung.com" <dongsoo45.kim@samsung.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	=?EUC-KR?B?sejH/MHY?= <riverful.kim@samsung.com>,
	=?EUC-KR?B?uc66tMij?= <bhmin@samsung.com>
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thank you Hans,

Thanks to you I got the point of selecting input and output is that
only physical connection can make it. It is really helping.

BTW, more I work on v4l2 more I need for decent documentation. I
should rather make some porting guide and technical documents for
other developers. Actually V4L2 specification should be serving more
detailed information indeed. When I see some sort of [?] things in the
API specification document, thousands of question marks starts
floating in my brain ;-O
Cheers,

Nate

2009/5/26 Hans Verkuil <hverkuil@xs4all.nl>:
> On Tuesday 26 May 2009 08:32:00 Dongsoo, Nathaniel Kim wrote:
>> Hello Hans,
>>
>> I took a look into ivtv driver but the VIDEO_SELECT_SOURCE doesn't fit
>> in the feature that I was explaining. ivtv_passthrough_mode seems to
>> be all about selecting input source not output. Am I right? But in my
>> case, I have (1)external camera, (2)memory for input source and
>> (1)memory, (2)LCD FIFO(like overlay) for output. It means that use
>> case can be established like this:
>>
>> (A) using external camera for input and memory for output => memcpy
>> the memory to framebuffer to display preview
>>
>> (B) using external camera for input and memory for output => memcpy
>> the memory and save as a file (recording or snapshot). maybe the same
>> case as (A)
>
> This is the same as A.
>
>>
>> (C) using external camera for input and LCD FIFO for output => turn on
>> the camera and will se preview with doing nothing further in userspace
>> (like memcpy)
>
> For this you need VIDEO_SELECT_SOURCE.
>
>>
>> (D) using memory for input source and memory for output => actually in
>> this case we can use "rotator" feature of camera interface. so let the
>> multimedia file go through the camera interface and rotate
>> orientation.
>>
>> (E) using memory for input source and LCD FIFO for output => rotate
>> multimedia file and display direct to LCD.
>
> Do D and E both go through the "rotator" feature of the camera interface?
> Anyway D sounds more like the proposed omap scaler device: basically a
> codec device.
>
> Anyway, based on this description S_INPUT has only one input: the camera.
> And S_OUTPUT has only the LCD as it's output. Those are the only physical
> connections.
>
> VIDEO_SELECT_SOURCE allows you to shortcut the two. It does not have
> anything to do with selecting the input or output. It just tells the driver
> to not use memory as its source/destination (which is the default behavior
> at all times), but connect the input and output together internally.
>
> Hope this helps.
>
> Regards,
>
>        Hans
>
>>
>> So in this case, should I use VIDIOC_S_INPUT to select input and
>> VIDIOC_S_OUTPUT to select output device? or I got in the wrong way in
>> the first place....(if VIDEO_SELECT_SOURCE is the right one for me)
>>
>> If the concept above fits in VIDIOC_S_OUTPUT then I think we need more
>> "type" define because I think any of type defined is not matching
>> feature of "output to memory".
>> Cheers,
>>
>> Nate
>>
>> 2009/5/22 Dongsoo Kim <dongsoo.kim@gmail.com>:
>> > Hi Hans,
>> >
>> > 2009. 05. 22, 오후 9:40, Hans Verkuil 작성:
>> >> On Friday 22 May 2009 04:05:47 Dongsoo, Nathaniel Kim wrote:
>> >>> Hi Hans,
>> >>>
>> >>> On Thu, May 21, 2009 at 9:07 PM, Hans Verkuil <hverkuil@xs4all.nl>
> wrote:
>> >>>> On Wednesday 20 May 2009 13:48:08 Dongsoo, Nathaniel Kim wrote:
>> >>>>> Hello everyone,
>> >>>>>
>> >>>>> Doing a new camera interface driver job of new AP from Samsung, a
>> >>>>> single little question doesn't stop making me confused.
>> >>>>> The camera IP in Samsung application processor supports for two of
>> >>>>> output paths, like "to memory" and "to LCD FIFO".
>> >>>>> It seems to be VIDIOC_G_OUTPUT/S_OUTPUT which I need to use (just
>> >>>>> guessing), but according to Hans's ivtv driver the "output" of
>> >>>>> G_OUTPUT/S_OUTPUT is supposed to mean an actually and physically
>> >>>>> separated real output path like Composite, S-Video and so on.
>> >>>>>
>> >>>>> Do you think that memory or LCD FIFO can be an "output" device in
>> >>>>> this case? Because in earlier version of my driver, I assumed that
>> >>>>> the "LCD FIFO" is a kind of "OVERLAY" device, so I didn't even need
>> >>>>> to use G_OUTPUT and S_OUTPUT to route output device. I'm just not
>> >>>>> sure about which idea makes sense. or maybe both of them could make
>> >>>>> sense indeed...
>> >>>>
>> >>>> When you select "to memory", then the video from the camera is DMAed
>> >>>> to the CPU, right? But selecting "to LCD" means that the video is
>> >>>> routed internally to the LCD without any DMA to the CPU taking
>> >>>> place, right?
>> >>>
>> >>> Yes definitely right.
>> >>>
>> >>>> This is similar to the "passthrough" mode of the ivtv driver.
>> >>>>
>> >>>> This header: linux/dvb/video.h contains an ioctl called
>> >>>> VIDEO_SELECT_SOURCE, which can be used to select either memory or a
>> >>>> demuxer (or in this case, the camera) as the source of the output
>> >>>> (the LCD in this case). It is probably the appropriate ioctl to
>> >>>> implement for this.
>> >>>
>> >>> So, in user space we should call  VIDIO_SELECT_SOURCE ioctl?
>> >>
>> >> Yes.
>> >>
>> >>>> The video.h header is shared between v4l and dvb and contains
>> >>>> several ioctls meant to handle output. It is poorly documented and I
>> >>>> think it should be merged into the v4l2 API and properly
>> >>>> documented/cleaned up.
>> >>>
>> >>> I agree with you. Anyway, camera interface is not a DVB device but
>> >>> supporting this source routing feature means that we also need this
>> >>> API in v4l2.
>> >>
>> >> It's valid to use VIDEO_SELECT_SOURCE in an v4l2 driver. It's
>> >> currently used
>> >> by ivtv. It's an historical accident that these ioctls ended up in the
>> >> dvb header.
>> >
>> > Oh, I'll look into the driver. Cheers.
>> >
>> >>>> Note that overlays are meant for on-screen displays. Usually these
>> >>>> are associated with a framebuffer device. Your hardware may
>> >>>> implement such an OSD as well, but that is different from this
>> >>>> passthrough feature.
>> >>>
>> >>> Sorry Hans, I'm not sure that I'm following this part. Can I put it
>> >>> in the way like this?
>> >>> The OSD feature in Samsung AP should be handled separated with the
>> >>> selecting source feature (camera-to-FB and camera-to-memory). So that
>> >>> I should implement both of them. (overlay feature and select source
>> >>> feature)
>> >>> Am I following? Please let me know if there is something wrong.
>> >>
>> >> Yes, that's correct.
>> >>
>> >>> BTW, my 5M camera driver which is including the new V4L2 API proposal
>> >>> I gave a talk in SF couldn't have approval from my bosses to be
>> >>> opened to the public. But I'll try to make another camera device
>> >>> driver which can cover must of the API I proposed.
>> >>
>> >> That's a shame. Erm, just to make it clear for your bosses: any v4l2
>> >> driver
>> >> that uses any of the videobuf_*, v4l2_i2c_*, v4l2_device_* or
>> >> v4l2_int_* functions must be a GPL driver, and thus has to be made
>> >> available upon request. All these functions are marked
>> >> EXPORT_SYMBOL_GPL. I don't know if they realize this fact.
>> >
>> > Oops I didn't make it clear that my driver was not used for a
>> > commercial product. I made them for our platform development and test,
>> > and as a matter of fact my drivers will be opened in the end but not
>> > just soon enough. I think there is some issues in non-technical area
>> > which I'm not aware of. I'll make another driver with other camera
>> > device because I can't wait any longer. My boss approved that should be
>> > OK. And actually it is challenging indeed.
>> > Cheers,
>> >
>> > Nate
>> >
>> >> Regards,
>> >>
>> >>        Hans
>> >>
>> >> --
>> >> Hans Verkuil - video4linux developer - sponsored by TANDBERG
>
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
