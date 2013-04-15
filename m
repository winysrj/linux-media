Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754985Ab3DOVeQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Apr 2013 17:34:16 -0400
Date: Mon, 15 Apr 2013 18:34:05 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: Patchwork and em28xx delegates
Message-ID: <20130415183405.44aa28eb@redhat.com>
In-Reply-To: <516C6AFB.1060601@googlemail.com>
References: <516C2DC8.8080203@googlemail.com>
	<20130415135018.3a867598@redhat.com>
	<516C6AFB.1060601@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 15 Apr 2013 23:02:51 +0200
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Am 15.04.2013 18:50, schrieb Mauro Carvalho Chehab:
> > Em Mon, 15 Apr 2013 18:41:44 +0200
> > Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
> >
> >> I've just noticed that my 2 pending em28xx patches have got delegate
> >> assigned:
> >>
> >> https://patchwork.linuxtv.org/patch/17834/
> >> => delegated to mkrufky
> >>
> >> https://patchwork.linuxtv.org/patch/17928/     (Obsoleted)
> >> => delegated to hverkuil
> >>
> >> Ist this a patchwork failure or is the new submaintainers workflow the
> >> reason ?
> > Sub-maintainers workflow. We expect that most patches will be applied via 
> > one of the sub-maintainers. That will likely improve Kernel's quality and
> > help to reduce the maintainers overload.
> 
> How is the em28xx driver split betweend the submaintainers ?

Analog part => Hans
Tuners, demods  => Mkrufky

> Where should I send em28xx patches in the future ? 

To the same place: linux-media@vger.kernel.org.

> You are still the em28xx maintainer, right ?

Currently, I only wear the driver maintainer's hat when there's no other people
looking into it, or when the patches would affect something that I'm working
with.

The advantage is that a patch get more reviews, with is good.

Btw, em28xx is not auto-delegated. If it was received such delegation,
it is likely because either Hans or Michael (or both) decided to add
reviewing your patches on their todo list.

Of course, if are there any dependency between the three patches in this
series, that means that the entire 3 patch series will needed to be
merged into just one sub-maintainers tree.

Cheers,
Mauro
