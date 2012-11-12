Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657Ab2KLLfA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Nov 2012 06:35:00 -0500
Message-ID: <50A0DED4.9010500@redhat.com>
Date: Mon, 12 Nov 2012 09:34:44 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Richard <tuxbox.guru@gmail.com>
CC: linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>
Subject: Re: Skeleton LinuxDVB framework
References: <CAKQROYViF1PhLNquiPOQAxRs4jnwHXg-kK2PBG3irTtnXpDCwg@mail.gmail.com> <000d01cdb886$d08f8ed0$71aeac70$@com> <20121102104734.04d708de@gaivota.chehab> <CAKQROYW6VAppdPFXT1vR0hE+jwZyq9hors2aGkAEW5=dEU0m+A@mail.gmail.com>
In-Reply-To: <CAKQROYW6VAppdPFXT1vR0hE+jwZyq9hors2aGkAEW5=dEU0m+A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Richard,

Em 11-11-2012 07:25, Richard escreveu:
> Hi Mauro (and others),
>
> The documentation shows userspace applications quite clearly, and they
> are very easy - its the device driver that I would like to understand
> and implement on a SoC. The 'Copy someone elses' idea will get me to
> an end, but I have to convince my team of engineers/architects that
> the LinuxDVB is the future; and currently I cannot find any
> documentation on the .fops, calling conventions, execution order (what
> is the dependency order of devices) and such.  I would like to promote
> the understanding of the driver, and not blindly hack someone else's
> creations. (Hacking code causes maintenance problems later on)
> I am currently using a proprietary API that was developed originally
> for NeucleusOS that works, and now would like to move to a Linux
> standard type system. (Moving from a Working API to an unknown API is
> a risk)
>
> Are there any architecture/API documentation on how the driver is
> implemented, even pseudo-code would be useful. (Call is 'The Anatomy
> of the DVB driver' if you will)

I see. AFAIKT, you won't find any such documentation for the current
API. The thing is that some userspace developers believe that the better
documentation is the open sourced code, and that they also prefer to
code than to write documentation.

There is, however, some recent description for the dvb-usb-v2 API,
sent to the mailing list (Antti: it makes sense to put the very latest
version under Documentation/dvb).

So, until very recently, we were still fighting to synchronize the
userspace API with the code, as there used to have lots of discrepancy
there. The V4L2 API is a little ahead, in terms of documentation, as
we started to document the internal API a few years ago (at
Documentation/video4linux/v4l2-framework.txt). Also, a lwn.net article
covered several aspects of it.

Yet, there aren't many places where you need to take a look to see how
the DVB core works:

$ ls -la drivers/media/dvb-core/*.[ch]
-rw-rw-r-- 1 v4l v4l  8791 Out  6 09:14 drivers/media/dvb-core/demux.h
-rw-rw-r-- 1 v4l v4l 30946 Out 29 09:46 drivers/media/dvb-core/dmxdev.c
-rw-rw-r-- 1 v4l v4l  2592 Out 25 16:12 drivers/media/dvb-core/dmxdev.h
-rw-rw-r-- 1 v4l v4l 45886 Out  6 09:14 drivers/media/dvb-core/dvb_ca_en50221.c
-rw-rw-r-- 1 v4l v4l  4082 Out  6 09:14 drivers/media/dvb-core/dvb_ca_en50221.h
-rw-rw-r-- 1 v4l v4l 32288 Out 27 16:15 drivers/media/dvb-core/dvb_demux.c
-rw-rw-r-- 1 v4l v4l  3811 Out  6 09:14 drivers/media/dvb-core/dvb_demux.h
-rw-rw-r-- 1 v4l v4l 11848 Out  6 09:14 drivers/media/dvb-core/dvbdev.c
-rw-rw-r-- 1 v4l v4l  4089 Out  6 09:14 drivers/media/dvb-core/dvbdev.h
-rw-rw-r-- 1 v4l v4l 12922 Out  6 09:14 drivers/media/dvb-core/dvb_filter.c
-rw-rw-r-- 1 v4l v4l  6064 Out  6 09:14 drivers/media/dvb-core/dvb_filter.h
-rw-rw-r-- 1 v4l v4l 71891 Out 29 09:46 drivers/media/dvb-core/dvb_frontend.c
-rw-rw-r-- 1 v4l v4l 12634 Out 17 09:58 drivers/media/dvb-core/dvb_frontend.h
-rw-rw-r-- 1 v4l v4l  5423 Out  6 09:14 drivers/media/dvb-core/dvb_math.c
-rw-rw-r-- 1 v4l v4l  1974 Out  6 09:14 drivers/media/dvb-core/dvb_math.h
-rw-rw-r-- 1 v4l v4l 42937 Out 27 16:14 drivers/media/dvb-core/dvb_net.c
-rw-rw-r-- 1 v4l v4l  1686 Out 27 16:14 drivers/media/dvb-core/dvb_net.h
-rw-rw-r-- 1 v4l v4l  7225 Out  6 09:14 drivers/media/dvb-core/dvb_ringbuffer.c
-rw-rw-r-- 1 v4l v4l  6340 Out  6 09:14 drivers/media/dvb-core/dvb_ringbuffer.h
-rw-rw-r-- 1 v4l v4l 15385 Out  6 09:14 drivers/media/dvb-core/dvb-usb-ids.h

The DVB core is typically a way better any proprietary DVB stack. The
maturity of the code is warranted by having probably the largest developers
community inspecting it and fixing bugs.

For example, as the code is part of the upstream Kernel, the team of Kernel
janitors are always looking into the code and fixing issues there. Also,
when some internal Linux API got changed or fixed, the one that does such
changes also apply the fixes at the DVB stack, making it properly integrated
into the Kernel.

As you likely know, the way Linux development works is that interested
people submit us patches with the things they're working. Others will review
the submission, asking for corrections, when needed. When everything is ok,
I merge the stuff and send it upstream. That applies to documentation too.

So, if you're willing to work on writing some documentation for the DVB
stack, feel free to submit us documentation patches. We can then review
and eventually fix it if we found anything wrong or imprecisely described.

Regards,
Mauro
