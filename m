Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:34161 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752250AbdEPRBc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 May 2017 13:01:32 -0400
Received: by mail-oi0-f42.google.com with SMTP id b204so33363734oii.1
        for <linux-media@vger.kernel.org>; Tue, 16 May 2017 10:01:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2075aeff-6ef9-8fa8-696e-f932d68a03ea@xs4all.nl>
References: <CAF_dkJBOf16Xz=wx6KT4FLqU_X+Ok+0ZbsV=JfRGs_tN+YKHeQ@mail.gmail.com>
 <2075aeff-6ef9-8fa8-696e-f932d68a03ea@xs4all.nl>
From: Patrick Doyle <wpdster@gmail.com>
Date: Tue, 16 May 2017 13:01:01 -0400
Message-ID: <CAF_dkJBswpV0vYvAKvD7m+i7SPz58cqNeF0ZAWicKuVWnhtkfw@mail.gmail.com>
Subject: Re: v4l2_subdev_queryctrl and friends
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 16, 2017 at 12:13 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> It needs something like this (taken from rcar-vin.c):
>
>         ret = v4l2_ctrl_add_handler(&vin->ctrl_handler, sd->ctrl_handler, NULL);
>         if (ret < 0)
>                 return ret;
>
Thank you .
That did the trick.

Continuing on the topic of backporting the driver the 4.12 driver to
4.4... should I submit my modified version of the driver to this list
for review and possible inclusion in the 4.4 kernel tree?

--wpd
