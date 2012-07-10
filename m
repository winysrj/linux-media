Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50398 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072Ab2GJDRm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Jul 2012 23:17:42 -0400
Received: by yhmm54 with SMTP id m54so86292yhm.19
        for <linux-media@vger.kernel.org>; Mon, 09 Jul 2012 20:17:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALF0-+W_rNqn-cXK76DJH=5DtdgmvzrfDg-ZcF_RHu_-2pGR2w@mail.gmail.com>
References: <1340991243-2951-1-git-send-email-elezegarcia@gmail.com>
	<4FF61111.7050900@redhat.com>
	<4FF616E5.6040206@gmail.com>
	<4FF62AD8.2080907@redhat.com>
	<CALF0-+W_rNqn-cXK76DJH=5DtdgmvzrfDg-ZcF_RHu_-2pGR2w@mail.gmail.com>
Date: Tue, 10 Jul 2012 00:17:41 -0300
Message-ID: <CALF0-+WhLkraoL2ckVAqcU044z5tJ3xaWg1EXByBpzKn8My8iQ@mail.gmail.com>
Subject: Re: [PATCH v4] media: Add stk1160 new driver
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Sylwester Nawrocki <snjw23@gmail.com>, linux-media@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey Mauro,

On Fri, Jul 6, 2012 at 11:41 AM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
> On Thu, Jul 5, 2012 at 9:01 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> Em 05-07-2012 19:36, Sylwester Nawrocki escreveu:
>>> On 07/06/2012 12:11 AM, Mauro Carvalho Chehab wrote:
>>>>> +static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
>>>>> +{
>>>>> +   struct stk1160 *dev = video_drvdata(file);
>>>>> +
>>>>> +   if (!stk1160_is_owner(dev, file))
>>>>> +           return -EBUSY;
>>>>> +
>>>>> +   return vb2_dqbuf(&dev->vb_vidq, p, file->f_flags&  O_NONBLOCK);
>>>>
>>>> Why to use O_NONBLOCK here? it should be doing whatever userspace wants.
>>>
>>> This is OK, since the third argument to vb2_dqbuf() is a boolean indicating
>>> whether this call should be blocking or not. And a "& O_NONBLOCK" masks this
>>> information out from file->f_flags.
>>
>> Ah! OK then.
>>
>> It might be better to initialize it during vb2 initialization, at open,
>> instead of requiring this argument every time vb_dqbuf() is called.

Currently stk1160 doesn't implement an open call, but uses v4l2_fh_open instead.
I'm not sure I should add a separate open, or perhaps you would accept
to initialize this non-block flag in vidioc_reqbufs.

On the other hand, many drivers are doing it at dqbuf, like here at stk1160,
and I was wondering: is it *that* bad?

Thanks,
Ezequiel.
