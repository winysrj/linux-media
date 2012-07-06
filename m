Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:54762 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab2GFOlw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 10:41:52 -0400
Received: by ghrr11 with SMTP id r11so8660608ghr.19
        for <linux-media@vger.kernel.org>; Fri, 06 Jul 2012 07:41:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FF62AD8.2080907@redhat.com>
References: <1340991243-2951-1-git-send-email-elezegarcia@gmail.com>
	<4FF61111.7050900@redhat.com>
	<4FF616E5.6040206@gmail.com>
	<4FF62AD8.2080907@redhat.com>
Date: Fri, 6 Jul 2012 11:41:51 -0300
Message-ID: <CALF0-+W_rNqn-cXK76DJH=5DtdgmvzrfDg-ZcF_RHu_-2pGR2w@mail.gmail.com>
Subject: Re: [PATCH v4] media: Add stk1160 new driver
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Sylwester Nawrocki <snjw23@gmail.com>, linux-media@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 5, 2012 at 9:01 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 05-07-2012 19:36, Sylwester Nawrocki escreveu:
>> On 07/06/2012 12:11 AM, Mauro Carvalho Chehab wrote:
>>>> +static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
>>>> +{
>>>> +   struct stk1160 *dev = video_drvdata(file);
>>>> +
>>>> +   if (!stk1160_is_owner(dev, file))
>>>> +           return -EBUSY;
>>>> +
>>>> +   return vb2_dqbuf(&dev->vb_vidq, p, file->f_flags&  O_NONBLOCK);
>>>
>>> Why to use O_NONBLOCK here? it should be doing whatever userspace wants.
>>
>> This is OK, since the third argument to vb2_dqbuf() is a boolean indicating
>> whether this call should be blocking or not. And a "& O_NONBLOCK" masks this
>> information out from file->f_flags.
>
> Ah! OK then.
>
> It might be better to initialize it during vb2 initialization, at open,
> instead of requiring this argument every time vb_dqbuf() is called.
>

Okey, I'll do that.

> Btw, just noticed a minor issue: an space is required before the "&" operator.
>

That space was there, it got mangled on Sylwester answer. :-)

Regards,
Ezequiel.
