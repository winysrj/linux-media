Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:48797 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751926AbbIKQpR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2015 12:45:17 -0400
Message-ID: <55F304D5.90405@xs4all.nl>
Date: Fri, 11 Sep 2015 18:44:05 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org
CC: pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@linaro.org,
	robdclark@gmail.com, daniel.vetter@ffwll.ch, labbott@redhat.com
Subject: Re: [RFC RESEND 04/11] v4l: Unify cache management hint buffer flags
References: <1441972234-8643-1-git-send-email-sakari.ailus@linux.intel.com> <1441972234-8643-5-git-send-email-sakari.ailus@linux.intel.com> <55F300CE.5060204@xs4all.nl>
In-Reply-To: <55F300CE.5060204@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/11/2015 06:26 PM, Hans Verkuil wrote:
> On 09/11/2015 01:50 PM, Sakari Ailus wrote:
>> The V4L2_BUF_FLAG_NO_CACHE_INVALIDATE and V4L2_BUF_FLAG_NO_CACHE_CLEAN
>> buffer flags are currently not used by the kernel. Replace the definitions
>> by a single V4L2_BUF_FLAG_NO_CACHE_SYNC flag to be used by further
>> patches.
>>
>> Different cache architectures should not be visible to the user space
>> which can make no meaningful use of the differences anyway. In case a
>> device can make use of non-coherent memory accesses, the necessary cache
>> operations depend on the CPU architecture and the buffer type, not the
>> requests of the user. The cache operation itself may be skipped on the
>> user's request which was the purpose of the two flags.
>>
>> On ARM the invalidate and clean are separate operations whereas on
>> x86(-64) the two are a single operation (flush). Whether the hardware uses
>> the buffer for reading (V4L2_BUF_TYPE_*_OUTPUT*) or writing
>> (V4L2_BUF_TYPE_*CAPTURE*) already defines the required cache operation
>> (clean and invalidate, respectively). No user input is required.
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Let me add something here: drivers should be able to override this flag.

There are drivers that need to do fixups in buf_finish (a typical example is to
fill in some JPEG or MPEG header). Obviously this does require syncing to the
cpu.

This is actually a bigger problem since trying to do this with dmabuf can fail
as well. I made patches for that, but I never got around to finishing it:

http://git.linuxtv.org/cgit.cgi/hverkuil/media_tree.git/log/?h=vb2-prep5

Basically this changes drivers so they are explicit when they need cpu access
to a buffer.

By using these begin/end_cpu_access functions you can still implement fixups
correctly, although it does mean that the NO_CACHE_SYNC is effectively (but
unavoidably) ignored.

I think my patch series should be merged with this patch series 

The cover letter I wrote for the RFC patch series containing these cpu access
functions is here:

http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/84399

I quote:

"The last 5 patches make this more strict by requiring all cpu access to
be bracketed by calls to vb2_plane_begin/end_cpu_access() which replaces
the old vb2_plane_vaddr() call.

Note: two drivers still use the vb2_plane_vaddr() call: coda and
exynos4-is/fimc-capture.c. For both drivers I will need some help since
I am not sure where to put the begin/end calls. Patch 15 removes
the vb2_plane_vaddr call, so obviously those two drivers won't compile
after that."

So that's the missing part that I never got around to.

Of course, there are new drivers as well since the last time I posted it,
so there may be more to do now.

I also said:

"The issues that patches 12-16 address are [...] only an issue when using
dmabuf with drivers that need cpu access."

But it will *also* be an issue once this new NO_CACHE_SYNC flag is honored.

Regards,

	Hans

