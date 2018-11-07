Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:42350 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbeKGTg0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Nov 2018 14:36:26 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: Re: [RFC] Create test script(s?) for regression testing
Date: Wed, 07 Nov 2018 12:06:55 +0200
Message-ID: <4049608.APCVuh3Y7C@avalon>
In-Reply-To: <b1bdffdb-9667-6c2a-b1be-b7bf2022817a@xs4all.nl>
References: <d0b6420c-e6b9-64c3-3577-fd0546790af3@xs4all.nl> <2115308.QQYpHGbrpd@avalon> <b1bdffdb-9667-6c2a-b1be-b7bf2022817a@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wednesday, 7 November 2018 10:05:12 EET Hans Verkuil wrote:
> On 11/06/2018 08:58 PM, Laurent Pinchart wrote:
> > On Tuesday, 6 November 2018 15:56:34 EET Hans Verkuil wrote:
> >> On 11/06/18 14:12, Laurent Pinchart wrote:
> >>> On Tuesday, 6 November 2018 13:36:55 EET Sakari Ailus wrote:
> >>>> On Tue, Nov 06, 2018 at 09:37:07AM +0100, Hans Verkuil wrote:
> >>>>> Hi all,
> >>>>> 
> >>>>> After the media summit (heavy on test discussions) and the V4L2 event
> >>>>> regression we just found it is clear we need to do a better job with
> >>>>> testing.
> >>>>> 
> >>>>> All the pieces are in place, so what is needed is to combine it and
> >>>>> create a script that anyone of us as core developers can run to check
> >>>>> for regressions. The same script can be run as part of the kernelci
> >>>>> regression testing.
> >>>> 
> >>>> I'd say that *some* pieces are in place. Of course, the more there is,
> >>>> the better.
> >>>> 
> >>>> The more there are tests, the more important it would be they're
> >>>> automated, preferrably without the developer having to run them on his/
> >>>> her own machine.
> >>> 
> >>> From my experience with testing, it's important to have both a core set
> >>> of tests (a.k.a. smoke tests) that can easily be run on developers'
> >>> machines, and extended tests that can be offloaded to a shared testing
> >>> infrastructure (but possibly also run locally if desired).
> >> 
> >> That was my idea as well for the longer term. First step is to do the
> >> basic smoke tests (i.e. run compliance tests, do some (limited) streaming
> >> test).
> >> 
> >> There are more extensive (and longer running) tests that can be done, but
> >> that's something to look at later.
> >> 
> >>>>> We have four virtual drivers: vivid, vim2m, vimc and vicodec. The last
> >>>>> one is IMHO not quite good enough yet for testing: it is not fully
> >>>>> compliant to the upcoming stateful codec spec. Work for that is
> >>>>> planned as part of an Outreachy project.
> >>>>> 
> >>>>> My idea is to create a script that is maintained as part of v4l-utils
> >>>>> that loads the drivers and runs v4l2-compliance and possibly other
> >>>>> tests against the virtual drivers.
> >>>> 
> >>>> How about spending a little time to pick a suitable framework for
> >>>> running the tests? It could be useful to get more informative reports
> >>>> than just pass / fail.
> >>> 
> >>> We should keep in mind that other tests will be added later, and the
> >>> test framework should make that easy.
> >> 
> >> Since we want to be able to run this on kernelci.org, I think it makes
> >> sense to let the kernelci folks (Hi Ezequiel!) decide this.
> > 
> > KernelCI isn't the only test infrastructure out there, so let's not forget
> > about the other ones.
> 
> True, but they are putting time and money into this, so they get to choose
> as far as I am concerned :-)

