Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:36672 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbeKHEm3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Nov 2018 23:42:29 -0500
Date: Wed, 7 Nov 2018 17:10:35 -0200
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Shuah Khan <shuah@kernel.org>, sean@mess.org
Subject: Re: [RFC] Create test script(s?) for regression testing
Message-ID: <20181107171035.0cc0360b@coco.lan>
In-Reply-To: <4049608.APCVuh3Y7C@avalon>
References: <d0b6420c-e6b9-64c3-3577-fd0546790af3@xs4all.nl>
        <2115308.QQYpHGbrpd@avalon>
        <b1bdffdb-9667-6c2a-b1be-b7bf2022817a@xs4all.nl>
        <4049608.APCVuh3Y7C@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 07 Nov 2018 12:06:55 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Hans,
>=20
> On Wednesday, 7 November 2018 10:05:12 EET Hans Verkuil wrote:
> > On 11/06/2018 08:58 PM, Laurent Pinchart wrote: =20
> > > On Tuesday, 6 November 2018 15:56:34 EET Hans Verkuil wrote: =20
> > >> On 11/06/18 14:12, Laurent Pinchart wrote: =20
> > >>> On Tuesday, 6 November 2018 13:36:55 EET Sakari Ailus wrote: =20
> > >>>> On Tue, Nov 06, 2018 at 09:37:07AM +0100, Hans Verkuil wrote: =20
> > >>>>> Hi all,
> > >>>>>=20
> > >>>>> After the media summit (heavy on test discussions) and the V4L2 e=
vent
> > >>>>> regression we just found it is clear we need to do a better job w=
ith
> > >>>>> testing.
> > >>>>>=20
> > >>>>> All the pieces are in place, so what is needed is to combine it a=
nd
> > >>>>> create a script that anyone of us as core developers can run to c=
heck
> > >>>>> for regressions. The same script can be run as part of the kernel=
ci
> > >>>>> regression testing. =20
> > >>>>=20
> > >>>> I'd say that *some* pieces are in place. Of course, the more there=
 is,
> > >>>> the better.
> > >>>>=20
> > >>>> The more there are tests, the more important it would be they're
> > >>>> automated, preferrably without the developer having to run them on=
 his/
> > >>>> her own machine. =20
> > >>>=20
> > >>> From my experience with testing, it's important to have both a core=
 set
> > >>> of tests (a.k.a. smoke tests) that can easily be run on developers'
> > >>> machines, and extended tests that can be offloaded to a shared test=
ing
> > >>> infrastructure (but possibly also run locally if desired). =20
> > >>=20
> > >> That was my idea as well for the longer term. First step is to do the
> > >> basic smoke tests (i.e. run compliance tests, do some (limited) stre=
aming
> > >> test).
> > >>=20
> > >> There are more extensive (and longer running) tests that can be done=
, but
> > >> that's something to look at later.
> > >>  =20
> > >>>>> We have four virtual drivers: vivid, vim2m, vimc and vicodec. The=
 last
> > >>>>> one is IMHO not quite good enough yet for testing: it is not fully
> > >>>>> compliant to the upcoming stateful codec spec. Work for that is
> > >>>>> planned as part of an Outreachy project.
> > >>>>>=20
> > >>>>> My idea is to create a script that is maintained as part of v4l-u=
tils
> > >>>>> that loads the drivers and runs v4l2-compliance and possibly other
> > >>>>> tests against the virtual drivers. =20

(adding Shuah)

IMO, the best would be to have something like that as part of Kernel
self test, as this could give a broader covering than just Kernel CI.

Yeah, I know that one of the concerns is that the *-compliance stuff
we have are written in C++ and it is easier to maintain then at
v4l-utils, but maybe it would be acceptable at kselftest to have a
test bench there with would download the sources from a git tree
and then build just the v4l2-compliance stuff, e. g. having a Kernel
self test target that would do something like:

	git clone --depth 1 git://linuxtv.org/v4l-utils.git tests && \
	cd tests && ./autogen.sh && make tests && ./run_tests.sh

(the actual selftest target would likely be different, as it=20
 should take into account make O=3D<some_output_dir>)

If this would be acceptable upstream, then we'll need to stick with the
output format defined by Kernel Self Test[1].

[1] I guess it uses the TAP13 format:
	https://testanything.org/tap-version-13-specification.html

