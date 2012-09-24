Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:64837 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593Ab2IXMRM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 08:17:12 -0400
Message-id: <50604F3C.2060006@samsung.com>
Date: Mon, 24 Sep 2012 14:17:00 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
	sumit.semwal@ti.com, daeinki@gmail.com, daniel.vetter@ffwll.ch,
	robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, remi@remlab.net,
	subashrp@gmail.com, mchehab@redhat.com, g.liakhovetski@gmx.de,
	dmitriyz@google.com, s.nawrocki@samsung.com, k.debski@samsung.com,
	linux-doc@vger.kernel.org
Subject: Re: [PATCHv8 02/26] Documentation: media: description of DMABUF
 importing in V4L2
References: <1344958496-9373-1-git-send-email-t.stanislaws@samsung.com>
 <1344958496-9373-3-git-send-email-t.stanislaws@samsung.com>
 <201208221247.36471.hverkuil@xs4all.nl>
In-reply-to: <201208221247.36471.hverkuil@xs4all.nl>
Content-type: text/plain; charset=ISO-8859-15
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,
Thank you for review.

On 08/22/2012 12:47 PM, Hans Verkuil wrote:
> On Tue August 14 2012 17:34:32 Tomasz Stanislawski wrote:
>> This patch adds description and usage examples for importing
>> DMABUF file descriptor in V4L2.
>>
>> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> CC: linux-doc@vger.kernel.org
>> ---
>>  Documentation/DocBook/media/v4l/compat.xml         |    4 +
>>  Documentation/DocBook/media/v4l/io.xml             |  180 ++++++++++++++++++++
>>  .../DocBook/media/v4l/vidioc-create-bufs.xml       |    3 +-
>>  Documentation/DocBook/media/v4l/vidioc-qbuf.xml    |   15 ++
>>  Documentation/DocBook/media/v4l/vidioc-reqbufs.xml |   47 ++---
>>  5 files changed, 226 insertions(+), 23 deletions(-)
>>

[snip]

>> +&v4l2-plane; in the multi-planar API case).  The driver must be switched into
>> +DMABUF I/O mode by calling the &VIDIOC-REQBUFS; with the desired buffer type.
>> +No buffers (planes) are allocated beforehand, consequently they are not indexed
>> +and cannot be queried like mapped buffers with the
>> +<constant>VIDIOC_QUERYBUF</constant> ioctl.</para>
> 
> I disagree with that. Userptr buffers can use QUERYBUF just fine. Even for the
> userptr you still have to fill in the buffer index when calling QBUF.
> 
> So I see no reason why you couldn't use QUERYBUF in the DMABUF case. The only
> difference is that the fd field is undefined (set to -1 perhaps?) if the bufffer
> isn't queued.
> 
> QUERYBUF can be very useful for debugging, for example to see what the status
> is of each buffer and how many are queued.
> 

Ok. I agree that QUERYBUF can be useful for debugging. The value of fd field
should be the last value passed using QBUF. It would simplify streaming
because an application would not have to keep the file descriptor around.

