Return-path: <mchehab@gaivota>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:4141 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab1AFHhK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Jan 2011 02:37:10 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Pawel Osciak <pawel@osciak.com>
Subject: Re: [PATCH] [media] Add multi-planar API documentation
Date: Thu, 6 Jan 2011 08:36:56 +0100
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com
References: <1294114845-5862-1-git-send-email-pawel@osciak.com> <201101040853.09377.hverkuil@xs4all.nl> <AANLkTimUUqhK4yKZkD-J4hAo-V_jcH9pMkPa71USLBkL@mail.gmail.com>
In-Reply-To: <AANLkTimUUqhK4yKZkD-J4hAo-V_jcH9pMkPa71USLBkL@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101060836.56267.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Thursday, January 06, 2011 06:53:37 Pawel Osciak wrote:
> Hi Hans,
> Huge thanks for the review!
> 
> On Mon, Jan 3, 2011 at 23:53, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > On Tuesday, January 04, 2011 05:20:45 Pawel Osciak wrote:
> >> Add DocBook documentation for the new multi-planar API extensions to the
> >> Video for Linux 2 API DocBook.
> >>
> >> Signed-off-by: Pawel Osciak <pawel@osciak.com>
> >> ---
> >>  Documentation/DocBook/media-entities.tmpl     |    4 +
> >>  Documentation/DocBook/v4l/common.xml          |    2 +
> >>  Documentation/DocBook/v4l/compat.xml          |   11 +
> >>  Documentation/DocBook/v4l/dev-capture.xml     |   13 +-
> >>  Documentation/DocBook/v4l/dev-output.xml      |   13 +-
> >>  Documentation/DocBook/v4l/func-mmap.xml       |   10 +-
> >>  Documentation/DocBook/v4l/func-munmap.xml     |    3 +-
> >>  Documentation/DocBook/v4l/io.xml              |  242 +++++++++++++++++++++----
> >>  Documentation/DocBook/v4l/pixfmt.xml          |  114 +++++++++++-
> >>  Documentation/DocBook/v4l/planar-apis.xml     |   79 ++++++++
> >>  Documentation/DocBook/v4l/v4l2.xml            |   21 ++-
> >>  Documentation/DocBook/v4l/vidioc-enum-fmt.xml |    2 +
> >>  Documentation/DocBook/v4l/vidioc-g-fmt.xml    |   15 ++-
> >>  Documentation/DocBook/v4l/vidioc-qbuf.xml     |   24 ++-
> >>  Documentation/DocBook/v4l/vidioc-querybuf.xml |   14 +-
> >>  Documentation/DocBook/v4l/vidioc-querycap.xml |   14 ++
> >>  16 files changed, 515 insertions(+), 66 deletions(-)
> >>  create mode 100644 Documentation/DocBook/v4l/planar-apis.xml
> >>
> >> diff --git a/Documentation/DocBook/media-entities.tmpl b/Documentation/DocBook/media-entities.tmpl
> >> index be34dcb..74923d7 100644
> >> --- a/Documentation/DocBook/media-entities.tmpl
> >> +++ b/Documentation/DocBook/media-entities.tmpl
> 
> <snip>
> 
> 
> >> +memset (&amp;reqbuf, 0, sizeof (reqbuf));
> >
> > No space before (
> >
> 
> I used the previous example and modified it, I didn't want to change
> code style. But I guess it's maybe the original one that should be
> corrected as well...
> 
> >> +reqbuf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> >> +reqbuf.memory = V4L2_MEMORY_MMAP;
> >> +reqbuf.count = 20;
> >> +
> >> +if (-1 == ioctl (fd, &VIDIOC-REQBUFS;, &amp;reqbuf)) {
> >
> > Ditto. Same below.
> >
> > It's also better to do 'if (ioctl() < 0) {'
> >
> 
> Ditto ;) Maybe I should do a separate patch for the original example later.

Probably a good idea. This example code is really old, written before the
cding style was strictly enforced. Cleaning it up is a good idea.

<snip>
> >> +           to memory allocated for this plane by an application.</entry>
> >> +       </row>
> >> +       <row>
> >> +         <entry>__u32</entry>
> >> +         <entry><structfield>data_offset</structfield></entry>
> >> +         <entry></entry>
> >> +         <entry>Offset in bytes to video data in the plane, if applicable.
> >> +         </entry>
> >> +       </row>
> >> +       <row>
> >> +         <entry>__u32</entry>
> >> +         <entry><structfield>reserved[11]</structfield></entry>
> >> +         <entry></entry>
> >> +         <entry>Reserved for future use. Should be zero.</entry>
> >
> > Who zeroes this? Driver and/or application?
> >
> 
> Well, it's ignored, as most reserved fields are. Should I say the
> application should zero it? Or maybe even say nothing at all?

Typically write ioctls (_IOW/_IOWR) require the app to zero reserved fields,
while read ioctls (_IOR/_IOWR) require the driver to zero reserved fields.

This is usually mentioned in the spec, particularly if the app has to zero
the fields. If you don't mention that apps should zero, then they typically
don't :-)

<snip>

> >> +  <section>
> >> +    <title>Calls that distinguish between single and multi-planar APIs</title>
> >> +    <variablelist>
> >> +      <varlistentry>
> >> +        <term>&VIDIOC-QUERYCAP;</term>
> >> +        <listitem>Two additional multi-planar capabilities are added. They can
> >> +        be set together with non-multi-planar ones for devices that support both
> >> +        APIs.</listitem>
> >
> > What happens if a driver supports only single-planar API, but the core adds
> > transparent support for multi-planar API? Are the MPLANE caps set or not?
> > I can't remember what we decided to do. Ditto for the other way around (driver
> > does only multi-planar, but core adds single-planar support).
> >
> 
> Hm, that's a good point. Right now are not hijacking the caps ioctl...
> This is tricky though, I don't see any good solutions. Adding
> additional caps artificially would practically result in
> V4L2_CAP_VIDEO_CAPTURE_MPLANE == V4L2_CAP_VIDEO_CAPTURE. But what
> makes MPLANE or not-MPLANE "supported" are the actual formats later
> on, not the API.
> 
> If we were to add artificial caps, then adding non-mplane caps to
> mplane drivers might actually be the problematic case: if a
> multi-planar driver didn't support any single-planar formats (and
> there would be no practical way of knowing that from our standpoint),
> a single-planar application would ENUM_FMT and get 0 formats, which
> wouldn't be good.
> Adding mplane caps to non-mplane drivers might actually be somehow
> safer, as long as the application behaves and uses only single-planar
> formats (as ENUM_FMT would return), it'll always work.
> 
> So ironically, all (what about the non-video_ioctl2 case?) splanar
> drivers would be supporting mplane API, but not all mplane drivers
> would be supporting splane API, because of the enumeration problem. I
> hope I got it right, it's kind of late for me now...
> 
> What do you think?

Perhaps we should make a slight change to the meaning of CAP_VIDEO_CAPTURE
and CAP_VIDEO_CAPTURE_MPLANE: instead of saying that the first means that
the single-planar API is supported and that the second means that the
multi-planar API is supported it should say that the first means that there
are single-plane formats and that the second means that there are multi-plane
formats.

Which API you are to use is up to the application although if only single
plane formats are available, then the app should use the single-plane API
since there is no guarantee that the multi-plane API is available (for drivers
bypassing video_ioctl2).

Eventually all drivers should use video_ioctl2, but that's not going to happen
any time soon, unless we get some janitorial help from people.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
