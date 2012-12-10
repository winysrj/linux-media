Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3550 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab2LJNHV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Dec 2012 08:07:21 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: RFC: First draft of guidelines for submitting patches to linux-media
Date: Mon, 10 Dec 2012 14:07:09 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201212101407.09338.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

As discussed in Barcelona I would write a text describing requirements for new
drivers and what to expect when submitting patches to linux-media.

This is a first rough draft and nothing is fixed yet.

I have a few open questions:

1) Where to put it? One thing I would propose that we improve is to move the
dvb and video4linux directories in Documentation/ to Documentation/media to
correctly reflect the drivers/media structure. If we do that, then we can put
this document in Documentation/media/SubmittingMediaPatches.

Alternatively, this is something we can document in our wiki.

2) Are there DVB requirements as well for new drivers? We discussed a list of
V4L2 requirements in Barcelona, but I wonder if there is a similar list that
can be made for DVB drivers. Input on that will be welcome.

3) This document describes the situation we will have when the submaintainers
take their place early next year. So please check if I got that part right.

4) In Barcelona we discussed 'tags' for patches to help organize them. I've
made a proposal for those in this document. Feedback is very welcome.

5) As discussed in Barcelona there will be git tree maintainers for specific
platforms, but we didn't really go into detail who would be responsible for
which platform. If you want to maintain a particular platform, then please
let me know.

6) The patchwork section is very short at the moment. It should be extended
when patchwork gets support to recognize the various tags.

7) Anything else that should be discussed here?

Again, remember that this is a rough draft only, so be gentle with me :-)

Regards,

	Hans

--------------------------- cut here -------------------------------

General Information
===================

For general information on how to submit patches see:

http://linuxtv.org/wiki/index.php/Developer_Section

In particular the section 'Submitting Your Work'.

This document goes into more detail regarding media specific requirements when
submitting patches and what the patch flow looks like in this subsystem.


Submitting New Media Drivers
============================

When submitting new media drivers for inclusion in drivers/staging/media all
that is required is that the driver compiles with the latest kernel and that an
entry is added to the MAINTAINERS file.

For inclusion as a non-staging driver the requirements are more strict:

General requirements:

- It must pass checkpatch.pl, but see the note regarding interpreting the
  output from checkpatch below.
- An entry for the driver is added to the MAINTAINERS file.

V4L2 specific requirements:

- Use struct v4l2_device for bridge drivers, use struct v4l2_subdev for
  sub-device drivers.
- Use the control framework for control handling.
- Use struct v4l2_fh if the driver supports events (implied by the use of
  controls) or priority handling.
- Use videobuf2 for buffer handling. Mike Krufky will look into extending vb2
  to support DVB buffers. Note: using vb2 for VBI devices has not been tested
  yet, but it should work. Please contact the mailinglist in case of problems
  with that.
- Must pass the v4l2-compliance tests.

DVB specific requirements:

TBD


How to deal with checkpatch.pl?
===============================

First of all, the requirement to comply to the kernel coding style is there for
a reason. Sometimes people feel that it is a pointless exercise: after all,
code is code, right? Why would just changing some spacing improve it?

But the coding style is not there to help you (at least, not directly), it is
there to help those who have to review and/or maintain your code as it takes a
lot of time to review code or try to figure out how someone else's code works.
By at least ensuring that the coding style is consistent with other code we can
concentrate on what humans to best: pattern matching. Ever read a book or
article that did not use the correct spelling, grammar and/or punctuation
rules? Did you notice how your brain 'stumbles' whenever it encounters such
mistakes? It makes the text harder to understand and slower to read. The same
happens with code that does not comply to the conventions of the project and it
is the reason why most large projects, both open source and proprietary, have a
coding style.

However, when interpreting the checkpatch output it is good to remember that it
is just an automated tool and there are cases where what checkpatch recommends
does not actually results in the best readable code. This is particularly true
for the line length warnings. A warning that a line is 82 characters long can
probably be ignored, since breaking up such a line will usually make the code
harder to understand. A warning that a line is 101 characters long definitely
needs attention, since that's an indication that the line is really too long.

The guideline here is to check such warnings, but use common sense whether or
not to fix them.

Please do run checkpatch before posting any code to the mailinglist. Code that
clearly violates the kernel coding style will be rejected and you will be asked
to repost after fixing the style. We are not going to waste time trying to
review code that uses a non-standard coding style, our time is too limited for
that.

The sole exception are staging drivers as the only rule there is that it
compiles.


Timeline for code submissions
=============================

After a new kernel is released the merge window will be open for about two
weeks. During that time Linus will merge any pending work for the next kernel.
Once that merge window is closed only regression fixes and serious bug fixes
will be accepted, everything else will be postponed until the next merge
window.

