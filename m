Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f47.google.com ([209.85.219.47]:53795 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755875Ab3G3PTT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jul 2013 11:19:19 -0400
Received: by mail-oa0-f47.google.com with SMTP id m6so9444412oag.20
        for <linux-media@vger.kernel.org>; Tue, 30 Jul 2013 08:19:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201307301545.51529.hverkuil@xs4all.nl>
References: <CAPybu_1kw0CjtJxt-ivMheJSeSEi95ppBbDcG1yXOLLRaR4tRg@mail.gmail.com>
 <201307301545.51529.hverkuil@xs4all.nl>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Tue, 30 Jul 2013 17:18:58 +0200
Message-ID: <CAPybu_13HCY1i=tH1krdKGOSbJNgek-X4gt1cGmo_oB=AqTxKg@mail.gmail.com>
Subject: Re: Question about v4l2-compliance: cap->readbuffers
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for the explanation Hans!

I finaly manage to pass that one ;)

Just one more question. Why the compliance test checks if the DISABLED
flag is on on for qctrls?

http://git.linuxtv.org/v4l-utils.git/blob/3ae390e54a0ba627c9e74953081560192b996df4:/utils/v4l2-compliance/v4l2-test-controls.cpp#l137

 137         if (fl & V4L2_CTRL_FLAG_DISABLED)
 138                 return fail("DISABLED flag set\n");

Apparently that has been added on:
http://git.linuxtv.org/v4l-utils.git/commit/0a4d4accea7266d7b5f54dea7ddf46cce8421fbb

But I have failed to find a reason

Thanks again!






On Tue, Jul 30, 2013 at 3:45 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Tue 30 July 2013 15:12:57 Ricardo Ribalda Delgado wrote:
>> Hello
>>
>> I am developing a driver for a camera that supports read/write and
>> mmap access to the buffers.
>>
>> When I am running the compliance test, I cannot pass it because of
>> this test on v4l2-test-formats.cpp
>>
>> 904                 if (!(node->caps & V4L2_CAP_READWRITE))
>> 905                         fail_on_test(cap->readbuffers);
>> 906                 else if (node->caps & V4L2_CAP_STREAMING)
>> 907                         fail_on_test(!cap->readbuffers);
>>
>> What should be the value of cap-readbuffers for a driver such as mine,
>> that supports cap_readwrite and cap_streaming? Or I cannot support
>> both, although at least this drivers do the same?
>
> The readbuffers parameter is highly dubious. I generally set it in a driver
> to the lowest number of buffers the hardware allows (e.g. what VIDIOC_REQBUFS
> returns if you give it a buffer count of 1).
>
> In theory this value allows you to increase the number of buffers used
> by read() so you can have more frames pending. In practice the only driver
> using it is sn9c102, which is an obscure webcam that really should be folded
> into the gspca driver suite.
>
> I am really tempted to deprecate/obsolete readbuffers.
>
> Anyway, to squash this compliance error just set readbuffers to the lowest
> number of allowed buffers.
>
> Regards,
>
>         Hans
>
>>
>>
>> $ git grep CAP_READWRITE *  | grep CAP_STREAMING
>> pci/cx25821/cx25821-video.c: V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
>> pci/cx88/cx88-video.c: cap->device_caps = V4L2_CAP_READWRITE |
>> V4L2_CAP_STREAMING;
>> pci/saa7134/saa7134-video.c: cap->device_caps = V4L2_CAP_READWRITE |
>> V4L2_CAP_STREAMING;
>> platform/marvell-ccic/mcam-core.c: V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
>> platform/via-camera.c: V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
>> usb/cx231xx/cx231xx-video.c: cap->device_caps = V4L2_CAP_READWRITE |
>> V4L2_CAP_STREAMING;
>> usb/em28xx/em28xx-video.c: V4L2_CAP_READWRITE | V4L2_CAP_VIDEO_CAPTURE
>> | V4L2_CAP_STREAMING;
>> usb/stkwebcam/stk-webcam.c: | V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
>> usb/tlg2300/pd-video.c: V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
>>
>>
>> Thanks!
>>
>>



-- 
Ricardo Ribalda
