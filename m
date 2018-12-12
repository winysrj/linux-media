Return-Path: <SRS0=2Dg0=OV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,
	T_MIXED_ES,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5757C04EB8
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 07:30:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CE8E2084E
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 07:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544599813;
	bh=h9kpy3/U2ugf3O504dWN9mGKzQjzbd5T/nBYHPNsSoo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=blzxmjqcItGnPS04C3WFBkt1qI4gOxzsxd/ySDhUpzTud0Swju9QE3Vi7RUvrWz/w
	 lNzL/+q6XO6cRAXgtd0y4udeNFpGn65ogQpDtM1QK3vTBQHlIhsqx30pXPNIi0LYtm
	 PkLTGM3T7pwj4RhpayO/d+2qRpt0PRiWPnutvdOg=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4CE8E2084E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbeLLHaM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 12 Dec 2018 02:30:12 -0500
Received: from casper.infradead.org ([85.118.1.10]:51752 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbeLLHaM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Dec 2018 02:30:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=bbWdihQYPuNLro4yunhCVyd62P6MPfTMj6FdX81uYKk=; b=tbzQrWNMCRldiSmvt+iXKg94so
        3D1DZHtZ0Be7U+6kyGgcds4u55mKwaD8F6qZoDAjk52dwDjD9B8ohegAiHjCM+98tjhASAC+drPtR
        7ZtyYXKcIWD/R/Dlzv0Gg+1ehvXzw2aEQXgWeFbCqfjwP9v5sr8+ZmalooaIEWuyDdZRZKAJTfLCH
        1ucsKm3+aksP2ZERbLj6FPAj+f7fivuOxR/cBdNSE+MmO1kdBHsOxJLTrge9QaRSNSCBayo6RoFfv
        nVQ9I2zmYEk2IdHnDQz77aOWmrbB8OzwQzdCdHv2kK+bLsGEoPTJPGuDqV0dYetyqxirNMOn2vUDI
        Td5hv4Pg==;
Received: from [177.159.254.7] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gWyy8-00046U-Oo; Wed, 12 Dec 2018 07:30:09 +0000
Date:   Wed, 12 Dec 2018 05:30:02 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Sakari Ailus <sakari.ailus@iki.fi>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc:     linux-media@vger.kernel.org, media-workshop@linuxtv.org
Subject: Re: [media-workshop] [ANN] Edinburgh Media Summit 2018 meeting
 report
Message-ID: <20181212053002.3c2c2f11@coco.lan>
In-Reply-To: <20181117224502.63hz6sh5qd6heolu@valkosipuli.retiisi.org.uk>
References: <CGME20181117224556epcas4p35542fe9cdf5ee333d388ec078b12c8e8@epcas4p3.samsung.com>
 <20181117224502.63hz6sh5qd6heolu@valkosipuli.retiisi.org.uk>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Sakari,

Em Sun, 18 Nov 2018 00:45:02 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hello everyone,

Sorry for taking so long to review this. Was very busy those days.

It follows my comments.

>=20
>=20
> Here's the report on the Media Summit held on 25th October in Edinburgh.
> The report is followed by the stateless codec discussion two days earlier.
>=20
> Note: this is bcc'd to the meeting attendees plus a few others. I didn't
> use cc as the list servers tend to reject messages with too many
> recipients in cc / to headers.
>=20
> Most presenters used slides some of which are already available here
> (expect more in the near future):
>=20
> <URL:https://www.linuxtv.org/downloads/presentations/media_summit_2018/>
>=20
> The original announcement for the meeting is here:
>=20
> <URL:https://www.spinics.net/lists/linux-media/msg141095.html>
>=20
> The raw notes can be found here:
>=20
> <URL:http://www.retiisi.org.uk/~sailus/v4l2/notes/osseu18-media.html>
>=20
>=20
> Attendees
> ---------
>=20
> 	Brad Love
> 	Ezequiel Garcia
> 	Gustavo Padovan
> 	Hans Verkuil
> 	Helen Koike
> 	Hidenori Yamaji
> 	Ivan Kalinin
> 	Jacopo Mondi
> 	Kieran Bingham
> 	Laurent Pinchart
> 	Mauro Chebab
> 	Maxime Ripard
> 	Michael Grzeschik
> 	Michael Ira Krufky
> 	Niklas S=C3=B6derlund
> 	Patrick Lai
> 	Paul Elder
> 	Peter Griffin
> 	Ralph Clark
> 	Ricardo Ribalda
> 	Sakari Ailus
> 	Sean Young
> 	Seung-Woo Kim
> 	Stefan Klug
> 	Vinod Koul
>=20
>=20
> CEC status - Hans Verkuil
> -------------------------
>=20
> Hans prensented an update on CEC status. Besides the slides, noteworthy
> information is maintained here:
>=20
> <URL:https://hverkuil.home.xs4all.nl/cec-status.txt>
>=20
> Slides:
> <URL:https://www.linuxtv.org/downloads/presentations/media_summit_2018/me=
dia-cec-status.pdf>

It makes sense to add a quick summary of the main points to the meeting
report that was there at the slide deck, in order to make the report more
complete.

>=20
> rc-core status report - Sean Young
> ----------------------------------
>=20
> (Contributed by Sean Young)

Sorry, I didn't understand what you're meaning here. The status
report was made by Sean. No need to repeat it.

> In the last year all staging lirc drivers have been either removed
> or ported to rc-core. Decoding of the more obscure IR protocols and
> protocol variants can now be done with BPF, with support in both the
> kernel and ir-keytable (which is in v4l-utils). Generally we're in a good
> situation wrt IR support.
>=20
> There is some more ancient hardware (serial or usb-serial) that does not
> have support but not sure if anyone cares. kernel-doc is a little sparse
> and does not cover BPF IR decoding, so that needs improving. There was a
> discussion on enabling builds with CONFIG_RC_CORE=3Dn. Sean suggested we
> could have rc_allocate_driver() return NULL and have the drivers deal
> with this gracefully, i.e. their probe functions should continue without
> IR. Mauro said there should be a per-driver config option (as is done
> for saa7134 for example).

Please break each topic on different paragraphs, as it makes easier to
read and comment.

>=20
> No conclusion was reached on this.

No conclusion was reached on what?

> Persistent storage of controls - Ricardo Ribalda
> ------------------------------------------------
>=20
> Ricardo gave a presentation on a proposed solution for using the V4L2
> control framework as an interface for updating control value defaults on
> sensor EEPROM.
>=20
> Sensors commonly come with device specific tuning information that's
> embedded in the device EEPROM. Whereas this is also very common for raw
> cameras on mobile devices, the discussion this time was concentrated on
> industrial cameras.
>=20
> The EEPROM contents may be written by the sensor vendor but occasionally
> may need to be updated by customers. Setting the control default value was
> suggested as the exact mechanism to do this.
>=20
> The proposal was to use controls as the interface to update sensor tuning
> information in the EEPROM.
>=20
> There were arguments for and against the approach:
>=20
> + Drivers usually get these things right: relying on an user space program
>   to do this is an additional dependency.
> + Re-use of an existing interface (root priviledge check may be added).
>=20
> - Partial solution only: EEPROM contents may need to be updated for other
>   reasons as well, and a "spotty" implementation for updating certain
>   EEPROM locations seems very use case specific.
> - Changes required to the control framework for this --- defaults are not
>   settable at the moment.
> - The need is very use case specific, and adding support for that in a
>   generic framework does not seem to fit very well.

I remember I mentioned, as an alternative, to use the firmware API,
if one wants to update the eeprom contents. If I'm not mistaken,
Ricardo opted not using it.

Ricardo?

>=20
> The general consensus appears to be not to change the control framework
> this way, but to continue to update the EEPROM using a specific user space
> program.
>=20
>=20
> Tooling for sub-system tree maintenance - Laurent Pinchart
> ----------------------------------------------------------
>=20
> Laurent talked about the DRM tree maintenance model.
>=20
> The DRM tree has switched to co-maintainer model. This has made it possib=
le
> to share the burden of tree maintenance, removing bottlenecks they've had.
>=20
> The larger number of people having (and using) their commit rights has
> created the need for a more strict rules for the tree maintenance, and
> subsequently a tool to implement it. It's called "DIM", the DRM Inglorious
> Maintenance tool. This is a command line tool that works as a front-end to
> execute the workflow.
>=20
> <URL:https://01.org/linuxgraphics/gfx-docs/maintainer-tools/dim.html>
>=20
> In particular what's worth noting:
>=20
> - The conflicts are resolved by the committer, not by the tree maintainer.
>=20
> - DIM stores conflict resolutions (as resolved by developers) to a shared
>   cache.
>=20
> - DIM makes doing common mistakes harder by using sanity checks.
>=20
> There are about 50 people who currently have commit rights to the DRM tre=
e.
> There are no reports of commit rights having been forcibly removed as of
> yet. This strongly suggests that the model is workable.
>=20
> The use of the tool puts additional responsibilities as well as some burd=
en
> to the committers. Before the patches may be pushed, they are first
> compiled on developer's machine. That requires time, and without special
> arrangements such as having a second local workspace, and that time is aw=
ay
> from productive work.
>=20
> The discussion that followed was concentrated on the possibility of using=
 a
> similar model for the media tree. While the suggestion was initially met =
by
> mostly favourable reception, there were concerns as well.
>=20
> V4L2 *was* maintained generally according to the suggested model --- albe=
it
> without the proposed tools or process that needed to be strictly followed.
> There was once an incident which involved merging around 9000 lines of
> unreviewed code in a lot of places. What followed was not pretty, and this
> eventually lead to loss of multiple developers.
>  =20
> Could this happen again? The DRM tree has not suffered such incidents, and
> generally it understood such incident could be addressed by simply
> reverting such a patch and removing commit rights if necessary.=20

> (Editor
> note: we have reverted the media tree master state to an earlier commit
> many times for various reasons. Could it be one of the reasons the 9000
> line patch was not reverted was that the version control wasn't based on
> git??)

We actually reverted it, but it caused a huge confusion and produced
lots of discussions. We lost several active developers: people that
were not happy by the 9000 lines patchset stepping on everyone's feet
and people that were not happy by reverting it.

> Some opined that we do not have a bottleneck in reviewing patches and
> getting them merged whilst others thought this was not the case. It is
> certainly true that a very large number of patches (around 500 in the last
> kernel release) went in through the media tree.

> It still appears that there
> would be more patches and more drivers to get in if the throughput was
> higher.

I'm not so sure about that (if we expect good quality patches),
specially while we don't have any automatic testing tool to
double check some stuff.

As a result of those discussions, One of the things that we've agreed
there is to give trees at LinuxTV for more active developers that
we trust enough to skip a sub-maintainer's review.

We also agreed to try to improve the tooling at linuxtv.org, in
order to try to improve our processes (although this discussion
was actually split on other topics, like KernelCI and linuxtv infra).

>=20
>=20
> Current status of testing on the media tree - Sakari
> ----------------------------------------------------
>=20
> The common practice in media subsystem development is that developers do
> test their patches before submitting them. This is an unwritten rule:
> sometimes patches end up not being tested after making slight changes to
> them, or they have been tested on a different kernel version. The develop=
er
> may also simply forget to test the patch.
>=20
> Besides this, it is not uncommon that changing the kernel configuration or
> switching to a different architecture will cause a compilation warning or
> an error.
>=20
> The 0-day bot will catch some of these errors before the patches are
> merged, but that testing does not fully cover all the possible cases. The=
re
> are some common pain points in V4L2-related Kconfig options (plain V4L2, =
MC
> or MC + subdev uAPI); newly submitted drivers may in fact require one of
> these, but the developer may not have realised that and so this ends up n=
ot
> being taken into account in Kconfig.
>=20
> Once the review is done, and after being applied to the sub-maintainer
> tree, a patch is applied to Mauro's local tree and Mauro performs
> additional tests on it. These tests currently prevent a fair number of
> problems reaching a wider audience than the media developers.
>=20
> On the other hand, whenever an issue is found, the patch will have to be
> fixed by the sub-maintainer or the developer. This is hardly ideal, as the
> problem has existed usually for a month or two before being spotted --- by
> a program. These checks should be instead performed on the patch when it's
> submitted.
>=20
>=20
> Automated testing - Ezequiel Garcia
> -----------------------------------
>=20
> Ideal Continuous Integration process consists of the following steps:
>=20
> 	1. patch submission
> 	2. review and approval
> 	3. merge
>=20
> The core question is "what level of quality standards do we want to
> enforce". The maintenance process should be modelled around this question,
> and not the other way around. Automated testing can be a part of enforcing
> the quality standards.
>=20
> There are three steps:
>=20
> 	1. Define the quality standard
> 	2. Define how to quantify quality in respect to the standard
> 	3. Define how to enforce the standards
>=20
> On the tooling side, an uAPI test tool exists. It's called v4l2-complianc=
e,
> and new drivers are required to pass the v4l2-compliance test.
> It has quite a few favourable properties:
>=20
> - Complete in terms of the uAPI coverage
> - Quick and easy to run
> - Nice output format for humans & scripts
>=20
> There are some issues as well:
>=20
> - No codec support (stateful or stateless)
> - No SDR or touch support
> - Frequently updated (distribution shipped v4l2-compliance useless)
> - Only one contributor
>=20
> Ezequiel noted that some people think that v4l2-compliance is changing too
> often but Hans responded that this is a necessity. The API gets amended
> occasionally and the existing API gets new tests. Mauro proposed moving
> v4l2-compliance to the kernel source tree but Hans preferred keeping it
> separate. That way it's easier to develop it.
>=20
> To address the problem of only a single contributor, it was suggested that
> people implementing new APIs would need to provide the tests for
> v4l2-compliance as well. To achieve this, the v4l2-compliance codebase
> needs some cleanup to make it easier to contribute. The codebase is larger
> and there is no documentation.
>=20
> V4l2-compliance also covers MC, V4L2 and V4L2 sub-device uAPIs.
>=20
> DVB will require its own test tooling; it is not covered by
> v4l2-compliance. In order to facilitate automated testing, a virtual DVB
> driver would be useful as well. The task was added to the list of projects
> needing volunteers:
>=20
> <URL:https://linuxtv.org/wiki/index.php/Media_Open_Source_Projects:_Looki=
ng_for_Volunteers>
>=20
> There are some other test tools that could cover V4L2 but at the moment it
> seems somewhat far-fetched any of them would be used to test V4L2 in the
> near future:
>=20
> 	- kselftest
> 	- kunit
> 	- gst-validate
> 	- ktf (https://github.com/oracle/ktf, http://heim.ifi.uio.no/~knuto/ktf/)
>=20
> KernelCI is a test automation system that supports automated compile and
> boot testing. As a newly added feature, additional tests may be
> implemented. This is what Collabora has implemented, effectively the
> current demo system runs v4l2-compliance on virtual drivers in a virtual
> machines (LAVA slaves).
>=20
> A sample of the current test report is here:
>=20
> <URL:https://www.mail-archive.com/linux-media@vger.kernel.org/msg135787.h=
tml>
>=20
> The established way to run KernelCI tests is off the head of the branches=
 of
> the stable and development kernel trees, including linux-next. This is not
> useful as such to support automated testing of patches for the media tree:
> the patches need to be tested before they are merged, not after merging.
>=20
> In the discusion that followed among a slightly smaller group of people, =
it
> was suggested that tests could be run from select developer kernel trees,
> from any branch. If a developer needs long-term storage, (s)he could have
> another tree which would not be subject automated test builds.
> Alternatively, the branch name could be used as a basis for triggering
> an automated build, but this could end up being too restrictive.
>=20
> Merging the next rc1 by the maintainer would be no special case: the bran=
ch
> would be tested in similar way than the developer branches containing
> patches, and tests should need to pass before pushing the content to the
> media tree master branch.
>=20
> Ezequiel wished that people would reply to his e-mail to express their
> wishes on the testing needs (see sample report above).
>=20
>=20
> Stateless codecs - Hans Verkuil
> -------------------------------
>=20
> Support for stateless codecs will be merged for v4.20 with an Allwinner
> staging codec driver.
>=20
> The earlier stateless codec discussion ended up concluding that the
> bitstream parsing is application specific, so there will be no need for a
> generic implementation that was previously foreseen. The question that
> remains is: should there be a simple parser for compliance testing?
>=20
> All main applications support libva which was developed as the codec API =
to
> be used with Intel GPUs. A libVA frontend was written to support the
> Cedrus stateless V4L2 decoder driver. It remains to be seen whether the
> same implementation could be used as such for the other stateless codec
> drivers or whether changes, or in the worst case a parallel implementatio=
n,
> would be needed.
>=20
> Slides:
> <URL:https://www.linuxtv.org/downloads/presentations/media_summit_2018/me=
dia-codec-userspace.pdf>
>=20
>=20
> New versions of the old IOCTLs - Hans Verkuil
> ---------------------------------------------
>=20
> V4L2 is an old API with shifting focus in terms of functionality and
> hardware supported. While there has been lots of changes to the two during
> the existence of V4L2, some of the API is unchanged since the old
> times. While the API is usable for the purpose, it is needlessly clunky: =
it
> is often not obvious how an IOCTL is related to the task at hand (such as
> using S_PARM to set the frame interval) or the API does not use year
> 2038-safe timestamps (struct v4l2_buffer). These APIs deserve to be
> updated.
>=20
> * VIDIOC_*_PARM
>=20
> In the case of VIDIOC_G_PARM and VIDIOC_S_PARM, the IOCTLs are only used =
to
> set and get the frame interval.=20

> In this case, what can be done, is to add a
> new IOCTL definition, with the same IOCTL number and with binary-equivale=
nt
> IOCTL argument struct that only contains the field for the frame rate
> itself. This is binary-compatible with the existing code and no
> compatibility code will be needed. The new IOCTLs will be called
> VIDIOC_G_FRAME_INTERVAL and VIDIOC_S_FRAME_INTERVAL.
>=20
> * VIDIOC_ENUM_FRAME_INTERVALS
>=20
> Besides discrete set of supported frame intervals,
> VIDIOC_ENUM_FRAME_INTERVALS has stepwise frame interval as well. Stepwise
> could be removed as the Qualcomm venus codec and uvc (100 ns units) are t=
he
> only users. Additionally, the buffer type should be added to struct
> v4l2_frmivalenum.
>=20
> There was also a discussion related to enumerating frame intervals in uni=
ts
> of ns vs. fractional seconds. The reasoning using a fraction is that this
> way the frame interval on many standards can be conveyed precisely.
> Somebody recalled "flick", that is is the common denominator of the frame
> rates on all TV standards. Drivers could simply move to use the flick as
> the denominator, to make frame interval reporting uniform across the
> drivers.
>=20
> * struct v4l2_buffer
>=20
> struct v4l2_buffer is an age-old struct. There are a few issues in it:
>=20
> - The timestamp is not 2038-safe.
> - The multi-plane implementation is a mess.
> - Differing implementation for the end single-plane and multi-plane APIs =
is
>   confusing for both applications and drivers.
>=20
> The proposal is to create a new v4l2_buffer struct. The differences to the
> old one would be:
>=20
> - __u64 timestamps. These are 2038-safe. The timestamp source is
>   maintained, i.e. the type remains CLOCK_MONOTONIC apart from certain
>   drivers (e.g. UVC) that lets the user choose the timestamp.
> - Put the planes right to struct v4l2_buffer. The plane struct would also
>   be changed; the new plane struct would be called v4l2_ext_plane.
> - While at it, the plane description can be improved:
> 	- The start of data from the beginning of the plane memory.
> 	- Add width and height to the buffer? This would make image size
> 	  changes easier for the codec. (Ed. note: pixel format as well.
> 	  But this approach could only partially support what the request
> 	  API is for.)
> - Unify single- and multi-planar APIs.
>=20
> The new struct could be called v4l2_ext_buffer.
>=20
> As the new IOCTL argument struct will have has different syntax as well as

	s/have has/have/

> semantics, it deserves to be named differently. Compatibility code will be
> needed to convert the users of the old IOCTLs to the new struct used
> internally by the kernel and drivers, and then back to the user.
>=20
> * struct v4l2_create_buffers
>=20
> Of the format, only the pix.fmt.sizeimage field is effectively used by the
> drivers supporting VIDIOC_CREATE_BUFS. This could be simplified, by just
> providing the desired buffer size instead of the entire v4l2_format struc=
t.
> The user would be instructed to use TRY_FMT to obtain that buffer size.
>=20
> The need to delete buffers seems to have eventually surfaced. That was
> expected, but it wasn't known when this would happen. As the buffer index
> range would become non-contiguous, it should be possible to create buffers
> one by one only, as otherwise the indices of the additional buffers would
> no longer be communicated to the user unambiguously.
>=20
> So there would be new IOCTLs:
>=20
> - VIDIOC_CREATE_BUF - Create a single buffer of given size (plus other
> 		      non-format related aspects)
> - VIDIOC_DELETE_BUF - Delete a single buffer
> - VIDIOC_DELETE_ALL_BUFS - Delete all buffers
>=20
> The naming still requires some work. The opposite of create is "destroy",
> not "delete".
>=20
> * struct v4l2_pix_format vs. struct v4l2_pix_format_mplane
>=20
> Working with the two structs depending on whether the format is
> multi-planar or not is painful. While we're doing changes in the area, the
> two could be unified as well.

> (Editor note: this could be still orthogonal
> to the buffers, so it could be done separately as well. We'll see.)

I suspect that those "editor note" (as any post-meeting notes) don't=20
belong to the final report.=20

But yeah, perhaps this could be done seprarately. Let's discuss
it when actual patches gets posted.

>=20
> Slides:
> <URL:https://www.linuxtv.org/downloads/presentations/media_summit_2018/me=
dia-new-ioctls.pdf>

I guess there was an action plan for that, based on the discussions
(maybe some of them ended by being merged with the presentation on the
above?).

Hans,=20

Did you take any notes about the actions to be taken? I found
very helpful to have an action plan item below the topics where
we made such plan.


> Fault tolerant V4L2 - Kieran Bingham
> ------------------------------------
>=20
> Kieran presented a system where the media hardware complex consisted of
> eight more or less independent camera sensors that naturally end up being
> within a single media device.
>=20
> The current implementation, as well as the API, necessitates that all
> devices in a media device probe successfully before the entire media devi=
ce
> is exposed to the user. Otherwise the user would see with a partial
> view of the device, without the knowledge it is such.
>=20
> To address the problem, additional information need to be provided to the
> user space. In particular:
>=20
> - Events on the media device to tell the graph has changed.
>=20
> - Graph version number is incremented at graph change (already
>   implemented).
>=20
> - The property API could be applicable --- placeholders for entities that
>   have not yet appeared?
>=20
> 	- Alternative: known entities that have failed to probe created in
> 	  the media graph and marked "disable" or "failed".
>=20
> - Query the state of media graph completeness.
>=20
> That way, even when the devices in a media controller device appear one by
> one, the user space will be able to have all the necessary information on
> the registration state of the device.
>=20
>=20
> Complex cameras - Mauro Chehab
> ------------------------------
>=20
> Some new laptops integrate a raw Bayer camera + ISP instead of a USB
> webcam. This is expected to increase, as the solution is generally cheaper
> and results in better quality images --- as long as all the pieces of the
> puzzle are in place, including the proprietary 3A library.
>=20
> Still, such devices need to be supported.

> (Ed. note: there were two talks related to this topic given in the ELc-E.)
>=20
> <URL:https://www.youtube.com/watch?v=3DKpaNNJr92CY&index=3D31&list=3DPLbz=
oR-pLrL6qThA7SAbhVfuMbjZsJX1CY>
> <URL:https://www.youtube.com/watch?v=3DGIhV7tiUji0&index=3D60&list=3DPLbz=
oR-pLrL6qThA7SAbhVfuMbjZsJX1CY>

In this specific case, it is worth to keep the note, as those presentations
happened at ELC-Eu and were explicitly mentioned there during the
discussions.

> Development process - All
> -------------------------
>=20
> Topic-wise this is continuation of the "Tooling for sub-system tree
> maintenance", "Current status of testing on the media tree" and "Automated
> testing" topics above.
>=20
> The question here is whether there's something that could be improved in
> the media development process and if so, how could that be done.
>=20
> What came up was a suggestion to have multi-committer tree in a similar
> manner as the DRM developers do. This was seen to be more interesting for
> developers than simply being asked to review patches.
>=20
> It certainly does raise the need for more precise rules for what may be
> committed to the multi-committer tree, when etc.
>=20
> It was also requested that experienced driver maintainers would send pull
> requests on patches to their drivers instead of going through a
> sub-maintainer (pre-agreed with the relevant (sub)maintainer). This would
> take some work away from sub-maintainers, but not the maintainer.
>=20
> No firm decisions were reached in this topic. Perhaps this could be tried
> out?

We did decide to experment the "experienced driver" maintainership
model.=20

Btw, I already added an account for one such developer :-)

> There was also a request to document the sub-maintainer names in the wiki
> so that it'd be easier for people to figure out who to ping if their
> patches do not get merged.

I'm ok with that, but, after the LPC, I suspect that the best is to
document it in sync with the per-subsystem profile. I'm waiting for Don=20
to submit an updated patchset, in order to rebase our subsystem's
profile.

>=20
>=20
> linuxtv.org hosting - All
> -------------------------
>=20
> Mauro noted that linuxtv.org is currently hosted in a virtual machine
> somewhere in a German university. The administrator of the virtual machine
> has not been involved with Video4Linux for some time but has been kind to
> provide us the hosting over the years.
>=20
> It has been recognised that there is a need to find a new hosting location
> for the virtual machine. There is also a question of the domain name
> linuxtv.org. Discussion followed.
>=20
> What could be agreed on rather immediately was that the domain name should
> be owned by "us". "Us" is not a legal entity at the moment, and a practic=
al
> arrangement to achieve that could be to find a new association to own the
> domain name.
>=20
> The hosting of the virtual machine could possibly be handled by the same
> association. In practice this would likely mean a virtual machine on a
> hosting provider. Ideally this would be paid for by a company or a group =
of
> companies.
>=20
> No decisions were reached on the topic.

There was actually one decision: to talk with Linux Foundation about
that. Laurent was against, but the majority was ok with the idea.

> Tuesday's stateless codec discussion
> ------------------------------------
>=20
> Hans presented a summary of this in his stateless codec status
> presentation, here are a bit more details.
>=20
> We had a discussion (first in the Microsoft sponsor suite, then at the ba=
r)

I don't think that the room location is relevant for the report :-)

Also, we should split this on a separate report, as this was
another meeting and not all people listed above participated on it.

> on how to support user space for the stateless codecs better. The expected
> outcome of that would be a rough understanding how a stateless codec user
> space library would look like.
>=20
> The raw notes are available here:
>=20
> <URL:http://www.retiisi.org.uk/~sailus/v4l2/notes/osseu18-codecs.html>
>=20
> * Attendees
>=20
>     Alexandre Courbot
>     Chris Healy
>     Ezequiel Garcia
>     Hans Verkuil
>     Kieran Bingham
>     Laurent Pinchart
>     Maxime Ripard
>     Mauro Carvalho Chehab
>     Nicolas Dufresne
>     Niklas S=C3=B6derlund
>     Philip Zabell
>     Sakari Ailus
>     Tomasz Figa
>     Victor J=C3=A1quez
>=20
> * Buffer management
>=20
> Nicolas reported an issue in V4L2 buffer management. The V4L2 decouples t=
he
> buffers from the format, and assumes all queued buffers (at a given point
> of time) have the same format. (Ed. note: the request API could be used to
> address this, but that particular features is not yet supported.)
>=20
> * User space library
>=20
> The existing projects generally integrate their own bitstream parsers for
> codecs. There are subtle reasons why that tends to be the case, instead of
> using more generic parsers. There are differences in error handling, for
> instance, or other matters of policy, the variation which could be
> difficult to fully offer using a generic API.
>=20
> Maxime noted that VLC recently released a new parser meant to be used as a
> library, and that could be useful. Nicolas believes that we'd need a pars=
er
> library independent of any other code base to avoid pulling in extra
> libraries and this parser would need to be maintained. It could be
> difficult to find the volunteers to do that.
>=20
> Does ChromeOS have its own parser? Alexandre believes it does, but little
> was known beyond that.
>=20
> There's also the language problem: ffmpeg and gstreamer are written in C,
> the ChomeOS parser in C++, VLC is moving to Rust. What do we pick, how do
> we ensure interoperability?
>=20
> * libVA re-use
>=20
> As a short-term solution, implementing a generic wrapper using the V4L2
> stateless codec API to offer libVA API would enable generic applications =
to
> use the V4L2 stateless codec drivers as most applications already support
> libVA.
>=20
> 70 % of the applications use FFMPEG, which has a software codec API that =
is
> nearly identical to the V4L2 statless codec API. It would be trivial for
> applications to switch to V4L2 natively.
>=20
> Mauro would like us to explain our plans to Intel to avoid surprises later
> on.

To be clear: it was said at the meeting that libVA is sponsored an=20
maintained by Intel. If we're willing to use it, we should sync with
them, in order to avoid unexpected surprises if they change it in a way
that would cause problems for the V4L2 stateless coded implementation.

>=20
> * Source code hosting
>=20
> libva is hosted on freedesktop. Should we host the libva-v4l2-codec backe=
nd
> there, or host it on linuxtv.org? Hans would prefer linuxtv.org as it's
> "closer to our kernel implementation".
>=20
> * Backend support in libva
>=20
> libva loads backends in order, and picks the first one that reports it can
> support the platform. There is also an environment variable that can
> specify a backend. Ezequiel enquired how to support platforms that would
> have multiple hardware codecs. libva doesn't seem to support this at the
> moment. Nicolas reported that there's an Intel SoC that have both an Intel
> graphics core and a Vega64 graphics core that both have a codec.
>=20
> Hans said that a platform that expose multiple codecs will likely be used
> for specialized applications, and requiring those to implement codec
> support directly is acceptable. Our main focus should be to support the
> common case.
>=20
> * Vendor support
>=20
> NVidia is following our progress and is interested in using the V4L2
> stateless API. On the userspace side, vdpau is pretty much dead, they have
> moved to nvdec. OMX is being phasing out, in particular that is taking
> place for RaspberryPi now.
>=20
> * Tooling
>=20
> bootlin has developed a debugging tool called v4l2-request-test
> (https://github.com/bootlin/v4l2-request-test) that has been very useful =
to
> debug the codec driver without going through the full userspace stack. Th=
is
> is worth mentioning and integrating.
>=20
> * API discussions
>=20
> Using buffer indices as handles to reference frames
>=20
> This has been proposed by Tomasz, and Hans has serious concerns, he
> believes that having userspace predict what buffer indices will be used in
> the future is very fragile and would prefer using a separate 64-bit cookie
> associated with v4l2_buffers.
>=20
> Using capture buffer indices as reference frame handles requires predicti=
ng
> the buffer index on the capture queue which the output queue frames will =
be
> decoded into. We could use the output queue buffer index instead, but that
> wouldn't work with multi-slice decoding (multiple output buffers for a
> single capture buffer). Using a cookie set by userspace on the output sid=
e,
> then copied to the capture queue by the driver, solves that problem. All
> slices queued on the output queue for the same decoded picture will have
> the same cookie value (userspace will have to ensure that).
>=20
> Tomasz would prefer a buffer index-based solution, to avoid keeping a
> cookie-index map in userspace. Due to how V4L2 works, enqueuing a new
> dmabuf handle on the capture side for a V4L2 buffer with a given index wi=
ll
> effectively delete the corresponding cookie, so userspace would need to
> ensure it doesn't overwrite buffers; (Tomasz: To clarify, I don't see the
> significant benefit of using cookies over indices. It makes it easier for
> user space, because it doesn't have to predict the CAPTURE buffers, but
> still is error prone because of the buffer requeuing problem. For now it
> would be good to see how it translates into real code, though. In the
> meantime I can try to find a better idea.)
>=20

Once we have a final version for both Tuesday meeting and the
Linux Media Summit, I'll post it at the "news" section of linuxtv,
add the group photo and the links for the presentation and for
our nightly dinner.

Thanks,
Mauro
