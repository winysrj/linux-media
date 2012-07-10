Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34507 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907Ab2GJM0M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jul 2012 08:26:12 -0400
Received: by yenl2 with SMTP id l2so11155245yen.19
        for <linux-media@vger.kernel.org>; Tue, 10 Jul 2012 05:26:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201207100839.32830.hverkuil@xs4all.nl>
References: <1340991243-2951-1-git-send-email-elezegarcia@gmail.com>
	<CALF0-+W_rNqn-cXK76DJH=5DtdgmvzrfDg-ZcF_RHu_-2pGR2w@mail.gmail.com>
	<CALF0-+WhLkraoL2ckVAqcU044z5tJ3xaWg1EXByBpzKn8My8iQ@mail.gmail.com>
	<201207100839.32830.hverkuil@xs4all.nl>
Date: Tue, 10 Jul 2012 09:26:11 -0300
Message-ID: <CALF0-+VKNfp=_qUzoTKfJO_nsj_e+29pnNAt5Ze-BCewccBjJA@mail.gmail.com>
Subject: Re: [PATCH v4] media: Add stk1160 new driver
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tue, Jul 10, 2012 at 3:39 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Tue July 10 2012 05:17:41 Ezequiel Garcia wrote:
>> Hey Mauro,
>>
>> On Fri, Jul 6, 2012 at 11:41 AM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
>> > On Thu, Jul 5, 2012 at 9:01 PM, Mauro Carvalho Chehab
>> > <mchehab@redhat.com> wrote:
>> >> Em 05-07-2012 19:36, Sylwester Nawrocki escreveu:
>> >>> On 07/06/2012 12:11 AM, Mauro Carvalho Chehab wrote:
>> >>>>> +static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
>> >>>>> +{
>> >>>>> +   struct stk1160 *dev = video_drvdata(file);
>> >>>>> +
>> >>>>> +   if (!stk1160_is_owner(dev, file))
>> >>>>> +           return -EBUSY;
>> >>>>> +
>> >>>>> +   return vb2_dqbuf(&dev->vb_vidq, p, file->f_flags&  O_NONBLOCK);
>
> Take a look at the latest videobuf2-core.h: I've added helper functions
> that check the owner. You can probably simplify the driver code quite a bit
> by using those helpers.

Ok.

>
>> >>>>
>> >>>> Why to use O_NONBLOCK here? it should be doing whatever userspace wants.
>> >>>
>> >>> This is OK, since the third argument to vb2_dqbuf() is a boolean indicating
>> >>> whether this call should be blocking or not. And a "& O_NONBLOCK" masks this
>> >>> information out from file->f_flags.
>> >>
>> >> Ah! OK then.
>> >>
>> >> It might be better to initialize it during vb2 initialization, at open,
>> >> instead of requiring this argument every time vb_dqbuf() is called.
>
> You can't do this at open since the application can change the NONBLOCK mode
> after open. So the current approach is correct.

Yes, that sounds ok. Let's wait until Mauro returns from holiday to discuss this
with him.

Also, what do you think about current_norm usage?

Regards,
Ezequiel.
