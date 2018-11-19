Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f196.google.com ([209.85.219.196]:38463 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727281AbeKSObz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Nov 2018 09:31:55 -0500
Received: by mail-yb1-f196.google.com with SMTP id u103-v6so12060463ybi.5
        for <linux-media@vger.kernel.org>; Sun, 18 Nov 2018 20:09:34 -0800 (PST)
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com. [209.85.219.169])
        by smtp.gmail.com with ESMTPSA id n142-v6sm961793ywd.75.2018.11.18.20.09.32
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 18 Nov 2018 20:09:32 -0800 (PST)
Received: by mail-yb1-f169.google.com with SMTP id h187-v6so12045788ybg.10
        for <linux-media@vger.kernel.org>; Sun, 18 Nov 2018 20:09:32 -0800 (PST)
MIME-Version: 1.0
References: <20181117224502.63hz6sh5qd6heolu@valkosipuli.retiisi.org.uk>
In-Reply-To: <20181117224502.63hz6sh5qd6heolu@valkosipuli.retiisi.org.uk>
From: Tomasz Figa <tfiga@chromium.org>
Date: Mon, 19 Nov 2018 13:09:20 +0900
Message-ID: <CAAFQd5AwQCB48kE9r7=sG5LEb2ib7ggobAs_9fUurOyPdv-6fw@mail.gmail.com>
Subject: Re: [ANN] Edinburgh Media Summit 2018 meeting report
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, media-workshop@linuxtv.org,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Nov 18, 2018 at 7:45 AM Sakari Ailus <sakari.ailus@iki.fi> wrote:
>
> Hello everyone,
>
>
> Here's the report on the Media Summit held on 25th October in Edinburgh.
> The report is followed by the stateless codec discussion two days earlier.
>
> Note: this is bcc'd to the meeting attendees plus a few others. I didn't
> use cc as the list servers tend to reject messages with too many
> recipients in cc / to headers.
>
> Most presenters used slides some of which are already available here
> (expect more in the near future):
>
> <URL:https://www.linuxtv.org/downloads/presentations/media_summit_2018/>
>
> The original announcement for the meeting is here:
>
> <URL:https://www.spinics.net/lists/linux-media/msg141095.html>
>
> The raw notes can be found here:
>
> <URL:http://www.retiisi.org.uk/~sailus/v4l2/notes/osseu18-media.html>

Thanks Sakari for editing the notes. Let me share my thoughts inline.

