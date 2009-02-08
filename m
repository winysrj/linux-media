Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43843 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbZBHKIn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Feb 2009 05:08:43 -0500
Date: Sun, 8 Feb 2009 08:07:47 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: CityK <cityk@rogers.com>
Cc: hermann pitton <hermann-pitton@arcor.de>,
	David Engel <david@istwok.net>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	V4L <video4linux-list@redhat.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Josh Borke <joshborke@gmail.com>,
	David Lonie <loniedavid@gmail.com>, linux-media@vger.kernel.org
Subject: Re: KWorld ATSC 115 all static
Message-ID: <20090208080747.7d0ed1c5@caramujo.chehab.org>
In-Reply-To: <498926EE.4050204@rogers.com>
References: <7994.62.70.2.252.1232028088.squirrel@webmail.xs4all.nl>
	<496FE555.7090405@rogers.com>
	<496FFCE2.8010902@rogers.com>
	<200901171720.03890.hverkuil@xs4all.nl>
	<49737088.7060800@rogers.com>
	<20090202235820.GA9781@opus.istwok.net>
	<4987DE4E.2090902@rogers.com>
	<1233714662.3728.45.camel@pc10.localdom.local>
	<498926EE.4050204@rogers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 04 Feb 2009 00:26:06 -0500
CityK <cityk@rogers.com> wrote:

> Nope -- as I mentioned, dropping back to a snapshot from roughly 3 weeks
> ago and applying Mike's patch works with both the nv and nvidia driver,
> hence disproving that it is anything X related. 

CityK,

It seems I missed your email with the detailed logs.

Let's go by parts: Let's first try to solve the issue with the i2c gate, in
order to have both analog and digital modes to work properly. After having it
fixed, we can go ahead and check if the issue with some softwares are a
regression at the driver (or at v4l core) or something else at X space.

Could you please send me the logs of the driver of it working (old tree +
Mike's patch) and not working (with current tip)?

Please load it with the following debug options:
	modprobe saa7134 i2c_scan=1 video_debug=3 core_debug=1 i2c_debug=1

Btw, I have one PCMCIA board with me that stopped working with Hans patches
applied at tip. So, I suspect that some regression were caused by the i2c
conversion. I'll use this board to debug the driver.

Cheers,
Mauro
