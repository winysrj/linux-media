Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:58208 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751320AbdGQOfb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Jul 2017 10:35:31 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 14/14] [media] fix warning on v4l2_subdev_call() result
 interpreted as bool
To: Arnd Bergmann <arnd@arndb.de>
References: <20170714092540.1217397-1-arnd@arndb.de>
 <20170714093938.1469319-1-arnd@arndb.de>
 <f57e08d9-0984-b67c-c64b-c7e0542d0361@xs4all.nl>
 <CAK8P3a1zBW_QuPtRFNwuVyE_ziySoV9_ebz4sD7Bya3eRoo8SA@mail.gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        IDE-ML <linux-ide@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        Alan Cox <alan@linux.intel.com>,
        adi-buildroot-devel@lists.sourceforge.net,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        devel@driverdev.osuosl.org
Message-ID: <3a927e60-332a-f01d-f1af-98649e9f51b5@xs4all.nl>
Date: Mon, 17 Jul 2017 16:35:27 +0200
MIME-Version: 1.0
In-Reply-To: <CAK8P3a1zBW_QuPtRFNwuVyE_ziySoV9_ebz4sD7Bya3eRoo8SA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17/07/17 16:26, Arnd Bergmann wrote:
> On Mon, Jul 17, 2017 at 3:45 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> On 14/07/17 11:36, Arnd Bergmann wrote:
>>> @@ -201,8 +202,9 @@ static int cx18_g_fmt_sliced_vbi_cap(struct file *file, void *fh,
>>>        * digitizer/slicer.  Note, cx18_av_vbi() wipes the passed in
>>>        * fmt->fmt.sliced under valid calling conditions
>>>        */
>>> -     if (v4l2_subdev_call(cx->sd_av, vbi, g_sliced_fmt, &fmt->fmt.sliced))
>>> -             return -EINVAL;
>>> +     ret = v4l2_subdev_call(cx->sd_av, vbi, g_sliced_fmt, &fmt->fmt.sliced);
>>> +     if (ret)
>>> +             return ret;
>>
>> Please keep the -EINVAL here. I can't be 100% certain that returning 'ret' wouldn't
>> break something.
> 
> I think Dan was recommending the opposite here, if I understood you
> both correctly:
> he said we should propagate the error code unless we know it's wrong, while you
> want to keep the current behavior to avoid introducing changes ;-)
> 
> I guess in either case, looking at the callers more carefully would be
> a good idea.

The subtle problem here is that v4l2_subdev_call will return -ENOIOCTLCMD if
ops->vbi->g_sliced_fmt == NULL, which typically is not returned to userspace
but either ignored or replaced by another error. It indicates that the
sub device doesn't implement this operation, and it depends on the context
and the operation whether or not that is to be considered an error.

I have no clue what is expected here, without digging deep in the code.

Better to keep it as-is. It really isn't important to waste time on this.

> 
>>> -     return 0;
>>> +     return ret;
>>>  }
>>>
>>>  int atomisp_flash_enable(struct atomisp_sub_device *asd, int num_frames)
>>>
>>
>> This is all very hackish, though. I'm not terribly keen on this patch. It's not
>> clear to me *why* these warnings appear in your setup.
> 
> it's possible that this only happened with 'ccache', which first preprocesses
> the source and the passes it with v4l2_subdev_call expanded into the
> compiler. This means the line looks like
> 
>         if ((!(cx->sd_av) ? -ENODEV :
>             (((cx->sd_av)->ops->vbi && (cx->sd_av)->ops->vbi->g_sliced_fmt) ?
>                (cx->sd_av)->ops->vbi->g_sliced_fmt(cx->sd_av)),
> &fmt->fmt.sliced) :
>                -ENOIOCTLCMD))
> 
> The compiler now complains about the sub-expression that it sees for
> cx->sd_av==NULL:
> 
>    if (-ENODEV)
> 
> which it considers nonsense because it is always true and the value gets
> ignored.
> 
> Let me try again without ccache for now and see what warnings remain.
> We can find a solution for those first, and then decide how to deal with
> ccache.

Sounds good.

I'm OK with applying this if there is no other way to prevent these warnings.

Regards,

	Hans

> 
>         Arnd
> 
