Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757623Ab0ENHY6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 May 2010 03:24:58 -0400
Message-ID: <4BECFB17.1040500@redhat.com>
Date: Fri, 14 May 2010 09:26:15 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Frank Schaefer <fschaefer.oss@googlemail.com>,
	linux-media@vger.kernel.org
Subject: Re: gspca-sonixj: ioctl VIDIOC_DQBUF blocks for 3s and retuns EIO
References: <4BEC21B9.4010605@googlemail.com> <20100514080049.1cf7c726@tele>
In-Reply-To: <20100514080049.1cf7c726@tele>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 05/14/2010 08:00 AM, Jean-Francois Moine wrote:
> On Thu, 13 May 2010 17:58:49 +0200
> Frank Schaefer<fschaefer.oss@googlemail.com>  wrote:
>
>> I'm not sure if I'm hitting a bug or this is the expected driver
>> behavior: With a Microsoft LifeCam VX-3000 (045e:00f5) and
>> gspca-sonixj, ioctl VIDIOC_DQBUF intermittently blocks for exactly 3
>> seconds and then returns EIO.
>> I noticed that it strongly depends on the captured scenery: when it's
>> changing much, everything is fine.
>> But when for example capturing the wall under constant (lower) light
>> conditions, I'm getting this error nearly permanently.
>>
>> It's a JPEG-device, so I guess the device stops sending data if the
>> picture doesn't change and that's how it should be.
>> But is the long blocking + EIO the way drivers should handle this
>> situtation ?
>
> Hello Frank,
>
> You are right, this is a bug. I did not know that a webcam could suspend
> streaming when the image did not change. I will remove the timeout.
>

The way jpeg works mandates that for each block some data still needs to
be generated even if it is a solid color, moreover as these cams do jpeg
not mpeg, there is no delta towards the previous frame. So the cam should
not stop streaming if it doe timing out and returning -EIO is appropriate.

Thus we should not remove the DQBUF timeout IMHO.

Regards,

Hans
