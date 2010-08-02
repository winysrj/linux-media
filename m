Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:46216 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338Ab0HBIUN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Aug 2010 04:20:13 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8
Received: from eu_spt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0L6I00674N5MM940@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 02 Aug 2010 09:20:10 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L6I006L1N5MSG@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 02 Aug 2010 09:20:10 +0100 (BST)
Date: Mon, 02 Aug 2010 10:18:32 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: RE: [PATCH v5 0/3] Multi-planar video format and buffer support for
 the V4L2 API
In-reply-to: <A69FA2915331DC488A831521EAE36FE4016B9622E1@dlee06.ent.ti.com>
To: "'Karicheri, Muralidharan'" <m-karicheri2@ti.com>,
	linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Tomasz Fujak <t.fujak@samsung.com>
Message-id: <002701cb321b$4b96c930$e2c45b90$%osciak@samsung.com>
Content-language: pl
References: <1280479783-23945-1-git-send-email-p.osciak@samsung.com>
 <A69FA2915331DC488A831521EAE36FE4016B9622E1@dlee06.ent.ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
thanks for the review.

>Karicheri, Muralidharan <m-karicheri2@ti.com> wrote:
>
>>
>>
>>7. Format conversion
>>----------------------------------
>>v4l2 core ioctl handling includes a simple conversion layer that allows
>>translation - when possible - between multi-planar and single-planar APIs,
>>transparently to drivers and applications.
>>
>>The table below summarizes conversion behavior for cases when driver and
>>application use different API versions:
>>
>>---------------------------------------------------------------
>>              | Application MP --> Driver SP --> Application MP
>>   G_FMT      |            always OK   |   always OK
>>   S_FMT      |            -EINVAL     |   always OK
>> TRY_FMT      |            -EINVAL     |   always OK
>>---------------------------------------------------------------
>>              | Application SP --> Driver MP --> Application SP
>>   G_FMT      |            always OK   |   -EBUSY
>>   S_FMT      |            always OK   |   -EBUSY and WARN()
>> TRY_FMT      |            always OK   |   -EBUSY and WARN()
>>
>
>What is the logic behind using -EBUSY for this? Why not -EINVAL? Also why use
>WARN()?
>

We think that it's better to return EBUSY from a G_FMT call to say:
"Your call is valid, but I cannot tell you the format now, but may be able to
later" (i.e. after I switch back to a single-planar format). EINVAL just says
"Your call is invalid", i.e. no point in retrying. Also, EINVAL doesn't really
make sense for G_FMT.

WARN because, as explained below, we think of it as a bug in driver to adjust
a 1-plane format to a >1-plane format on S/TRY.

>>Legend:
>>- SP - single-planar API used (NOT format!)
>>- MP - multi-planar API used (NOT format!)
>>- always OK - conversion is always valid irrespective of number of planes
>>- -EINVAL - if an MP application tries to TRY or SET a format with more
>>            than 1 plane, EINVAL is returned from the conversion function
>>            (of course, 1-plane multi-planar formats work and are
>>converted)
>>- -EBUSY - if an MP driver returns a more than 1-plane format to an SP
>>           application, the conversion layer returns EBUSY to the
>>application;
>>           this is useful in cases when the driver is currently set to a
>>more
>>           than 1-plane format, SP application would not be able to
>>understand
>>           it)
>>- -EBUSY and WARN() - there is only one reason for which SET or TRY from an
>>SP
>>           application would result in a driver returning a more than 1-
>>plane
>>           format - when the driver adjusts a 1-plane format to a more than
>>           1-plane format. This should not happen and is a bug in driver,
>>hence
>>           a WARN_ON(). Application receives EBUSY.
>>
>>
>
>Suppose, S_FMT/TRY_FMT is called with UYVY format and driver supports only
>NV12 (2 plane) only, then for
>
>Application SP --> Driver MP --> Application SP
>
>I guess in this case, new drivers that supports multi-plane format would have
>to return old NV12 format code (for backward compatibility). Is
>this handled by driver or translation layer?
>

Not really. If a driver supports a 2-plane format only, an SP application
won't be able to use it (unless we copy video data from two separate memory
buffers into one and back on each QBUF/DQBUF in core ioctl handling, I don't
think we want to go that far). The app expects one buffer, not two. So this is
an EINVAL.

>Application MP --> Driver SP --> Application MP
>
>In this case, new driver would return new NV12 format code and have no issue.
>Not sure what translation layer does in this scenario.
>

Again, not really. If an MP application requests a 2-plane format, the driver
cannot support it (it can support 1-plane formats only). So this is also
an EINVAL.

Overall, we do not convert v4l2_buffers, we only convert format structs (not
the actual formats).

><snip>
>
>>
>>===============================================
>>V. Using ioctl()s and mmap()
>>===============================================
>>
>>* Format calls (VIDIOC_S/TRY/G_FMT) are converted transparently across APIs
>>  by the ioctl handling code, where possible. Conversion from single-planar
>>  to multi-planar cannot fail, but the other way around is possible only
>>for
>>  1-plane formats.
>>  Possible errors in conversion are described below.
>>
>
>Could you explain what you mean by conversion of formats? The idea of the
>translation layer functionality is not clear to me. An example would help.
>


I guess this needs to be rephrased:

It doesn't convert the actual formats, it only converts between APIs, i.e.
between different format structs. So it's a conversion between struct
v4l2_pix_format_mplane and struct v4l2_pix_format. It's not a conversion
of formats, the format stays completely identical.

So basically an NV12 format can be passed as well in a v4l2_pix_format
struct as in v4l2_pix_format_mplane. Fourccs and other fields will be
exactly the same. Only the location of those fields will differ,
a v4l2_pix_format_mplane struct will have an array of v4l2_plane_pix_format
of size one. Look at the fmt_sp_to_mp and fmt_mp_to_sp functions in
v4l2-ioctl.c and it should become more clear to you. It just moves some
fields between structs and back.

The reason behind this "conversion" layer is to ease driver development.
Drivers won't have to implement both vidioc_*_fmt_* and
vidioc_*_fmt_*_mplane versions of calls, only mplane ones.


Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center



