Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3582 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbZBULAt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Feb 2009 06:00:49 -0500
Received: from tschai.lan (cm-84.208.85.194.getinternet.no [84.208.85.194])
	(authenticated bits=0)
	by smtp-vbr8.xs4all.nl (8.13.8/8.13.8) with ESMTP id n1LB0bBH093969
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 21 Feb 2009 12:00:42 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: RFCv1: v4l-dvb development models & old kernel support
Date: Sat, 21 Feb 2009 12:00:45 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902211200.45373.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

RFC: v4l-dvb Development Models
Version 1, February 21st 2009
-------------------------------

Introduction
------------

The current v4l-dvb development model is based on a mercurial repository. 
Patches are fed into the repo by developers, the v4l-dvb maintainer will 
backport relevant patches from the upstream git repository into the v4l-dvb 
master and push essential fixes from the v4l-dvb repo into the upstream git 
repo. When a new kernel merge window opens all our accumulated changes are 
fed into the new kernel and the cycle starts again.

What makes our v4l-dvb special is the ability to support older kernels. 
Through the use of smart compat headers, scripts and #if KERNEL_VERSION 
lines in the code the backwards compatibility support is done in a way that 
keeps the code relatively untouched. When our code is fed to the kernel, 
all the compat code is stripped so none of this is visible upstream.

The obvious advantage is that people can use and test our drivers on older 
kernels without having to upgrade to the latest bleeding edge kernel. 
Currently we support kernels from 2.6.16 onwards.

However, the v4l-dvb tree has seen considerable growth. Below is a simple 
statistic:

$ du -bs linux-2.6.*/drivers/media/
 5569219 linux-2.6.16.61/drivers/media/
 7189484 linux-2.6.17.14/drivers/media/
 7910318 linux-2.6.18.8/drivers/media/
 8081530 linux-2.6.19.5/drivers/media/
 8419446 linux-2.6.20.21/drivers/media/
 8556067 linux-2.6.21.7/drivers/media/
 9121077 linux-2.6.22.19/drivers/media/
 9334386 linux-2.6.23.12/drivers/media/
 9667264 linux-2.6.24.7/drivers/media/
10121497 linux-2.6.25.11/drivers/media/
11244052 linux-2.6.26/drivers/media/
12322637 linux-2.6.27/drivers/media/
12947608 linux-2.6.28/drivers/media/
13719917 linux-2.6.29-rc4/drivers/media/

So the total amount of code in the 2.6.29 tree is about 2.5 times that of 
the 2.6.16 tree and that tree is almost three years old.

The high rate of changes and new drivers means that keeping up the backwards 
compatibility becomes an increasingly heavy burden.

This leads to two questions:

1) Can we change our development model in such a way that this burden is 
reduced?
2) How far back do we want to support older kernels anyway?

These questions are related, since changes in the development model has 
implications for the answer to the second question.


1: Alternatives to the development model
----------------------------------------

I see the following options:

A) Keep our current model. This also keeps the way we do our backwards 
compatibility unchanged.

B) Switch to a git tree that tracks Linus' tree closely and we drop 
backwards compatibility completely.

C) Switch to the ALSA approach (http://git.alsa-project.org/).

ALSA uses three trees: alsa-kernel tracks Linus' git tree, alsa-kmirror 
contains only the alsa part (similar to the layout of our repository), and 
alsa-driver is equal to alsa-kmirror, but with compatibility patches.

If I understand their method correctly new changes are pushed to alsa-kernel 
and a script merges the changes into alsa-kmirror. Patches meant for 
alsa-specific files (the equivalent to our v4l/scripts or v4l2-spec 
directories) have to be pushed to alsa-kmirror directly because there is of 
course no equivalent in alsa-kernel.

Every so often the alsa-driver repository is merged with the latest changes 
from alsa-kmirror and someone goes in, checks what broke this time and 
fixes any problems manually through the creation of patches.

D) Anyone? I can't think of other serious alternatives.


1.1 Pros and Cons
-----------------

A: Keep our current model

Pros:

