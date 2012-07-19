Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:38280 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab2GSTzV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jul 2012 15:55:21 -0400
Received: by gglu4 with SMTP id u4so3210474ggl.19
        for <linux-media@vger.kernel.org>; Thu, 19 Jul 2012 12:55:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201207192148.33665.hverkuil@xs4all.nl>
References: <1340308332-1118-1-git-send-email-elezegarcia@gmail.com>
	<CALF0-+W88U_cAGMrui9rwbNg8BBgekBi9B2unStKySY_RhS3zw@mail.gmail.com>
	<20120719154111.2e4296b9@pirotess>
	<201207192148.33665.hverkuil@xs4all.nl>
Date: Thu, 19 Jul 2012 16:55:20 -0300
Message-ID: <CALF0-+V2ZvZOsCj_hZuD=wwVL1D7p0smHki4x=YyghiM5Rvdqw@mail.gmail.com>
Subject: Re: [PATCH 10/10] staging: solo6x10: Avoid extern declaration by
 reworking module parameter
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Ismael Luceno <ismael.luceno@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 19, 2012 at 4:48 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Thu July 19 2012 20:41:11 Ismael Luceno wrote:
>> On Thu, 19 Jul 2012 10:25:09 -0300
>> Ezequiel Garcia <elezegarcia@gmail.com> wrote:
>> > On Wed, Jul 18, 2012 at 7:26 PM, Ismael Luceno
>> > <ismael.luceno@gmail.com> wrote:
>> > > On Thu, Jun 21, 2012 at 4:52 PM, Ezequiel Garcia
>> > > <elezegarcia@gmail.com> wrote:
>> > >> This patch moves video_nr module parameter to core.c
>> > >> and then passes that parameter as an argument to functions
>> > >> that need it.
>> > >> This way we avoid the extern declaration and parameter
>> > >> dependencies are better exposed.
>> > > <...>
>> > >
>> > > NACK.
>> > >
>> > > The changes to video_nr are supposed to be preserved.
>> >
>> > Mmm, I'm sorry but I don't see any functionality change in this patch,
>> > just a cleanup.
>> >
>> > What do you mean by "changes to video_nr are supposed to be
>> > preserved"?
>>
>> It is modified by solo_enc_alloc, which is called multiple times by
>> solo_enc_v4l2_init.
>
> You don't need to modify it at all. video_register_device() will start
> looking for a free video node number starting at video_nr and counting
> upwards, so increasing video_nr has no purpose. Leaving it out will give
> you exactly the same result.
>

Yes, but perhaps the module author wanted to force a device
/dev/videoX *start* number,
as it's documented in the parameter usage string:

  MODULE_PARM_DESC(video_nr, "videoX start number, -1 is autodetect (default)");

Now, I don't now why would one want to do that or if it makes sense at all.
In any case, it seems it's the intended behavior.
