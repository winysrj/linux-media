Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48711 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab1KKBpt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Nov 2011 20:45:49 -0500
Received: by yenr9 with SMTP id r9so2649345yen.19
        for <linux-media@vger.kernel.org>; Thu, 10 Nov 2011 17:45:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1320967905-7932-1-git-send-email-pdickeybeta@gmail.com>
References: <1320967905-7932-1-git-send-email-pdickeybeta@gmail.com>
Date: Thu, 10 Nov 2011 20:45:48 -0500
Message-ID: <CAGoCfiz5O4_GHnYWtt4RQsRCWV7iXEh8DYYNFX1_R7Ni2e3Yvg@mail.gmail.com>
Subject: Re: [PATCH 00/25] Add PCTV-80e Support to v4l
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Patrick Dickey <pdickeybeta@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 10, 2011 at 6:31 PM, Patrick Dickey <pdickeybeta@gmail.com> wrote:
> These are the files required to support the Pinnacle PCTV-80e USB Tuner in
> video-4-linux. The files were originally downloaded from
> http://www.kernellabs.com/hg/~dheitmueller/v4l-dvb-80e and modified to fix
> compilation errors and also to move the driver files from the drx39xy
> subdirectory to the frontends directory.
<snip>

Hi Patrick,

It's great to see someone taking the time to work to get this
upstream.  A few comments though:

None of these patches appear to have an Signed-off-by line.  Since I'm
the one vouching for the Micronas code being legitimately allowed to
be submitted (in conformance with the Developer's Certificate of
Origin), I am the one who needs to be the top signed-off-by (in fact,
by arbitrarily breaking my tree into 25 patches, you effectively
stripped off my authorship).

Further, while it's commendable that you broke this into 25 patches, I
think it's perfectly fine that it essentially be the two patches as
found in my hg tree (plus the very minor change needed to get the code
to compile against 3.x).  In fact, I suspect you could probably take
my two patches, apply them to the current 3.x tree, fix the two or
three conflicts, and have something that is submittable to staging.

It's not clear to me why you moved the driver files from
frontends/drx39xxj to just frontends.  I don't think anybody has ever
complained about having a subdirectory if there is a large enough set
of files.  Did somebody ask you to do that and I didn't see the email?

As you indicated, the code hasn't gone through any form of codingstyle
cleanup, and as a result needs to go against the staging tree instead
of the main tree.  You should consult with Mauro on how to approach
this problem, because currently you cannot do a demodulator driver
against staging because of the dependency on the em28xx bridge which
is already in stable (adding Mauro to the cc: to get his opinion).

In short, it almost feels like you did *too much* work given you
didn't make any material changes to the code itself as it's in my
tree.  I would suggest just submitting my two patches, and then on top
of that you can submit a whole series of patches doing cleanups.

And you should definitely review the following page on submitting
patches if you haven't already:

http://linuxtv.org/wiki/index.php/Development:_How_to_submit_patches

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
