Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:52672 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbaALQmT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jan 2014 11:42:19 -0500
Received: by mail-ea0-f174.google.com with SMTP id b10so2812312eae.5
        for <linux-media@vger.kernel.org>; Sun, 12 Jan 2014 08:42:18 -0800 (PST)
Message-ID: <52D2C630.60906@googlemail.com>
Date: Sun, 12 Jan 2014 17:43:28 +0100
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Chris Lee <updatelee@gmail.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Kworld 330u broken
References: <CAA9z4LYNHuORA+QnO_3NBj4mwBxSMFY8pXoF2y-iYjJD+Xqteg@mail.gmail.com>
In-Reply-To: <CAA9z4LYNHuORA+QnO_3NBj4mwBxSMFY8pXoF2y-iYjJD+Xqteg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10.01.2014 05:08, Chris Lee wrote:
> Im not sure exactly when it broke but alot of changes have happened in
> em28xx lately and they've broken my Kworld 330u. The issue is that
>
> ctl->demod = XC3028_FE_CHINA;
> ctl->fname = XC2028_DEFAULT_FIRMWARE;
> cfg.ctrl  = &ctl;
>
> are no longer being set, this causes xc2028_attach
>
> if (cfg->ctrl)
> xc2028_set_config(fe, cfg->ctrl);
>
> to never get called. Therefore never load the firmware. Ive attached
> my logs to show you what I mean.
>
> I quickly hacked up a patch, my tree is quite different from V4L's now
> so the line numbers may not lineup anymore, and Im sure you guys wont
> like it anyhow lol
>
> Chris Lee

Hi Chris,

thank you for testing and the patch !
The suggested changes in em28xx_attach_xc3028() look good, but instead 
of introducing a second copy of em28xx_setup_xc3028() in em28xx-dvb,
we should just move this function from the v4l extension back to the core.

Mauro, I can create a patch, but I assume there is already enough 
pending em28xx stuff that requires rebasing, so I assume it's easier for 
you to do it yourself.
Let me know if I can assist you.

Regards,
Frank


