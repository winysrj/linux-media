Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f180.google.com ([209.85.160.180]:36500 "EHLO
	mail-yk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933624AbbGHRJ4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jul 2015 13:09:56 -0400
Received: by ykey15 with SMTP id y15so17063232yke.3
        for <linux-media@vger.kernel.org>; Wed, 08 Jul 2015 10:09:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAM_ZknWEjUTy0btqFYhJvSJiAFV6uTJzB3ceZzEMxNkKHr2dTg@mail.gmail.com>
References: <CAM_ZknV+AEpxbPkKjDo68kRq-5fg1b7p77s+gfF3XGLZS9Tvyg@mail.gmail.com>
	<CAM_ZknWEjUTy0btqFYhJvSJiAFV6uTJzB3ceZzEMxNkKHr2dTg@mail.gmail.com>
Date: Wed, 8 Jul 2015 20:09:55 +0300
Message-ID: <CAM_ZknU-emTOt3c2mS1cC+YZ4hTbev-W-z9GLAP5wHuqF2pfCw@mail.gmail.com>
Subject: Re: tw5864 driver development, help needed
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: Linux Media <linux-media@vger.kernel.org>,
	"kernel-mentors@selenic.com" <kernel-mentors@selenic.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Steven Toth <stoth@kernellabs.com>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
	Walter Lozano <walter@vanguardiasur.com.ar>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 3, 2015 at 5:23 PM, Andrey Utkin
<andrey.utkin@corp.bluecherry.net> wrote:
> Up... we are moving much slower than we expected, desperately needing help.
>
> Running reference driver with Ubuntu 9 (with kernel 2.6.28.10) with
> 16-port card shows that the
> reference driver fails to work with it correctly. Also that driver is
> not complete, it requires your userland counterpart for usable
> operation, which is far from being acceptable in production.
>
> Currently what stops us with our driver is that "H264 encoding done"
> interrupt doesn't repeat, and CRC checksums mismatch for the first
> (and last) time this interrupt happens.
> We do our best to mimic what the reference driver does, but we might
> miss some point.
>
> I suspect that my initialization of video inputs or board clock
> configuration is insufficient or inconsistent with what device needs.
>
> Our work in progress is located in
> https://github.com/krieger-od/linux, directory
> drivers/staging/media/tw5864
>
> This is another request for expert help.
> The time is very important for us now.
>
> Thanks in advance and sorry for distraction.

Thanks for all who contacted us! Now we know we can count on you.
Just a small update so that you know the status of the project (and so
that you won't proceed looking into the last described issue, if this
is the case). We have interrupts repeating, and CRC checksums
matching. Now we are working on formatting of h264 stream (the frames
are returned without any headers, and reference driver has header
generation deeply and tightly bound to other code, so this will take
some time.
The latest state of this work in progress is in
github.com/krieger-od/linux.git , branch "brutal".

-- 
Bluecherry developer.
