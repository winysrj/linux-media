Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34720 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215Ab0F0D0f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Jun 2010 23:26:35 -0400
Received: by ewy7 with SMTP id 7so57455ewy.19
        for <linux-media@vger.kernel.org>; Sat, 26 Jun 2010 20:26:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C26AAAC.1020803@redhat.com>
References: <AANLkTim9TfITmvy7nEuSVJnCxRwCkpbmgRc2FIIIWHGF@mail.gmail.com>
	<201006262051.52754.hverkuil@xs4all.nl>
	<AANLkTikPKv6iCQmV14JSiR61AUMswsOoTB7i-eSHAwH4@mail.gmail.com>
	<4C26AAAC.1020803@redhat.com>
Date: Sat, 26 Jun 2010 23:26:33 -0400
Message-ID: <AANLkTimAXMupX9hYyfiTwZdi4d9a1v_N5sdz8k6b_Xhs@mail.gmail.com>
Subject: Re: Correct way to do s_ctrl ioctl taking into account subdev
	framework?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jun 26, 2010 at 9:34 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> would do the trick. Yet, the application is broken, as it is considering a positive
> return as an error. A positive code should never be considered as an error. So, we
> need to fix v4l2-ctl as well (ok, returning 1 is wrong as well, as this is a non-v4l2
> compliance in this case).

A strict interpretation of the spec would read that returning zero is
success, -1 is an well-formed error condition, and *ANYTHING* else is
a violation of the spec and an application used for testing compliance
should complain very loudly (which is exactly what it does).

In effect, the only patch I would consider valid for v4l2-ctl would be
one that makes the error even more LOUD than it already is.

> We might add a new handler at subdev, but, as Laurent is reworking
> it, the above trick would be an acceptable workaround.

Great.  I'll submit a patch to this effect, which would be applicable
until we have a final solution in place.

Thanks,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
