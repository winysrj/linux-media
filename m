Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3503 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab2E1K2X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 May 2012 06:28:23 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Subject: Re: [PATCH v3 1/1] v4l: drop v4l2_buffer.input and V4L2_BUF_FLAG_INPUT
Date: Mon, 28 May 2012 12:27:46 +0200
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com
References: <2396617.gGNm1rAEoQ@avalon> <1335962403-20706-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1335962403-20706-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205281227.46866.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ezequiel,

I'm just bringing this proposal to your attention as I am wondering how your driver (and
the old easycap driver that your driver will replace) handle the easycap device with
multiple inputs? Is it cycling through all inputs? In that case we might need the input
field.

Regards,

	Hans

On Wed May 2 2012 14:40:03 Sakari Ailus wrote:
> Remove input field in struct v4l2_buffer and flag V4L2_BUF_FLAG_INPUT which
> tells the former is valid. The flag is used by no driver currently.
> 
> Also change the documentation accordingly.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
> Hi,
> 
> This is the third version of the v4l2_buffer.input field removal patch.
> 
> What has changed since the previous version:
> 
> - Rename input as reserved2 instead of combining it to reserved and making
>   it an array.
> - cpia compile fix.
> - Change documentation accordingly.
> 
>  Documentation/DocBook/media/v4l/compat.xml      |    6 ++++++
>  Documentation/DocBook/media/v4l/io.xml          |   19 +++++--------------
>  Documentation/DocBook/media/v4l/vidioc-qbuf.xml |    9 +++------
>  drivers/media/video/cpia2/cpia2_v4l.c           |    2 +-
>  drivers/media/video/v4l2-compat-ioctl32.c       |   11 +++++------
>  drivers/media/video/videobuf-core.c             |   16 ----------------
>  drivers/media/video/videobuf2-core.c            |    5 ++---
>  include/linux/videodev2.h                       |    3 +--
>  8 files changed, 23 insertions(+), 48 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
> index 87339b2..b939457 100644
> --- a/Documentation/DocBook/media/v4l/compat.xml
> +++ b/Documentation/DocBook/media/v4l/compat.xml
> @@ -2422,6 +2422,12 @@ details.</para>
>  	  &VIDIOC-SUBDEV-G-SELECTION; and
>  	  &VIDIOC-SUBDEV-S-SELECTION;.</para>
>          </listitem>
> +	<listitem>
> +	  <para>Replaced <structfield>input</structfield> in
> +	  <structname>v4l2_buffer</structname> by
> +	  <structfield>reserved2</structfield> and removed
> +	  <constant>V4L2_BUF_FLAG_INPUT</constant>.</para>
> +	</listitem>
>        </orderedlist>
>      </section>
>  
> diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
> index b815929..e4cb063 100644
> --- a/Documentation/DocBook/media/v4l/io.xml
> +++ b/Documentation/DocBook/media/v4l/io.xml
> @@ -681,14 +681,12 @@ memory, set by the application. See <xref linkend="userp" /> for details.
>  	  </row>
>  	  <row>
>  	    <entry>__u32</entry>
> -	    <entry><structfield>input</structfield></entry>
> +	    <entry><structfield>reserved2</structfield></entry>
>  	    <entry></entry>
> -	    <entry>Some video capture drivers support rapid and
> -synchronous video input changes, a function useful for example in
> -video surveillance applications. For this purpose applications set the
> -<constant>V4L2_BUF_FLAG_INPUT</constant> flag, and this field to the
> -number of a video input as in &v4l2-input; field
> -<structfield>index</structfield>.</entry>
> +	    <entry>A place holder for future extensions and custom
> +(driver defined) buffer types
> +<constant>V4L2_BUF_TYPE_PRIVATE</constant> and higher. Applications
> +should set this to 0.</entry>
>  	  </row>
>  	  <row>
>  	    <entry>__u32</entry>
> @@ -921,13 +919,6 @@ Drivers set or clear this flag when the <constant>VIDIOC_DQBUF</constant>
>  ioctl is called.</entry>
>  	  </row>
>  	  <row>
> -	    <entry><constant>V4L2_BUF_FLAG_INPUT</constant></entry>
> -	    <entry>0x0200</entry>
> -	    <entry>The <structfield>input</structfield> field is valid.
> -Applications set or clear this flag before calling the
> -<constant>VIDIOC_QBUF</constant> ioctl.</entry>
> -	  </row>
> -	  <row>
>  	    <entry><constant>V4L2_BUF_FLAG_PREPARED</constant></entry>
>  	    <entry>0x0400</entry>
>  	    <entry>The buffer has been prepared for I/O and can be queued by the
> diff --git a/Documentation/DocBook/media/v4l/vidioc-qbuf.xml b/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
> index 9caa49a..77ff5be 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
> @@ -71,12 +71,9 @@ initialize the <structfield>bytesused</structfield>,
>  <structfield>field</structfield> and
>  <structfield>timestamp</structfield> fields, see <xref
>  linkend="buffer" /> for details.
> -Applications must also set <structfield>flags</structfield> to 0. If a driver
> -supports capturing from specific video inputs and you want to specify a video
> -input, then <structfield>flags</structfield> should be set to
> -<constant>V4L2_BUF_FLAG_INPUT</constant> and the field
> -<structfield>input</structfield> must be initialized to the desired input.
> -The <structfield>reserved</structfield> field must be set to 0. When using
> +Applications must also set <structfield>flags</structfield> to 0.
> +The <structfield>reserved2</structfield> and
> +<structfield>reserved</structfield> fields must be set to 0. When using
>  the <link linkend="planar-apis">multi-planar API</link>, the
>  <structfield>m.planes</structfield> field must contain a userspace pointer
>  to a filled-in array of &v4l2-plane; and the <structfield>length</structfield>
> diff --git a/drivers/media/video/cpia2/cpia2_v4l.c b/drivers/media/video/cpia2/cpia2_v4l.c
> index 077eb1d..c105612 100644
> --- a/drivers/media/video/cpia2/cpia2_v4l.c
> +++ b/drivers/media/video/cpia2/cpia2_v4l.c
> @@ -1289,7 +1289,7 @@ static int cpia2_dqbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
>  	buf->sequence = cam->buffers[buf->index].seq;
>  	buf->m.offset = cam->buffers[buf->index].data - cam->frame_buffer;
>  	buf->length = cam->frame_size;
> -	buf->input = 0;
> +	buf->reserved2 = 0;
>  	buf->reserved = 0;
>  	memset(&buf->timecode, 0, sizeof(buf->timecode));
>  
> diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
> index 2829d25..6d566b3 100644
> --- a/drivers/media/video/v4l2-compat-ioctl32.c
> +++ b/drivers/media/video/v4l2-compat-ioctl32.c
> @@ -327,7 +327,7 @@ struct v4l2_buffer32 {
>  		compat_caddr_t  planes;
>  	} m;
>  	__u32			length;
> -	__u32			input;
> +	__u32			reserved2;
>  	__u32			reserved;
>  };
>  
> @@ -387,8 +387,7 @@ static int get_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
>  		get_user(kp->index, &up->index) ||
>  		get_user(kp->type, &up->type) ||
>  		get_user(kp->flags, &up->flags) ||
> -		get_user(kp->memory, &up->memory) ||
> -		get_user(kp->input, &up->input))
> +		get_user(kp->memory, &up->memory)
>  			return -EFAULT;
>  
>  	if (V4L2_TYPE_IS_OUTPUT(kp->type))
> @@ -472,8 +471,7 @@ static int put_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
>  		put_user(kp->index, &up->index) ||
>  		put_user(kp->type, &up->type) ||
>  		put_user(kp->flags, &up->flags) ||
> -		put_user(kp->memory, &up->memory) ||
> -		put_user(kp->input, &up->input))
> +		put_user(kp->memory, &up->memory)
>  			return -EFAULT;
>  
>  	if (put_user(kp->bytesused, &up->bytesused) ||
> @@ -482,7 +480,8 @@ static int put_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
>  		put_user(kp->timestamp.tv_usec, &up->timestamp.tv_usec) ||
>  		copy_to_user(&up->timecode, &kp->timecode, sizeof(struct v4l2_timecode)) ||
>  		put_user(kp->sequence, &up->sequence) ||
> -		put_user(kp->reserved, &up->reserved))
> +		put_user(kp->reserved2, &up->reserved2) ||
> +		put_user(kp->reserved, &up->reserved)
>  			return -EFAULT;
>  
>  	if (V4L2_TYPE_IS_MULTIPLANAR(kp->type)) {
> diff --git a/drivers/media/video/videobuf-core.c b/drivers/media/video/videobuf-core.c
> index ffdf59c..bf7a326 100644
> --- a/drivers/media/video/videobuf-core.c
> +++ b/drivers/media/video/videobuf-core.c
> @@ -359,11 +359,6 @@ static void videobuf_status(struct videobuf_queue *q, struct v4l2_buffer *b,
>  		break;
>  	}
>  
> -	if (vb->input != UNSET) {
> -		b->flags |= V4L2_BUF_FLAG_INPUT;
> -		b->input  = vb->input;
> -	}
> -
>  	b->field     = vb->field;
>  	b->timestamp = vb->ts;
>  	b->bytesused = vb->size;
> @@ -402,7 +397,6 @@ int __videobuf_mmap_setup(struct videobuf_queue *q,
>  			break;
>  
>  		q->bufs[i]->i      = i;
> -		q->bufs[i]->input  = UNSET;
>  		q->bufs[i]->memory = memory;
>  		q->bufs[i]->bsize  = bsize;
>  		switch (memory) {
> @@ -566,16 +560,6 @@ int videobuf_qbuf(struct videobuf_queue *q, struct v4l2_buffer *b)
>  		goto done;
>  	}
>  
> -	if (b->flags & V4L2_BUF_FLAG_INPUT) {
> -		if (b->input >= q->inputs) {
> -			dprintk(1, "qbuf: wrong input.\n");
> -			goto done;
> -		}
> -		buf->input = b->input;
> -	} else {
> -		buf->input = UNSET;
> -	}
> -
>  	switch (b->memory) {
>  	case V4L2_MEMORY_MMAP:
>  		if (0 == buf->baddr) {
> diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
> index 3786d88..ccc71f2 100644
> --- a/drivers/media/video/videobuf2-core.c
> +++ b/drivers/media/video/videobuf2-core.c
> @@ -336,9 +336,9 @@ static int __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
>  	struct vb2_queue *q = vb->vb2_queue;
>  	int ret;
>  
> -	/* Copy back data such as timestamp, flags, input, etc. */
> +	/* Copy back data such as timestamp, flags, etc. */
>  	memcpy(b, &vb->v4l2_buf, offsetof(struct v4l2_buffer, m));
> -	b->input = vb->v4l2_buf.input;
> +	b->reserved2 = vb->v4l2_buf.reserved2;
>  	b->reserved = vb->v4l2_buf.reserved;
>  
>  	if (V4L2_TYPE_IS_MULTIPLANAR(q->type)) {
> @@ -860,7 +860,6 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b,
>  
>  	vb->v4l2_buf.field = b->field;
>  	vb->v4l2_buf.timestamp = b->timestamp;
> -	vb->v4l2_buf.input = b->input;
>  	vb->v4l2_buf.flags = b->flags & ~V4L2_BUFFER_STATE_FLAGS;
>  
>  	return 0;
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 5a09ac3..fed1d40 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -652,7 +652,7 @@ struct v4l2_buffer {
>  		struct v4l2_plane *planes;
>  	} m;
>  	__u32			length;
> -	__u32			input;
> +	__u32			reserved2;
>  	__u32			reserved;
>  };
>  
> @@ -666,7 +666,6 @@ struct v4l2_buffer {
>  /* Buffer is ready, but the data contained within is corrupted. */
>  #define V4L2_BUF_FLAG_ERROR	0x0040
>  #define V4L2_BUF_FLAG_TIMECODE	0x0100	/* timecode field is valid */
> -#define V4L2_BUF_FLAG_INPUT     0x0200  /* input field is valid */
>  #define V4L2_BUF_FLAG_PREPARED	0x0400	/* Buffer is prepared for queuing */
>  /* Cache handling flags */
>  #define V4L2_BUF_FLAG_NO_CACHE_INVALIDATE	0x0800
> 
