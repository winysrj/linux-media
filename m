Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:40152 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbeKHFZX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Nov 2018 00:25:23 -0500
Date: Wed, 7 Nov 2018 17:53:20 -0200
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Shuah Khan <shuah@kernel.org>, sean@mess.org
Subject: Re: [RFC] Create test script(s?) for regression testing
Message-ID: <20181107175320.640a8c74@coco.lan>
In-Reply-To: <3038136.0uhjixLgno@avalon>
References: <d0b6420c-e6b9-64c3-3577-fd0546790af3@xs4all.nl>
        <4049608.APCVuh3Y7C@avalon>
        <20181107171035.0cc0360b@coco.lan>
        <3038136.0uhjixLgno@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 07 Nov 2018 21:35:32 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> On Wednesday, 7 November 2018 21:10:35 EET Mauro Carvalho Chehab wrote:
> > Em Wed, 07 Nov 2018 12:06:55 +0200 Laurent Pinchart escreveu:  
> > > On Wednesday, 7 November 2018 10:05:12 EET Hans Verkuil wrote:  
> > >> On 11/06/2018 08:58 PM, Laurent Pinchart wrote:  
> > >>> On Tuesday, 6 November 2018 15:56:34 EET Hans Verkuil wrote:  
> > >>>> On 11/06/18 14:12, Laurent Pinchart wrote:  
> > >>>>> On Tuesday, 6 November 2018 13:36:55 EET Sakari Ailus wrote:  
> > >>>>>> On Tue, Nov 06, 2018 at 09:37:07AM +0100, Hans Verkuil wrote:  
> > >>>>>>> Hi all,
> > >>>>>>> 
> > >>>>>>> After the media summit (heavy on test discussions) and the V4L2
> > >>>>>>> event regression we just found it is clear we need to do a better
> > >>>>>>> job with testing.
> > >>>>>>> 
> > >>>>>>> All the pieces are in place, so what is needed is to combine it
> > >>>>>>> and create a script that anyone of us as core developers can run to
> > >>>>>>> check for regressions. The same script can be run as part of the
> > >>>>>>> kernelci regression testing.  
> > >>>>>> 
> > >>>>>> I'd say that *some* pieces are in place. Of course, the more there
> > >>>>>> is, the better.
> > >>>>>> 
> > >>>>>> The more there are tests, the more important it would be they're
> > >>>>>> automated, preferrably without the developer having to run them on
> > >>>>>> his/her own machine.  
> > >>>>> 
> > >>>>> From my experience with testing, it's important to have both a core
> > >>>>> set of tests (a.k.a. smoke tests) that can easily be run on
> > >>>>> developers' machines, and extended tests that can be offloaded to a
> > >>>>> shared testing infrastructure (but possibly also run locally if
> > >>>>> desired).  
> > >>>> 
> > >>>> That was my idea as well for the longer term. First step is to do the
> > >>>> basic smoke tests (i.e. run compliance tests, do some (limited)
> > >>>> streaming test).
> > >>>> 
> > >>>> There are more extensive (and longer running) tests that can be done,
> > >>>> but that's something to look at later.
> > >>>>   
> > >>>>>>> We have four virtual drivers: vivid, vim2m, vimc and vicodec. The
> > >>>>>>> last one is IMHO not quite good enough yet for testing: it is not
> > >>>>>>> fully compliant to the upcoming stateful codec spec. Work for that
> > >>>>>>> is planned as part of an Outreachy project.
> > >>>>>>> 
> > >>>>>>> My idea is to create a script that is maintained as part of
> > >>>>>>> v4l-utils that loads the drivers and runs v4l2-compliance and
> > >>>>>>> possibly other tests against the virtual drivers.  
> > 
> > (adding Shuah)
> > 
> > IMO, the best would be to have something like that as part of Kernel
> > self test, as this could give a broader covering than just Kernel CI.
> > 
> > Yeah, I know that one of the concerns is that the *-compliance stuff
> > we have are written in C++ and it is easier to maintain then at
> > v4l-utils, but maybe it would be acceptable at kselftest to have a
> > test bench there with would download the sources from a git tree
> > and then build just the v4l2-compliance stuff, e. g. having a Kernel
> > self test target that would do something like:
> > 
> > 	git clone --depth 1 git://linuxtv.org/v4l-utils.git tests && \
> > 	cd tests && ./autogen.sh && make tests && ./run_tests.sh  
> 
> Let me make sure I understand this properly. Are you proposing to add to 
> kselftest, which is part of the Linux kernel, and as such benefits from the 
> level of trust of Linus' tree, and which is run by a very large number of 
> machines from developer workstations to automated large-scale test 
> infrastructure, a provision to execute locally code that is downloaded at 
> runtime from the internet, with all the security issues this implies ?

