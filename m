Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f178.google.com ([209.85.213.178]:33144 "EHLO
        mail-yb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750872AbdGDF6U (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Jul 2017 01:58:20 -0400
Received: by mail-yb0-f178.google.com with SMTP id 84so61032362ybe.0
        for <linux-media@vger.kernel.org>; Mon, 03 Jul 2017 22:58:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170626153936.GB3090@jade>
References: <20170616073915.5027-2-gustavo@padovan.org> <201706182254.xqhcA9D6%fengguang.wu@intel.com>
 <20170626153936.GB3090@jade>
From: Tomasz Figa <tfiga@google.com>
Date: Tue, 4 Jul 2017 14:57:58 +0900
Message-ID: <CAAFQd5Ay_gN0pa8Q_Qk-UL_H3j-ana-uOySSSQL=7h5Vx=4SFQ@mail.gmail.com>
Subject: Re: [PATCH 01/12] [media] vb2: add explicit fence user API
To: Gustavo Padovan <gustavo@padovan.org>
Cc: kbuild test robot <lkp@intel.com>, kbuild-all@01.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gustavo,

On Tue, Jun 27, 2017 at 12:39 AM, Gustavo Padovan <gustavo@padovan.org> wrote:
> 2017-06-18 kbuild test robot <lkp@intel.com>:
>
>> Hi Gustavo,
>>
>> [auto build test ERROR on linuxtv-media/master]
>> [also build test ERROR on v4.12-rc5 next-20170616]
>> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>>
>> url:    https://github.com/0day-ci/linux/commits/Gustavo-Padovan/vb2-add-explicit-fence-user-API/20170618-210740
>> base:   git://linuxtv.org/media_tree.git master
>> config: x86_64-allmodconfig (attached as .config)
>> compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
>> reproduce:
>>         # save the attached .config to linux build tree
>>         make ARCH=x86_64
>>
>> All error/warnings (new ones prefixed by >>):
>>
>>    drivers/staging/media//atomisp/pci/atomisp2/atomisp_ioctl.c: In function 'atomisp_qbuf':
>> >> drivers/staging/media//atomisp/pci/atomisp2/atomisp_ioctl.c:1297:10: error: 'struct v4l2_buffer' has no member named 'reserved2'; did you mean 'reserved'?
>>          (buf->reserved2 & ATOMISP_BUFFER_HAS_PER_FRAME_SETTING)) {
>>              ^~
>>    drivers/staging/media//atomisp/pci/atomisp2/atomisp_ioctl.c:1299:50: error: 'struct v4l2_buffer' has no member named 'reserved2'; did you mean 'reserved'?
>>       pipe->frame_request_config_id[buf->index] = buf->reserved2 &
>>                                                      ^~
>>    drivers/staging/media//atomisp/pci/atomisp2/atomisp_ioctl.c: In function 'atomisp_dqbuf':
>>    drivers/staging/media//atomisp/pci/atomisp2/atomisp_ioctl.c:1483:5: error: 'struct v4l2_buffer' has no member named 'reserved2'; did you mean 'reserved'?
>>      buf->reserved2 = pipe->frame_config_id[buf->index];
>>         ^~
>>    In file included from include/linux/printk.h:329:0,
>>                     from include/linux/kernel.h:13,
>>                     from include/linux/delay.h:21,
>>                     from drivers/staging/media//atomisp/pci/atomisp2/atomisp_ioctl.c:24:
>>    drivers/staging/media//atomisp/pci/atomisp2/atomisp_ioctl.c:1488:6: error: 'struct v4l2_buffer' has no member named 'reserved2'; did you mean 'reserved'?
>>       buf->reserved2);
>>          ^
>
> Ouch! Seems the reserved2 was burned down by 2 drivers accessing it
> without any care for the uAPI. I'll change my patches to use the
> 'reserved' field instead.

Given that a reserved field has a clear meaning of being reserved and
the driver in question is in staging. I'd rather vote for fixing the
driver.

Best regards,
Tomasz
