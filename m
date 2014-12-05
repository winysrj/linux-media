Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:46661 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750924AbaLEPKK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Dec 2014 10:10:10 -0500
Message-ID: <5481CACD.5060008@xs4all.nl>
Date: Fri, 05 Dec 2014 16:10:05 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
CC: aviv.d.greenberg@intel.com
Subject: Re: [REVIEW PATCH 1/2] v4l: Add data_offset to struct v4l2_buffer
References: <1417605249-5322-1-git-send-email-sakari.ailus@iki.fi> <1417605249-5322-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1417605249-5322-2-git-send-email-sakari.ailus@iki.fi>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/03/2014 12:14 PM, Sakari Ailus wrote:
> From: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> The data_offset field tells the start of the image data from the beginning
> of the buffer. The bsize field 

bsize field? There is no bsize field in v4l2_buffer, so I'm confused.

> in struct v4l2_buffer includes this, but the
> sizeimage field in struct v4l2_pix_format does not.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  Documentation/DocBook/media/v4l/compat.xml      | 11 +++++++++++
>  Documentation/DocBook/media/v4l/io.xml          | 18 +++++++++++++++---
>  Documentation/DocBook/media/v4l/vidioc-qbuf.xml |  3 +--
>  drivers/media/usb/cpia2/cpia2_v4l.c             |  2 +-
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c   |  4 ++--
>  drivers/media/v4l2-core/videobuf2-core.c        | 17 ++++++++++++-----
>  include/uapi/linux/videodev2.h                  |  4 +++-
>  7 files changed, 45 insertions(+), 14 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
> index 0a2debf..ad54e72 100644
> --- a/Documentation/DocBook/media/v4l/compat.xml
> +++ b/Documentation/DocBook/media/v4l/compat.xml
> @@ -2579,6 +2579,17 @@ fields changed from _s32 to _u32.
>        </orderedlist>
>      </section>
>  
> +    <section>
> +      <title>V4L2 in Linux 3.20</title>
> +      <orderedlist>
> +	<listitem>
> +	  <para>Replaced <structfield>reserved2</structfield> by
> +	  <strucfield>data_offset<structfield> in struct
> +	  <structname>v4l2_buffer</structname>.</para>
> +	</listitem>
> +      </orderedlist>
> +    </section>
> +
>      <section id="other">
>        <title>Relation of V4L2 to other Linux multimedia APIs</title>
>  
> diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
> index 1c17f80..13baeac 100644
> --- a/Documentation/DocBook/media/v4l/io.xml
> +++ b/Documentation/DocBook/media/v4l/io.xml
> @@ -839,10 +839,22 @@ is the file descriptor associated with a DMABUF buffer.</entry>
>  	  </row>
>  	  <row>
>  	    <entry>__u32</entry>
> -	    <entry><structfield>reserved2</structfield></entry>
> +	    <entry><structfield>data_offset</structfield></entry>
>  	    <entry></entry>
> -	    <entry>A place holder for future extensions. Applications
> -should set this to 0.</entry>
> +	    <entry>
> +	      Start of the image data from the beginning of the buffer in
> +	      bytes. Applications must set this for both

Drop 'both'.

> +	      <constant>V4L2_BUF_TYPE_VIDEO_OUTPUT</constant> buffers
> +	      whereas driver must set this for
> +	      <constant>V4L2_BUF_TYPE_VIDEO_CAPTURE</constant> buffers
> +	      before &VIDIOC-PREPARE-BUF; and &VIDIOC-QBUF; IOCTLs. Note

s/IOCTLs/ioctls/

