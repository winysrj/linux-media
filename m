Return-Path: <SRS0=G3Vt=RO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8765CC43381
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 13:43:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E9FB2075C
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 13:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552311812;
	bh=E3OFAPPRW65czvHMxWtzrnKH4oHAUCX6ORVjgJUKc1M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=msno7fNCIbsA6gIWk+BwT9Dm9dxle/FiROdGAZbklruBJVqCs/p52rpSZfe94IUoY
	 +tKFr76X3oaMxlvjjLksaYBPqJ0g5JGS48USy1srSh/DKmyQ6tBUc3ti5UxnIqXHdH
	 ApHymQc1pij3GbAeKJ/63pt1aICbq0i79CgaBuwY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727548AbfCKNnb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Mar 2019 09:43:31 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:40120 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727357AbfCKNnb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Mar 2019 09:43:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:
        From:Date:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=734nJ4ktWIz0U+zyLL6TOXjVRAEclE9x2ksyCVIkMwA=; b=DVLvk0qMKAUElL7E7qdIAFNsn
        O0FbAPJx2IGR3B8kqixMZdOGN/ivgyJAjP4nQ/qP8SsPzBGsLc2iN2Jpq1D+AO2fjyqSMzFphd4OD
        66npyTGZWtrCInv/TODzSocmXf0RH4krBJX+awQFgLJ+7/DmIcUOze6NoTLbz1Kk3L0RifV9/q9ER
        L5z6/K3Yq6iaZoS2W11UKzzh6qIt4sWIJesVqls3esd3KjiCqL+xBOKN6fa4eI40sMja/aebVVZHi
        6BaX64bpWuoDQRHfr2sb/eq1wofc/VhYCgPxNqPkCJQ/DW3ZRsd39hmlczUxj8rVtBdzzWWLvOJMv
        YKrfIcgSA==;
Received: from [177.157.99.145] (helo=coco.lan)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1h3LDB-0001GX-Hx; Mon, 11 Mar 2019 13:43:26 +0000
Date:   Mon, 11 Mar 2019 10:43:21 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Sakari Ailus <sakari.ailus@iki.fi>
Cc:     Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        media-workshop@linuxtv.org
Subject: Re: [media-workshop] [ANN] Edinburgh Media Summit 2018 meeting
 report
Message-ID: <20190311104321.097f53e3@coco.lan>
In-Reply-To: <20190311112358.7k5rt7ssmbuewuln@valkosipuli.retiisi.org.uk>
References: <CGME20181117224556epcas4p35542fe9cdf5ee333d388ec078b12c8e8@epcas4p3.samsung.com>
        <20181117224502.63hz6sh5qd6heolu@valkosipuli.retiisi.org.uk>
        <20181212053002.3c2c2f11@coco.lan>
        <20190311112358.7k5rt7ssmbuewuln@valkosipuli.retiisi.org.uk>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Mon, 11 Mar 2019 13:23:58 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
>=20
> On Wed, Dec 12, 2018 at 05:30:02AM -0200, Mauro Carvalho Chehab wrote:
> > Sakari,
> >=20
> > Em Sun, 18 Nov 2018 00:45:02 +0200
> > Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> >  =20
> > > Hello everyone, =20
> >=20
> > Sorry for taking so long to review this. Was very busy those days. =20
>=20
> Likewise in my reply. Please see my comments below. Let me know if you're
> fine with the proposed changes.
>=20
> >=20
> > It follows my comments.
> >  =20
> > >=20
> > >=20
> > > Here's the report on the Media Summit held on 25th October in Edinbur=
gh.
> > > The report is followed by the stateless codec discussion two days ear=
lier.
> > >=20
> > > Note: this is bcc'd to the meeting attendees plus a few others. I did=
n't
> > > use cc as the list servers tend to reject messages with too many
> > > recipients in cc / to headers.
> > >=20
> > > Most presenters used slides some of which are already available here
> > > (expect more in the near future):
> > >=20
> > > <URL:https://www.linuxtv.org/downloads/presentations/media_summit_201=
8/>
> > >=20
> > > The original announcement for the meeting is here:
> > >=20
> > > <URL:https://www.spinics.net/lists/linux-media/msg141095.html>
> > >=20
> > > The raw notes can be found here:
> > >=20
> > > <URL:http://www.retiisi.org.uk/~sailus/v4l2/notes/osseu18-media.html>
> > >=20
> > >=20
> > > Attendees
> > > ---------
> > >=20
> > > 	Brad Love
> > > 	Ezequiel Garcia
> > > 	Gustavo Padovan
> > > 	Hans Verkuil
> > > 	Helen Koike
> > > 	Hidenori Yamaji
> > > 	Ivan Kalinin
> > > 	Jacopo Mondi
> > > 	Kieran Bingham
> > > 	Laurent Pinchart
> > > 	Mauro Chebab
> > > 	Maxime Ripard
> > > 	Michael Grzeschik
> > > 	Michael Ira Krufky
> > > 	Niklas S=C3=B6derlund
> > > 	Patrick Lai
> > > 	Paul Elder
> > > 	Peter Griffin
> > > 	Ralph Clark
> > > 	Ricardo Ribalda
> > > 	Sakari Ailus
> > > 	Sean Young
> > > 	Seung-Woo Kim
> > > 	Stefan Klug
> > > 	Vinod Koul
> > >=20
> > >=20
> > > CEC status - Hans Verkuil
> > > -------------------------
> > >=20
> > > Hans prensented an update on CEC status. Besides the slides, notewort=
hy
> > > information is maintained here:
> > >=20
> > > <URL:https://hverkuil.home.xs4all.nl/cec-status.txt>
> > >=20
> > > Slides:
> > > <URL:https://www.linuxtv.org/downloads/presentations/media_summit_201=
8/media-cec-status.pdf> =20
> >=20
> > It makes sense to add a quick summary of the main points to the meeting
> > report that was there at the slide deck, in order to make the report mo=
re
> > complete. =20
>=20
> Bullet points from the slide:
>=20
> - cec-gpio error injection support
>=20
> - tda998x (including BeagleBoard Bone support after gpiolib changes)
>=20
> - ChromeOS EC CEC
>=20
> - In progress: omap5/dra7xx/am57xx TI (waiting for DSS redesign to land)
>=20
> - In progress: SECO cec driver (for UDOO x86 boards, expected for 4.21)
>=20
> - DisplayPort CEC-Tunneling-over-AUX for i915, nouveau, amdgpu
>=20
> - MegaChips 2900 chipset based adapters seems to support this protocol ve=
ry
>   well
>=20
> - Continuing work on CEC utilities, esp. the compliance test: it is in
>   continuous use at Cisco.