> > >>>>=20
> > >>>> How about spending a little time to pick a suitable framework for
> > >>>> running the tests? It could be useful to get more informative repo=
rts
> > >>>> than just pass / fail. =20
> > >>>=20
> > >>> We should keep in mind that other tests will be added later, and the
> > >>> test framework should make that easy. =20
> > >>=20
> > >> Since we want to be able to run this on kernelci.org, I think it mak=
es
> > >> sense to let the kernelci folks (Hi Ezequiel!) decide this. =20
> > >=20
> > > KernelCI isn't the only test infrastructure out there, so let's not f=
orget
> > > about the other ones. =20
> >=20
> > True, but they are putting time and money into this, so they get to cho=
ose
> > as far as I am concerned :-) =20

Surely, but no matter who is paying, if one wants to merge things upstream,
he/she has to stick with upstream ruleset.

That's said, we should try to not make life harder than it should be for
it, but some things should be standardized, if we want future contributions
there. At very minimal, from my side, I'd like it to be as much compatible
with Kernel selftest infrastructure as possible.

I would try to avoid placing KernelCI-specific stuff (like adding LAVA code)
inside v4l-utils tree. With regards to that, one alternative would be to
split KernelCI specific code on a different tree and use "git subtree".

> It's still our responsibility to give V4L2 a good test framework, and to =
drive=20
> it in the right direction. We don't accept V4L2 API extensions blindly ju=
st=20
> because a company happens to put time and money into it (there may have b=
een=20
> one exception, but it's not the rule), we instead review all proposals=20
> carefully. The same should be true with tests.
>=20
> > If others are interested and willing to put up time and money, they sho=
uld
> > let themselves be known.
> >=20
> > I'm not going to work on such an integration, although I happily accept
> > patches.
> >  =20
> > >> As a developer all I need is a script to run smoke tests so I can ca=
tch
> > >> most regressions (you never catch all).
> > >>=20
> > >> I'm happy to work with them to make any changes to compliance tools =
and
> > >> scripts so they fit better into their test framework.
> > >>=20
> > >> The one key requirement to all this is that you should be able to run
> > >> these tests without dependencies to all sorts of external packages/
> > >> libraries. =20
> > >=20
> > > v4l-utils already has a set of dependencies, but those are largely
> > > manageable. For v4l2-compliance we'll install libv4l, which depends on
> > > libjpeg. =20
> >=20
> > That's already too much. You can manually build v4l2-compliance with no
> > dependencies whatsoever, but we're missing a Makefile target for that. =
It's
> > been useful for embedded systems with poor cross-compile environments. =
=20
>=20
> I don't think depending on libv4l and libjpeg would be a big issue.

Having v4l2-compliance depending on libv4l is not an issue, as both are
at the same tree. Except for glibc, I would avoid any other dependencies
like libjpeg.

> On the=20
> other hand, given what v4l2-compliance do, one could also argue that it s=
hould=20
> not use libv4l at all and go straight for the kernel API. This boils down=
 to=20
> the question of whether we consider libv4l as part of the official V4L2 s=
tack,=20
> or if we want to officially deprecate it given that it hasn't really live=
d to=20
> the promises it made.

There's no question here: currently, libv4l2 is part of official V4L2
stack, as almost all V4L2 generic applications rely on it. We made some
pressure for apps to use it and we did the conversion ourselves for several
existing apps. So, for the better of the worse, we're committed to it.

When libcamera becomes a reality, and applications get ported to it, then
it would make sense to re-evaluate it.

> > It is really very useful to be able to compile those core utilities wit=
h no
> > external libraries other than glibc. You obviously will loose some
> > functionality when you compile it that way.
> >=20
> > These utilities are not like a typical application. I really don't care=
 how
> > many libraries are linked in by e.g. qv4l2, xawtv, etc. But for v4l2-ct=
l,
> > v4l2-compliance, cec-ctl/follower/compliance (and probably a few others=
 as
> > well) you want a minimum of dependencies so you can run them everywhere,
> > even with the crappiest toolchains or cross-compile environments. =20
>=20
> If you want to make them easy to deploy, a more useful option would be a=
=20
> makefile rule to compile them statically.

I agree. Also, the better would be to actually have an option to build them
in a way that both 32 bits on 64 bits ioctl calls would be tested.

=46rom my side, a really useful smoke test would be to detect if a 32-bits
ioctl call is not properly handled by the Kernel, as this is something
that people usually forget to test when touching media APIs.

>=20
> > >>> Regarding the test output, many formats exist (see
> > >>> https://testanything.org/ and
> > >>> https://chromium.googlesource.com/chromium/src/+/master/docs/testin=
g/
> > >>> json_test_results_format.md for instance), we should pick one of the
> > >>> leading industry standards (what those standards are still needs to=
 be
> > >>> researched  :-)).
> > >>>  =20
> > >>>> Do note that for different hardware the tests would be likely diff=
erent
> > >>>> as well although there are classes of devices for which the exact =
same
> > >>>> tests would be applicable. =20
> > >>>=20
> > >>> See http://git.ideasonboard.com/renesas/vsp-tests.git for an exampl=
e of
> > >>> device-specific tests. I think some of that could be generalized.
> > >>>  =20
> > >>>>> It should be simple to use and require very little in the way of
> > >>>>> dependencies. Ideally no dependencies other than what is in v4l-u=
tils
> > >>>>> so it can easily be run on an embedded system as well.
> > >>>>>=20
> > >>>>> For a 64-bit kernel it should run the tests both with 32-bit and
> > >>>>> 64-bit applications.
> > >>>>>=20
> > >>>>> It should also test with both single and multiplanar modes where
> > >>>>> available.
> > >>>>>=20
> > >>>>> Since vivid emulates CEC as well, it should run CEC tests too.
> > >>>>>=20
> > >>>>> As core developers we should have an environment where we can eas=
ily
> > >>>>> test our patches with this script (I use a VM for that).

