Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753009Ab1JPNoj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Oct 2011 09:44:39 -0400
Message-ID: <4E9ADFAE.8050208@redhat.com>
Date: Sun, 16 Oct 2011 11:44:14 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Piotr Chmura <chmooreck@poczta.onet.pl>,
	Greg KH <gregkh@suse.de>,
	Patrick Dickey <pdickeybeta@gmail.com>,
	LMML <linux-media@vger.kernel.org>, devel@driverdev.osuosl.org
Subject: Re: [PATCH 1/7] Staging submission: PCTV 74e driver (as102)
References: <4E7F1FB5.5030803@gmail.com> <CAGoCfixneQG=S5wy2qZZ50+PB-QNTFx=GLM7RYPuxfXtUy6Ecg@mail.gmail.com> <4E7FF0A0.7060004@gmail.com> <CAGoCfizyLgpEd_ei-SYEf6WWs5cygQJNjKPNPOYOQUqF773D4Q@mail.gmail.com> <20110927094409.7a5fcd5a@stein> <20110927174307.GD24197@suse.de> <20110927213300.6893677a@stein> <4E999733.2010802@poczta.onet.pl> <4E99F2FC.5030200@poczta.onet.pl> <20111016105731.09d66f03@stein> <CAGoCfix9Yiju3-uyuPaV44dBg5i-LLdezz-fbo3v29i6ymRT7w@mail.gmail.com>
In-Reply-To: <CAGoCfix9Yiju3-uyuPaV44dBg5i-LLdezz-fbo3v29i6ymRT7w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 16-10-2011 09:45, Devin Heitmueller escreveu:
> On Sun, Oct 16, 2011 at 4:57 AM, Stefan Richter
> <stefanr@s5r6.in-berlin.de> wrote:
>> Hi Piotr,
>>
>> thanks for getting this going again.  - I have not yet looked through the
>> source but have some small remarks on the patch format.
>>
>>  - In your changelogs and in the diffs, somehow the space between real
>>    name and e-mail address got lost.
>>
>>  - The repetition of the Subject: line as first line in the changelog is
>>    unnecessary (and would cause an undesired duplication e.g. when git-am
>>    is used, last time I checked).
>>
>>  - AFAICT, author of patch 1/7 is not Devin but you.  Hence the From: line
>>    right above the changelog is wrong.
>>
>>  - The reference to the source hg tree is very helpful.  However, since
>>    the as102 related history in there is very well laid out, it may be
>>    beneficial to quote some of this prior history.  I suggest, include
>>    the changelog of "as102: import initial as102 driver",
>>    http://kernellabs.com/hg/~dheitmueller/v4l-dvb-as102-2/rev/a78bda1e1a0b
>>    (but mark it clearly as a quote from the out-of-tree repo), and include
>>    a shortlog from this commit inclusive until the head commit inclusive.
>>    (Note, the hg author field appears to be wrong; some of the changes
>>    apparently need to be attributed to Pierrick Hascoet as author.)
>>    This would IMO improve the picture of who contributed what when this
>>    goes into mainline git history, even though the hg history needed to
>>    be discarded.
>>
>>  - A diffstat is always very nice to have in a patch posting.  Most tools
>>    for patch generation make it easy to add, and it helps the recipients
>>    of the patch posting.
>>    (Also, a diffstat of all patches combined would be good to have in the
>>    introductory PATCH 0/n posting, but not many developers take the time
>>    to do so.)
>>
>> Again, thanks for the effort and also thanks to Devin for making it
>> possible.
> 
> I think collapsing my entire patch series in to a single patch would
> not be acceptable, as it loses the entire history of what code was
> originally delivered by Abilis as well as what changes I made.  The
> fact that it's from multiple authors (including a commercial entity
> contributing the code) makes this worse.
> 
> I think the tree does need to be rebased, but I don't think the entire
> patch series would need to be reworked to be on staging from the
> beginning.  You could probably import the first patch (as102: import
> initial as102 driver), fix the usb_alloc_coherent() so that it
> compiles (and put a note in it saying you did), apply the rest of the
> patch series, and then add a final patch that says something like
> "moving to staging as code is not production ready".  This would allow
> the history to be preserved without having to rebase every patch to
> deal with the files being moved to the staging tree.

Rebasing a changeset to move it to staging is not as complex as it seems. 
I did it with tm6000 at the time I merged it. A simple bash script could
do that. Something like (untested):

$ git export some_base_reference
$ for i in 00*.patch; do sed s,/drivers/media/video,/drivers/staging,g <$i >a && mv a $i; done
$ mkdir patches/
$ mv 00*.patches patches/
$ (cd patches; ls *.patch > series)
$ git quiltimport

Of course, the Makefike/Kconfig patch will need changes, but this is as easy
as just dropping the hunks that are touching at /drivers/media/video/Makefile
and /drivers/media/video/Kconfig, and then adding a final patch adding it to
the /drivers/staging/*.

> 
> An alternative would be make a minor tweak to my first patch which
> removes the driver from the makefile.  Then every patch in the patch
> series wouldn't actually have to compile successfully until the very
> end when you add it back into the Makefile.  This is a luxury you can
> do when it's a brand new driver.
> 
> When it's a brand new driver there is a bit more flexibility as long
> as you don't break "git bisect".  Both of the approaches described
> above accomplish that.
> 
> Mauro, what do you think?

Didn't actually reviewed the changeset, but let me comment about the
submission procedure.

Folding patches from different authors generally is not a good idea.
As Devin said, things like replacing "foo" by "bar" because "foo" core
function were replaced by "bar" upstream is the kind of thing that you
could fold, if you properly document it with:
 
[john@john_email.com: replaced "foo" by "bar" to fix compilation] 

So, you should rebase the patchsets, instead of just folding everything.
It is up to you to change the patches on each patch, or to do it only at
a final patch. Both ways work for me.

I suggest you to remove the Kconfig/Makefile hunks that enables the driver
compilation from the original series, and apply it as a final patch at the
end. This makes your rebasing work easier, as you won't need to test patch
by patch if they are not breaking compilation.

In any case, when analyzing a driver submission like that, I generally just
apply everything from a quilt series, see the final result and review it,
as:
	1) the history doesn't matter for me;
	2) it is easier to review a new driver as a hole, as the history
may be full of things that will later be changed by something else;
	3) checkpatch will be happier, especially if you've added some
patches to fix checkpatch complains at the end of the series.

Btw, I've agreed with Greg that I'll be moving the media staging stuff into
a separate directory. I'll prepare the patches later, probably during the next
merge window, in order to avoid merge conflicts between Greg's tree and mine,
especially since I intend to move some drivers out of staging, as they seem
to be ready to be at drivers/media.

So, if you're submitting a new driver for staging, I suggest you to put it already
into drivers/staging/media. This mean one less driver for me to move on my
upcoming changeset ;)

I hope that helps.