No, I'm not proposing to make it unsafe. The above is just a rogue
example to explain an idea. The actual implementation should take
security into account. It could, for example, use things like downloading
a signed tarball and run it inside a container, use some git tree
hosted at kernel.org, etc.

> 
> > (the actual selftest target would likely be different, as it
> >  should take into account make O=<some_output_dir>)
> > 
> > If this would be acceptable upstream, then we'll need to stick with the
> > output format defined by Kernel Self Test[1].
> > 
> > [1] I guess it uses the TAP13 format:
> > 	https://testanything.org/tap-version-13-specification.html
> >   
> > >>>>>> How about spending a little time to pick a suitable framework for
> > >>>>>> running the tests? It could be useful to get more informative
> > >>>>>> reports than just pass / fail.  
> > >>>>> 
> > >>>>> We should keep in mind that other tests will be added later, and the
> > >>>>> test framework should make that easy.  
> > >>>> 
> > >>>> Since we want to be able to run this on kernelci.org, I think it
> > >>>> makes sense to let the kernelci folks (Hi Ezequiel!) decide this.  
> > >>> 
> > >>> KernelCI isn't the only test infrastructure out there, so let's not
> > >>> forget about the other ones.  
> > >> 
> > >> True, but they are putting time and money into this, so they get to
> > >> choose as far as I am concerned :-)  
> > 
> > Surely, but no matter who is paying, if one wants to merge things upstream,
> > he/she has to stick with upstream ruleset.
> > 
> > That's said, we should try to not make life harder than it should be for
> > it, but some things should be standardized, if we want future contributions
> > there. At very minimal, from my side, I'd like it to be as much compatible
> > with Kernel selftest infrastructure as possible.
> > 
> > I would try to avoid placing KernelCI-specific stuff (like adding LAVA code)
> > inside v4l-utils tree. With regards to that, one alternative would be to
> > split KernelCI specific code on a different tree and use "git subtree".  
> 
> I don't think we need git submodules (assuming this is what you mean). Our 
> responsibility is to provide tests. KernelCI's responsibility is to integrate 
> them. We should make the integration as easy as possible, but I don't think we 
> need to maintain the integration in our test tree.

Agreed. I'm just saying that maybe git subtrees could help with making it
easy to integrate different maintained trees.

