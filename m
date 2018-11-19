Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:38603 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728514AbeKSVcB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Nov 2018 16:32:01 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Shuah Khan <shuah@kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: videobuf2-core.c: call to v4l_vb2q_enable_media_source()?
Message-ID: <b71907b6-9e41-f56c-8c25-3b0cf47be645@xs4all.nl>
Date: Mon, 19 Nov 2018 12:08:42 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shuah, Mauro,

I noticed that the function vb2_core_streamon() in videobuf2-core.c calls
v4l_vb2q_enable_media_source(q).

That function in turn assumes that q->owner is a v4l2_fh struct. But I
don't think that is true for DVB devices.

And since videobuf2-core.c is expected to be DVB/V4L independent, this seems
wrong.

It was introduced over 2 years ago in commit 77fa4e0729987:

commit 77fa4e072998705883c4dc672963b4bf7483cea9
Author: Shuah Khan <shuahkh@osg.samsung.com>
Date:   Thu Feb 11 21:41:29 2016 -0200

    [media] media: Change v4l-core to check if source is free

    Change s_input, s_fmt, s_tuner, s_frequency, querystd, s_hw_freq_seek,
    and vb2_core_streamon interfaces that alter the tuner configuration to
    check if it is free, by calling v4l_enable_media_source().

    If source isn't free, return -EBUSY.

    v4l_disable_media_source() is called from v4l2_fh_exit() to release
    tuner (source).

    vb2_core_streamon() uses v4l_vb2q_enable_media_source().

    Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Note that this precedes the DVB_MMAP config option, so at the time this
likely worked fine. But I wonder why it works if that DVB_MMAP option is
set? Pure luck?

I think this call should be moved to videobuf2-v4l2.c (might require some
refactoring). It really doesn't belong in videobuf2-core.c.

Regards,

	Hans
