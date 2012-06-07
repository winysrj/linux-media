Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44614 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760931Ab2FGRfG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jun 2012 13:35:06 -0400
Received: by bkcji2 with SMTP id ji2so808878bkc.19
        for <linux-media@vger.kernel.org>; Thu, 07 Jun 2012 10:35:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACKLOr1_pOSkMfo7xWMPd4qJvo8MgNa-dswWVKGBx=enaEB2CQ@mail.gmail.com>
References: <1338905173-5968-1-git-send-email-javier.martin@vista-silicon.com>
	<CAOMZO5AnR9e9O+A+8zH+W+3pa0=cey=9wL0Oa2z+YrhYadvQ1w@mail.gmail.com>
	<CACKLOr28+2pQqOKyVP728kiD2BAnCzkMFgNL=059jmTpeFvQHg@mail.gmail.com>
	<CAOMZO5BA9pT0vwXT1zr+-fjHr5eT6eTYEzsKbrCs8rzxiQCwWg@mail.gmail.com>
	<CACKLOr1_pOSkMfo7xWMPd4qJvo8MgNa-dswWVKGBx=enaEB2CQ@mail.gmail.com>
Date: Thu, 7 Jun 2012 14:35:05 -0300
Message-ID: <CAOMZO5CaW+pUmVrgDFT857eyaR8kjzcE89K4ZBwi8TF0f5dxaA@mail.gmail.com>
Subject: Re: [PATCH] media: mx2_camera: Add YUYV output format.
From: Fabio Estevam <festevam@gmail.com>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org, Sascha Hauer <kernel@pengutronix.de>,
	Shawn Guo <shawn.guo@linaro.org>,
	Dirk Behme <dirk.behme@googlemail.com>,
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On Thu, Jun 7, 2012 at 5:30 AM, javier Martin
<javier.martin@vista-silicon.com> wrote:

> As i stated, the driver is still in an early development stage, it
> doesn't do anything useful yet. But this is the public git repository
> if you want to take a look:
>
> git repo: https://github.com/jmartinc/video_visstrim.git
> branch:  mx27-codadx6

Thanks, I will take a look at your tree when I am back to the office next week.

I also see that Linaro's tree has support for VPU for mx5/mx6:
http://git.linaro.org/gitweb?p=landing-teams/working/freescale/kernel.git;a=summary

,so we should probably think in unifying it with mx27 support there too.

>
> FYI we are only interested on adding support for the encoding path of
> the VPU, but we are trying our best to make it modular (as it is done
> in Samsung's [1]), so that anyone can add decoding support later.

Ok, sounds good.

> By the way, you work for Freescale, don't you?

Yes, correct.

> We have a couple of issues with the i.MX27 VPU:
>
> 1- Firmware for the VPU is provided as a table of binary values inside
> a source file which is licensed as GPL, however software is packaged
> in a .tar.gz file that is marked as NDA. Do we have the right to
> distribute this firmware with our products?
> 2- There is a BUG in the firmware that marks P frames as IDR when it
> should only be done to I frames. Would it be possible to have access
> to the source code of the firmware in order to fix that problem?

I will need to check this next week when I am back to the office.

Thanks,

Fabio Estevam