>> +
>> +    <example>
>> +      <title>Initiating streaming I/O with DMABUF file descriptors</title>
>> +
>> +      <programlisting>
>> +&v4l2-requestbuffers; reqbuf;
>> +
>> +memset (&amp;reqbuf, 0, sizeof (reqbuf));
>> +reqbuf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> +reqbuf.memory = V4L2_MEMORY_DMABUF;
>> +reqbuf.count = 1;
>> +
>> +if (ioctl (fd, &VIDIOC-REQBUFS;, &amp;reqbuf) == -1) {
>> +	if (errno == EINVAL)
>> +		printf ("Video capturing or DMABUF streaming is not supported\n");
>> +	else
>> +		perror ("VIDIOC_REQBUFS");
>> +
>> +	exit (EXIT_FAILURE);
> 
> Let's stick to the kernel coding style, so no ' ' before '(' in function calls.
> Same for the other program examples below.
> 

The ' ' before function was used for userptr and mmap usage examples.
These examples should be fixed too.

>> +}
>> +      </programlisting>
>> +    </example>
>> +
>> +    <para>Buffer (plane) file descriptor is passed on the fly with the
> 
> s/Buffer/The buffer/
> 
>> +&VIDIOC-QBUF; ioctl. In case of multiplanar buffers, every plane can be
> 
> 'Can be', 'should be' or 'must be'? Does it ever make sense to have the same
> fd for different planes? Do we have restrictions on this in the userptr case?
> 

I think that we should keep to 'can be'. I see no good reason to
prevent the same dmabuf to be used for different planes.
Allowing reusing of dmabufs with assistance of data_offset field
would allow to pass a 2-planar YUV420 from V4L2-single-plane API
to a driver with V4L2-multi-plane API.

[snip]

>> diff --git a/Documentation/DocBook/media/v4l/vidioc-qbuf.xml b/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
>> index 77ff5be..436d21c 100644
>> --- a/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
>> +++ b/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
>> @@ -109,6 +109,21 @@ they cannot be swapped out to disk. Buffers remain locked until
>>  dequeued, until the &VIDIOC-STREAMOFF; or &VIDIOC-REQBUFS; ioctl is
>>  called, or until the device is closed.</para>
>>  
>> +    <para>To enqueue a <link linkend="dmabuf">DMABUF</link> buffer applications
>> +set the <structfield>memory</structfield> field to
>> +<constant>V4L2_MEMORY_DMABUF</constant> and the <structfield>m.fd</structfield>
>> +field to a file descriptor associated with a DMABUF buffer. When the
>> +multi-planar API is used <structfield>m.fd</structfield> of the passed array of
> 
> multi-planar API is used the <structfield>m.fd</structfield> fields of the passed array of
> 
>> +&v4l2-plane; have to be used instead. When <constant>VIDIOC_QBUF</constant> is
>> +called with a pointer to this structure the driver sets the
>> +<constant>V4L2_BUF_FLAG_QUEUED</constant> flag and clears the
>> +<constant>V4L2_BUF_FLAG_MAPPED</constant> and
>> +<constant>V4L2_BUF_FLAG_DONE</constant> flags in the
>> +<structfield>flags</structfield> field, or it returns an error code.  This
>> +ioctl locks the buffer. Buffers remain locked until dequeued, until the
>> +&VIDIOC-STREAMOFF; or &VIDIOC-REQBUFS; ioctl is called, or until the device is
>> +closed.</para>
> 
> You need to explain what a 'locked buffer' means.

I propose following definition:
"Locking a buffer means passing it to a driver for an access by hardware.
"If an application accesses (reads/writes) a locked buffer then the result
is undefined."

What is your opinion about proposed definition?

> 
>> +
>>      <para>Applications call the <constant>VIDIOC_DQBUF</constant>
>>  ioctl to dequeue a filled (capturing) or displayed (output) buffer
>>  from the driver's outgoing queue. They just set the
>> diff --git a/Documentation/DocBook/media/v4l/vidioc-reqbufs.xml b/Documentation/DocBook/media/v4l/vidioc-reqbufs.xml
>> index d7c9505..20f4323 100644
>> --- a/Documentation/DocBook/media/v4l/vidioc-reqbufs.xml
>> +++ b/Documentation/DocBook/media/v4l/vidioc-reqbufs.xml
>> @@ -48,28 +48,30 @@
>>    <refsect1>
>>      <title>Description</title>
>>  
>> -    <para>This ioctl is used to initiate <link linkend="mmap">memory
>> -mapped</link> or <link linkend="userp">user pointer</link>
>> -I/O. Memory mapped buffers are located in device memory and must be
>> -allocated with this ioctl before they can be mapped into the
>> -application's address space. User buffers are allocated by
>> -applications themselves, and this ioctl is merely used to switch the
>> -driver into user pointer I/O mode and to setup some internal structures.</para>
>> +<para>This ioctl is used to initiate <link linkend="mmap">memory mapped</link>,
>> +<link linkend="userp">user pointer</link> or <link
>> +linkend="dmabuf">DMABUF</link> based I/O.  Memory mapped buffers are located in
>> +device memory and must be allocated with this ioctl before they can be mapped
>> +into the application's address space. User buffers are allocated by
>> +applications themselves, and this ioctl is merely used to switch the driver
>> +into user pointer I/O mode and to setup some internal structures.
>> +Similarly, DMABUF buffers are allocated by applications through a device
>> +driver, and this ioctl only configures the driver into DMABUF I/O mode without
>> +performing any direct allocation.</para>
>>  
>> -    <para>To allocate device buffers applications initialize all
>> -fields of the <structname>v4l2_requestbuffers</structname> structure.
>> -They set the <structfield>type</structfield> field to the respective
>> -stream or buffer type, the <structfield>count</structfield> field to
>> -the desired number of buffers, <structfield>memory</structfield>
>> -must be set to the requested I/O method and the <structfield>reserved</structfield> array
>> -must be zeroed. When the ioctl
>> -is called with a pointer to this structure the driver will attempt to allocate
>> -the requested number of buffers and it stores the actual number
>> -allocated in the <structfield>count</structfield> field. It can be
>> -smaller than the number requested, even zero, when the driver runs out
>> -of free memory. A larger number is also possible when the driver requires
>> -more buffers to function correctly. For example video output requires at least two buffers,
>> -one displayed and one filled by the application.</para>
>> +    <para>To allocate device buffers applications initialize all fields of the
>> +<structname>v4l2_requestbuffers</structname> structure.  They set the
>> +<structfield>type</structfield> field to the respective stream or buffer type,
>> +the <structfield>count</structfield> field to the desired number of buffers,
>> +<structfield>memory</structfield> must be set to the requested I/O method and
>> +the <structfield>reserved</structfield> array must be zeroed. When the ioctl is
>> +called with a pointer to this structure the driver will attempt to allocate the
>> +requested number of buffers and it stores the actual number allocated in the
>> +<structfield>count</structfield> field. It can be smaller than the number
>> +requested, even zero, when the driver runs out of free memory. A larger number
>> +is also possible when the driver requires more buffers to function correctly.
>> +For example video output requires at least two buffers, one displayed and one
>> +filled by the application.</para>
>>      <para>When the I/O method is not supported the ioctl
>>  returns an &EINVAL;.</para>
>>  
>> @@ -102,7 +104,8 @@ as the &v4l2-format; <structfield>type</structfield> field. See <xref
>>  	    <entry>__u32</entry>
>>  	    <entry><structfield>memory</structfield></entry>
>>  	    <entry>Applications set this field to
>> -<constant>V4L2_MEMORY_MMAP</constant> or
>> +<constant>V4L2_MEMORY_MMAP</constant>,
>> +<constant>V4L2_MEMORY_DMABUF</constant> or
>>  <constant>V4L2_MEMORY_USERPTR</constant>. See <xref linkend="v4l2-memory"
>>  />.</entry>
>>  	  </row>
>>
> 
> You also have to update the VIDIOC_CREATE_BUFS ioctl documentation!
> 
> I think the VIDIOC_PREPARE_BUF ioctl documentation is OK, but you might want to
> check that yourself, just in case.
> 

Ok.
Regards,
Tomasz Stanislawski

> Regards,
> 
> 	Hans
> 