[snip]
> Automated testing - Ezequiel Garcia
> -----------------------------------
>
> Ideal Continuous Integration process consists of the following steps:
>
>         1. patch submission
>         2. review and approval
>         3. merge
>
> The core question is "what level of quality standards do we want to
> enforce". The maintenance process should be modelled around this question,
> and not the other way around. Automated testing can be a part of enforcing
> the quality standards.
>
> There are three steps:
>
>         1. Define the quality standard
>         2. Define how to quantify quality in respect to the standard
>         3. Define how to enforce the standards
>
> On the tooling side, an uAPI test tool exists. It's called v4l2-compliance,
> and new drivers are required to pass the v4l2-compliance test.
> It has quite a few favourable properties:
>
> - Complete in terms of the uAPI coverage
> - Quick and easy to run
> - Nice output format for humans & scripts
>
> There are some issues as well:
>
> - No codec support (stateful or stateless)
> - No SDR or touch support
> - Frequently updated (distribution shipped v4l2-compliance useless)
> - Only one contributor
>
> Ezequiel noted that some people think that v4l2-compliance is changing too
> often but Hans responded that this is a necessity. The API gets amended
> occasionally and the existing API gets new tests. Mauro proposed moving
> v4l2-compliance to the kernel source tree but Hans preferred keeping it
> separate. That way it's easier to develop it.
>
> To address the problem of only a single contributor, it was suggested that
> people implementing new APIs would need to provide the tests for
> v4l2-compliance as well. To achieve this, the v4l2-compliance codebase
> needs some cleanup to make it easier to contribute. The codebase is larger
> and there is no documentation.
>
> V4l2-compliance also covers MC, V4L2 and V4L2 sub-device uAPIs.
>
> DVB will require its own test tooling; it is not covered by
> v4l2-compliance. In order to facilitate automated testing, a virtual DVB
> driver would be useful as well. The task was added to the list of projects
> needing volunteers:
>
> <URL:https://linuxtv.org/wiki/index.php/Media_Open_Source_Projects:_Looking_for_Volunteers>
>
> There are some other test tools that could cover V4L2 but at the moment it
> seems somewhat far-fetched any of them would be used to test V4L2 in the
> near future:
>
>         - kselftest
>         - kunit
>         - gst-validate
>         - ktf (https://github.com/oracle/ktf, http://heim.ifi.uio.no/~knuto/ktf/)
>
> KernelCI is a test automation system that supports automated compile and
> boot testing. As a newly added feature, additional tests may be
> implemented. This is what Collabora has implemented, effectively the
> current demo system runs v4l2-compliance on virtual drivers in a virtual
> machines (LAVA slaves).
>
> A sample of the current test report is here:
>
> <URL:https://www.mail-archive.com/linux-media@vger.kernel.org/msg135787.html>
>
> The established way to run KernelCI tests is off the head of the branches of
> the stable and development kernel trees, including linux-next. This is not
> useful as such to support automated testing of patches for the media tree:
> the patches need to be tested before they are merged, not after merging.
>
> In the discusion that followed among a slightly smaller group of people, it
> was suggested that tests could be run from select developer kernel trees,
> from any branch. If a developer needs long-term storage, (s)he could have
> another tree which would not be subject automated test builds.
> Alternatively, the branch name could be used as a basis for triggering
> an automated build, but this could end up being too restrictive.
>
> Merging the next rc1 by the maintainer would be no special case: the branch
> would be tested in similar way than the developer branches containing
> patches, and tests should need to pass before pushing the content to the
> media tree master branch.
>
> Ezequiel wished that people would reply to his e-mail to express their
> wishes on the testing needs (see sample report above).
>

I'd really love having codec tests there, but we're still working to
finalize the API, so not much to say about testing. :( The ideal mode
would test all the sequences defined by the API, including erroneous
operations from the userspace to verify error handling.

>
> Stateless codecs - Hans Verkuil
> -------------------------------
>
> Support for stateless codecs will be merged for v4.20 with an Allwinner
> staging codec driver.
>
> The earlier stateless codec discussion ended up concluding that the
> bitstream parsing is application specific, so there will be no need for a
> generic implementation that was previously foreseen. The question that
> remains is: should there be a simple parser for compliance testing?
>
> All main applications support libva which was developed as the codec API to
> be used with Intel GPUs. A libVA frontend was written to support the
> Cedrus stateless V4L2 decoder driver. It remains to be seen whether the
> same implementation could be used as such for the other stateless codec
> drivers or whether changes, or in the worst case a parallel implementation,
> would be needed.

I believe it should work for Rockchip VPU as well.

>
> Slides:
> <URL:https://www.linuxtv.org/downloads/presentations/media_summit_2018/media-codec-userspace.pdf>
>
>
> New versions of the old IOCTLs - Hans Verkuil
> ---------------------------------------------
>
> V4L2 is an old API with shifting focus in terms of functionality and
> hardware supported. While there has been lots of changes to the two during
> the existence of V4L2, some of the API is unchanged since the old
> times. While the API is usable for the purpose, it is needlessly clunky: it
> is often not obvious how an IOCTL is related to the task at hand (such as
> using S_PARM to set the frame interval) or the API does not use year
> 2038-safe timestamps (struct v4l2_buffer). These APIs deserve to be
> updated.
>
[snip]
> * struct v4l2_buffer
>
> struct v4l2_buffer is an age-old struct. There are a few issues in it:
>
> - The timestamp is not 2038-safe.
> - The multi-plane implementation is a mess.
> - Differing implementation for the end single-plane and multi-plane APIs is
>   confusing for both applications and drivers.
>
> The proposal is to create a new v4l2_buffer struct. The differences to the
> old one would be:
>
> - __u64 timestamps. These are 2038-safe. The timestamp source is
>   maintained, i.e. the type remains CLOCK_MONOTONIC apart from certain
>   drivers (e.g. UVC) that lets the user choose the timestamp.
> - Put the planes right to struct v4l2_buffer. The plane struct would also
>   be changed; the new plane struct would be called v4l2_ext_plane.
> - While at it, the plane description can be improved:
>         - The start of data from the beginning of the plane memory.

This is a must, since otherwise there is no way to have one DMA-buf
contain multiple planes at offsets, which actually is a common case in
the graphics world.

>         - Add width and height to the buffer? This would make image size
>           changes easier for the codec. (Ed. note: pixel format as well.
>           But this approach could only partially support what the request
>           API is for.)
> - Unify single- and multi-planar APIs.
>
> The new struct could be called v4l2_ext_buffer.
>
> As the new IOCTL argument struct will have has different syntax as well as
> semantics, it deserves to be named differently. Compatibility code will be
> needed to convert the users of the old IOCTLs to the new struct used
> internally by the kernel and drivers, and then back to the user.
>
> * struct v4l2_create_buffers
>
> Of the format, only the pix.fmt.sizeimage field is effectively used by the
> drivers supporting VIDIOC_CREATE_BUFS. This could be simplified, by just
> providing the desired buffer size instead of the entire v4l2_format struct.
> The user would be instructed to use TRY_FMT to obtain that buffer size.
>

There is a problem with using TRY_FMT for stateful codecs, because
once the CAPTURE format is established from the stream metadata, any
format operations would only accept formats that are compatible with
current stream. Currently TRY_FMT is defined to behave exactly as
S_FMT, except that it doesn't update the active format.

Perhaps it would actually make sense to keep the full v4l2_format
struct in VIDIOC_CREATE_BUFS and actually make the implementation
compute the size based on the other fields (if sizeimage is left 0 for
example or smaller than needed for the format)?

> The need to delete buffers seems to have eventually surfaced. That was
> expected, but it wasn't known when this would happen. As the buffer index
> range would become non-contiguous, it should be possible to create buffers
> one by one only, as otherwise the indices of the additional buffers would
> no longer be communicated to the user unambiguously.
>

allocated = 0;
while (allocated < to_allocate) {
        // ...
        create_bufs.count = to_allocate - allocated;
        ret = ioctl(fd, VIDIOC_CREATE_BUFS, &create_bufs);
        allocated += create_bufs.count;
        // ... add [create_bufs.index, create_bufs.index +
create_bufs.count - 1] to the list of buffer indices
}

> So there would be new IOCTLs:
>
> - VIDIOC_CREATE_BUF - Create a single buffer of given size (plus other
>                       non-format related aspects)

What would this ioctl give us over VIDIOC_CREATE_BUF with count=1?

> - VIDIOC_DELETE_BUF - Delete a single buffer
> - VIDIOC_DELETE_ALL_BUFS - Delete all buffers
>
> The naming still requires some work. The opposite of create is "destroy",
> not "delete".
>
> * struct v4l2_pix_format vs. struct v4l2_pix_format_mplane
>
> Working with the two structs depending on whether the format is
> multi-planar or not is painful. While we're doing changes in the area, the
> two could be unified as well. (Editor note: this could be still orthogonal
> to the buffers, so it could be done separately as well. We'll see.)
>

This is a huge pain on both userspace and driver sides.

On a related note, the split into M and non-M formats also poses a
userspace compatibility problem, as many drivers that expose M formats
fail to expose support for corresponding non-M formats, only because
the implementation becomes messy if you have to deal with both.

[snip]

> Slides:
> <URL:https://www.linuxtv.org/downloads/presentations/media_summit_2018/media-new-ioctls.pdf>
>
[snip]
>
> linuxtv.org hosting - All
> -------------------------
>
> Mauro noted that linuxtv.org is currently hosted in a virtual machine
> somewhere in a German university. The administrator of the virtual machine
> has not been involved with Video4Linux for some time but has been kind to
> provide us the hosting over the years.
>
> It has been recognised that there is a need to find a new hosting location
> for the virtual machine. There is also a question of the domain name
> linuxtv.org. Discussion followed.
>
> What could be agreed on rather immediately was that the domain name should
> be owned by "us". "Us" is not a legal entity at the moment, and a practical
> arrangement to achieve that could be to find a new association to own the
> domain name.
>
> The hosting of the virtual machine could possibly be handled by the same
> association. In practice this would likely mean a virtual machine on a
> hosting provider. Ideally this would be paid for by a company or a group of
> companies.
>
> No decisions were reached on the topic.

Any chance that we could have the toolkit on linuxtv.org improved? Examples:
 - The new patchwork (as on lore.kernel.org or
patchwork.freedesktop.org) has a lot of useful features that our
linuxtv one misses (for example tracking of patches within a series or
tracking versions of patches),
 - The color scheme of diff views in the web git is not very readable
(the dark blue items in particular):
   https://git.linuxtv.org/media_tree.git/diff/?id2=d148b85e8b0779b910f3120a1b72e3e105ad2c47
   Making it consistent with the patchwork scheme would solve the problem.

Best regards,
Tomasz