> 
>> ---
>>  Documentation/DocBook/media/v4l/io.xml | 25 +++++++++++--------------
>>  include/trace/events/v4l2.h            |  3 +--
>>  include/uapi/linux/videodev2.h         |  7 +++++--
>>  3 files changed, 17 insertions(+), 18 deletions(-)
>>
>> diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
>> index 7bbc2a4..4facd63 100644
>> --- a/Documentation/DocBook/media/v4l/io.xml
>> +++ b/Documentation/DocBook/media/v4l/io.xml
>> @@ -1112,21 +1112,18 @@ application. Drivers set or clear this flag when the
>>  	  linkend="vidioc-qbuf">VIDIOC_DQBUF</link> ioctl is called.</entry>
>>  	  </row>
>>  	  <row>
>> -	    <entry><constant>V4L2_BUF_FLAG_NO_CACHE_INVALIDATE</constant></entry>
>> +	    <entry><constant>V4L2_BUF_FLAG_NO_CACHE_SYNC</constant></entry>
>>  	    <entry>0x00000800</entry>
>> -	    <entry>Caches do not have to be invalidated for this buffer.
>> -Typically applications shall use this flag if the data captured in the buffer
>> -is not going to be touched by the CPU, instead the buffer will, probably, be
>> -passed on to a DMA-capable hardware unit for further processing or output.
>> -</entry>
>> -	  </row>
>> -	  <row>
>> -	    <entry><constant>V4L2_BUF_FLAG_NO_CACHE_CLEAN</constant></entry>
>> -	    <entry>0x00001000</entry>
>> -	    <entry>Caches do not have to be cleaned for this buffer.
>> -Typically applications shall use this flag for output buffers if the data
>> -in this buffer has not been created by the CPU but by some DMA-capable unit,
>> -in which case caches have not been used.</entry>
>> +	    <entry>Do not perform CPU cache synchronisation operations
>> +	    when the buffer is queued or dequeued. The user is
>> +	    responsible for the correct use of this flag. It should be
>> +	    only used when the buffer is not accessed using the CPU,
>> +	    e.g. the buffer is written to by a hardware block and then
>> +	    read by another one, in which case the flag should be set
>> +	    in both <link linkend="vidioc-qbuf">VIDIOC_DQBUF</link>
>> +	    and <link linkend="vidioc-qbuf">VIDIOC_QBUF</link> IOCTLs.
>> +	    The flag has no effect on some devices / architectures.
>> +	    </entry>
>>  	  </row>
>>  	  <row>
>>  	    <entry><constant>V4L2_BUF_FLAG_LAST</constant></entry>
>> diff --git a/include/trace/events/v4l2.h b/include/trace/events/v4l2.h
>> index dbf017b..4cee91d 100644
>> --- a/include/trace/events/v4l2.h
>> +++ b/include/trace/events/v4l2.h
>> @@ -78,8 +78,7 @@ SHOW_FIELD
>>  		{ V4L2_BUF_FLAG_ERROR,		     "ERROR" },		      \
>>  		{ V4L2_BUF_FLAG_TIMECODE,	     "TIMECODE" },	      \
>>  		{ V4L2_BUF_FLAG_PREPARED,	     "PREPARED" },	      \
>> -		{ V4L2_BUF_FLAG_NO_CACHE_INVALIDATE, "NO_CACHE_INVALIDATE" }, \
>> -		{ V4L2_BUF_FLAG_NO_CACHE_CLEAN,	     "NO_CACHE_CLEAN" },      \
>> +		{ V4L2_BUF_FLAG_NO_CACHE_SYNC,	     "NO_CACHE_SYNC" },	      \
>>  		{ V4L2_BUF_FLAG_TIMESTAMP_MASK,	     "TIMESTAMP_MASK" },      \
>>  		{ V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN,   "TIMESTAMP_UNKNOWN" },   \
>>  		{ V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC, "TIMESTAMP_MONOTONIC" }, \
>> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
>> index 3228fbe..8d85aac 100644
>> --- a/include/uapi/linux/videodev2.h
>> +++ b/include/uapi/linux/videodev2.h
>> @@ -875,8 +875,11 @@ struct v4l2_buffer {
>>  #define V4L2_BUF_FLAG_TIMECODE			0x00000100
>>  /* Buffer is prepared for queuing */
>>  #define V4L2_BUF_FLAG_PREPARED			0x00000400
>> -/* Cache handling flags */
>> -#define V4L2_BUF_FLAG_NO_CACHE_INVALIDATE	0x00000800
>> +/* Cache sync hint */
>> +#define V4L2_BUF_FLAG_NO_CACHE_SYNC		0x00000800
>> +/* DEPRECATED. THIS WILL BE REMOVED IN THE FUTURE! */
>> +#define V4L2_BUF_FLAG_NO_CACHE_INVALIDATE	V4L2_BUF_FLAG_NO_CACHE_SYNC
>> +/* DEPRECATED. THIS WILL BE REMOVED IN THE FUTURE! */
>>  #define V4L2_BUF_FLAG_NO_CACHE_CLEAN		0x00001000
>>  /* Timestamp type */
>>  #define V4L2_BUF_FLAG_TIMESTAMP_MASK		0x0000e000
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

