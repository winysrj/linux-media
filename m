Return-path: <linux-media-owner@vger.kernel.org>
Received: from test.hauke-m.de ([5.39.93.123]:55369 "EHLO test.hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932514AbaGWTEk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jul 2014 15:04:40 -0400
Message-ID: <53D00578.3090906@hauke-m.de>
Date: Wed, 23 Jul 2014 20:56:56 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: "backports@vger.kernel.org" <backports@vger.kernel.org>,
	linux-media@vger.kernel.org
Subject: Re: Removal of regulator framework
References: <53CA9A77.6060409@hauke-m.de> <CAB=NE6WvY1ZnwogYR0YLuiMUOeRvqeEjhhnLHUpeJjteSTwfGA@mail.gmail.com> <20140723145724.3102ae3a.m.chehab@samsung.com> <CAB=NE6W3+fRQkxe-TEKVyPSMXWNVr44TNhCwd6g-7nH+83jx=Q@mail.gmail.com>
In-Reply-To: <CAB=NE6W3+fRQkxe-TEKVyPSMXWNVr44TNhCwd6g-7nH+83jx=Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/23/2014 08:23 PM, Luis R. Rodriguez wrote:
> On Wed, Jul 23, 2014 at 10:57 AM, Mauro Carvalho Chehab
> <m.chehab@samsung.com> wrote:
>> Em Wed, 23 Jul 2014 10:13:28 -0700
>> "Luis R. Rodriguez" <mcgrof@do-not-panic.com> escreveu:
>>
>>> On Sat, Jul 19, 2014 at 9:19 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>>>> Maintaining the regulator drivers in backports costs some time and I do
>>>> not need them. Is anybody using the regulator drivers from backports? I
>>>> would like to remove them.
>>>
>>> That came simply from collateral of backporting media drivers,
>>> eventually I started running into device drivers that used the
>>> regulator framework. Since we have tons of media drivers perhaps the
>>> more sensible thing to do is to white list a set of media divers that
>>> people actually care and then we just nuke both regulator and media
>>> drivers that no one cares for. For that though I'd like to ask media
>>> folks.
>>
>> Hi Luis,
>>
>> The drivers that currently use regulators are mostly the ones at
>> drivers/media/platform, plus the corresponding I2C drivers for their
>> webcam sensors, under drivers/media/i2c.
>>
>> I think that there's one exception though: em28xx. This driver can use
>> some sensor drivers, as it supports a few webcams. This is one of
>> the most used USB media driver, as there are lots of USB supported
>> on it, supporting 4 types of devices on it: analog TV, capture card,
>> digital TV and webcam.
>>
>> The webcam part of em28xx is not that relevant, as there are very few
>> models using it. However, currently, it is not possible to just
>> disable webcam support. It shouldn't be hard to make webcam support
>> optional on it, as it has already sub-drivers for V4L2, DVB, ALSA and
>> remote controller. One additional driver for webcam, that could be
>> disabled at the backport tree shouldn't be hard to do. If you want it,
>> patches are welcome.
> 
> Thanks for the details Mauro, are you aware of current or future uses
> of backports for media at this point? Adding media drivers was more of
> an experiment to see how hard or easy it would be to add a new
> unrelated subsystem, we carry it now and as collateral also carry some
> regulator drivers but its not clear the value in terms of users, so
> hence Hauke's question of removal of the regulator drivers. It'd be
> good to limit the drivers we carry to what folks actually use and care
> about.
> 
>   Luis
> 

Hi,

carrying some regularity drivers which are needed for some specific
media driver does not look like a big problem. The current problem from
my side is that we carry all regularity drivers by default and that
causes some problems. Many of these driver are used only on one specific
SoC product line and uses their often changing interface, so they break
often.

When all the regulator drivers are only needed for the media driver I
would add just add the driver which are actually used by a shipped media
driver and nothing more.

Hauke
