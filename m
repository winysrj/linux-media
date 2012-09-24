Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8688 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398Ab2IXKq1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 06:46:27 -0400
Message-ID: <50603A52.3040208@redhat.com>
Date: Mon, 24 Sep 2012 12:47:46 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 4/4] gspca_pac7302: add support for green balance adjustment
References: <1347811240-4000-1-git-send-email-fschaefer.oss@googlemail.com> <1347811240-4000-4-git-send-email-fschaefer.oss@googlemail.com> <5059FFF1.30104@googlemail.com> <505A2C52.4040001@redhat.com> <505A3112.10207@googlemail.com> <505ADD14.7070208@redhat.com> <505B03FC.3080707@googlemail.com>
In-Reply-To: <505B03FC.3080707@googlemail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Sorry for the slow response ...

On 09/20/2012 01:54 PM, Frank Schäfer wrote:
> Hi,
>
> Am 20.09.2012 11:08, schrieb Hans de Goede:

<snip>

>> Many webcams have RGB gains, but we don't have standard CID-s for these,
>> instead we've Blue and Red Balance. This has grown historically
>> because of
>> the bttv cards which actually have Blue and Red balance controls in
>> hardware,
>> rather then the usual RGB gain triplet. Various gspca drivers cope
>> with this
>> in different ways.
>>
>> If you look at the pac7302 driver before your latest 4 patches it has
>> a Red and Blue balance control controlling the Red and Blue gain, and a
>> Whitebalance control, which is not White balance at all, but simply
>> controls the green gain...
>
> Ok, so if I understand you right, red+green+blue balance = white balance.
> And because we already have defined red, blue and whitebalance controls
> for historical reasons, we don't need green balance ?
> Maybe that matches physics, but I don't think it's a sane approach for a
> user interface...

No what I was trying to say is that the balance controls are for hardware
which actually has balance controls and not per color gains (such as the
bt87x chips), but they are being abused by many drivers to add support for
per color gains. And then you miss one control. And in the case of the pac7302
driver the "original" route was taken of using whitebalance to control
the green gain. Which is wrong IMHO, but it is what the driver does know.

A proper fix would be to introduce new controls for all 3 gains, and use
those instead of using the balance controls + adding a 3th balance control
being discussed in the thread titled:
"Gain controls in v4l2-ctrl framework".

>> And as said other drivers have similar (albeit usually different) hacks.
>>
>> At a minimum I would like you to rework your patches to:
>> 1) Not add the new Green balance, and instead modify the existing
>> whitebalance
>> to control the new green gain you've found. Keeping things as broken as
>> they are, but not worse; and
>
> I prefer waiting for the results of the discussion you are proposing
> further down.
>

I see in your next mail that you've changed your mind. So I would like to
move forward with this by adding your 2 patches + 1 more patch to also
make the whitebalance control (which really is the green gain control)
use 0x02 rather then 0xc6. To do this we must make sure that 0xc6 has
a proper fixed / default setting. So what does the windows driver use
for this? 1 like with 0xc5 and 0xc7 ?

And can you do a 3th patch to make the whitebalance control control
0x02 rather then 0xc6 like you did for red and blue balance?

Then later on when the "Gain controls in v4l2-ctrl framework" discussion
is done we can change these controls to the new controls.

>> 2) Try to use both the page 0 reg 0x01 - 0x03 and page 0 reg 0xc5 - 0xc7
>> at the same time to get a wider ranged control. Maybe 0xc5 - 0xc7 are
>> simply the most significant bits of a wider ranged gain ?
>
> I don't think so. The windows driver does not use them.
> It even doesn't use the full range of registers 0x01-0x03.
> Of course, I have expermiented with the full range and it works, but it
> doesn't make much sense to use it.
>

Ok.


Regards,

Hans
