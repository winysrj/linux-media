Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:64355 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab2ACLCK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Jan 2012 06:02:10 -0500
Date: Tue, 3 Jan 2012 11:59:26 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
	"Wu, Josh" <Josh.wu@atmel.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [GIT PULL] at91: devices and boards files update for 3.3
In-Reply-To: <4F02DD2E.9070401@atmel.com>
Message-ID: <Pine.LNX.4.64.1201031156440.6716@axis700.grange>
References: <4EEA034C.9020800@atmel.com> <CAOesGMiEg-8LA9-yUXRrDwGLGfVeFn7Xax9jhkDr+fZ5GU06QA@mail.gmail.com>
 <4EEB73DD.3070505@atmel.com> <CAOesGMjC8tOY52LV=E9=KX_FbcC-eMoNHJ4E87vOrqk44=zJnA@mail.gmail.com>
 <Pine.LNX.4.64.1112171928380.13817@axis700.grange>
 <CAOesGMi6-iPPBSP_TgKHf_agGSOrQeoB1CU=xhj8wuM2dQvf0A@mail.gmail.com>
 <Pine.LNX.4.64.1112180103220.13817@axis700.grange>
 <CAOesGMiWH--=_fu1ufztb6jZLTDO8_EboDd+hEd=TN-AnRJ3Yw@mail.gmail.com>
 <4F02DD2E.9070401@atmel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(added Mauro and linux-media to CC)

On Tue, 3 Jan 2012, Nicolas Ferre wrote:

> On 12/20/2011 05:32 AM, Olof Johansson :
> > On Sat, Dec 17, 2011 at 4:08 PM, Guennadi Liakhovetski
> > <g.liakhovetski@gmx.de> wrote:
> > 
> >>> We can keep one late-merge branch in arm-soc that contain patches with
> >>> external and possibly late dependencies and submit that branch last,
> >>> but it would be good if we had a bit of margin to get it in. :)
> >>
> >> Ok, let's try this.
> > 
> > Sounds good. Let us know when the stable branch is available. Nicolas,
> > please prepare your branch as soon as possible once you have that info
> > and send a pull request -- we still want the code into arm-soc
> > branches very soon.
> 
> Olof, Guennadi,
> 
> I rebase today this branch on top of:
> git://linuxtv.org/gliakhovetski/v4l-dvb.git for-3.3
> 
> I send another pull request real-soon-now...
> Will it be still possible to make it for 3.3 merge window?

Looks like Mauro still hasn't pulled my branch in. I did ask him on IRC to 
do this and to push to Linus asap, but maybe he has missed that, I really 
should have mentioned that in the pull request. Mauro, could you, please, 
pull and include my branch in your first pull request for Linus for 3.3?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
