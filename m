Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:33556 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab2GSTSb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jul 2012 15:18:31 -0400
Received: by gglu4 with SMTP id u4so3165123ggl.19
        for <linux-media@vger.kernel.org>; Thu, 19 Jul 2012 12:18:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120719154111.2e4296b9@pirotess>
References: <1340308332-1118-1-git-send-email-elezegarcia@gmail.com>
	<1340308332-1118-10-git-send-email-elezegarcia@gmail.com>
	<CADThq4+29av-MeYZR8KfBiBQkFPx+OpWhe40Kk+WX1yUD=4dOA@mail.gmail.com>
	<CALF0-+W88U_cAGMrui9rwbNg8BBgekBi9B2unStKySY_RhS3zw@mail.gmail.com>
	<20120719154111.2e4296b9@pirotess>
Date: Thu, 19 Jul 2012 16:18:30 -0300
Message-ID: <CALF0-+Vv2DhBsddcu_fm47Y3YQDd9vkCZC=ChcxWhoKcenZYTg@mail.gmail.com>
Subject: Re: [PATCH 10/10] staging: solo6x10: Avoid extern declaration by
 reworking module parameter
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Ismael Luceno <ismael.luceno@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 19, 2012 at 3:41 PM, Ismael Luceno <ismael.luceno@gmail.com> wrote:
> On Thu, 19 Jul 2012 10:25:09 -0300
> Ezequiel Garcia <elezegarcia@gmail.com> wrote:
>> On Wed, Jul 18, 2012 at 7:26 PM, Ismael Luceno
>> <ismael.luceno@gmail.com> wrote:
>> > On Thu, Jun 21, 2012 at 4:52 PM, Ezequiel Garcia
>> > <elezegarcia@gmail.com> wrote:
>> >> This patch moves video_nr module parameter to core.c
>> >> and then passes that parameter as an argument to functions
>> >> that need it.
>> >> This way we avoid the extern declaration and parameter
>> >> dependencies are better exposed.
>> > <...>
>> >
>> > NACK.
>> >
>> > The changes to video_nr are supposed to be preserved.
>>
>> Mmm, I'm sorry but I don't see any functionality change in this patch,
>> just a cleanup.
>>
>> What do you mean by "changes to video_nr are supposed to be
>> preserved"?
>
> It is modified by solo_enc_alloc, which is called multiple times by
> solo_enc_v4l2_init.

Mmm, I see what you mean. Sorry for not noticing that :-(

However, I still think that extern int is really not needed and should
be cleaned up.
Using global variables is not a nice practice, and using this extern
hides dependencies, i.e. hides who is using video_nr.
(For instance, I failed to see such dependency)

Perhaps, you could consider passing the int as a pointer, so that
solo_enc_alloc()
can modify it.

However, since it's your driver, you have access to the hardware, etc.
I won't push any further this issue. Plus, this little issue is not the
one preventing from moving out of staging.

Feel free to nack any other of the patches,
though I think this one was the only one non-trivial.

Thanks for reviewing,
Ezequiel.