- we know it works.
- having backwards compatibility is very helpful in testing the drivers, it 
makes it very easy to point testers to the latest code base and have them 
install it.

Cons:

- no direct access to a full kernel git tree which makes it hard to make 
changes that go outside the drivers/media directory (e.g. platform related 
changes).
- received patches against the latest git tree can be hard to apply if they 
conflict with our compat code in the source.
- over time the code becomes ugly and harder to maintain with all the 
backwards compatibility changes.
- the lack of a kernel git tree as the main repository makes it laborious 
for the v4l-dvb maintainer to create patches for the upstream git tree.
- it's a continuous effort to try and keep the compatibility working. 
Because the repository is such a quickly changing codebase any fixed compat 
issue is promptly replaced by new compat issues.


B: Switch to a git tree and drop compatibility completely

Pros:

- makes driver development and v4l-dvb maintenance very easy.
- no compatibility issues anymore, this saves a lot of time.
- ability to change kernel code outside the driver/media part.
- received patches against the latest git tree are easy to apply.

Cons:

- no compatibility means that the initial testbase will be reduced 
substantially since it will be too difficult for many users to install the 
bleeding-edge kernel. So real feedback won't come in until the code is 
released as part of the main distros kernels.
- the same is true for ourselves: we need to continuously upgrade our 
kernel, which is not always an option.


C: The ALSA model

Pros:

- ability to change kernel code outside the driver/media part.
- the core code contains no compatibility code, thus making it very clean.
- received patches against the latest git tree are easy to apply.
- sending patches upstream is much easier.
- if patches go in that would break compatibility, then that doesn't 
immediately affect the compatibility git tree since these patches aren't 
merged automatically.
- the compatibility patches do not have to be that concerned about the mess 
they make of the code since the patched code will never go upstream.
- for the compatibility tree we can reuse our existing compatibility 
mechanism. No need to reinvent the wheel.

Cons:

- someone has to go in on a regular basis and merge the latest changes into 
the compatibility tree and fix up everything that broke. This is a 
commitment that may be hard to keep up.
- it is a fair amount of work to convert our model into this new model.
- developers will probably have to run the latest kernel as well in order to 
test whether their changes can be compiled and run correctly on the latest 
git tree. This might be a Pro as well, since it will also allow you to 
catch bugs quicker.
- if a change breaks compat in the compatibility tree, then that will make 
it hard for end users to test. You probably need to make a private copy of 
the compat tree just to fix that up, allowing end users to test your code.


1.2 Overall conclusion
----------------------

Looking at the options I think that the ALSA model is a very good candidate. 
Since it uses the standard git tree the maintenance of the repository when 
it comes to 'interfacing' with the Linus' tree is much simplified. Since 
getting fixes and new drivers into the mainline kernel is our prime task it 
is right that this part should be easy.

I think it is also good that the compat tree is more reliable. Now our code 
breaks too often for older kernels due to new patches that were committed. 
Replacing this by a periodic merge-and-fix cycle will make it less fragile. 
And the fact that it isn't code that goes to the mainline kernel allows us 
to be less concerned about how ugly the patch will look like.

We do need some way of assigning the fixing of broken compatibility to 
several people. It is not a task that should fall to only one or two 
persons. Whoever broke it should probably also fix it, in particular if 
that person was the maintainer of the driver as well. It's a matter of 
sharing the pain.


2 How many kernels to support?
------------------------------

Currently we go back three years to kernel 2.6.16. This is tested daily by 
running a compile on all versions from 2.6.16 (and on multiple 
architectures as well). While a successful compile doesn't mean that it 
will also run, it actually is a pretty good indicator.

A quick check (v4l/scripts/gentree.pl 2.6.29 linux/ gentree; du -sb 
linux/drivers/ gentree/drivers/) shows that we have about 200 kB of 
compatibility code in the driver sources:

14249297        linux/drivers/
14055008        gentree/drivers/

Keeping support for older kernels should come with an expiry date as at some 
point in time the effort involved outweighs the benefits. It also keeps the 
amount of compat code down and you know that particularly ugly patches can 
eventually be removed. We are not paid to maintain this code, and we have 
better things to do with our time than to keep the maintenance of an old 
kernel up.

