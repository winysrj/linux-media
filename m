Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:62687 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755354Ab0J0N7q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Oct 2010 09:59:46 -0400
Received: by qwf7 with SMTP id 7so2362qwf.19
        for <linux-media@vger.kernel.org>; Wed, 27 Oct 2010 06:59:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CC827DD.5070109@redhat.com>
References: <AANLkTikGT6m9Ji3bBrwUB-yJY9dT0j8eCP_RNAvh3deG@mail.gmail.com>
	<4CC7EC13.1080008@redhat.com>
	<20101027104933.GC15291@aniel.fritz.box>
	<4CC827DD.5070109@redhat.com>
Date: Wed, 27 Oct 2010 15:59:45 +0200
Message-ID: <AANLkTim6ji=_bgdPWpv7608J8t6P5EfWZrhq8BRVWjnR@mail.gmail.com>
Subject: Re: [PATCH] Too slow libv4l MJPEG decoding with HD cameras
From: Mitar <mmitar@gmail.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Janne Grunau <j@jannau.net>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi!

On Wed, Oct 27, 2010 at 3:23 PM, Hans de Goede <hdegoede@redhat.com> wrote:
> If and only if libjpeg-turbo turns out to be much slower this is something
> to consider. But the first thing to do here is see if we can solve this
> in a way which is acceptable to all downstream users of libv4l, and thus
> can be added in a non optional way (so make libv4l require libjpeg).

I opted for avcodec as I have been told it is the fastest
implementation around. But I have not really tested that claim. So for
sure this should be tested. I tested just original tinyjpeg vs.
avcodec implementation.

I am sorry but I do not have time to do more work on this. Especially
because libjpeg-turbo also seems to have problems with restart
markers:

http://libjpeg-turbo.virtualgl.org/About/Performance (at the end)

which is the problem I am currently try to deal with also with ffmpeg:

https://roundup.ffmpeg.org/issue2325

Restart markers are used by Logitech HD Pro Webcam C910 to allow
decoding of MJPEG in parallel for example on GPU for even faster
decoding.

So implementing libjpeg-turbo does not seem that it would give me a
working solution and improvement over libavcodec. (And for ffmpeg
there is at least patch for that.)

Maybe we should make libv4l plugable in this respect? So that
different underlying libraries could be easily swapped and tested and
used? Or just use different compilation switches and let distribution
maintainers decide which one they want to use?


Mitar
