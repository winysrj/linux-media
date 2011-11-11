Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58828 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756462Ab1KKCg3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Nov 2011 21:36:29 -0500
Received: by iage36 with SMTP id e36so3650107iag.19
        for <linux-media@vger.kernel.org>; Thu, 10 Nov 2011 18:36:29 -0800 (PST)
Message-ID: <4EBC8A2C.40305@gmail.com>
Date: Thu, 10 Nov 2011 20:36:28 -0600
From: Patrick Dickey <pdickeybeta@gmail.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 00/25] Add PCTV-80e Support to v4l
References: <1320967905-7932-1-git-send-email-pdickeybeta@gmail.com> <CAGoCfiz5O4_GHnYWtt4RQsRCWV7iXEh8DYYNFX1_R7Ni2e3Yvg@mail.gmail.com>
In-Reply-To: <CAGoCfiz5O4_GHnYWtt4RQsRCWV7iXEh8DYYNFX1_R7Ni2e3Yvg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/10/2011 07:45 PM, Devin Heitmueller wrote:
> On Thu, Nov 10, 2011 at 6:31 PM, Patrick Dickey
> <pdickeybeta@gmail.com> wrote:
>> These are the files required to support the Pinnacle PCTV-80e USB
>> Tuner in video-4-linux. The files were originally downloaded
>> from http://www.kernellabs.com/hg/~dheitmueller/v4l-dvb-80e and
>> modified to fix compilation errors and also to move the driver
>> files from the drx39xy subdirectory to the frontends directory.
> <snip>
> 
> Hi Patrick,
> 
> It's great to see someone taking the time to work to get this 
> upstream.  A few comments though:
> 
> None of these patches appear to have an Signed-off-by line.  Since
> I'm the one vouching for the Micronas code being legitimately
> allowed to be submitted (in conformance with the Developer's
> Certificate of Origin), I am the one who needs to be the top
> signed-off-by (in fact, by arbitrarily breaking my tree into 25
> patches, you effectively stripped off my authorship).
> 

I thought the signed off lines were there. When I generated the
patches, I used "git format-patch -s --subject-prefix='PATCH]
[SIGNED-OFF' media-master " which I thought would add that in. However
it must not have.  I'll resubmit the patches with your name on the top
and then mine below.  It'll probably be tomorrow or Saturday before I
get to that, though.

> Further, while it's commendable that you broke this into 25
> patches, I think it's perfectly fine that it essentially be the two
> patches as found in my hg tree (plus the very minor change needed
> to get the code to compile against 3.x).  In fact, I suspect you
> could probably take my two patches, apply them to the current 3.x
> tree, fix the two or three conflicts, and have something that is
> submittable to staging.
> 

The reason that I broke it up into 25 patches is because I did a test
send to myself (as one patch for the entire driver) and it was almost
3MB in size. So, I decided to break it into a single patch for each
file to reduce the size--and so each file could be dealt with
separately.  If that was the wrong thing to do, I'll fix it.

> It's not clear to me why you moved the driver files from 
> frontends/drx39xxj to just frontends.  I don't think anybody has
> ever complained about having a subdirectory if there is a large
> enough set of files.  Did somebody ask you to do that and I didn't
> see the email?
> 

This was another unilateral decision. When I was trying to get this
working on my computer, I found that make wouldn't even go into the
subdirectory. Which meant that whenever I plugged the USB Tuner in, it
would fail because it couldn't find the dvb_attach() method (from one
of the driver files). After moving them from the subdirectory to
frontends (and fixing the Makefile and Kconfig appropriately)
everything compiled and loaded correctly.  In the end, that was the
only thing I found that worked.  However, I can send them in the
subdirectory also.

> As you indicated, the code hasn't gone through any form of
> codingstyle cleanup, and as a result needs to go against the
> staging tree instead of the main tree.  You should consult with
> Mauro on how to approach this problem, because currently you cannot
> do a demodulator driver against staging because of the dependency
> on the em28xx bridge which is already in stable (adding Mauro to
> the cc: to get his opinion).
> 

This brings up a question for me. Most of the "trailing whitespace"
errors aren't showing up in any of my editors (nano or meld to name
two of them). And most of the trailing whitespace errors are in the
comments. So are those really issues that will block the files from
being submitted? Also, would they be happening because of the "DOS
Line Ending" errors on most of the same lines?

Also, I started to clean up the files tonight. Then I started thinking
about what you told me about the as102 drivers, and thought I should
submit them "as is" and then start the cleanup and submit those
patches separately. Also that way others could help with some of the
cleanup. I have to figure out if there's an easy way to convert all of
the "DOS Line Endings" to the appropriate style, or if I'll have to do
that manually (and whether my editor(s) caused this).

For Mauro: I can either resubmit everything once it's cleaned up, go
from here, start over and submit the original patches from Devin's
tree, or whatever you think is best.

> In short, it almost feels like you did *too much* work given you 
> didn't make any material changes to the code itself as it's in my 
> tree.  I would suggest just submitting my two patches, and then on
> top of that you can submit a whole series of patches doing
> cleanups.

One reason I did the extra work is because your tree had other files
(the cx18 drivers for example) that didn't seem to be needed by the
tuner. So, I cleaned them out (partially because I have two cards that
use those drivers and didn't want to break those).  I can review all
of the files to make sure that I didn't miss any.  And I can update
all of the files from your tree to the most current versions and
submit everything again.

> 
> And you should definitely review the following page on submitting 
> patches if you haven't already:
> 
> http://linuxtv.org/wiki/index.php/Development:_How_to_submit_patches
>
> 
I'll re-read the page this weekend. I did read it, and it does a great
job of telling you what needs to be done. I was struggling with how to
get some of the things done though (such as adding the Signed Off
lines to the code). Which is probably why most of the issues that I'm
having are coming up.

> Cheers,
> 
> Devin
> 

Thank you for your quick reply to this. And I'm sorry if I created
more issues than I solved.  I'll definitely take every bit of advice
in and rework everything properly.

Have a great evening. :)
Patrick.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk68iiwACgkQMp6rvjb3CARLGACeNIDvJkXtcPMBRhEIeetxTae2
mUEAniZ/cMSwyc3y/Qhrs5qPyHJJ4LQP
=vVhh
-----END PGP SIGNATURE-----
