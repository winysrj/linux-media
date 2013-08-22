Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56192 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab3HVA5F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Aug 2013 20:57:05 -0400
Received: by mail-bk0-f46.google.com with SMTP id 6so447962bkj.33
        for <linux-media@vger.kernel.org>; Wed, 21 Aug 2013 17:57:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201308211347.08650.hverkuil@xs4all.nl>
References: <CALxrGmVAtz3x1aCUf5QArvp9J4ioXBObuhBdAL8J-p3yMeyppg@mail.gmail.com>
	<201308211347.08650.hverkuil@xs4all.nl>
Date: Thu, 22 Aug 2013 08:57:01 +0800
Message-ID: <CALxrGmVfRj_Kc0C29w99pUw3K9c3X2SrO0RNG_G-xiJiSz52fw@mail.gmail.com>
Subject: Re: A false alarm for recursive lock in v4l2_ctrl_add_handler
From: Su Jiaquan <jiaquan.lnx@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>, jqsu@marvell.com,
	tianxf@marvell.com, xzhao10@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wed, Aug 21, 2013 at 7:47 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Wed 21 August 2013 12:56:21 Su Jiaquan wrote:
>> Hi Hans,
>>
>> Recently when we enable LOCKDEP in our kernel, it detected a "possible
>> recursive locking". As we check the code, we found that it's just a
>> false alarm, the conceived scenario should never happen. Shell I
>> submit a patch to suppress it?
>
> A patch went in for 3.10 that suppresses this false alarm.
>
> Regards,
>
>         Hans
>

Sorry I didn't notice the fix, Is it this one?

commit 6cd247ef22e493e1884e576c066661538b031981
Author: Andy Walls <awalls@md.metrocast.net>
Date:   Sat Mar 9 05:55:11 2013 -0300

    [media] v4l2-ctrls: eliminate lockdep false alarms for struct
v4l2_ctrl_handler.lock

Thanks!

Jiaquan