> 
> > > It's still our responsibility to give V4L2 a good test framework, and to
> > > drive it in the right direction. We don't accept V4L2 API extensions
> > > blindly just because a company happens to put time and money into it
> > > (there may have been one exception, but it's not the rule), we instead
> > > review all proposals carefully. The same should be true with tests.
> > >   
> > >> If others are interested and willing to put up time and money, they
> > >> should let themselves be known.
> > >> 
> > >> I'm not going to work on such an integration, although I happily accept
> > >> patches.
> > >>   
> > >>>> As a developer all I need is a script to run smoke tests so I can
> > >>>> catch most regressions (you never catch all).
> > >>>> 
> > >>>> I'm happy to work with them to make any changes to compliance tools
> > >>>> and scripts so they fit better into their test framework.
> > >>>> 
> > >>>> The one key requirement to all this is that you should be able to run
> > >>>> these tests without dependencies to all sorts of external packages/
> > >>>> libraries.  
> > >>> 
> > >>> v4l-utils already has a set of dependencies, but those are largely
> > >>> manageable. For v4l2-compliance we'll install libv4l, which depends on
> > >>> libjpeg.  
> > >> 
> > >> That's already too much. You can manually build v4l2-compliance with no
> > >> dependencies whatsoever, but we're missing a Makefile target for that.
> > >> It's been useful for embedded systems with poor cross-compile
> > >> environments.  
> > > 
> > > I don't think depending on libv4l and libjpeg would be a big issue.  
> > 
> > Having v4l2-compliance depending on libv4l is not an issue, as both are
> > at the same tree. Except for glibc, I would avoid any other dependencies
> > like libjpeg.
> >   
> > > On the other hand, given what v4l2-compliance do, one could also argue
> > > that it should not use libv4l at all and go straight for the kernel API.
> > > This boils down to the question of whether we consider libv4l as part of
> > > the official V4L2 stack, or if we want to officially deprecate it given
> > > that it hasn't really lived to the promises it made.  
> > 
> > There's no question here: currently, libv4l2 is part of official V4L2
> > stack, as almost all V4L2 generic applications rely on it. We made some
> > pressure for apps to use it and we did the conversion ourselves for several
> > existing apps. So, for the better of the worse, we're committed to it.  
> 
> Then we need a test suite that will exercise the libv4l API, and I would argue 
> also a test suite that will exercise the V4L2 API directly.

Makes sense.

> 
> > When libcamera becomes a reality, and applications get ported to it, then
> > it would make sense to re-evaluate it.
> >   
> > >> It is really very useful to be able to compile those core utilities with
> > >> no external libraries other than glibc. You obviously will loose some
> > >> functionality when you compile it that way.
> > >> 
> > >> These utilities are not like a typical application. I really don't care
> > >> how many libraries are linked in by e.g. qv4l2, xawtv, etc. But for
> > >> v4l2-ctl, v4l2-compliance, cec-ctl/follower/compliance (and probably a
> > >> few others as well) you want a minimum of dependencies so you can run
> > >> them everywhere, even with the crappiest toolchains or cross-compile
> > >> environments.  
> > > 
> > > If you want to make them easy to deploy, a more useful option would be a
> > > makefile rule to compile them statically.  
> > 
> > I agree. Also, the better would be to actually have an option to build them
> > in a way that both 32 bits on 64 bits ioctl calls would be tested.  
> 
> That's easy, you can just compile two binaries, a 32-bit version and a 64-bit 
> version.

Yes, that's the easiest way to do it. The point is that a "make tests" target 
should do it automatically, and store the 32bits and 64bits version of the
tools with different names, in order for both to be available at the same
time, as both will be called by a tests script.

Another possibility (that would require some rework) would be to have just
a single binary that would do both 32-bits and 64 bits calls, checking
if the net result is identical.

> 
> > From my side, a really useful smoke test would be to detect if a 32-bits
> > ioctl call is not properly handled by the Kernel, as this is something
> > that people usually forget to test when touching media APIs.
> >   
> > >>>>> Regarding the test output, many formats exist (see
> > >>>>> https://testanything.org/ and
> > >>>>> https://chromium.googlesource.com/chromium/src/+/master/docs/testing
> > >>>>> /json_test_results_format.md for instance), we should pick one of the
> > >>>>> leading industry standards (what those standards are still needs to
> > >>>>> be researched  :-)).
> > >>>>>   
> > >>>>>> Do note that for different hardware the tests would be likely
> > >>>>>> different as well although there are classes of devices for which
> > >>>>>> the exact same tests would be applicable.  
> > >>>>> 
> > >>>>> See http://git.ideasonboard.com/renesas/vsp-tests.git for an example
> > >>>>> of device-specific tests. I think some of that could be generalized.
> > >>>>>   
> > >>>>>>> It should be simple to use and require very little in the way of
> > >>>>>>> dependencies. Ideally no dependencies other than what is in
> > >>>>>>> v4l-utils so it can easily be run on an embedded system as well.
> > >>>>>>> 
> > >>>>>>> For a 64-bit kernel it should run the tests both with 32-bit and
> > >>>>>>> 64-bit applications.
> > >>>>>>> 
> > >>>>>>> It should also test with both single and multiplanar modes where
> > >>>>>>> available.
> > >>>>>>> 
> > >>>>>>> Since vivid emulates CEC as well, it should run CEC tests too.
> > >>>>>>> 
> > >>>>>>> As core developers we should have an environment where we can
> > >>>>>>> easily test our patches with this script (I use a VM for that).  
> > 
> > In my case, I'll use Jenkins, but I probably won't be adding any CI
> > plugin. So, I'd like a simple way to call qemu (or whatever) via the
> > Jenkins "build" script.
> >   
> > >>>>>>> I think maintaining the script (or perhaps scripts) in v4l-utils
> > >>>>>>> is best since that keeps it in sync with the latest kernel and
> > >>>>>>> v4l-utils developments.  
> > >>>>>> 
> > >>>>>> Makes sense --- and that can be always changed later on if there's
> > >>>>>> a need to.  
> > >>>>> 
> > >>>>> I wonder whether that would be best going forward, especially if we
> > >>>>> want to add more tests. Wouldn't a v4l-tests project make sense ?  
> > >>>> 
> > >>>> Let's see what happens. The more repos you have, the harder it
> > >>>> becomes to keep everything in sync with the latest kernel code.  
> > >>> 
> > >>> Why is that ? How would a v4l-tests repository make it more difficult
> > >>> ?  
> > >> 
> > >> Right now whenever we update the uAPI in the kernel we run 'make
> > >> sync-with-kernel' in v4l-utils to sync it to the latest kernel code. We
> > >> only do this for this repo, and adding a new repo where you have to do
> > >> that will just complicate matters and make it more likely you'll forget.  
> > 
> > Actually, that's not the only tree there with the same concept. We do
> > similar stuff on other userspace trees (xawtv3, tvtime, ...): they
> > all have a copy of the Kernel header files. I don't remember if we added
> > a make target to sync from Kernel on all of them - although I vaguely
> > remember that I added it (or thought about adding it) to some other tree.
> > 
> > Anyway, as I said early, we could think on using git subtree for
> > testing stuff. It is easy to use it, but not certain about the
> > results. Probably it would require some testing.
> >   
> > > Let's automate it then :-)  
> > 
> > Maybe this could be done in the future, but sometimes manual
> > adjustments are needed when "make sync-with-kernel" is used.
> > 
> > It not just copies the new headers. It also copies new RC keymaps
> > and some code from vivid driver for pattern generation.
> > 
> > Ok, an automated system could be triggered by Kernel commits and
> > check if "make sync-with-kernel" would produce any changes. If it
> > produces, it would re-build v4l-utils (and other similar tools),
> > checking if nothing bad fails. If nothing fails, it would merge
> > the changes automatically. Otherwise, it may warn someone to merge it.
> > 
> > This could work.
> >   
> > >> I don't see a good reason to create a new repo to store the test code.  
> > > 
> > > Having all test code in a separate git tree would make it easier for
> > > people to contribute without having to deal with v4l-utils in general.
> > > 
> > > Pretty much every time I want to cross-compile tools from v4l-utils I end
> > > up editing the makefiles to work around compilation failures due to
> > > missing dependencies that don't have config options, or just to disable
> > > tools that don't cross-compile for random reasons and that I don't need.  
> > 
> > That is easily solvable. Just fix the build system to not break if
> > there are missing dependencies or if a build is not possible on some
> > system.  
> 
> I'm not saying it's unsolvable, just that it's a problem today, and I can 
> easily imagine it being a problem for new contributors. v4l-utils is a 
> collection of miscellaneous tools that don't really fit anywhere else, and 
> makes sense as such, but for projects that we expect (or at least hope) to 
> grow and treat as first-class citizen, v4l-utils may not be the best option.
> 
> > Splitting the test code on a separate tree won't solve this issue. I mean,
> > if someone finds a compilation breakage due to some specific configuration,
> > the build system should be fixed.
> > 
> > That's said, while I don't have any strong opinion about that ATM, I'm more
> > inclined to have things that are specific for a particular testing toolset
> > (like KernelCI) on a separate tree.
> >   
> > > A separate repository would also allow us to put testing under the
> > > spotlight, instead of hiding the tools and scripts in subdirectories,
> > > mixed with other completely unrelated tools and scripts. I would then
> > > consider contributing vsp-tests to the V4L2 test suite, while I really
> > > wouldn't if it had to be part of v4l-utils.  
> > 
> > Yeah, right now, what's there at v4l-utils are must have stuff for
> > distributions. Testing code is something that doesn't really belong
> > inside distros. Adding stuff there would just make the tree bigger
> > for no good reason, IMHO.
> >   
> > > If we want to encourage driver authors to submit tests, we should also
> > > give commit rights. A separate repository would help there.  
> > 
> > Good point.
> >   
> > >> However, I do think we might want to create a new repo to store video
> > >> test sequences (something I expect to see when we start on testing
> > >> codecs).
> > >> 
> > >> It's IMHO a bad idea to add many MBs of video files to v4l-utils.  
> > > 
> > > That should definitely be a new repository.  
> > 
> > And independent from the testing repository itself. There is a catch here:
> > I don't think GPL is the right license for video files. They should
> > probably be licensed using some Creative Commons license.
> > 
> > Actually, even a model that would stick a license file for each video
> > would be possible.
> >   
> > >>>> My experience is that if you want to have good tests, then writing
> > >>>> tests should be as easy as possible. Keep dependencies at an absolute
> > >>>> minimum.  
> > >>> 
> > >>> To make it as easy as possible we need to provide high-level APIs, so
> > >>> dependencies will be unavoidable. I found for instance that Python
> > >>> bindings were very useful to write tests for DRM/KMS (using libkmsxx),
> > >>> and I plan to have a look at Python bindings for V4L2.  
> > >> 
> > >> Let's just start with simple smoke tests. Python bindings etc. are
> > >> something for the future. Nobody has the time to work on that anyway.  
> > > 
> > > That's not true, TI has added V4L2 Python bindings to kmsxx, and moving
> > > the VIN test scripts to Python is on the todo list of the Renesas
> > > multimedia upstreaming team. There could be other efforts I'm not aware
> > > of. Please don't assume that nobody runs tests just because no patches are
> > > sent for the non- existing V4L2 test infrastructure :-)  
> > 
> > Again, if we have some tests that would depend on specific stuff, the
> > building system should be capable of detecting the presence or absence
> > of the needed libraries and external programs (like python2, python3,
> > pip,...) and work accordingly, disabling tests if the needed toolset is
> > not available.
> > 
> > I'm with Hans on that matter: better to start with an absolute minimum
> > of dependencies (like just: make, autotools, c, c++, bash),  
> 
> On a site note, for a new project, we might want to move away from autotools. 
> cmake and meson are possible alternatives that are way less painful.

