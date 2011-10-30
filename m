Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:36143 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389Ab1J3LR2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Oct 2011 07:17:28 -0400
Date: Sun, 30 Oct 2011 12:17:10 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Piotr Chmura <chmooreck@poczta.onet.pl>
Cc: Sylwester Nawrocki <snjw23@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Greg KH <gregkh@suse.de>,
	Patrick Dickey <pdickeybeta@gmail.com>,
	LMML <linux-media@vger.kernel.org>, devel@driverdev.osuosl.org
Subject: Re: [PATCH v3 4/14] staging/media/as102: checkpatch fixes
Message-ID: <20111030121710.73f9ee11@stein>
In-Reply-To: <20111030081156.14b70914@darkstar>
References: <4E7F1FB5.5030803@gmail.com>
	<CAGoCfixneQG=S5wy2qZZ50+PB-QNTFx=GLM7RYPuxfXtUy6Ecg@mail.gmail.com>
	<4E7FF0A0.7060004@gmail.com>
	<CAGoCfizyLgpEd_ei-SYEf6WWs5cygQJNjKPNPOYOQUqF773D4Q@mail.gmail.com>
	<20110927094409.7a5fcd5a@stein>
	<20110927174307.GD24197@suse.de>
	<20110927213300.6893677a@stein>
	<4E999733.2010802@poczta.onet.pl>
	<4E99F2FC.5030200@poczta.onet.pl>
	<20111016105731.09d66f03@stein>
	<CAGoCfix9Yiju3-uyuPaV44dBg5i-LLdezz-fbo3v29i6ymRT7w@mail.gmail.com>
	<4E9ADFAE.8050208@redhat.com>
	<20111018094647.d4982eb2.chmooreck@poczta.onet.pl>
	<20111018111151.635ac39e.chmooreck@poczta.onet.pl>
	<20111018215146.1fbc223f@darkstar>
	<4EABD3E2.3070302@gmail.com>
	<4EABFCF8.2010003@poczta.onet.pl>
	<4EAC2676.8030808@gmail.com>
	<4EAC3C57.5070701@poczta.onet.pl>
	<4EAC7214.5030008@gmail.com>
	<20111030081156.14b70914@darkstar>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Oct 30 Piotr Chmura wrote:
> Patch taken from http://kernellabs.com/hg/~dheitmueller/v4l-dvb-as102-2/
> 
> Original source and comment:
> # HG changeset patch
> # User Devin Heitmueller <dheitmueller@kernellabs.com>
> # Date 1267318701 18000
> # Node ID 69c8f5172790784738bcc18f8301919ef3d5373f
> # Parent  b91e96a07bee27c1d421b4c3702e33ee8075de83
> as102: checkpatch fixes
> 
> From: Devin Heitmueller <dheitmueller@kernellabs.com>
> 
> Fix make checkpatch issues reported against as10x_cmd.c.
> 
> Priority: normal
> 
> Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
> Signed-off-by: Piotr Chmura <chmooreck@poczta.onet.pl>
> ----
> Added missing empty lines at end of patch
> 
> Sylwester could you check if it applies cleanly now ?
> 
> 
> diff --git linux/drivers/staging/media/as102/as10x_cmd.c linuxb/drivers/staging/media/as102/as10x_cmd.c
> --- linux/drivers/staging/media/as102/as10x_cmd.c
> +++ linuxb/drivers/staging/media/as102/as10x_cmd.c
[...]

"man git-am" says:  "'From: ' [...] lines *starting* the body
override the respective commit author name and title values taken from the
headers."  (Emphasis mine.)  So, if the author field of the commit is
meant to be set to Devin Heitmueller, the line "From: Devin [...]" needs
to be placed as the first body of the mail message body.

Or more correctly spoken, lines in a format like RFC 2822 mail headers may
appear in the mail body and are recognized by "git am" as input for commit
metadata
  - if they are "From: ", "Subject: ", or "Date: " header-like lines,
  - if they appear before any other kinds of lines of the mail body.

A pro pos, it would be good to not only preserve author name and address
that way, but also authorship date.  I.e. if possible transform the line
"# Date 1267318701 18000" into an RFC 2822 date-header like line and put
it together with the From: line at the beginning of the body.  I am not
sure which date-time specification formats "git am" understands, but at
least the one per RFC 2822 clause 3.3 works.

The date thing would be icing on the cake.  In current practice, not many
kernel developers who forward patches by mail seem to be aware of it.

On the rest of the changelog, the part that you added:
  - The URL of the original repo was of some interest in the first patch
    which adds all the entire driver.  But it is hardly interesting in a
    checkpatch cleanup.
  - The information that this was once a HG changeset (before it became a
    mailed patch and hopefully eventually becomes a git commit...) as well
    as the original commit ID and parent commit ID are not of interest for
    the git changelog.

On the rest of the changelog, the part written by Devin:
  - Well, that doesn't say a lot.  /What/ kinds of checkpatch issues were
    "fixed", and why?  In my opinion, the fact that a certain script called
    checkpatch was involved at all is one of the last interesting facts
    about this change.  There was nothing "fixed" here.  From a quick look
    at it, this patch reformats whitespace and changes perhaps some other
    code formatting to bring it closer to normal Linux code format.
  - We don't have "Priority" lines in mainline changelogs.

However, since the kind of changes done in this patch appears to be mostly
or entirely trivial, it is not a drama to have a less than perfect
changelog (to say it mildly).  But please consider for future
contributions:  When writing a changelog always describe the reason or
impact of the change.  E.g. here whitespace changes (and more?) without
(?) change of functionality (without change of generated machine code
even?). ---  This criticism goes primarily to Devin, but also to Piotr who
had the chance to improve the changelog.

A very brief guide about good changelogs can be found in Andrew Morton's
"The Perfect Patch", e.g. http://kerneltrap.org/node/3737.  It takes a bit
of consideration how to apply it to a patch like this one though.  Hint:
The answer to "why the kernel needed patching" in this case is *not*
"because checkpatch told so". ;-)

Take this criticism of the changelog not as a request to change this
particular one, but as something to keep in mind in future contributions.

On the part after changelog, before the diff:
  - The delimiter is supposed to be *three* dashes, immediately followed
    by end-of-line, not four dashes.  See "man git-am" for lines that are
    recognized as beginning the patch == ending the changelog.
  - Please always insert a diffstat here.  This is a help to anybody
    wanting to review or handle a patch posting.

On the diff:
  - In typical patches which only touch a small part of a file, it is very
    important to generate the patch like "diff --show-c-function [...]"
    a.k.a. "diff -p [...]" would do.  While this information is ignored by
    any tool which applies the patch, it highly increases the human-
    readability of the diff.
    Of course in this patch here which changes almost the entire file, this
    bit is not important for readability.  But keep it in mind for future
    patch postings.
-- 
Stefan Richter
-=====-==-== =-=- ====-
http://arcgraph.de/sr/