OK!

>=20
> >  =20
> > >=20
> > > rc-core status report - Sean Young
> > > ----------------------------------
> > >=20
> > > (Contributed by Sean Young) =20
> >=20
> > Sorry, I didn't understand what you're meaning here. The status
> > report was made by Sean. No need to repeat it. =20
>=20
> Sean wrote the summary as well, the rest is written by me.

I see. Well, I don't think we need to track this, as the Etherpad
notes itself (with was used as the basis for the report) was=20
authored by several participants of the Media Summit.

>=20
> >  =20
> > > In the last year all staging lirc drivers have been either removed
> > > or ported to rc-core. Decoding of the more obscure IR protocols and
> > > protocol variants can now be done with BPF, with support in both the
> > > kernel and ir-keytable (which is in v4l-utils). Generally we're in a =
good
> > > situation wrt IR support.
> > >=20
> > > There is some more ancient hardware (serial or usb-serial) that does =
not
> > > have support but not sure if anyone cares. kernel-doc is a little spa=
rse
> > > and does not cover BPF IR decoding, so that needs improving. There wa=
s a
> > > discussion on enabling builds with CONFIG_RC_CORE=3Dn. Sean suggested=
 we
> > > could have rc_allocate_driver() return NULL and have the drivers deal
> > > with this gracefully, i.e. their probe functions should continue with=
out
> > > IR. Mauro said there should be a per-driver config option (as is done
> > > for saa7134 for example). =20
> >=20
> > Please break each topic on different paragraphs, as it makes easier to
> > read and comment.
> >  =20
> > >=20
> > > No conclusion was reached on this. =20
> >=20
> > No conclusion was reached on what? =20
>=20
> That probably raises more questions than it answers. I'll drop the line.

Ok.

>=20
> >  =20
> > > Persistent storage of controls - Ricardo Ribalda
> > > ------------------------------------------------
> > >=20
> > > Ricardo gave a presentation on a proposed solution for using the V4L2
> > > control framework as an interface for updating control value defaults=
 on
> > > sensor EEPROM.
> > >=20
> > > Sensors commonly come with device specific tuning information that's
> > > embedded in the device EEPROM. Whereas this is also very common for r=
aw
> > > cameras on mobile devices, the discussion this time was concentrated =
on
> > > industrial cameras.
> > >=20
> > > The EEPROM contents may be written by the sensor vendor but occasiona=
lly
> > > may need to be updated by customers. Setting the control default valu=
e was
> > > suggested as the exact mechanism to do this.
> > >=20
> > > The proposal was to use controls as the interface to update sensor tu=
ning
> > > information in the EEPROM.
> > >=20
> > > There were arguments for and against the approach:
> > >=20
> > > + Drivers usually get these things right: relying on an user space pr=
ogram
> > >   to do this is an additional dependency.
> > > + Re-use of an existing interface (root priviledge check may be added=
).
> > >=20
> > > - Partial solution only: EEPROM contents may need to be updated for o=
ther
> > >   reasons as well, and a "spotty" implementation for updating certain
> > >   EEPROM locations seems very use case specific.
> > > - Changes required to the control framework for this --- defaults are=
 not
> > >   settable at the moment.
> > > - The need is very use case specific, and adding support for that in a
> > >   generic framework does not seem to fit very well. =20
> >=20
> > I remember I mentioned, as an alternative, to use the firmware API,
> > if one wants to update the eeprom contents. If I'm not mistaken,
> > Ricardo opted not using it.
> >=20
> > Ricardo? =20
>=20
> I let Ricardo to comment that.
>=20
> >  =20
> > >=20
> > > The general consensus appears to be not to change the control framewo=
rk
> > > this way, but to continue to update the EEPROM using a specific user =
space
> > > program.
> > >=20
> > >=20
> > > Tooling for sub-system tree maintenance - Laurent Pinchart
> > > ----------------------------------------------------------
> > >=20
> > > Laurent talked about the DRM tree maintenance model.
> > >=20
> > > The DRM tree has switched to co-maintainer model. This has made it po=
ssible
> > > to share the burden of tree maintenance, removing bottlenecks they've=
 had.
