Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f48.google.com ([209.85.219.48]:53858 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425AbaAGUXW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jan 2014 15:23:22 -0500
Received: by mail-oa0-f48.google.com with SMTP id k1so765529oag.7
        for <linux-media@vger.kernel.org>; Tue, 07 Jan 2014 12:23:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAF0Ff2kVYCY=9WJgGw9FMUnjC5a2RG364OxmByCyF+KoQBpxLA@mail.gmail.com>
References: <CAGj5WxCajB0ORTQ_rz9wv+ec9bXE1A9tM_MGP3qb0eyaxhC5ew@mail.gmail.com>
	<52CC275B.5030907@gmx.de>
	<CAGj5WxDuZadCm+Hwp=BDPwPf1fb4nuFXLotK8ePR7Q14-zvkMg@mail.gmail.com>
	<CAF0Ff2kVYCY=9WJgGw9FMUnjC5a2RG364OxmByCyF+KoQBpxLA@mail.gmail.com>
Date: Tue, 7 Jan 2014 20:23:21 +0000
Message-ID: <CAGj5WxBuBvQHg55eJLuje8aiin1ht7nnDjEO=NxUyC0x8U=8wA@mail.gmail.com>
Subject: Re: Upstreaming SAA716x driver to the media_tree
From: Luis Alves <ljalvs@gmail.com>
To: Konstantin Dimitrov <kosio.dimitrov@gmail.com>
Cc: Andreas Regel <andreas.regel@gmx.de>,
	linux-media <linux-media@vger.kernel.org>,
	Chris Lee <updatelee@gmail.com>,
	Manu Abraham <abraham.manu@gmail.com>, crazycat69@narod.ru,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Antti Palosaari <crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Konstantin,
(here we go again...)

What the hell are you talking about? I didn't submit any I2C patch.
This email is just about Manu sending his SAA716x driver to the media_tree.

And where do you see any "saa716x_input.[c|h]" in my repo?

Anyway, since you asked I took some pics:
https://plus.google.com/photos/105602732859464871628/albums/5966247612074668305?authkey=CN3jl9mWhrDhQg
(SDA_HOLD setting in the comment)

For SDA_HOLD = 0x19 the next clock rising edge is really close to the
data line release.
Even 0x14 is too close, so I will use a smaller value so maybe 0x10 is
fine for the 400kHZ clk speed.

And I do have a TBS card that doesn't work with Manu default setting (0x19).


Your email besides being offending, is empty.
If someone's actions hurt the community are your own.

Not going to enter in personal discussions in here nor going to waist
time answering to anymore of your offending emails.
If you want to exchange some thoughts, mail me personally.

Regards,
Luis







On Tue, Jan 7, 2014 at 5:31 PM, Konstantin Dimitrov
<kosio.dimitrov@gmail.com> wrote:
> Luis,
>
> can you explain to us all here how exactly you came up to those
> particular I2C fixes:
>
> https://github.com/ljalves/linux_media/commit/be7cd1ff82cc20578b805ad508d089f818ae726d
>
> because essentially they are the same as what i did years ago -
> included as source code in drivers i made for some TBS cards (source
> code is available all over online) or we just have the exact same case
> with you as before:
>
> http://www.spinics.net/lists/linux-media/msg65888.html
>
> http://www.spinics.net/lists/linux-media/msg65889.html
>
> and you're continue to taking credit for patches i made or basically
> stealing them.
>
> if they were some trivial patches i won't mind, but even they are
> small, they are nothing like trivial.
>
> so, i believe you will have really hard time to explain "your" I2C
> fixes, because for example the SDA hold time value of 0x14 is needed
> for only one particular SAA716x-based card (other such cards can work
> with wide range of SDA hold time settings) and i'm sure you don't know
> that card and cannot cite its model or any technical details why
> that's needed, because you don't have it, as well it takes quite an
> effort and good knowledge of I2C signaling with oscilloscope to figure
> out that value, as well that exactly that value needs changing.
>
> why you didn't use for example 0x16 or 0x13 for SDA hold time in
> "your" I2C patch?!
>
> so, one time, like the previous time, excuse that you just didn't know
> who the author of that work is may fly, but second time, especially
> considering that the SAA716x code base from which i'm sure you took
> (not to use stole) those settings contains my name as copyright,
> because i actually added to that code base new code i developed from
> scratch like for example saa716x_input.[c|h], is another thing you
> cannot explain.
>
> so, i was waiting Manu to upstream his SAA716x driver code some day
> and then submit the improvements i made to it. yet again you're trying
> to take that from me and again, conveniently you included many people
> on CC, but not me.
>
> in my opinion what you're doing is not right, because that patch is
> not clean-room reverse-engineering, you just took those changes from
> another open-source base and if nothing else it's at least common
> courtesy in open-source community when you didn't make them to not
> submit them as "your" patches.
>
> i also think with your actions you're actually hurting the community,
> because people like me, that do actually have the technical
> understanding and can help and contribute further improvements are
> driven away from the community, because
> effectively the community accepting behavior like yours is encouraging
> code stealing!!
>
> --konstantin
>
> On Tue, Jan 7, 2014 at 6:33 PM, Luis Alves <ljalvs@gmail.com> wrote:
>> HI Andreas,
>>
>> My initial commit is based on:
>> http://powarman.dyndns.org/hgwebdir.cgi/v4l-dvb-saa716x/
>> (I think it's your repo with some commits from Soeren Moch)
>>
>> The difference to my working area is that I have the driver placed in
>> "drivers/media/pci/saa716x" (instead of
>> "drivers/media/common/saa716x") and everything is rebased on the
>> latest media_tree.
>> On top of that I just have 2 commits: one to be able to build FF cards
>> and another to fix some i2c issues.
>>
>> You can check my repo here:
>> https://github.com/ljalves/linux_media/commits/saa716x
>>
>> Regards,
>> Luis
>>
>>
>> On Tue, Jan 7, 2014 at 4:12 PM, Andreas Regel <andreas.regel@gmx.de> wrote:
>>> Hi Luis,
>>>
>>> Am 07.01.2014 12:58, schrieb Luis Alves:
>>>> Hi,
>>>>
>>>> I'm finishing a new frontend driver for one of my dvb cards, but the
>>>> pcie bridge uses the (cursed) saa716x.
>>>> As far as I know the progress to upstream Manu's driver to the
>>>> media_tree has stalled.
>>>>
>>>> In CC I've placed some of the people that I found working on it
>>>> lately, supporting a few dvb cards.
>>>>
>>>> It would be good if we could gather everything in one place and send a
>>>> few patchs to get this upstreamed for once...
>>>>
>>>> Manu, do you see any inconvenience in sending your driver to the
>>>> linux_media tree?
>>>> I'm available to place some effort on this task.
>>>
>>> which repository of the saa761x is your work based on?
>>>
>>> Regards,
>>> Andreas
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
