Return-path: <mchehab@gaivota>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60619 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892Ab1AAVZG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Jan 2011 16:25:06 -0500
Received: by eye27 with SMTP id 27so5560622eye.19
        for <linux-media@vger.kernel.org>; Sat, 01 Jan 2011 13:25:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201101012218.36967.hverkuil@xs4all.nl>
References: <AANLkTi=3ekVmf-gVU=bO2dHn4svMbExZ3TKGeiV1Jrrd@mail.gmail.com>
	<201101012218.36967.hverkuil@xs4all.nl>
Date: Sat, 1 Jan 2011 16:25:04 -0500
Message-ID: <AANLkTimO713U7x8f5YCdxZgs0LE2cGHj6aNyy0pEj+is@mail.gmail.com>
Subject: Re: V4L2 spec behavior for G_TUNER and T_STANDBY
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Hans,

Thanks for the feedback.

On Sat, Jan 1, 2011 at 4:18 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> This basically means that a video tuner will bail out, which sounds
>> good because the rest of the function supposedly assumes a radio
>> device.  However, as a result the has_signal() call (which returns
>> signal strength) will never be executed for video tuners.  You
>> wouldn't notice this if a video decoder subdev is responsible for
>> showing signal strength, but if you're expecting the tuner to provide
>> the info, the call will never happen.
>
> I am not aware of any tuner that does that. I think that for video this
> is always done by a video decoder. That said, it isn't pretty, but a lot
> of this is legacy code and I wouldn't want to change it.

The Xceive tuners have their analog demodulator onboard, so they make
available a 0-100% signal strength.

> After digging some more I think that check_mode is a poor function. There are
> two things that check_mode does: checking if the tuner support radio and/or tv
> mode (that's fine), and if it is in standby: not so fine. That should be a
> separate function since filling in frequency ranges can be done regardless of
> the standby state.

Yeah, I didn't realize myself that is what check_mode was doing until
I had this problem.

I'll see if I can cook up a patch which returns the appropriate data
even when in standby, while trying to minimize the risk of introducing
a regression.

Thanks,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