What are the benefits of having compatibility code?

1) It increases the test coverage: more users can try out the code since 
upgrading to a bleeding edge kernel is usually not an option.
2) It eases our own development efforts for pretty much the same reason: no 
need to upgrade to the latest git kernel to test your code.

The drawbacks are obvious:

1) it's a lot of work to keep the compatibility working.
2) sometimes really large changes are made in the kernel that makes it very 
hard to keep support older kernels at all.

Usually the changes are renamed data structures, fields that are 
removed/added or moved to another struct altogether. While annoying, it is 
usually not too hard to fix.

However, in the particular case of the i2c model that was changed in kernel 
2.6.22 (and that sparked this discussion), the changes are so intrusive 
that they could no longer be fixed with a simple #if KERNEL_VERSION. It 
would probably still be possible if we had only a handfew of i2c modules, 
but i2c is a integral part of the design of many devices and we currently 
have 50 of these to maintain (and more coming in all the time).

At the moment keeping the compatibility alive for kernels older than 2.6.22 
actually slows down development, both for us and for the i2c core. And due 
to the code needed to support these older kernels the upstream code is 
actually affected and it looks really weird in these newer kernels.

2.6.22 is now over 1.5 years old. It is readily available in all the major 
distros with the exception of the enterprise versions.

I would like to propose some rules that we can use to decide how far we go 
in supporting older kernels.

1) As long as the three major distros do not yet support a certain kernel, 
we obviously have to keep compatibility code in.

2) Support for kernels older than the oldest supported kernel by the three 
major distros should be dropped. This explicitly excludes enterprise 
kernels (more about that below).

3) In case of *major* technical problems we should have the option to drop 
support for kernels older than the oldest kernel supported by the latest 
distro releases. This is as a last resort only, but in all the time I've 
been developing for v4l-dvb the i2c core changes are the first that would 
qualify for this rule.

In my view enterprise distros are *not* our responsibility. First of all 
people pay for them, so if they want to have webcams supported they should 
go to their vendor. We are not paid for doing this, nor are we supported by 
the vendors of the distros. I am convinced that the group involved is 
small: I can't remember seeing any bug reports for kernels from enterprise 
distros here. And if there are a few, then it is such a small number that 
it really doesn't pay to accomodate them.

I think it is also completely fair to expect that users of old unsupported 
non-enterprise distros should upgrade to something newer first. If only 
because for many developers it will can be hard or impossible to even 
install an old kernel on there machine anymore.

Note that development model C would still make it possible to support 
enterprise kernels without compromising the code quality of the main tree. 
However, that will be a substantial amount of work. If RedHat or Suse 
thinks there is enough demand for that, then they are free to have one of 
their own developers to do the work. But that's not what we should spend 
our unpaid time on.

Currently the oldest supported kernels are:

Oldest supported Fedora kernel is 2.6.25 (Fedora 9): 
http://fedoraproject.org/wiki/Releases

Oldest supported openSUSE kernel is 2.6.22 (10.3). I don't know when the 
end-of-life due date is for this openSUSE release. It might not be too long 
from now. (I can't find a decent webpage with the openSUSE releases, does 
anyone have one?)

Oldest supported Ubuntu kernel is 2.6.22 (7.10): 
https://wiki.ubuntu.com/Releases. End of life for this one will be in April 
2009, after that the oldest kernel for Ubuntu will be 2.6.27 (8.10).

In my view these criteria strike a good balance between supporting our users 
so we can good test coverage, and limiting the effort involved in 
supporting the compatibility code. And they are also based on simple facts: 
whenever the oldest regularly supported kernel changes, we can go in and 
remove some of the compat code. No need for discussions, the rules are 
clear and consistent.

And luckily, since the oldest kernel currently in regular use is 2.6.22 that 
makes a very good argument for dropping the i2c compatibility mess.

In addition, limiting the number of supported kernels will ease the effort 
needed to switch development models, should we actually decide to do so.

Comments?

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