> > >=20
> > > The larger number of people having (and using) their commit rights has
> > > created the need for a more strict rules for the tree maintenance, and
> > > subsequently a tool to implement it. It's called "DIM", the DRM Inglo=
rious
> > > Maintenance tool. This is a command line tool that works as a front-e=
nd to
> > > execute the workflow.
> > >=20
> > > <URL:https://01.org/linuxgraphics/gfx-docs/maintainer-tools/dim.html>
> > >=20
> > > In particular what's worth noting:
> > >=20
> > > - The conflicts are resolved by the committer, not by the tree mainta=
iner.
> > >=20
> > > - DIM stores conflict resolutions (as resolved by developers) to a sh=
ared
> > >   cache.
> > >=20
> > > - DIM makes doing common mistakes harder by using sanity checks.
> > >=20
> > > There are about 50 people who currently have commit rights to the DRM=
 tree.
> > > There are no reports of commit rights having been forcibly removed as=
 of
> > > yet. This strongly suggests that the model is workable.
> > >=20
> > > The use of the tool puts additional responsibilities as well as some =
burden
> > > to the committers. Before the patches may be pushed, they are first
> > > compiled on developer's machine. That requires time, and without spec=
ial
> > > arrangements such as having a second local workspace, and that time i=
s away
> > > from productive work.
> > >=20
> > > The discussion that followed was concentrated on the possibility of u=
sing a
> > > similar model for the media tree. While the suggestion was initially =
met by
> > > mostly favourable reception, there were concerns as well.
> > >=20
> > > V4L2 *was* maintained generally according to the suggested model --- =
albeit
> > > without the proposed tools or process that needed to be strictly foll=
owed.
> > > There was once an incident which involved merging around 9000 lines of
> > > unreviewed code in a lot of places. What followed was not pretty, and=
 this
> > > eventually lead to loss of multiple developers.
> > >  =20
> > > Could this happen again? The DRM tree has not suffered such incidents=
, and
> > > generally it understood such incident could be addressed by simply
> > > reverting such a patch and removing commit rights if necessary.  =20
> >  =20
> > > (Editor
> > > note: we have reverted the media tree master state to an earlier comm=
it
> > > many times for various reasons. Could it be one of the reasons the 90=
00
> > > line patch was not reverted was that the version control wasn't based=
 on
> > > git??) =20
> >=20
> > We actually reverted it, but it caused a huge confusion and produced
> > lots of discussions. We lost several active developers: people that
> > were not happy by the 9000 lines patchset stepping on everyone's feet
> > and people that were not happy by reverting it. =20
>=20
> Do you happen to remember any details? Did that "reverting" for instance
> involve rolling back to the state before the offending patch after more
> comments had been done?

Don't remember the exact details anymore. This was at the time we used
Mercurial to manage the tree. It was either a patch reverting the
previous stuff, or more likely, we just dropped the patch from it.

> That said, I feel this is not overly important. The DRM folks have proved
> this model works.

So far, it is working for them, but, last time I asked, it seems that
DRM didn't have yet an issue where a developer with commit rights that
had started to deliberately violate their policies.

For media, the multi-commit model worked fine for us by the time
we used it (from 2005 to ~2008), until we had a major issue and had
to change it.

> Still I agree this is good to remember and document, but
> I don't see us getting into such situation _even if_ we'd switch to a
> similar way of working.

As we had this situation in the past, I would prefer to wait until
DRM start to have similar issues in order to see how they'll handle
it in practice, in order to evaluate about returning to use such model
again.

Anyway, this is post-media summit discussions. For the report, we should
stick with what it was discussed there.

>=20
> >  =20
> > > Some opined that we do not have a bottleneck in reviewing patches and
> > > getting them merged whilst others thought this was not the case. It is
> > > certainly true that a very large number of patches (around 500 in the=
 last
> > > kernel release) went in through the media tree. =20
> >  =20
> > > It still appears that there
> > > would be more patches and more drivers to get in if the throughput was
> > > higher. =20
> >=20
> > I'm not so sure about that (if we expect good quality patches),
> > specially while we don't have any automatic testing tool to
> > double check some stuff. =20
>=20
> I agree. To help improving the process from here, we do need automated
> testing. I don't think anyone has really even argued against adding
> automated testing.
>=20
> Considering the amount of coverage in the meeting as well as the interest
> in general, it's just a question of time until we have something quite
> usable.
>=20
> >=20
> > As a result of those discussions, One of the things that we've agreed
> > there is to give trees at LinuxTV for more active developers that
> > we trust enough to skip a sub-maintainer's review. =20
>=20
> We used to have more active developer involvement. Anyway, I'll add a note
> on this.
>=20
> >=20
> > We also agreed to try to improve the tooling at linuxtv.org, in
> > order to try to improve our processes (although this discussion
> > was actually split on other topics, like KernelCI and linuxtv infra). =
=20
>=20
> How about:
>=20
> It was also agreed to try to improve tooling at linuxtv.org to streamline
> the workflow. (Ed. note: also see testing related topics below.)

OK!

>=20
> >  =20
> > >=20
> > >=20
> > > Current status of testing on the media tree - Sakari
> > > ----------------------------------------------------
> > >=20
> > > The common practice in media subsystem development is that developers=
 do
> > > test their patches before submitting them. This is an unwritten rule:
> > > sometimes patches end up not being tested after making slight changes=
 to
