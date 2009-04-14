Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:47263 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190AbZDNMxC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Apr 2009 08:53:02 -0400
Received: by fxm2 with SMTP id 2so2412026fxm.37
        for <linux-media@vger.kernel.org>; Tue, 14 Apr 2009 05:53:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090414091233.3ea2f6e4@pedra.chehab.org>
References: <200903262049.10425.vasily@scopicsoftware.com>
	 <200904131317.01731.hverkuil@xs4all.nl>
	 <36c518800904131808m67482f2ex54307dfab91ccdf0@mail.gmail.com>
	 <20090414091233.3ea2f6e4@pedra.chehab.org>
Date: Tue, 14 Apr 2009 15:53:00 +0300
Message-ID: <36c518800904140553m41fcbd34rb265e0993dd76689@mail.gmail.com>
Subject: Re: [REVIEW] v4l2 loopback
From: vasaka@gmail.com
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 14, 2009 at 3:12 PM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> On Tue, 14 Apr 2009 04:08:41 +0300
> vasaka@gmail.com wrote:
>
>> On Mon, Apr 13, 2009 at 2:17 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> > On Thursday 26 March 2009 19:49:10 Vasily wrote:
>> >> Hello, please review the new version of v4l2 loopback driver.
>> >> I fixed up comments to the previous submission, waiting for the new ones
>> >> :-), reposting for patchwork tool
>> >>
>> >> ---
>> >> This patch introduces v4l2 loopback module
>> >>
>> >> From: Vasily Levin <vasaka@gmail.com>
>> >>
>> >> This is v4l2 loopback driver which can be used to make available any
>> >> userspace video as v4l2 device. Initialy it was written to make
>> >> videoeffects available to Skype, but in fact it have many more uses.
>> >
>> > Hi Vasily,
>> >
>> > It's still on my todo list, but I have had very little time. If you still
>> > haven't seen a review in two weeks time, then please send me a reminder.
>> >
>> > Sorry about this, normally I review things like this much sooner but it has
>> > been very hectic lately.
>> >
>> > Regards,
>> >
>> >        Hans
>>
>> Hi Hans,
>>
>> Thanks for updating, driver is still waiting for review, I am glad to
>> here that it is on a todo list :-)
>
> Vasily,
>
> It is on my todo list. I've postponed it since it is valuable to have some
> discussions about this driver.
>
> The issue I see is that the V4L drivers are meant to support real devices. This
> driver that is a loopback for some userspace driver. I don't discuss its value
> for testing purposes or other random usage, but I can't see why this should be
> at upstream kernel.
>
> So, I'm considering to add it at v4l-dvb tree, but as an out-of-tree driver
> only. For this to happen, probably, we'll need a few adjustments at v4l build.
>
> Cheers,
> Mauro
>

Mauro,

ok, let it be out-of -tree driver, this is also good as I do not have
to adapt the driver to each new kernel, but I want to argue alittle
about Inclusion of the driver into upstream kernel.

 Main reason for inclusion to the kernel is ease of use, as I
understand installing the out-of-tree driver for some kernel needs
downloading of the whole v4l-dvb tree(am I right?).

 Loopback gives one opportunities to do many fun things with video
streams and when it needs just one step to begin using it chances that
someone will do something useful with the driver are higher.

 Awareness that there is such thing as loopback is also. If the driver
is in upstream tree - more people will see it and more chances that
more people will participate in loopback getiing better.

 vivi is an upstream driver :-)

Vasily
