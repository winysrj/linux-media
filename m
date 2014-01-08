Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:46411 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563AbaAHVns (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jan 2014 16:43:48 -0500
Received: by mail-ob0-f172.google.com with SMTP id gq1so2373644obb.17
        for <linux-media@vger.kernel.org>; Wed, 08 Jan 2014 13:43:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52CDC0C5.6010109@gmail.com>
References: <CABMudhTFmbv-PrNiGcW2yoGPiXuJ13fCmoqDFFBJfEjLk=gSgw@mail.gmail.com>
	<CAGoCfizK7ZFgHTcLgaJRaP-Bvjriv7+fu+=yw+btMEC+GvoU7w@mail.gmail.com>
	<CABMudhQ16ZhvFcwoTdHnU4B9cjVScV4Ohh81izoQDstWsV8X_A@mail.gmail.com>
	<CAGoCfiws5YdmiY8wYkE4_=yKSc3WxABMyUZiT22rTafs-g4SnA@mail.gmail.com>
	<CABMudhTjgXpitX83K2x6_Lyse=Rts0h+t-9LZpUNCAV8yacOJw@mail.gmail.com>
	<52CDC0C5.6010109@gmail.com>
Date: Wed, 8 Jan 2014 13:43:48 -0800
Message-ID: <CABMudhSAQdWmOr0iZ+aq_yB1=3Wy4go=WzUjuGRNWW99dJ4_9Q@mail.gmail.com>
Subject: Re: How can I find out what is the driver for device node '/dev/video11'
From: m silverstri <michael.j.silverstri@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sylwester, Devin,

Thank you.

On Wed, Jan 8, 2014 at 1:19 PM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> On 01/08/2014 08:15 PM, m silverstri wrote:
>>
>> Thanks.
>>
>> I am studying android source code.
>>  From here,  it has code which open("/dev/video11", O_RDWR, 0) as
>> decoding device.
>>
>>
>> http://androidxref.com/4.4.2_r1/xref/hardware/samsung_slsi/exynos5/libhwjpeg/ExynosJpegBase.cpp
>
>
> What you're looking for might be this proprietary Samsung JPEG codec driver
> used in Android.
>
> https://android.googlesource.com/kernel/exynos/+/android-exynos-3.4/drivers/media/video/exynos/jpeg/
>
> If you intend to use mainline kernel you need to consider the s5p-jpeg
> driver,
> which exposes to user space standard interface without any proprietary
> additions
> incompatible with the V4L2 spec.
>
>
>> I want to find out which is the corresponding driver code for device
>> '/dev/video11'.
>
>
> I suspect these numbers are fixed in the Android kernel (they are hard
> coded in the user space library as you're pointing out above), which is
> a pretty bad practice.
>
> It's better to use VIDIOC_QUERYCAP ioctl to find a video device with
> specific name, as Devin suggested. You can also find a video device
> exposed by a specific driver through sysfs, as is done in
> exynos_v4l2_open_devname() function in this a bit less hacky code:
>
> https://android.googlesource.com/platform/hardware/samsung_slsi/exynos5/+/jb-mr1-release/libv4l2/exynos_v4l2.c
>
> Thanks,
> Sylwester