> > > them, or they have been tested on a different kernel version. The dev=
eloper
> > > may also simply forget to test the patch.
> > >=20
> > > Besides this, it is not uncommon that changing the kernel configurati=
on or
> > > switching to a different architecture will cause a compilation warnin=
g or
> > > an error.
> > >=20
> > > The 0-day bot will catch some of these errors before the patches are
> > > merged, but that testing does not fully cover all the possible cases.=
 There
> > > are some common pain points in V4L2-related Kconfig options (plain V4=
L2, MC
> > > or MC + subdev uAPI); newly submitted drivers may in fact require one=
 of
> > > these, but the developer may not have realised that and so this ends =
up not
> > > being taken into account in Kconfig.
> > >=20
> > > Once the review is done, and after being applied to the sub-maintainer
> > > tree, a patch is applied to Mauro's local tree and Mauro performs
> > > additional tests on it. These tests currently prevent a fair number of
> > > problems reaching a wider audience than the media developers.
> > >=20
> > > On the other hand, whenever an issue is found, the patch will have to=
 be
> > > fixed by the sub-maintainer or the developer. This is hardly ideal, a=
s the
> > > problem has existed usually for a month or two before being spotted -=
-- by
> > > a program. These checks should be instead performed on the patch when=
 it's
> > > submitted.
> > >=20
> > >=20
> > > Automated testing - Ezequiel Garcia
> > > -----------------------------------
> > >=20
> > > Ideal Continuous Integration process consists of the following steps:
> > >=20
> > > 	1. patch submission
> > > 	2. review and approval
> > > 	3. merge
> > >=20
> > > The core question is "what level of quality standards do we want to
> > > enforce". The maintenance process should be modelled around this ques=
tion,
> > > and not the other way around. Automated testing can be a part of enfo=
rcing
> > > the quality standards.
> > >=20
> > > There are three steps:
> > >=20
> > > 	1. Define the quality standard
> > > 	2. Define how to quantify quality in respect to the standard
> > > 	3. Define how to enforce the standards
> > >=20
> > > On the tooling side, an uAPI test tool exists. It's called v4l2-compl=
iance,
> > > and new drivers are required to pass the v4l2-compliance test.
> > > It has quite a few favourable properties:
> > >=20
> > > - Complete in terms of the uAPI coverage
> > > - Quick and easy to run
> > > - Nice output format for humans & scripts
> > >=20
> > > There are some issues as well:
> > >=20
> > > - No codec support (stateful or stateless)
> > > - No SDR or touch support
> > > - Frequently updated (distribution shipped v4l2-compliance useless)
> > > - Only one contributor
> > >=20
> > > Ezequiel noted that some people think that v4l2-compliance is changin=
g too
> > > often but Hans responded that this is a necessity. The API gets amend=
ed
> > > occasionally and the existing API gets new tests. Mauro proposed movi=
ng
> > > v4l2-compliance to the kernel source tree but Hans preferred keeping =
it
> > > separate. That way it's easier to develop it.
> > >=20
> > > To address the problem of only a single contributor, it was suggested=
 that
