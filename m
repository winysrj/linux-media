Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:37870 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042Ab1AaOND (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Jan 2011 09:13:03 -0500
Message-ID: <4D46C36A.1040407@redhat.com>
Date: Mon, 31 Jan 2011 12:12:58 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Andy Walls <awalls@md.metrocast.net>
Subject: Re: [GIT PATCHES FOR 2.6.39] fix cx18 regression
References: <201101260823.43809.hverkuil@xs4all.nl>
In-Reply-To: <201101260823.43809.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 26-01-2011 05:23, Hans Verkuil escreveu:
> Mauro, please get this upstream asap since this fix needs to go into 2.6.38
> as well.
> 
> Regards,
> 
> 	Hans
> 
> The following changes since commit e5fb95675639f064ca40df7ad319f1c380443999:
>   Hans Verkuil (1):
>         [media] vivi: fix compiler warning
> 
> are available in the git repository at:
> 
>   ssh://linuxtv.org/git/hverkuil/media_tree.git cx18-fix
> 
> Hans Verkuil (1):
>       cx18: fix kernel oops when setting MPEG control before capturing.
> 
>  drivers/media/video/cx18/cx18-driver.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 

I tried to apply it against 2.6.38-rc2, but it failed:

       	mutex_init(&cx->serialize_lock);
        mutex_init(&cx->gpio_lock);
        mutex_init(&cx->epu2apu_mb_lock);
       	mutex_init(&cx->epu2cpu_mb_lock);

        ret = cx18_create_in_workq(cx);
<<<<<<<
=======
       	cx->cxhdl.capabilities = CX2341X_CAP_HAS_TS | CX2341X_CAP_HAS_SLICED_VBI;
        cx->cxhdl.ops = &cx18_cxhdl_ops;
        cx->cxhdl.func = cx18_api_func;
        cx->cxhdl.priv = &cx->streams[CX18_ENC_STREAM_TYPE_MPG];
        ret = cx2341x_handler_init(&cx->cxhdl, 50);
>>>>>>>
        if (ret)
                return ret;

Perhaps this change requires some patch delayed for .39?

Cheers,
Mauro
