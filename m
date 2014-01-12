Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:58021 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbaALQuW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jan 2014 11:50:22 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZA00ITDS3YU220@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Sun, 12 Jan 2014 11:50:22 -0500 (EST)
Date: Sun, 12 Jan 2014 14:50:17 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Chris Lee <updatelee@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Kworld 330u broken
Message-id: <20140112145017.2f4658e6@samsung.com>
In-reply-to: <52D2C630.60906@googlemail.com>
References: <CAA9z4LYNHuORA+QnO_3NBj4mwBxSMFY8pXoF2y-iYjJD+Xqteg@mail.gmail.com>
 <52D2C630.60906@googlemail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 12 Jan 2014 17:43:28 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> On 10.01.2014 05:08, Chris Lee wrote:
> > Im not sure exactly when it broke but alot of changes have happened in
> > em28xx lately and they've broken my Kworld 330u. The issue is that
> >
> > ctl->demod = XC3028_FE_CHINA;
> > ctl->fname = XC2028_DEFAULT_FIRMWARE;
> > cfg.ctrl  = &ctl;
> >
> > are no longer being set, this causes xc2028_attach
> >
> > if (cfg->ctrl)
> > xc2028_set_config(fe, cfg->ctrl);
> >
> > to never get called. Therefore never load the firmware. Ive attached
> > my logs to show you what I mean.
> >
> > I quickly hacked up a patch, my tree is quite different from V4L's now
> > so the line numbers may not lineup anymore, and Im sure you guys wont
> > like it anyhow lol
> >
> > Chris Lee
> 
> Hi Chris,
> 
> thank you for testing and the patch !
> The suggested changes in em28xx_attach_xc3028() look good, but instead 
> of introducing a second copy of em28xx_setup_xc3028() in em28xx-dvb,
> we should just move this function from the v4l extension back to the core.
> 
> Mauro, I can create a patch, but I assume there is already enough 
> pending em28xx stuff that requires rebasing, so I assume it's easier for 
> you to do it yourself.
> Let me know if I can assist you.

Yes, I can handle it.

Regards,
Mauro
