Return-path: <mchehab@gaivota>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59282 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab1AFFx7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Jan 2011 00:53:59 -0500
Received: by wyb28 with SMTP id 28so16095759wyb.19
        for <linux-media@vger.kernel.org>; Wed, 05 Jan 2011 21:53:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201101040853.09377.hverkuil@xs4all.nl>
References: <1294114845-5862-1-git-send-email-pawel@osciak.com> <201101040853.09377.hverkuil@xs4all.nl>
From: Pawel Osciak <pawel@osciak.com>
Date: Wed, 5 Jan 2011 21:53:37 -0800
Message-ID: <AANLkTimUUqhK4yKZkD-J4hAo-V_jcH9pMkPa71USLBkL@mail.gmail.com>
Subject: Re: [PATCH] [media] Add multi-planar API documentation
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Hans,
Huge thanks for the review!

On Mon, Jan 3, 2011 at 23:53, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Tuesday, January 04, 2011 05:20:45 Pawel Osciak wrote:
>> Add DocBook documentation for the new multi-planar API extensions to the
>> Video for Linux 2 API DocBook.
>>
>> Signed-off-by: Pawel Osciak <pawel@osciak.com>
>> ---
>>  Documentation/DocBook/media-entities.tmpl     |    4 +
>>  Documentation/DocBook/v4l/common.xml          |    2 +
>>  Documentation/DocBook/v4l/compat.xml          |   11 +
>>  Documentation/DocBook/v4l/dev-capture.xml     |   13 +-
>>  Documentation/DocBook/v4l/dev-output.xml      |   13 +-
>>  Documentation/DocBook/v4l/func-mmap.xml       |   10 +-
>>  Documentation/DocBook/v4l/func-munmap.xml     |    3 +-
>>  Documentation/DocBook/v4l/io.xml              |  242 +++++++++++++++++++++----
>>  Documentation/DocBook/v4l/pixfmt.xml          |  114 +++++++++++-
>>  Documentation/DocBook/v4l/planar-apis.xml     |   79 ++++++++
>>  Documentation/DocBook/v4l/v4l2.xml            |   21 ++-
>>  Documentation/DocBook/v4l/vidioc-enum-fmt.xml |    2 +
>>  Documentation/DocBook/v4l/vidioc-g-fmt.xml    |   15 ++-
>>  Documentation/DocBook/v4l/vidioc-qbuf.xml     |   24 ++-
>>  Documentation/DocBook/v4l/vidioc-querybuf.xml |   14 +-
>>  Documentation/DocBook/v4l/vidioc-querycap.xml |   14 ++
>>  16 files changed, 515 insertions(+), 66 deletions(-)
>>  create mode 100644 Documentation/DocBook/v4l/planar-apis.xml
>>
>> diff --git a/Documentation/DocBook/media-entities.tmpl b/Documentation/DocBook/media-entities.tmpl
>> index be34dcb..74923d7 100644
>> --- a/Documentation/DocBook/media-entities.tmpl
>> +++ b/Documentation/DocBook/media-entities.tmpl

<snip>