In my case, I'll use Jenkins, but I probably won't be adding any CI
plugin. So, I'd like a simple way to call qemu (or whatever) via the
Jenkins "build" script.

> > >>>>>=20
> > >>>>> I think maintaining the script (or perhaps scripts) in v4l-utils =
is
> > >>>>> best since that keeps it in sync with the latest kernel and v4l-u=
tils
> > >>>>> developments. =20
> > >>>>=20
> > >>>> Makes sense --- and that can be always changed later on if there's=
 a
> > >>>> need to. =20
> > >>>=20
> > >>> I wonder whether that would be best going forward, especially if we=
 want
> > >>> to add more tests. Wouldn't a v4l-tests project make sense ? =20
> > >>=20
> > >> Let's see what happens. The more repos you have, the harder it becom=
es to
> > >> keep everything in sync with the latest kernel code. =20
> > >=20
> > > Why is that ? How would a v4l-tests repository make it more difficult=
 ? =20
> >=20
> > Right now whenever we update the uAPI in the kernel we run 'make
> > sync-with-kernel' in v4l-utils to sync it to the latest kernel code. We
> > only do this for this repo, and adding a new repo where you have to do =
that
> > will just complicate matters and make it more likely you'll forget. =20

Actually, that's not the only tree there with the same concept. We do
similar stuff on other userspace trees (xawtv3, tvtime, ...): they
all have a copy of the Kernel header files. I don't remember if we added
a make target to sync from Kernel on all of them - although I vaguely=20
remember that I added it (or thought about adding it) to some other tree.

Anyway, as I said early, we could think on using git subtree for
testing stuff. It is easy to use it, but not certain about the
results. Probably it would require some testing.

> Let's automate it then :-)

Maybe this could be done in the future, but sometimes manual
adjustments are needed when "make sync-with-kernel" is used.

It not just copies the new headers. It also copies new RC keymaps
and some code from vivid driver for pattern generation.

Ok, an automated system could be triggered by Kernel commits and
check if "make sync-with-kernel" would produce any changes. If it
produces, it would re-build v4l-utils (and other similar tools),
checking if nothing bad fails. If nothing fails, it would merge
the changes automatically. Otherwise, it may warn someone to merge it.

This could work.

>=20
> > I don't see a good reason to create a new repo to store the test code. =
=20
>=20
> Having all test code in a separate git tree would make it easier for peop=
le to=20
> contribute without having to deal with v4l-utils in general.=20

> Pretty much every=20
> time I want to cross-compile tools from v4l-utils I end up editing the=20
> makefiles to work around compilation failures due to missing dependencies=
 that=20
> don't have config options, or just to disable tools that don't cross-comp=
ile=20
> for random reasons and that I don't need.

That is easily solvable. Just fix the build system to not break if
there are missing dependencies or if a build is not possible on some
system.

Splitting the test code on a separate tree won't solve this issue. I mean,=
=20
if someone finds a compilation breakage due to some specific configuration,
the build system should be fixed.

