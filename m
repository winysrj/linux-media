Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:45967 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758Ab0DAV3c (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Apr 2010 17:29:32 -0400
Received: by gwaa18 with SMTP id a18so1054361gwa.19
        for <linux-media@vger.kernel.org>; Thu, 01 Apr 2010 14:29:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BB50D1A.7020803@redhat.com>
References: <201004011001.10500.hverkuil@xs4all.nl>
	 <4BB4D9AB.6070907@redhat.com>
	 <g2q829197381004011129lc706e6c3jcac6dcc756012173@mail.gmail.com>
	 <201004012306.31471.hverkuil@xs4all.nl> <4BB50D1A.7020803@redhat.com>
Date: Thu, 1 Apr 2010 17:29:30 -0400
Message-ID: <n2y829197381004011429u1d405025t8586abebeb3948ef@mail.gmail.com>
Subject: Re: V4L-DVB drivers and BKL
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 1, 2010 at 5:16 PM, Mauro Carvalho Chehab <mchehab@redhat.com>
>> What was the reason behind the asynchronous loading? In general it simplifies
>> things a lot if you load modules up front.
>
> The reason is to avoid a dead lock: driver A depends on symbols on B (the
> other driver init code) that depends on symbols at A (core stuff, locks, etc).

I believe these problems can be avoided with a common entry point for
initializing the DVB submodule (where the loading of the subordinate
module sets a pointer to a function for the main module to call).  In
fact, doesn't em28xx do that today with it's "init" function for its
submodules?

> There are other approaches to avoid this trouble, like the attach method used
> by the DVB modules, but an asynchronous (and parallel) load offers another
> advantage: it speeds up boot time, as other processors can take care of the
> load of the additonal modules.

I think though that we need to favor stability/reliability over
performance.  In this case, I have seen a number of bridges where
having a "-dvb.ko" exposes this race, and I would much rather have it
take another 200ms to load the driver than continue to deal with
intermittent problems with hardware being in an unknown state.  Don't
quote me on this number, but on em28xx I run into problems about 20%
of the time where the dvb device fails to get created successfully
because of this race (forcing me to reboot the system).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
