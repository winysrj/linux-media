Return-path: <mchehab@gaivota>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3163 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714Ab1AAVo4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Jan 2011 16:44:56 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: V4L2 spec behavior for G_TUNER and T_STANDBY
Date: Sat, 1 Jan 2011 22:44:44 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <AANLkTi=3ekVmf-gVU=bO2dHn4svMbExZ3TKGeiV1Jrrd@mail.gmail.com> <201101012218.36967.hverkuil@xs4all.nl> <AANLkTimO713U7x8f5YCdxZgs0LE2cGHj6aNyy0pEj+is@mail.gmail.com>
In-Reply-To: <AANLkTimO713U7x8f5YCdxZgs0LE2cGHj6aNyy0pEj+is@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101012244.44231.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Saturday, January 01, 2011 22:25:04 Devin Heitmueller wrote:
> Hi Hans,
> 
> Thanks for the feedback.
> 
> On Sat, Jan 1, 2011 at 4:18 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >> This basically means that a video tuner will bail out, which sounds
> >> good because the rest of the function supposedly assumes a radio
> >> device.  However, as a result the has_signal() call (which returns
> >> signal strength) will never be executed for video tuners.  You
> >> wouldn't notice this if a video decoder subdev is responsible for
> >> showing signal strength, but if you're expecting the tuner to provide
> >> the info, the call will never happen.
> >
> > I am not aware of any tuner that does that. I think that for video this
> > is always done by a video decoder. That said, it isn't pretty, but a lot
> > of this is legacy code and I wouldn't want to change it.
> 
> The Xceive tuners have their analog demodulator onboard, so they make
> available a 0-100% signal strength.
> 
> > After digging some more I think that check_mode is a poor function. There are
> > two things that check_mode does: checking if the tuner support radio and/or tv
> > mode (that's fine), and if it is in standby: not so fine. That should be a
> > separate function since filling in frequency ranges can be done regardless of
> > the standby state.
> 
> Yeah, I didn't realize myself that is what check_mode was doing until
> I had this problem.
> 
> I'll see if I can cook up a patch which returns the appropriate data
> even when in standby, while trying to minimize the risk of introducing
> a regression.

Since you are working with tuner-core and xceive I wonder if you could also
make a patch to remove T_DIGITAL_TV in enum tuner_mode. T_DIGITAL_TV (and it's
public API counterpart V4L2_TUNER_DIGITAL_TV) are not used (and never were used
since digital tuning is handled through dvb).

We can't remove V4L2_TUNER_DIGITAL_TV (although we can mark it as deprecated in
videodev2.h), but T_DIGITAL_TV should definitely be removed.

The only tuner driver that uses T_DIGITAL_TV is tuner-xc2028.c, but on closer
analysis it turns out that it uses enum tuner_mode as an internal mode. So this
mode is never set outside the driver. Instead it should have used an internal
xceive_mode enum.

Everywhere else T_DIGITAL_TV can be removed.

For some reason I'm in an early spring-cleaning mode (winter-cleaning mode?)
these days :-) Getting rid of old obsolete stuff is always nice.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
