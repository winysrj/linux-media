Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:8458 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933617Ab3LIO75 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Dec 2013 09:59:57 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MXJ00CDROBVUS80@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 09 Dec 2013 09:59:55 -0500 (EST)
Date: Mon, 09 Dec 2013 12:59:49 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: linux-media <linux-media@vger.kernel.org>,
	Luis Alves <ljalvs@gmail.com>
Subject: Re: [GIT PULL] git://linuxtv.org/mkrufky/dvb cx24117
Message-id: <20131209125949.69240a89@samsung.com>
In-reply-to: <CAOcJUbwN_op_NcHAmCamrY+oQRFwm4YfC2SXr7NmGfH15fmm9g@mail.gmail.com>
References: <20131113180124.16699fa7@vujade>
 <CAOcJUbwN_op_NcHAmCamrY+oQRFwm4YfC2SXr7NmGfH15fmm9g@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 8 Dec 2013 20:18:04 -0500
Michael Krufky <mkrufky@linuxtv.org> escreveu:

> Mauro,
> 
> What is the status of this pull request?  Patchwork says "changes
> requested" but I have no record of any changes requested....
> 
> https://patchwork.linuxtv.org/patch/20728/

Thanks for pinging about that.

I can't remember about reviewing those patches. Perhaps someone with write
access to patchwork might have changed the status of this one by mistake.

I'll re-tag this as new and review those patches.

Regards,
Mauro

> 
> Thanks,
> 
> Mike
> 
> On Wed, Nov 13, 2013 at 6:01 PM, Michael Krufky <mkrufky@linuxtv.org> wrote:
> > The following changes since commit
> > 80f93c7b0f4599ffbdac8d964ecd1162b8b618b9:
> >
> >   [media] media: st-rc: Add ST remote control driver (2013-10-31
> >   08:20:08 -0200)
> >
> > are available in the git repository at:
> >
> >   git://linuxtv.org/mkrufky/dvb cx24117
> >
> > for you to fetch changes up to 1c468cec3701eb6e26c4911f8a9e8e35cbdebc01:
> >
> >   cx24117: Fix LNB set_voltage function (2013-11-13 13:06:44 -0500)
> >
> > ----------------------------------------------------------------
> > Luis Alves (2):
> >       cx24117: Add complete demod command list
> >       cx24117: Fix LNB set_voltage function
> >
> >  drivers/media/dvb-frontends/cx24117.c | 121
> >  ++++++++++++++++++++-------------- 1 file changed, 71 insertions(+),
> >  50 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro
