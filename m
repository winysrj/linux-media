Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:36908 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346AbZBHMkk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Feb 2009 07:40:40 -0500
Date: Sun, 8 Feb 2009 10:39:57 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: CityK <cityk@rogers.com>, hermann pitton <hermann-pitton@arcor.de>,
	David Engel <david@istwok.net>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	V4L <video4linux-list@redhat.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Josh Borke <joshborke@gmail.com>,
	David Lonie <loniedavid@gmail.com>,
	linux-media@vger.kernel.org, Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: KWorld ATSC 115 all static
Message-ID: <20090208103957.306f4329@caramujo.chehab.org>
In-Reply-To: <20090208080747.7d0ed1c5@caramujo.chehab.org>
References: <7994.62.70.2.252.1232028088.squirrel@webmail.xs4all.nl>
	<496FE555.7090405@rogers.com>
	<496FFCE2.8010902@rogers.com>
	<200901171720.03890.hverkuil@xs4all.nl>
	<49737088.7060800@rogers.com>
	<20090202235820.GA9781@opus.istwok.net>
	<4987DE4E.2090902@rogers.com>
	<1233714662.3728.45.camel@pc10.localdom.local>
	<498926EE.4050204@rogers.com>
	<20090208080747.7d0ed1c5@caramujo.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 8 Feb 2009 08:07:47 -0200
Mauro Carvalho Chehab <mchehab@infradead.org> wrote:

> On Wed, 04 Feb 2009 00:26:06 -0500
> CityK <cityk@rogers.com> wrote:
> 
> > Nope -- as I mentioned, dropping back to a snapshot from roughly 3 weeks
> > ago and applying Mike's patch works with both the nv and nvidia driver,
> > hence disproving that it is anything X related. 
> 
> CityK,
> 
> It seems I missed your email with the detailed logs.
> 
> Let's go by parts: Let's first try to solve the issue with the i2c gate, in
> order to have both analog and digital modes to work properly. After having it
> fixed, we can go ahead and check if the issue with some softwares are a
> regression at the driver (or at v4l core) or something else at X space.
> 
> Could you please send me the logs of the driver of it working (old tree +
> Mike's patch) and not working (with current tip)?
> 
> Please load it with the following debug options:
> 	modprobe saa7134 i2c_scan=1 video_debug=3 core_debug=1 i2c_debug=1

Also, please test the new code I made available at:

	http://linuxtv.org/hg/~mchehab/saa7134

It contains a code that will hopefully fix this issue.

> Btw, I have one PCMCIA board with me that stopped working with Hans patches
> applied at tip. So, I suspect that some regression were caused by the i2c
> conversion. I'll use this board to debug the driver.

The issue here seems to be unrelated: sometimes, tda8290/tda8275 is not
detected on my MSI TV@nyware A/D NB device. The chip simply stops answering at
address 0x4b (7bit notation). Not sure why and not sure if this is a regression
or not. Anyway, while debugging it, I noticed that the i2c gate control for
those devices were broken. I wrote some patches to fix (also at the same tree),
but this didn't solve the issue (it will probably solve another issue with
sleep/wakeup on this device).

Michael,

Please take a look at the tda8290/tda827x patches

Cheers,
Mauro