> > > people implementing new APIs would need to provide the tests for
> > > v4l2-compliance as well. To achieve this, the v4l2-compliance codebase
> > > needs some cleanup to make it easier to contribute. The codebase is l=
arger
> > > and there is no documentation.
> > >=20
> > > V4l2-compliance also covers MC, V4L2 and V4L2 sub-device uAPIs.
> > >=20
> > > DVB will require its own test tooling; it is not covered by
> > > v4l2-compliance. In order to facilitate automated testing, a virtual =
DVB
> > > driver would be useful as well. The task was added to the list of pro=
jects
> > > needing volunteers:
> > >=20
> > > <URL:https://linuxtv.org/wiki/index.php/Media_Open_Source_Projects:_L=
ooking_for_Volunteers>
> > >=20
> > > There are some other test tools that could cover V4L2 but at the mome=
nt it
> > > seems somewhat far-fetched any of them would be used to test V4L2 in =
the
> > > near future:
> > >=20
> > > 	- kselftest
> > > 	- kunit
> > > 	- gst-validate
> > > 	- ktf (https://github.com/oracle/ktf, http://heim.ifi.uio.no/~knuto/=
ktf/)
> > >=20
> > > KernelCI is a test automation system that supports automated compile =
and
> > > boot testing. As a newly added feature, additional tests may be
> > > implemented. This is what Collabora has implemented, effectively the
> > > current demo system runs v4l2-compliance on virtual drivers in a virt=
ual
> > > machines (LAVA slaves).
> > >=20
> > > A sample of the current test report is here:
> > >=20
> > > <URL:https://www.mail-archive.com/linux-media@vger.kernel.org/msg1357=
87.html>
> > >=20
> > > The established way to run KernelCI tests is off the head of the bran=
ches of
> > > the stable and development kernel trees, including linux-next. This i=
s not
> > > useful as such to support automated testing of patches for the media =
tree:
> > > the patches need to be tested before they are merged, not after mergi=
ng.
> > >=20
> > > In the discusion that followed among a slightly smaller group of peop=
le, it
> > > was suggested that tests could be run from select developer kernel tr=
ees,
> > > from any branch. If a developer needs long-term storage, (s)he could =
have
> > > another tree which would not be subject automated test builds.
> > > Alternatively, the branch name could be used as a basis for triggering
> > > an automated build, but this could end up being too restrictive.
> > >=20
> > > Merging the next rc1 by the maintainer would be no special case: the =
branch
> > > would be tested in similar way than the developer branches containing
> > > patches, and tests should need to pass before pushing the content to =
the
> > > media tree master branch.
> > >=20
> > > Ezequiel wished that people would reply to his e-mail to express their
> > > wishes on the testing needs (see sample report above).
> > >=20
> > >=20
> > > Stateless codecs - Hans Verkuil
> > > -------------------------------
> > >=20
> > > Support for stateless codecs will be merged for v4.20 with an Allwinn=
er
> > > staging codec driver.
> > >=20
> > > The earlier stateless codec discussion ended up concluding that the
> > > bitstream parsing is application specific, so there will be no need f=
or a
> > > generic implementation that was previously foreseen. The question that
> > > remains is: should there be a simple parser for compliance testing?
> > >=20
> > > All main applications support libva which was developed as the codec =
API to
> > > be used with Intel GPUs. A libVA frontend was written to support the
> > > Cedrus stateless V4L2 decoder driver. It remains to be seen whether t=
he
> > > same implementation could be used as such for the other stateless cod=
ec
> > > drivers or whether changes, or in the worst case a parallel implement=
ation,
> > > would be needed.
> > >=20
> > > Slides:
> > > <URL:https://www.linuxtv.org/downloads/presentations/media_summit_201=
8/media-codec-userspace.pdf>
> > >=20
> > >=20
> > > New versions of the old IOCTLs - Hans Verkuil
> > > ---------------------------------------------
> > >=20
> > > V4L2 is an old API with shifting focus in terms of functionality and
> > > hardware supported. While there has been lots of changes to the two d=
uring
> > > the existence of V4L2, some of the API is unchanged since the old
> > > times. While the API is usable for the purpose, it is needlessly clun=
ky: it
> > > is often not obvious how an IOCTL is related to the task at hand (suc=
h as
> > > using S_PARM to set the frame interval) or the API does not use year
> > > 2038-safe timestamps (struct v4l2_buffer). These APIs deserve to be
> > > updated.
> > >=20
> > > * VIDIOC_*_PARM
> > >=20
> > > In the case of VIDIOC_G_PARM and VIDIOC_S_PARM, the IOCTLs are only u=
sed to
> > > set and get the frame interval.  =20
> >  =20
> > > In this case, what can be done, is to add a
> > > new IOCTL definition, with the same IOCTL number and with binary-equi=
valent
> > > IOCTL argument struct that only contains the field for the frame rate
> > > itself. This is binary-compatible with the existing code and no
> > > compatibility code will be needed. The new IOCTLs will be called
> > > VIDIOC_G_FRAME_INTERVAL and VIDIOC_S_FRAME_INTERVAL.
> > >=20
> > > * VIDIOC_ENUM_FRAME_INTERVALS
> > >=20
> > > Besides discrete set of supported frame intervals,
> > > VIDIOC_ENUM_FRAME_INTERVALS has stepwise frame interval as well. Step=
wise
> > > could be removed as the Qualcomm venus codec and uvc (100 ns units) a=
re the
> > > only users. Additionally, the buffer type should be added to struct
> > > v4l2_frmivalenum.
> > >=20
> > > There was also a discussion related to enumerating frame intervals in=
 units
> > > of ns vs. fractional seconds. The reasoning using a fraction is that =
this
> > > way the frame interval on many standards can be conveyed precisely.
> > > Somebody recalled "flick", that is is the common denominator of the f=
rame
> > > rates on all TV standards. Drivers could simply move to use the flick=
 as
> > > the denominator, to make frame interval reporting uniform across the
> > > drivers.
> > >=20
> > > * struct v4l2_buffer
> > >=20
> > > struct v4l2_buffer is an age-old struct. There are a few issues in it:
> > >=20
> > > - The timestamp is not 2038-safe.
> > > - The multi-plane implementation is a mess.
> > > - Differing implementation for the end single-plane and multi-plane A=
PIs is
> > >   confusing for both applications and drivers.
> > >=20
> > > The proposal is to create a new v4l2_buffer struct. The differences t=
o the
> > > old one would be:
> > >=20
> > > - __u64 timestamps. These are 2038-safe. The timestamp source is
> > >   maintained, i.e. the type remains CLOCK_MONOTONIC apart from certain
> > >   drivers (e.g. UVC) that lets the user choose the timestamp.
> > > - Put the planes right to struct v4l2_buffer. The plane struct would =
also
> > >   be changed; the new plane struct would be called v4l2_ext_plane.
> > > - While at it, the plane description can be improved:
> > > 	- The start of data from the beginning of the plane memory.
> > > 	- Add width and height to the buffer? This would make image size
> > > 	  changes easier for the codec. (Ed. note: pixel format as well.
> > > 	  But this approach could only partially support what the request
> > > 	  API is for.)
> > > - Unify single- and multi-planar APIs.
> > >=20
> > > The new struct could be called v4l2_ext_buffer.
> > >=20
> > > As the new IOCTL argument struct will have has different syntax as we=
ll as =20
> >=20
> > 	s/have has/have/ =20
>=20
> Will fix.

Thanks.

