Return-path: <linux-media-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42724 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752232Ab1LCQlQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 3 Dec 2011 11:41:16 -0500
Date: Sat, 3 Dec 2011 16:42:52 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andreas Oberritter <obi@linuxtv.org>
Cc: HoP <jpetrous@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver
 because of worrying about possible misusage?
Message-ID: <20111203164252.3a66d638@lxorguk.ukuu.org.uk>
In-Reply-To: <4EDA4AB4.90303@linuxtv.org>
References: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com>
	<4ED6C5B8.8040803@linuxtv.org>
	<4ED75F53.30709@redhat.com>
	<CAJbz7-0td1FaDkuAkSGQRdgG5pkxjYMUGLDi0Y5BrBF2=6aVCw@mail.gmail.com>
	<20111202231909.1ca311e2@lxorguk.ukuu.org.uk>
	<4EDA4AB4.90303@linuxtv.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> FWIW, the virtual DVB device we're talking about doesn't have any
> networking capabilities by itself. It only allows to create virtual DVB
> adapters and to relay DVB API ioctls to userspace in a
> transport-agnostic way.

Which you can do working from CUSE already, as has been pointed out or
with LD_PRELOAD. This btw makes the proprietary thing seem a rather odd
objection - they could do it too.

> The original version of the vtuner interface makes use of demux hardware
> and also feeds the relevant streams to a/v decoders, in which case you
> cannot avoid copying the MPEG data to kernel space.

Right and that aspect of it actually makes a lot more sense to me,
because receive and decode/playback are different functional units.

But jumping up and down arguing about how you want to name the code isn't
going to produce a productive result

To answer the other question posed by "HoP" - yes you can do TCP from
kernel space. We need this for things like NFS, CIFS etc. That might well
be valuable especially for low end hardware. The best code to read is
probably the net/sunrpc code to get an idea of how it ends up looking.

Alan
