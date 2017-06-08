Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35861 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751578AbdFHVg5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Jun 2017 17:36:57 -0400
MIME-Version: 1.0
In-Reply-To: <20170608171728.09d3b194@vento.lan>
References: <20170313192035.29859-1-gustavo@padovan.org> <20170525003101.GA16058@jade>
 <20170608171728.09d3b194@vento.lan>
From: Shuah Khan <shuahkhan@gmail.com>
Date: Thu, 8 Jun 2017 15:36:56 -0600
Message-ID: <CAKocOOOZCSjKe6FLxyLV3m0LxFqGM4BgEwokvbdhVvbMxKDAyQ@mail.gmail.com>
Subject: Re: [RFC 00/10] V4L2 explicit synchronization support
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Gustavo Padovan <gustavo@padovan.org>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        shuahkh@osg.samsung.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gustavo,

On Thu, Jun 8, 2017 at 2:17 PM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> Hi Gustavo,
>
> Em Wed, 24 May 2017 21:31:01 -0300
> Gustavo Padovan <gustavo@padovan.org> escreveu:
>
>> Hi all,
>>
>> I've been working on the v2 of this series, but I think I hit a blocker
>> when trying to cover the case where the driver asks to requeue the
>> buffer. It is related to the out-fence side.
>>
>> In the current implementation we return on QBUF an out-fence fd that is not
>> tied to any buffer, because we don't know the queueing order until the
>> buffer is queued to the driver. Then when the buffer is queued we use
>> the BUF_QUEUED event to notify userspace of the index of the buffer,
>> so now userspace knows the buffer associated to the out-fence fd
>> received earlier.
>>
>> Userspace goes ahead and send a DRM Atomic Request to the kernel to
>> display that buffer on the screen once the fence signals. If it is
>> a nonblocking request the fence waiting is past the check phase, thus
>> it isn't allowed to fail anymore.
>>
>> But now, what happens if the V4L2 driver calls buffer_done() asking
>> to requeue the buffer. That means the operation failed and can't
>> signal the fence, starving the DRM side.
>>
>> We need to fix that. The only way I can see is to guarantee ordering of
>> buffers when out-fences are used. Ordering is something that HAL3 needs
>> to so maybe there is more than one reason to do it like this. I'm not
>> a V4L2 expert, so I don't know all the consequences of such a change.
>>
>> Any other ideas?
>>
>> The current patchset is at:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/padovan/linux.git/log/?h=v4l2-fences

Do you plan to send the v2 out? I did a quick review and have a few comments.

[media] vb2: split out queueing from vb_core_qbuf()

It changes the sequence a bit.

/* Fill buffer information for the userspace */
  if (pb)
  call_void_bufop(q, fill_user_buffer, vb, pb);

With the changes - user information is filled before __enqueue_in_driver(vb);

Anyway, it might be a good idea to send the v2 out for review and we can review
patches in detail. I am hoping to test your patch series on odroid-xu4
next week.
Could you please add me to the thread as well as include me when you send
v2 and subsequent versions.

thanks,
-- Shuah