>=20
> >  =20
> > > semantics, it deserves to be named differently. Compatibility code wi=
ll be
> > > needed to convert the users of the old IOCTLs to the new struct used
> > > internally by the kernel and drivers, and then back to the user.
> > >=20
> > > * struct v4l2_create_buffers
> > >=20
> > > Of the format, only the pix.fmt.sizeimage field is effectively used b=
y the
> > > drivers supporting VIDIOC_CREATE_BUFS. This could be simplified, by j=
ust
> > > providing the desired buffer size instead of the entire v4l2_format s=
truct.
> > > The user would be instructed to use TRY_FMT to obtain that buffer siz=
e.
> > >=20
> > > The need to delete buffers seems to have eventually surfaced. That was
> > > expected, but it wasn't known when this would happen. As the buffer i=
ndex
> > > range would become non-contiguous, it should be possible to create bu=
ffers
> > > one by one only, as otherwise the indices of the additional buffers w=
ould
> > > no longer be communicated to the user unambiguously.
> > >=20
> > > So there would be new IOCTLs:
> > >=20
> > > - VIDIOC_CREATE_BUF - Create a single buffer of given size (plus other
> > > 		      non-format related aspects)
> > > - VIDIOC_DELETE_BUF - Delete a single buffer
> > > - VIDIOC_DELETE_ALL_BUFS - Delete all buffers
> > >=20
> > > The naming still requires some work. The opposite of create is "destr=
oy",
> > > not "delete".
> > >=20
> > > * struct v4l2_pix_format vs. struct v4l2_pix_format_mplane
> > >=20
> > > Working with the two structs depending on whether the format is
> > > multi-planar or not is painful. While we're doing changes in the area=
, the
> > > two could be unified as well. =20
> >  =20
> > > (Editor note: this could be still orthogonal
> > > to the buffers, so it could be done separately as well. We'll see.) =
=20
> >=20
> > I suspect that those "editor note" (as any post-meeting notes) don't=20
> > belong to the final report.  =20
>=20
> I wanted to make the report more readable for people who are not actively
> working on V4L2 development and are thus likely not able to make such
> connections.

I understand, but the focus of the report is on what happened there.

Feel free to do any personal views about what happened there, or about
any post-meeting notes, but please keep them outside of the report's body,
as the report should be as objective as possible about what was discussed
there.

>=20
> >=20
> > But yeah, perhaps this could be done seprarately. Let's discuss
> > it when actual patches gets posted.
> >  =20
> > >=20
> > > Slides:
> > > <URL:https://www.linuxtv.org/downloads/presentations/media_summit_201=
8/media-new-ioctls.pdf> =20
> >=20
> > I guess there was an action plan for that, based on the discussions
> > (maybe some of them ended by being merged with the presentation on the
> > above?).
> >=20
> > Hans,=20
> >=20
> > Did you take any notes about the actions to be taken? I found
> > very helpful to have an action plan item below the topics where
> > we made such plan.
> >=20
> >  =20
> > > Fault tolerant V4L2 - Kieran Bingham
> > > ------------------------------------
> > >=20
> > > Kieran presented a system where the media hardware complex consisted =
of
> > > eight more or less independent camera sensors that naturally end up b=
eing
> > > within a single media device.
> > >=20
> > > The current implementation, as well as the API, necessitates that all
> > > devices in a media device probe successfully before the entire media =
device
> > > is exposed to the user. Otherwise the user would see with a partial
> > > view of the device, without the knowledge it is such.
> > >=20
> > > To address the problem, additional information need to be provided to=
 the
> > > user space. In particular:
> > >=20
> > > - Events on the media device to tell the graph has changed.
> > >=20
> > > - Graph version number is incremented at graph change (already
> > >   implemented).
> > >=20
> > > - The property API could be applicable --- placeholders for entities =
that
> > >   have not yet appeared?
> > >=20
> > > 	- Alternative: known entities that have failed to probe created in
> > > 	  the media graph and marked "disable" or "failed".
> > >=20
> > > - Query the state of media graph completeness.
> > >=20
> > > That way, even when the devices in a media controller device appear o=
ne by
> > > one, the user space will be able to have all the necessary informatio=
n on
> > > the registration state of the device.
> > >=20
> > >=20
> > > Complex cameras - Mauro Chehab
> > > ------------------------------
> > >=20
> > > Some new laptops integrate a raw Bayer camera + ISP instead of a USB
> > > webcam. This is expected to increase, as the solution is generally ch=
eaper
> > > and results in better quality images --- as long as all the pieces of=
 the
> > > puzzle are in place, including the proprietary 3A library.
> > >=20
> > > Still, such devices need to be supported. =20
> >  =20
> > > (Ed. note: there were two talks related to this topic given in the EL=
c-E.)
> > >=20
> > > <URL:https://www.youtube.com/watch?v=3DKpaNNJr92CY&index=3D31&list=3D=
PLbzoR-pLrL6qThA7SAbhVfuMbjZsJX1CY>
> > > <URL:https://www.youtube.com/watch?v=3DGIhV7tiUji0&index=3D60&list=3D=
PLbzoR-pLrL6qThA7SAbhVfuMbjZsJX1CY> =20
> >=20
> > In this specific case, it is worth to keep the note, as those presentat=
ions
> > happened at ELC-Eu and were explicitly mentioned there during the
> > discussions.
> >  =20
> > > Development process - All
> > > -------------------------
> > >=20
> > > Topic-wise this is continuation of the "Tooling for sub-system tree
> > > maintenance", "Current status of testing on the media tree" and "Auto=
mated
> > > testing" topics above.
> > >=20
> > > The question here is whether there's something that could be improved=
 in
> > > the media development process and if so, how could that be done.
> > >=20
> > > What came up was a suggestion to have multi-committer tree in a simil=
ar
> > > manner as the DRM developers do. This was seen to be more interesting=
 for
> > > developers than simply being asked to review patches.
> > >=20
> > > It certainly does raise the need for more precise rules for what may =
be
> > > committed to the multi-committer tree, when etc.
> > >=20
> > > It was also requested that experienced driver maintainers would send =
pull
> > > requests on patches to their drivers instead of going through a
> > > sub-maintainer (pre-agreed with the relevant (sub)maintainer). This w=
ould
> > > take some work away from sub-maintainers, but not the maintainer.
> > >=20
> > > No firm decisions were reached in this topic. Perhaps this could be t=
ried
> > > out? =20
> >=20
> > We did decide to experment the "experienced driver" maintainership
> > model.=20
> >=20
> > Btw, I already added an account for one such developer :-) =20
>=20
> Ok, so we're actually trying this out. Great! :-)
>=20
> >  =20
> > > There was also a request to document the sub-maintainer names in the =
wiki
> > > so that it'd be easier for people to figure out who to ping if their
> > > patches do not get merged. =20
> >=20
> > I'm ok with that, but, after the LPC, I suspect that the best is to
> > document it in sync with the per-subsystem profile. I'm waiting for Don=
=20
> > to submit an updated patchset, in order to rebase our subsystem's
> > profile. =20
>=20
> Ok. There's a list in the wiki but I think few people end up finding it
> when they needed it. :-I
>=20
> >  =20
> > >=20
> > >=20
> > > linuxtv.org hosting - All
> > > -------------------------
> > >=20
> > > Mauro noted that linuxtv.org is currently hosted in a virtual machine
> > > somewhere in a German university. The administrator of the virtual ma=
chine
> > > has not been involved with Video4Linux for some time but has been kin=
d to
> > > provide us the hosting over the years.
> > >=20
> > > It has been recognised that there is a need to find a new hosting loc=
ation
> > > for the virtual machine. There is also a question of the domain name
> > > linuxtv.org. Discussion followed.
> > >=20
> > > What could be agreed on rather immediately was that the domain name s=
hould
> > > be owned by "us". "Us" is not a legal entity at the moment, and a pra=
ctical
> > > arrangement to achieve that could be to find a new association to own=
 the