It's still our responsibility to give V4L2 a good test framework, and to drive 
it in the right direction. We don't accept V4L2 API extensions blindly just 
because a company happens to put time and money into it (there may have been 
one exception, but it's not the rule), we instead review all proposals 
carefully. The same should be true with tests.

> If others are interested and willing to put up time and money, they should
> let themselves be known.
> 
> I'm not going to work on such an integration, although I happily accept
> patches.
> 
> >> As a developer all I need is a script to run smoke tests so I can catch
> >> most regressions (you never catch all).
> >> 
> >> I'm happy to work with them to make any changes to compliance tools and
> >> scripts so they fit better into their test framework.
> >> 
> >> The one key requirement to all this is that you should be able to run
> >> these tests without dependencies to all sorts of external packages/
> >> libraries.
> > 
> > v4l-utils already has a set of dependencies, but those are largely
> > manageable. For v4l2-compliance we'll install libv4l, which depends on
> > libjpeg.
> 
> That's already too much. You can manually build v4l2-compliance with no
> dependencies whatsoever, but we're missing a Makefile target for that. It's
> been useful for embedded systems with poor cross-compile environments.

I don't think depending on libv4l and libjpeg would be a big issue. On the 
other hand, given what v4l2-compliance do, one could also argue that it should 
not use libv4l at all and go straight for the kernel API. This boils down to 
the question of whether we consider libv4l as part of the official V4L2 stack, 
or if we want to officially deprecate it given that it hasn't really lived to 
the promises it made.

> It is really very useful to be able to compile those core utilities with no
> external libraries other than glibc. You obviously will loose some
> functionality when you compile it that way.
> 
> These utilities are not like a typical application. I really don't care how
> many libraries are linked in by e.g. qv4l2, xawtv, etc. But for v4l2-ctl,
> v4l2-compliance, cec-ctl/follower/compliance (and probably a few others as
> well) you want a minimum of dependencies so you can run them everywhere,
> even with the crappiest toolchains or cross-compile environments.

If you want to make them easy to deploy, a more useful option would be a 
makefile rule to compile them statically.

> >>> Regarding the test output, many formats exist (see
> >>> https://testanything.org/ and
> >>> https://chromium.googlesource.com/chromium/src/+/master/docs/testing/
> >>> json_test_results_format.md for instance), we should pick one of the
> >>> leading industry standards (what those standards are still needs to be
> >>> researched  :-)).
> >>> 
> >>>> Do note that for different hardware the tests would be likely different
> >>>> as well although there are classes of devices for which the exact same
> >>>> tests would be applicable.
> >>> 
> >>> See http://git.ideasonboard.com/renesas/vsp-tests.git for an example of
> >>> device-specific tests. I think some of that could be generalized.
> >>> 
> >>>>> It should be simple to use and require very little in the way of
> >>>>> dependencies. Ideally no dependencies other than what is in v4l-utils
> >>>>> so it can easily be run on an embedded system as well.
> >>>>> 
> >>>>> For a 64-bit kernel it should run the tests both with 32-bit and
> >>>>> 64-bit applications.
> >>>>> 
> >>>>> It should also test with both single and multiplanar modes where
> >>>>> available.
> >>>>> 
> >>>>> Since vivid emulates CEC as well, it should run CEC tests too.
> >>>>> 
> >>>>> As core developers we should have an environment where we can easily
> >>>>> test our patches with this script (I use a VM for that).
> >>>>> 
> >>>>> I think maintaining the script (or perhaps scripts) in v4l-utils is
> >>>>> best since that keeps it in sync with the latest kernel and v4l-utils
> >>>>> developments.
> >>>> 
> >>>> Makes sense --- and that can be always changed later on if there's a
> >>>> need to.
> >>> 
> >>> I wonder whether that would be best going forward, especially if we want
> >>> to add more tests. Wouldn't a v4l-tests project make sense ?
> >> 
> >> Let's see what happens. The more repos you have, the harder it becomes to
> >> keep everything in sync with the latest kernel code.
> > 
> > Why is that ? How would a v4l-tests repository make it more difficult ?
> 
> Right now whenever we update the uAPI in the kernel we run 'make
> sync-with-kernel' in v4l-utils to sync it to the latest kernel code. We
> only do this for this repo, and adding a new repo where you have to do that
> will just complicate matters and make it more likely you'll forget.

Let's automate it then :-)

> I don't see a good reason to create a new repo to store the test code.

Having all test code in a separate git tree would make it easier for people to 
contribute without having to deal with v4l-utils in general. Pretty much every 
time I want to cross-compile tools from v4l-utils I end up editing the 
makefiles to work around compilation failures due to missing dependencies that 
don't have config options, or just to disable tools that don't cross-compile 
for random reasons and that I don't need.

A separate repository would also allow us to put testing under the spotlight, 
instead of hiding the tools and scripts in subdirectories, mixed with other 
completely unrelated tools and scripts. I would then consider contributing 
vsp-tests to the V4L2 test suite, while I really wouldn't if it had to be part 
of v4l-utils.

If we want to encourage driver authors to submit tests, we should also give 
commit rights. A separate repository would help there.

> However, I do think we might want to create a new repo to store video test
> sequences (something I expect to see when we start on testing codecs).
> 
> It's IMHO a bad idea to add many MBs of video files to v4l-utils.

That should definitely be a new repository.

> >> My experience is that if you want to have good tests, then writing tests
> >> should be as easy as possible. Keep dependencies at an absolute minimum.
> > 
> > To make it as easy as possible we need to provide high-level APIs, so
> > dependencies will be unavoidable. I found for instance that Python
> > bindings were very useful to write tests for DRM/KMS (using libkmsxx), and
> > I plan to have a look at Python bindings for V4L2.
> 
> Let's just start with simple smoke tests. Python bindings etc. are something
> for the future. Nobody has the time to work on that anyway.

That's not true, TI has added V4L2 Python bindings to kmsxx, and moving the 
VIN test scripts to Python is on the todo list of the Renesas multimedia 
upstreaming team. There could be other efforts I'm not aware of. Please don't 
assume that nobody runs tests just because no patches are sent for the non-
existing V4L2 test infrastructure :-)

> >> Let's be honest, we (well, mainly me) are doing these tests as a side
> >> job, it's not our main focus.
> > 
> > That's a mindset that needs to evolve :-)
> 
> I want to be more aggressive with this: new APIs will need patches to
> v4l-utils as well before they can be accepted, and ideally new tests.

That's something we should enforce, but to do so, we first need to polish our 
test infrastructure. In particular v4l2-compliance needs to be modularized and 
documented to make it easier to contribute new tests.

I would also go one step further, I would like new APIs to always come with a 
userspace implementation in a non-test stack.

> And hopefully the kernelci project will lead to some improvements as well.
> 
> >> Anything that makes writing tests more painful is bad and just gets in
> >> the way.
> > 
> > I don't see any disagreement on this. What makes it easy to write tests
> > will however be much more prone to arguments.
> 
> Since I'm pretty much the only one who has been writing tests, I'd say that
> I can make a good argument :-)

You're pretty much the only one contributing tests to v4l-utils, but certainly 
not the only one who has been writing tests.

-- 
Regards,

Laurent Pinchart
