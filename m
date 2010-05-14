Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:37146 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756753Ab0ENSok (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 May 2010 14:44:40 -0400
Received: by fg-out-1718.google.com with SMTP id d23so1803766fga.1
        for <linux-media@vger.kernel.org>; Fri, 14 May 2010 11:44:39 -0700 (PDT)
Message-ID: <4BED9A16.5070205@googlemail.com>
Date: Fri, 14 May 2010 20:44:38 +0200
From: Frank Schaefer <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Jean-Francois Moine <moinejf@free.fr>, linux-media@vger.kernel.org
Subject: Re: gspca-sonixj: ioctl VIDIOC_DQBUF blocks for 3s and retuns EIO
References: <4BEC21B9.4010605@googlemail.com> <20100514080049.1cf7c726@tele> <4BECFB17.1040500@redhat.com>
In-Reply-To: <4BECFB17.1040500@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans de Goede schrieb:
> Hi,
>
> On 05/14/2010 08:00 AM, Jean-Francois Moine wrote:
>> On Thu, 13 May 2010 17:58:49 +0200
>> Frank Schaefer<fschaefer.oss@googlemail.com>  wrote:
>>
>>> I'm not sure if I'm hitting a bug or this is the expected driver
>>> behavior: With a Microsoft LifeCam VX-3000 (045e:00f5) and
>>> gspca-sonixj, ioctl VIDIOC_DQBUF intermittently blocks for exactly 3
>>> seconds and then returns EIO.
>>> I noticed that it strongly depends on the captured scenery: when it's
>>> changing much, everything is fine.
>>> But when for example capturing the wall under constant (lower) light
>>> conditions, I'm getting this error nearly permanently.
>>>
>>> It's a JPEG-device, so I guess the device stops sending data if the
>>> picture doesn't change and that's how it should be.
>>> But is the long blocking + EIO the way drivers should handle this
>>> situtation ?
>>
>> Hello Frank,
>>
>> You are right, this is a bug. I did not know that a webcam could suspend
>> streaming when the image did not change. I will remove the timeout.
>>
>
> The way jpeg works mandates that for each block some data still needs to
> be generated even if it is a solid color, moreover as these cams do jpeg
> not mpeg, there is no delta towards the previous frame. So the cam should
> not stop streaming if it doe timing out and returning -EIO is
> appropriate.
>
> Thus we should not remove the DQBUF timeout IMHO.
Urgh, sorry, of course jpeg is not mpeg !
So the device *should* not stop sending frames, which means that I will
have to find out what's exactly going on in the kernel...
Will need some time, I don't have permanent access to this device.

Thanks so far,
Frank