> > > domain name.
> > >=20
> > > The hosting of the virtual machine could possibly be handled by the s=
ame
> > > association. In practice this would likely mean a virtual machine on a
> > > hosting provider. Ideally this would be paid for by a company or a gr=
oup of
> > > companies.
> > >=20
> > > No decisions were reached on the topic. =20
> >=20
> > There was actually one decision: to talk with Linux Foundation about
> > that. Laurent was against, but the majority was ok with the idea. =20
>=20
> I remember Laurent was not the only one expressing concerns related to
> using such hosting providers. I rather remember hearing this from quite a
> few people in the discussion. Either way, the decisions related to e.g.
> hosting will be taken later when more information is available, including
> what LF has to offer.

I only remember Laurent raising such concerns at the meeting.

>=20
> How about replacing the original last paragraph with:
>=20
> Mauro will discuss with LF to find out what they can offer. Concerns were
> expressed over other organisations providing us with hosting we are not in
> charge of ourselves. Other options related to domain ownership and hosting
> will be researched as well.

Sounds OK to me.

>=20
> >  =20
> > > Tuesday's stateless codec discussion
> > > ------------------------------------
> > >=20
> > > Hans presented a summary of this in his stateless codec status
> > > presentation, here are a bit more details.
> > >=20
> > > We had a discussion (first in the Microsoft sponsor suite, then at th=
e bar) =20
> >=20
> > I don't think that the room location is relevant for the report :-) =20
>=20
> :-D
>=20
> >=20
> > Also, we should split this on a separate report, as this was
> > another meeting and not all people listed above participated on it. =20
>=20
> Works for me.
>=20
> >  =20
> > > on how to support user space for the stateless codecs better. The exp=
ected
> > > outcome of that would be a rough understanding how a stateless codec =
user
> > > space library would look like.
> > >=20
> > > The raw notes are available here:
> > >=20
> > > <URL:http://www.retiisi.org.uk/~sailus/v4l2/notes/osseu18-codecs.html>
> > >=20
> > > * Attendees
> > >=20
> > >     Alexandre Courbot
> > >     Chris Healy
> > >     Ezequiel Garcia
> > >     Hans Verkuil
> > >     Kieran Bingham
> > >     Laurent Pinchart
> > >     Maxime Ripard
> > >     Mauro Carvalho Chehab
> > >     Nicolas Dufresne
> > >     Niklas S=C3=B6derlund
> > >     Philip Zabell
> > >     Sakari Ailus
> > >     Tomasz Figa
> > >     Victor J=C3=A1quez
> > >=20
> > > * Buffer management
> > >=20
> > > Nicolas reported an issue in V4L2 buffer management. The V4L2 decoupl=
es the
> > > buffers from the format, and assumes all queued buffers (at a given p=
oint
> > > of time) have the same format. (Ed. note: the request API could be us=
ed to
> > > address this, but that particular features is not yet supported.)
> > >=20
> > > * User space library
> > >=20
> > > The existing projects generally integrate their own bitstream parsers=
 for
> > > codecs. There are subtle reasons why that tends to be the case, inste=
ad of
> > > using more generic parsers. There are differences in error handling, =
for
> > > instance, or other matters of policy, the variation which could be
> > > difficult to fully offer using a generic API.
> > >=20
> > > Maxime noted that VLC recently released a new parser meant to be used=
 as a