That's said, while I don't have any strong opinion about that ATM, I'm more=
=20
inclined to have things that are specific for a particular testing toolset=
=20
(like KernelCI) on a separate tree.

> A separate repository would also allow us to put testing under the spotli=
ght,=20
> instead of hiding the tools and scripts in subdirectories, mixed with oth=
er=20
> completely unrelated tools and scripts. I would then consider contributin=
g=20
> vsp-tests to the V4L2 test suite, while I really wouldn't if it had to be=
 part=20
> of v4l-utils.

Yeah, right now, what's there at v4l-utils are must have stuff for
distributions. Testing code is something that doesn't really belong
inside distros. Adding stuff there would just make the tree bigger
for no good reason, IMHO.

> If we want to encourage driver authors to submit tests, we should also gi=
ve=20
> commit rights. A separate repository would help there.

Good point.

> > However, I do think we might want to create a new repo to store video t=
est
> > sequences (something I expect to see when we start on testing codecs).
> >=20
> > It's IMHO a bad idea to add many MBs of video files to v4l-utils. =20
>=20
> That should definitely be a new repository.

And independent from the testing repository itself. There is a catch here:
I don't think GPL is the right license for video files. They should
probably be licensed using some Creative Commons license.

Actually, even a model that would stick a license file for each video
would be possible.

> > >> My experience is that if you want to have good tests, then writing t=
ests
> > >> should be as easy as possible. Keep dependencies at an absolute mini=
mum. =20
> > >=20
> > > To make it as easy as possible we need to provide high-level APIs, so
> > > dependencies will be unavoidable. I found for instance that Python
> > > bindings were very useful to write tests for DRM/KMS (using libkmsxx)=
, and
> > > I plan to have a look at Python bindings for V4L2. =20
> >=20
> > Let's just start with simple smoke tests. Python bindings etc. are some=
thing
> > for the future. Nobody has the time to work on that anyway. =20
>=20
> That's not true, TI has added V4L2 Python bindings to kmsxx, and moving t=
he=20
> VIN test scripts to Python is on the todo list of the Renesas multimedia=
=20
> upstreaming team. There could be other efforts I'm not aware of. Please d=
on't=20
> assume that nobody runs tests just because no patches are sent for the no=
n-
> existing V4L2 test infrastructure :-)

Again, if we have some tests that would depend on specific stuff, the=20
building system should be capable of detecting the presence or absence=20
of the needed libraries and external programs (like python2, python3,=20
pip,...) and work accordingly, disabling tests if the needed toolset is
not available.

I'm with Hans on that matter: better to start with an absolute minimum
of dependencies (like just: make, autotools, c, c++, bash), warranting
that the core will work with just those. We can later add more stuff,
making them optional and teaching the build system to detect the=20
extra dependencies.

>=20
> > >> Let's be honest, we (well, mainly me) are doing these tests as a side
> > >> job, it's not our main focus. =20
> > >=20
> > > That's a mindset that needs to evolve :-) =20
> >=20
> > I want to be more aggressive with this: new APIs will need patches to
> > v4l-utils as well before they can be accepted, and ideally new tests. =
=20
>=20
> That's something we should enforce, but to do so, we first need to polish=
 our=20
> test infrastructure. In particular v4l2-compliance needs to be modularize=
d and=20
> documented to make it easier to contribute new tests.

Agreed. We also need a dtv-compliance tool, in order to test the Digital TV
API.

>=20
> I would also go one step further, I would like new APIs to always come wi=
th a=20
> userspace implementation in a non-test stack.

Good point.

> > And hopefully the kernelci project will lead to some improvements as we=
ll.
> >  =20
> > >> Anything that makes writing tests more painful is bad and just gets =
in
> > >> the way. =20

Yes, but discussing in advance the requirements may delay a little bit
the first implementation, but it will be less painful as we keep adding=20
more stuff to it.

> > >=20
> > > I don't see any disagreement on this. What makes it easy to write tes=
ts
> > > will however be much more prone to arguments. =20
> >=20
> > Since I'm pretty much the only one who has been writing tests, I'd say =
that
> > I can make a good argument :-) =20
>=20
> You're pretty much the only one contributing tests to v4l-utils, but cert=
ainly=20
> not the only one who has been writing tests.

Talking only about the stuff on trees we maintain, Sean also sent=20
some remote controller tests to Kernel selftest.

Thanks,
Mauro
