Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847Ab2ITJHT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Sep 2012 05:07:19 -0400
Message-ID: <505ADD14.7070208@redhat.com>
Date: Thu, 20 Sep 2012 11:08:36 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 4/4] gspca_pac7302: add support for green balance adjustment
References: <1347811240-4000-1-git-send-email-fschaefer.oss@googlemail.com> <1347811240-4000-4-git-send-email-fschaefer.oss@googlemail.com> <5059FFF1.30104@googlemail.com> <505A2C52.4040001@redhat.com> <505A3112.10207@googlemail.com>
In-Reply-To: <505A3112.10207@googlemail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 09/19/2012 10:54 PM, Frank Schäfer wrote:
> Am 19.09.2012 22:34, schrieb Hans de Goede:

<snip>

>>> Hans, it seems like you didn't pick up these patches up yet...
>>> Is there anything wrong with them ?
>>
>> I've somehow completely missed them. Can you resend the entire set
>> please?
>
> No problem, but I can't do that before weekend (I'm currently not at home).
> I've sent these 4 patches on last Sunday (16. Sept) evening.
> Maybe you can pick them up from patchwork ?
> http://patchwork.linuxtv.org/patch/14433/

Ah yes, patchwork, that will work. Unfortunately that only solves the
me having missed the patches problem.

First of all thanks for working on this! I'm afraid you've managed to find
one of the weak spots in the v4l2 API, namely how we deal with RGB gains.

Many webcams have RGB gains, but we don't have standard CID-s for these,
instead we've Blue and Red Balance. This has grown historically because of
the bttv cards which actually have Blue and Red balance controls in hardware,
rather then the usual RGB gain triplet. Various gspca drivers cope with this
in different ways.

If you look at the pac7302 driver before your latest 4 patches it has
a Red and Blue balance control controlling the Red and Blue gain, and a
Whitebalance control, which is not White balance at all, but simply
controls the green gain...

And as said other drivers have similar (albeit usually different) hacks.

At a minimum I would like you to rework your patches to:
1) Not add the new Green balance, and instead modify the existing whitebalance
to control the new green gain you've found. Keeping things as broken as
they are, but not worse; and
2) Try to use both the page 0 reg 0x01 - 0x03 and page 0 reg 0xc5 - 0xc7
at the same time to get a wider ranged control. Maybe 0xc5 - 0xc7 are
simply the most significant bits of a wider ranged gain ?
Note that if you cannot control them both from a single control in such
a way that you get a smooth control range, then lets just fix
0xc5 - 0xc7 at a value of 2 for all 3 and be done with it, but at least
we should try :)

As said the above is the minimum, what I would really like is a discussion
on linux-media about adding proper RGB gain controls for all the cameras
which have these.

Note this brings with itself the question should we export such lowlevel
controls at all ? In some drivers the per color gains are simply all
kept at the same level and controlled as part of the master gain control,
giving it a wider and/or more fine grained range, leading to better autogain
behavior. Given how our sw autowhitebalance works (and that that works
reasonable well), their is not much added value in exporting them separately,
while they do tend to improve the standard gain control when used as part
of it ...

So what we really need is a plan how to deal with these controls, and then
send an RFC for this to the list.

Regards,

Hans