>> +memset (&amp;reqbuf, 0, sizeof (reqbuf));
>
> No space before (
>

I used the previous example and modified it, I didn't want to change
code style. But I guess it's maybe the original one that should be
corrected as well...

>> +reqbuf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
>> +reqbuf.memory = V4L2_MEMORY_MMAP;
>> +reqbuf.count = 20;
>> +
>> +if (-1 == ioctl (fd, &VIDIOC-REQBUFS;, &amp;reqbuf)) {
>
> Ditto. Same below.
>
> It's also better to do 'if (ioctl() < 0) {'
>

Ditto ;) Maybe I should do a separate patch for the original example later.

<snip>

>> @@ -596,6 +702,64 @@ should set this to 0.</entry>
>>        </tgroup>
>>      </table>
>>
>> +    <table frame="none" pgwide="1" id="v4l2-plane">
>> +      <title>struct <structname>v4l2_plane</structname></title>
>> +      <tgroup cols="4">
>> +        &cs-ustr;
>> +     <tbody valign="top">
>> +       <row>
>> +         <entry>__u32</entry>
>> +         <entry><structfield>bytesused</structfield></entry>
>> +         <entry></entry>
>> +         <entry>The number of bytes occupied by data in the plane
>> +         (its payload).</entry>
>> +       </row>
>> +       <row>
>> +         <entry>__u32</entry>
>> +         <entry><structfield>length</structfield></entry>
>> +         <entry></entry>
>> +         <entry>Size in bytes of the plane (not its payload).</entry>
>> +       </row>
>> +       <row>
>> +         <entry>union</entry>
>> +         <entry><structfield>m</structfield></entry>
>> +         <entry></entry>
>> +         <entry></entry>
>> +       </row>
>> +       <row>
>> +         <entry></entry>
>> +         <entry>__u32</entry>
>> +         <entry><structfield>mem_offset</structfield></entry>
>> +         <entry>When memory type in the containing &v4l2-buffer; is
>
> When the
>
>> +           <constant>V4L2_MEMORY_MMAP</constant>, this is the value that
>> +           should be passed to &func-mmap;, analogically to the
>
> analogically -> similar
>
>> +           <structfield>offset</structfield> field in &v4l2-buffer;.</entry>
>> +       </row>
>> +       <row>
>> +         <entry></entry>
>> +         <entry>__unsigned long</entry>
>> +         <entry><structfield>userptr</structfield></entry>
>> +         <entry>When memory type in the containing &v4l2-buffer; is
>
> When the
>
>> +           <constant>V4L2_MEMORY_USERPTR</constant>, a userspace pointer
>
> a userspace -> this is a userspace
>
>> +           to memory allocated for this plane by an application.</entry>
>> +       </row>
>> +       <row>
>> +         <entry>__u32</entry>
>> +         <entry><structfield>data_offset</structfield></entry>
>> +         <entry></entry>
>> +         <entry>Offset in bytes to video data in the plane, if applicable.
>> +         </entry>
>> +       </row>
>> +       <row>
>> +         <entry>__u32</entry>
>> +         <entry><structfield>reserved[11]</structfield></entry>
>> +         <entry></entry>
>> +         <entry>Reserved for future use. Should be zero.</entry>
>
> Who zeroes this? Driver and/or application?
>

Well, it's ignored, as most reserved fields are. Should I say the
application should zero it? Or maybe even say nothing at all?

<snip>

>> diff --git a/Documentation/DocBook/v4l/planar-apis.xml b/Documentation/DocBook/v4l/planar-apis.xml
>> new file mode 100644
>> index 0000000..ce89831
>> --- /dev/null
>> +++ b/Documentation/DocBook/v4l/planar-apis.xml
>> @@ -0,0 +1,79 @@
>> +<section id="planar-apis">
>> +  <title>Single- and multi-planar APIs</title>
>> +
>> +  <para>Some devices require data for each input or output video frame
>> +  to be placed in discontiguous memory buffers. In such cases one
>> +  video frame has to be addressed using more than one memory address, i.e. one
>> +  pointer per "plane". A plane is a sub-buffer of current frame. For examples
>> +  of such formats see <xref linkend="pixfmt" />.</para>
>> +
>> +  <para>Initially, V4L2 API did not support multi-planar buffers and a set of
>> +  extensions has been introduced to handle them. Those extensions constitute
>> +  what is being referred to as the "multi-planar API".</para>
>> +
>> +  <para>Some of the V4L2 API calls and structures are interpreted differently,
>> +  depending on whether single- or multi-planar API is being used. An application
>> +  can choose whether to use one or the other by passing a corresponding buffer
>> +  type to its ioctl calls. Multi-planar versions of buffer types are suffixed with
>> +  an `_MPLANE' string. For a list of available multi-planar buffer types
>> +  see &v4l2-buf-type;.
>> +  </para>
>> +
>> +  <section>
>> +    <title>Multi-planar formats</title>
>> +    <para>Multi-planar API introduces new multi-planar formats. Those formats
>> +    use a separate set of FourCC codes. It is important to distinguish between
>> +    the multi-planar API and a multi-planar format. Multi-planar API calls can
>> +    handle all single-planar formats as well, while single-planar API cannot
>
> while -> while the
>
>> +    handle multi-planar formats. Applications do not have to switch between APIs
>> +    when handling both single- and multi-planar devices and should use the
>> +    multi-planar API version for both single- and multi-planar formats.
>> +    Drivers that do not support multi-planar API can still be handled with it,
>> +    utilizing a compatibility layer built into standard V4L2 ioctl handling.
>> +    </para>
>> +  </section>
>> +
>> +  <section>
>> +    <title>Single and multi-planar API compatibility layer</title>
>> +    <para>In most cases, applications can use the multi-planar API with older
>
> 'In most cases': I know why, but we really need to work on converting those
> drivers that still do not use video_ioctl2 :-(
>
> Perhaps a footnote explaining this might be useful here.
>
>> +    drivers that support only its single-planar version and vice versa.
>> +    Appropriate conversion is done seamlessly for both applications and drivers
>> +    in the V4L2 core. The general rule of thumb is: as long as an application
>> +    uses formats that a driver supports, it can use either API (although use
>> +    of multi-planar formats is only possible with the multi-planar API). The
>> +    list of formats supported by a driver can be obtained using the
>> +    &VIDIOC-ENUM-FMT; call. It is possible, but discouraged, for a driver or
>> +    an application to support and use both versions of the API.</para>
>> +  </section>
>> +
>> +  <section>
>> +    <title>Calls that distinguish between single and multi-planar APIs</title>
>> +    <variablelist>
>> +      <varlistentry>
>> +        <term>&VIDIOC-QUERYCAP;</term>
>> +        <listitem>Two additional multi-planar capabilities are added. They can
>> +        be set together with non-multi-planar ones for devices that support both
>> +        APIs.</listitem>
>
> What happens if a driver supports only single-planar API, but the core adds
> transparent support for multi-planar API? Are the MPLANE caps set or not?
> I can't remember what we decided to do. Ditto for the other way around (driver
> does only multi-planar, but core adds single-planar support).
>

Hm, that's a good point. Right now are not hijacking the caps ioctl...
This is tricky though, I don't see any good solutions. Adding
additional caps artificially would practically result in
V4L2_CAP_VIDEO_CAPTURE_MPLANE == V4L2_CAP_VIDEO_CAPTURE. But what
makes MPLANE or not-MPLANE "supported" are the actual formats later
on, not the API.

If we were to add artificial caps, then adding non-mplane caps to
mplane drivers might actually be the problematic case: if a
multi-planar driver didn't support any single-planar formats (and
there would be no practical way of knowing that from our standpoint),
a single-planar application would ENUM_FMT and get 0 formats, which
wouldn't be good.
Adding mplane caps to non-mplane drivers might actually be somehow
safer, as long as the application behaves and uses only single-planar
formats (as ENUM_FMT would return), it'll always work.

So ironically, all (what about the non-video_ioctl2 case?) splanar
drivers would be supporting mplane API, but not all mplane drivers
would be supporting splane API, because of the enumeration problem. I
hope I got it right, it's kind of late for me now...

What do you think?

<snip>

>>
>
> Thank you for the documentation!
>
> Regards,
>
>        Hans
>
> --
> Hans Verkuil - video4linux developer - sponsored by Cisco
>

Again, big thanks for reviewing!
-- 
Best regards,
Pawel Osciak
