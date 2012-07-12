Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:46066 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab2GLX71 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jul 2012 19:59:27 -0400
Received: by gglu4 with SMTP id u4so3059149ggl.19
        for <linux-media@vger.kernel.org>; Thu, 12 Jul 2012 16:59:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201207100839.32830.hverkuil@xs4all.nl>
References: <1340991243-2951-1-git-send-email-elezegarcia@gmail.com>
	<CALF0-+W_rNqn-cXK76DJH=5DtdgmvzrfDg-ZcF_RHu_-2pGR2w@mail.gmail.com>
	<CALF0-+WhLkraoL2ckVAqcU044z5tJ3xaWg1EXByBpzKn8My8iQ@mail.gmail.com>
	<201207100839.32830.hverkuil@xs4all.nl>
Date: Thu, 12 Jul 2012 20:59:25 -0300
Message-ID: <CALF0-+Wt4PJFceOVq40qhcOUScjYsg8APuKFR_ZjE9z-M83c1g@mail.gmail.com>
Subject: Re: [PATCH v4] media: Add stk1160 new driver
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

On Tue, Jul 10, 2012 at 3:39 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> Take a look at the latest videobuf2-core.h: I've added helper functions
> that check the owner. You can probably simplify the driver code quite a bit
> by using those helpers.
>

Indeed, using latest vb2_xxx_fop and vb2_ioctl_xxx the driver can be
heavily reduced.
(Great work, by the way)

Almost every function looks like a direct replacement, except for mmap.

If you look at current stk1160, I'm taking the lock for mmap:

        mutex_lock(&dev->v4l_lock);
        rc = vb2_mmap(&dev->vb_vidq, vma);
        mutex_unlock(&dev->v4l_lock);


However, vb2_fop_mmap does no locking. I'm having a hard time understanding
why this is not needed, perhaps you could clarify this a bit?

Thanks,
Ezequiel.