> > > library, and that could be useful. Nicolas believes that we'd need a =
parser
> > > library independent of any other code base to avoid pulling in extra
> > > libraries and this parser would need to be maintained. It could be
> > > difficult to find the volunteers to do that.
> > >=20
> > > Does ChromeOS have its own parser? Alexandre believes it does, but li=
ttle
> > > was known beyond that.
> > >=20
> > > There's also the language problem: ffmpeg and gstreamer are written i=
n C,
> > > the ChomeOS parser in C++, VLC is moving to Rust. What do we pick, ho=
w do
> > > we ensure interoperability?
> > >=20
> > > * libVA re-use
> > >=20
> > > As a short-term solution, implementing a generic wrapper using the V4=
L2
> > > stateless codec API to offer libVA API would enable generic applicati=
ons to
> > > use the V4L2 stateless codec drivers as most applications already sup=
port
> > > libVA.
> > >=20
> > > 70 % of the applications use FFMPEG, which has a software codec API t=
hat is
> > > nearly identical to the V4L2 statless codec API. It would be trivial =
for
> > > applications to switch to V4L2 natively.
> > >=20
> > > Mauro would like us to explain our plans to Intel to avoid surprises =
later
> > > on. =20
> >=20
> > To be clear: it was said at the meeting that libVA is sponsored an=20
> > maintained by Intel. If we're willing to use it, we should sync with
> > them, in order to avoid unexpected surprises if they change it in a way
> > that would cause problems for the V4L2 stateless coded implementation. =
=20
>=20
> How about, instead of the original:
>=20
> We need to explain our plans to libVA maintainers to better coordinate
> libVA API development in a way the V4L2 stateless codecs are taken into
> account.

Works for me.

>=20
> >  =20
> > >=20
> > > * Source code hosting
> > >=20
> > > libva is hosted on freedesktop. Should we host the libva-v4l2-codec b=
ackend
> > > there, or host it on linuxtv.org? Hans would prefer linuxtv.org as it=
's
> > > "closer to our kernel implementation".
> > >=20
> > > * Backend support in libva
> > >=20
> > > libva loads backends in order, and picks the first one that reports i=
t can
> > > support the platform. There is also an environment variable that can
> > > specify a backend. Ezequiel enquired how to support platforms that wo=
uld
> > > have multiple hardware codecs. libva doesn't seem to support this at =
the
> > > moment. Nicolas reported that there's an Intel SoC that have both an =
Intel
> > > graphics core and a Vega64 graphics core that both have a codec.
> > >=20
> > > Hans said that a platform that expose multiple codecs will likely be =
used
> > > for specialized applications, and requiring those to implement codec
> > > support directly is acceptable. Our main focus should be to support t=
he
> > > common case.
> > >=20
> > > * Vendor support
> > >=20
> > > NVidia is following our progress and is interested in using the V4L2
> > > stateless API. On the userspace side, vdpau is pretty much dead, they=
 have
> > > moved to nvdec. OMX is being phasing out, in particular that is taking
> > > place for RaspberryPi now.
> > >=20
> > > * Tooling
> > >=20
> > > bootlin has developed a debugging tool called v4l2-request-test
> > > (https://github.com/bootlin/v4l2-request-test) that has been very use=
ful to
> > > debug the codec driver without going through the full userspace stack=
. This
> > > is worth mentioning and integrating.
> > >=20
> > > * API discussions
> > >=20
> > > Using buffer indices as handles to reference frames
> > >=20
> > > This has been proposed by Tomasz, and Hans has serious concerns, he
> > > believes that having userspace predict what buffer indices will be us=
ed in
> > > the future is very fragile and would prefer using a separate 64-bit c=
ookie
> > > associated with v4l2_buffers.
> > >=20
> > > Using capture buffer indices as reference frame handles requires pred=
icting
> > > the buffer index on the capture queue which the output queue frames w=
ill be
> > > decoded into. We could use the output queue buffer index instead, but=
 that
> > > wouldn't work with multi-slice decoding (multiple output buffers for a
> > > single capture buffer). Using a cookie set by userspace on the output=
 side,
> > > then copied to the capture queue by the driver, solves that problem. =
All
> > > slices queued on the output queue for the same decoded picture will h=
ave
> > > the same cookie value (userspace will have to ensure that).
> > >=20
> > > Tomasz would prefer a buffer index-based solution, to avoid keeping a
> > > cookie-index map in userspace. Due to how V4L2 works, enqueuing a new
> > > dmabuf handle on the capture side for a V4L2 buffer with a given inde=
x will
> > > effectively delete the corresponding cookie, so userspace would need =
to
> > > ensure it doesn't overwrite buffers; (Tomasz: To clarify, I don't see=
 the
> > > significant benefit of using cookies over indices. It makes it easier=
 for
> > > user space, because it doesn't have to predict the CAPTURE buffers, b=
ut
> > > still is error prone because of the buffer requeuing problem. For now=
 it
> > > would be good to see how it translates into real code, though. In the
> > > meantime I can try to find a better idea.)
> > >  =20
> >=20
> > Once we have a final version for both Tuesday meeting and the
> > Linux Media Summit, I'll post it at the "news" section of linuxtv,
> > add the group photo and the links for the presentation and for
> > our nightly dinner. =20
>=20
> Sounds good.
>=20



Thanks,
Mauro