> +	      that data_offset is included in
> +	      <structfield>bytesused</structfield>. So the size of the image
> +	      in the plane is <structfield>bytesused</structfield>-
> +	      <structfield>data_offset</structfield> at offset
> +	      <structfield>data_offset</structfield> from the start of the
> +	      plane.
> +	    </entry>
>  	  </row>
>  	  <row>
>  	    <entry>__u32</entry>
> diff --git a/Documentation/DocBook/media/v4l/vidioc-qbuf.xml b/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
> index 3504a7f..f529e4d 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
> @@ -72,8 +72,7 @@ initialize the <structfield>bytesused</structfield>,
>  <structfield>timestamp</structfield> fields, see <xref
>  linkend="buffer" /> for details.
>  Applications must also set <structfield>flags</structfield> to 0.
> -The <structfield>reserved2</structfield> and
> -<structfield>reserved</structfield> fields must be set to 0. When using
> +The <structfield>reserved</structfield> field must be set to 0. When using
>  the <link linkend="planar-apis">multi-planar API</link>, the
>  <structfield>m.planes</structfield> field must contain a userspace pointer
>  to a filled-in array of &v4l2-plane; and the <structfield>length</structfield>
> diff --git a/drivers/media/usb/cpia2/cpia2_v4l.c b/drivers/media/usb/cpia2/cpia2_v4l.c
> index 9caea83..a94e83a 100644
> --- a/drivers/media/usb/cpia2/cpia2_v4l.c
> +++ b/drivers/media/usb/cpia2/cpia2_v4l.c
> @@ -952,7 +952,7 @@ static int cpia2_dqbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
>  	buf->sequence = cam->buffers[buf->index].seq;
>  	buf->m.offset = cam->buffers[buf->index].data - cam->frame_buffer;
>  	buf->length = cam->frame_size;
> -	buf->reserved2 = 0;
> +	buf->data_offset = 0;
>  	buf->reserved = 0;
>  	memset(&buf->timecode, 0, sizeof(buf->timecode));
>  
> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> index af63543..e238066 100644
> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> @@ -326,7 +326,7 @@ struct v4l2_buffer32 {
>  		__s32		fd;
>  	} m;
>  	__u32			length;
> -	__u32			reserved2;
> +	__u32			data_offset;
>  	__u32			reserved;
>  };
>  
> @@ -491,7 +491,7 @@ static int put_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
>  		put_user(kp->timestamp.tv_usec, &up->timestamp.tv_usec) ||
>  		copy_to_user(&up->timecode, &kp->timecode, sizeof(struct v4l2_timecode)) ||
>  		put_user(kp->sequence, &up->sequence) ||
> -		put_user(kp->reserved2, &up->reserved2) ||
> +		put_user(kp->data_offset, &up->data_offset) ||
>  		put_user(kp->reserved, &up->reserved))
>  			return -EFAULT;
>  
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 7aed8f2..3162de8 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -607,6 +607,9 @@ static int __verify_length(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>  
>  		if (b->bytesused > length)
>  			return -EINVAL;
> +
> +		if (b->data_offset > 0 && b->data_offset >= bytesused)
> +			return -EINVAL;
>  	}
>  
>  	return 0;
> @@ -657,7 +660,6 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
>  
>  	/* Copy back data such as timestamp, flags, etc. */
>  	memcpy(b, &vb->v4l2_buf, offsetof(struct v4l2_buffer, m));
> -	b->reserved2 = vb->v4l2_buf.reserved2;
>  	b->reserved = vb->v4l2_buf.reserved;
>  
>  	if (V4L2_TYPE_IS_MULTIPLANAR(q->type)) {
> @@ -666,14 +668,17 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
>  		 * for it. The caller has already verified memory and size.
>  		 */
>  		b->length = vb->num_planes;
> +		b->data_offset = vb->v4l2_buf.data_offset;
>  		memcpy(b->m.planes, vb->v4l2_planes,
>  			b->length * sizeof(struct v4l2_plane));
>  	} else {
>  		/*
> -		 * We use length and offset in v4l2_planes array even for
> -		 * single-planar buffers, but userspace does not.
> +		 * We use length, data_offset and bytesused in
> +		 * v4l2_planes array even for single-planar buffers,
> +		 * but userspace does not.
>  		 */
>  		b->length = vb->v4l2_planes[0].length;
> +		b->data_offset = vb->v4l2_planes[0].data_offset;
>  		b->bytesused = vb->v4l2_planes[0].bytesused;
>  		if (q->memory == V4L2_MEMORY_MMAP)
>  			b->m.offset = vb->v4l2_planes[0].m.mem_offset;
> @@ -1306,11 +1311,13 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
>  			v4l2_planes[0].length = b->length;
>  		}
>  
> -		if (V4L2_TYPE_IS_OUTPUT(b->type))
> +		if (V4L2_TYPE_IS_OUTPUT(b->type)) {
>  			v4l2_planes[0].bytesused = b->bytesused ?
>  				b->bytesused : v4l2_planes[0].length;
> -		else
> +			v4l2_planes[0].data_offset = b->data_offset;
> +		} else {
>  			v4l2_planes[0].bytesused = 0;
> +		}
>  
>  	}
>  
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 1c2f84f..e9806c6 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -675,6 +675,8 @@ struct v4l2_plane {
>   * @length:	size in bytes of the buffer (NOT its payload) for single-plane
>   *		buffers (when type != *_MPLANE); number of elements in the
>   *		planes array for multi-plane buffers
> + * @data_offset: Offset of the start of data from the beginning of the
> + *		buffer. Typically zero.
>   *
>   * Contains data exchanged by application and driver using one of the Streaming
>   * I/O methods.
> @@ -698,7 +700,7 @@ struct v4l2_buffer {
>  		__s32		fd;
>  	} m;
>  	__u32			length;
> -	__u32			reserved2;
> +	__u32			data_offset;
>  	__u32			reserved;
>  };
>  
> 

I think we need to add new helper functions that give back the real plane size
(i.e. bytesused - data_offset) and the actual plane start position (plane start
+ data_offset). It will be a bit tricky though to check existing drivers.

AFAICT vivid is one driver that uses vb2_plane_size() to check if enough space
is available for the image, but that doesn't take the data_offset into account.

I suspect that similar problems occur for output drivers. And what isn't properly
defined at the moment is what should happen if an output driver doesn't support
a particular data_offset value.

I think the only thing you can do in that case is to return an error when QBUF
is called.

Regards,

	Hans
