Return-path: <linux-media-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45368 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753968Ab1LDOnI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 4 Dec 2011 09:43:08 -0500
Date: Sun, 4 Dec 2011 14:44:42 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: VDR User <user.vdr@gmail.com>
Cc: Walter Van Eetvelt <walter@van.eetvelt.be>,
	Andreas Oberritter <obi@linuxtv.org>, HoP <jpetrous@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver
 because of worrying about possible misusage?
Message-ID: <20111204144442.23d65ae8@lxorguk.ukuu.org.uk>
In-Reply-To: <CAA7C2qgz1GYhVwXwiO5dt09+Mv0719tfCBmK7ud07RZ2VDNxTw@mail.gmail.com>
References: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com>
	<4ED6C5B8.8040803@linuxtv.org>
	<4ED75F53.30709@redhat.com>
	<CAJbz7-0td1FaDkuAkSGQRdgG5pkxjYMUGLDi0Y5BrBF2=6aVCw@mail.gmail.com>
	<20111202231909.1ca311e2@lxorguk.ukuu.org.uk>
	<4EDA4AB4.90303@linuxtv.org>
	<CAA7C2qjfWW8=kePZDO4nYR913RyuP-t+u8P9LV4mDh9bANr3=Q@mail.gmail.com>
	<aff8302dd6c3eb047c39d3a2d1fd2382@mail.eetvelt.be>
	<CAA7C2qgz1GYhVwXwiO5dt09+Mv0719tfCBmK7ud07RZ2VDNxTw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> While I agree with your more broad view of the issue, I specifically
> talked about VDR.  AFAIK Klaus has no intention of adding true
> server/client support to VDR, so for VDR users, this sounds like it
> could be a working solution without the strict limitations of
> streamdev.

So fix Klaus rather than mess up the kernel.

If you are trying to solve a VDR political problem then kernel hacks are
not the way to go. Someone who cares about it needs to fix VDR, with or
without its current maintainer.
