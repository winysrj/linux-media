Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56208 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab2CTSLT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Mar 2012 14:11:19 -0400
Received: by yhmm54 with SMTP id m54so340557yhm.19
        for <linux-media@vger.kernel.org>; Tue, 20 Mar 2012 11:11:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <E1S9oTc-0006p5-Qf@www.linuxtv.org>
References: <E1S9oTc-0006p5-Qf@www.linuxtv.org>
Date: Tue, 20 Mar 2012 20:11:18 +0200
Message-ID: <CABA=pqfDxDfx6ngP9JVQSatiMA64ez5qrSJZqyi+j2C6f4MkGA@mail.gmail.com>
Subject: Re: [git:v4l-dvb/for_v3.4] [media] em28xx: support for 2304:0242 PCTV
 QuatroStick (510e)
From: Ivan Kalvachev <ikalvachev@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 3/20/12, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> This is an automatic generated email to let you know that the following
> patch were queued at the
> http://git.linuxtv.org/media_tree.git tree:
>
> Subject: [media] em28xx: support for 2304:0242 PCTV QuatroStick (510e)
> Author:  Ivan Kalvachev <ikalvachev@gmail.com>
> Date:    Mon Mar 19 20:09:55 2012 -0300
>
> It is mostly copy/paste of the 520e code with setting GPIO7 removed
> (no LED light).

> I've worked on just released vanilla linux-3.3.0 kernel, so there may
> be 1/2 lines offset to the internal working source, but most of the
> code should apply cleanly.

If you still haven't pushed this upstream, can you (rebase and) amend
the message and remove the above paragraph. It is useless for commit
message.

Not a big deal if it is too late :)