In addition, before anything can be merged (regardless of whether this is
during the merge window or not) the new code should have been in the linux-next
tree for about a week at minimum to ensure there are no conflicts with work
being done in other kernel subsystems.

Furthermore, before code can be added to linux-next it has to be reviewed
first.  This will take time as well. Adding everything up this means that if
you want your code to be merged for the next kernel you should have it posted
to the linux-media mailinglist no later than rc5 of the current kernel, or it
may be too late. In fact, the earlier the better since reviews will take time,
and if corrections need to be made you may have to do several review/submit
cycles.

Remember that the core media developers have a job as well, and so won't always
have the time to review immediately. A general rule of thumb is to post a
reminder if a full week has passed without receiving any feedback. There is a
fair amount of traffic on the mailinglist and it wouldn't be the first time
that a patch was missed by reviewers.

One consequence of this is that as submitter you can get into the situation
that you post something, two weeks later you get a review, you post the
corrected version, you get more reviews 10 days later, etc. So it can be a
drawn-out process. This can be frustrating, but please stick with it. We have
seen cases where people seem to give up, but that is not our intention. We
welcome new code, but since none of the core developers work full time on this
we are constrained by the time we have available. Just be aware of this, plan
accordingly and don't give up.


Contacting developers
=====================

The linux-media mailinglist is the central place to get into contact with
developers. However, there are also two irc channels: #linuxtv (mostly DVB
related) and #v4l (mostly V4L related). Most developers are based in the US or
in Europe, so take those timezones into account.

Finally, you can often find developers during the three main Linux conferences
relevant to us: the Linux Plumbers Conference, the Embedded Linux Conference
and the Embedded Linux Conference Europe.


Patch tags
==========

When posting patches it is recommended to tag them to help us sort through them
quickly and efficiently.

The tags are:

[RFC PATCH x/y]: use this for preliminary patches for which you want to get
some early feedback.

[REVIEW PATCH x/y]: use this for patches that you consider OK for merging, but
that need to be reviewed.

Once your patches have been reviewed/acked you can post either a pull request
("[GIT PULL]") or use the "[FINAL PATCH x/y]" tag if you don't have a public
git tree.

If you post a new version of a patch series, then add 'v1', 'v2', etc. to the
RFC or REVIEW word, e.g.: "[RFCv2 PATCH x/y]".

If your patch is for the current rc kernel (so it is a regression or serious
bug fix), then add " FOR v3.x" after the PATCH or PULL keyword. For example:
"[REVIEW PATCH FOR v3.7 x/y]", or "[GIT PULL FOR v3.7]".

You can use the option --subject-prefix="REVIEW PATCHv1" with the 'git
send-email' to specify the prefix.

Patches without the appropriate tags will be processed manually, which will
take more time and may actually cause them to be dropped altogether.


Reviewed-by/Acked-by
====================

Within the media subsystem there are three levels of maintainership: Mauro
Carvalho Chehab is the maintainer of the whole subsystem and the
DVB/V4L/IR/Media Controller core code in particular, then there are a number of
submaintainers for specific areas of the subsystem:

- Kamil Debski: codec (aka memory-to-memory) drivers
- Hans de Goede: non-UVC USB webcam drivers
- Mike Krufky: frontends/tuners/demodulators In addition he'll be the reviewer
  for DVB core patches.
- Guennadi Liakhovetski: soc-camera drivers
- Laurent Pinchart: sensor subdev drivers.  In addition he'll be the reviewer
  for Media Controller core patches.
- Hans Verkuil: V4L2 drivers and video A/D and D/A subdev drivers (aka video
  receivers and transmitters). In addition he'll be the reviewer for V4L2 core
  patches.

Finally there are maintainers for specific drivers. This is documented in the
MAINTAINERS file.

When modifying existing code you need to get the Reviewed-by/Acked-by of the
maintainer of that code. So CC that maintainer when posting patches. If said
maintainer is unavailable then the submaintainer or even Mauro can accept it as
well, but that should be the exception, not the rule.

Once patches are accepted they will flow through the git tree of the
submaintainer to the git tree of the maintainer (Mauro) who will do a final
review.

There are a few exceptions: code for certain platforms goes through git trees
specific to that platform. The submaintainer will still review it and add a
acked-by or reviewed-by line, but it will not go through the submaintainer's
git tree.

The platform maintainers are:

TDB

In case patches touch on areas that are the responsibility of multiple
submaintainers, then they will decide among one another who will merge the
patches.


Patchwork
=========

Patchwork is an automated system that takes care of all posted patches. It can
be found here: http://patchwork.linuxtv.org/project/linux-media/list/

If your patch does not appear in patchwork after [TBD], then check if you used
the right patch tags and if your patch is formatted correctly (no HTML, no
mangled lines).

Whenever you patch changes state you'll get an email informing you about that.
