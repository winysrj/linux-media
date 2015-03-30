Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:50698 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753911AbbC3UVc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2015 16:21:32 -0400
Date: Mon, 30 Mar 2015 22:21:19 +0200
From: Stefan Lippers-Hollmann <s.l-h@gmx.de>
To: David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	m.chehab@samsung.com, James Hogan <james.hogan@imgtec.com>,
	Antti =?UTF-8?B?U2VwcMOkbMOk?= <a.seppala@gmail.com>,
	Tomas Melin <tomas.melin@iki.fi>
Subject: Re: mceusb: sysfs: cannot create duplicate filename '/class/rc/rc0'
  (race condition between multiple RC_CORE devices)
Message-ID: <20150330222119.16ee359e@mir>
In-Reply-To: <61aca9029bf06b2a3f322018aee00dda@hardeman.nu>
References: <201412181916.18051.s.L-H@gmx.de>
	<201412302211.40801.s.L-H@gmx.de>
	<20150330173031.1fb46443@mir>
	<61aca9029bf06b2a3f322018aee00dda@hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

On 2015-03-30, David Härdeman wrote:
> On 2015-03-30 17:30, Stefan Lippers-Hollmann wrote:
> > Hi
> > 
> > This is a follow-up for:
> > 	http://lkml.kernel.org/r/<201412181916.18051.s.L-H@gmx.de>
> > 	http://lkml.kernel.org/r/<201412302211.40801.s.L-H@gmx.de>
> 
> I can't swear that it's the case but I'm guessing this might be fixed by 
> the patches I posted earlier (in particular the one that converted 
> rc-core to use the IDA infrastructure for keeping track of registered 
> minor device numbers).

Do you have a pointer to that patch (-queue) or a tree containing it?
So far I've only found https://patchwork.linuxtv.org/patch/23370/
with those keywords, respectively the thread at 
http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/76514
which seems to be partially applied, anything I could test (reproducing
the problem takes its time, probably 4-10 weeks to be really sure, but 
I'd be happy to try or forward port the required parts).

Thanks a lot
	Stefan Lippers-Hollmann