Each toolset has advantages or disadvantages. We all know how
autotools can be painful.

One bad thing with cmake is that they deprecate stuff. A long-live project 
usually require several" backward" compat stuff at cmake files in order 
to cope with different behaviors that change as cmake evolves.

I never used mason myself.

> 
> > warranting that the core will work with just those. We can later add more
> > stuff, making them optional and teaching the build system to detect the
> > extra dependencies.  
> 
> My "that's not true" comment was related to the fact that nobody has the time 
> to work on that anyway. I don't dispute the fact that we should start with the 
> most basic tests, which will have the least dependencies.
> 
> > >>>> Let's be honest, we (well, mainly me) are doing these tests as a side
> > >>>> job, it's not our main focus.  
> > >>> 
> > >>> That's a mindset that needs to evolve :-)  
> > >> 
> > >> I want to be more aggressive with this: new APIs will need patches to
> > >> v4l-utils as well before they can be accepted, and ideally new tests.  
> > > 
> > > That's something we should enforce, but to do so, we first need to polish
> > > our test infrastructure. In particular v4l2-compliance needs to be
> > > modularized and documented to make it easier to contribute new tests.  
> > 
> > Agreed. We also need a dtv-compliance tool, in order to test the Digital TV
> > API.
> >   
> > > I would also go one step further, I would like new APIs to always come
> > > with a userspace implementation in a non-test stack.  
> > 
> > Good point.
> >   
> > >> And hopefully the kernelci project will lead to some improvements as
> > >> well.
> > >>   
> > >>>> Anything that makes writing tests more painful is bad and just gets
> > >>>> in the way.  
> > 
> > Yes, but discussing in advance the requirements may delay a little bit
> > the first implementation, but it will be less painful as we keep adding
> > more stuff to it.
> >   
> > >>> I don't see any disagreement on this. What makes it easy to write
> > >>> tests will however be much more prone to arguments.  
> > >> 
> > >> Since I'm pretty much the only one who has been writing tests, I'd say
> > >> that I can make a good argument :-)  
> > > 
> > > You're pretty much the only one contributing tests to v4l-utils, but
> > > certainly not the only one who has been writing tests.  
> > 
> > Talking only about the stuff on trees we maintain, Sean also sent
> > some remote controller tests to Kernel selftest.  
> 



Thanks,
Mauro
