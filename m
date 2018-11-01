Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f193.google.com ([209.85.219.193]:45354 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727453AbeKANF3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Nov 2018 09:05:29 -0400
Received: by mail-yb1-f193.google.com with SMTP id 131-v6so7582262ybe.12
        for <linux-media@vger.kernel.org>; Wed, 31 Oct 2018 21:04:18 -0700 (PDT)
Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com. [209.85.219.178])
        by smtp.gmail.com with ESMTPSA id x129-v6sm2506059ywb.74.2018.10.31.21.04.16
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Oct 2018 21:04:16 -0700 (PDT)
Received: by mail-yb1-f178.google.com with SMTP id t13-v6so1459228ybb.8
        for <linux-media@vger.kernel.org>; Wed, 31 Oct 2018 21:04:16 -0700 (PDT)
MIME-Version: 1.0
References: <CACT4Y+YHx3RUMGLv5T=-FJDZKEavK+sWBbAbenfm8mTQry8F+w@mail.gmail.com>
 <ea1f7e70-6e8c-76a2-291d-228f99ca0cd4@xs4all.nl>
In-Reply-To: <ea1f7e70-6e8c-76a2-291d-228f99ca0cd4@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 1 Nov 2018 13:04:04 +0900
Message-ID: <CAAFQd5DDDvJTB09HnuKTVVTFdStkmeMErcA1Cjavnti_RJG9Zg@mail.gmail.com>
Subject: Re: VIVID/VIMC and media fuzzing
To: dvyukov@google.com
Cc: helen.koike@collabora.com, Hans Verkuil <hverkuil@xs4all.nl>,
        syzkaller@googlegroups.com,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        samitolvanen@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dmitry,

On Wed, Oct 31, 2018 at 6:46 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 10/30/2018 03:02 PM, Dmitry Vyukov wrote:
[snip]
> >
> > Do I understand it correctly that when a process opens /dev/video* or
> > /dev/media* it gets a private instance of the device? In particular,
> > if several processes test this in parallel, will they collide? Or they
> > will stress separate objects?
>
> It actually depends on the driver. M2M devices will give you a private
> instance whenever you open it. Others do not, but you can call most ioctls
> in parallel. But after calling REQBUFS or CREATE_BUFS the filehandle that
> called those ioctls becomes owner of the device until the buffers are
> released. So other filehandles cannot do any streaming operations (EBUSY
> will be returned).

FWIW, you can query whether the device is M2M or not by
VIDIOC_QUERYCAP [1]. The capabilities field would have
V4L2_CAP_VIDEO_M2M or V4L2_CAP_VIDEO_M2M_MPLANE set for M2M devices.

[1] https://www.kernel.org/doc/html/latest/media/uapi/v4l/vidioc-querycap.html

Best regards,
Tomasz
