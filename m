Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:60147 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753177Ab3KULzY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Nov 2013 06:55:24 -0500
Message-ID: <1385035014.2102.10.camel@palomino.walls.org>
Subject: Re: [PATCH RFC] videobuf2: Improve file I/O emulation to handle
 buffers in any order
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	PawelOsciak <pawel@osciak.com>
Date: Thu, 21 Nov 2013 06:56:54 -0500
In-Reply-To: <528DBC90.5060707@xs4all.nl>
References: <1384995906.1917.12.camel@palomino.walls.org>
	 <528DBC90.5060707@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2013-11-21 at 08:56 +0100, Hans Verkuil wrote:
> Hi Andy,
> 
> As I mentioned in irc I have been working in this same area as well, so
> I'll take this patch and merge it in my tree and test it as well.
> 
> I suspect that it might be easiest if I add the patch to my upcoming
> patch series in order to prevent merge conflicts. I'll know more later
> today.

Hi Hans,

That sounds good to me. :)

I have 4 comments on my own stuff below:


> On 11/21/2013 02:05 AM, Andy Walls wrote:
> > (This patch is RFC, because it was compiled and tested against kernel
> > v3.5)
> > 
> > videobuf2 file I/O emulation assumed that buffers dequeued from the
> > driver would return in the order they were enqueued in the driver. 
> > 
> > Improve the file I/O emulator's book-keeping to remove this assumption.
> > 
> > Also remove the, AFAICT, assumption that only read() calls would need to
> > dequeue a buffer from the driver.

Please remove the above sentence, it is incorrect.

 
> > Also set the buf->size properly, if a write() dequeues a buffer.

Please append: ", and the VB2_FILEIO_WRITE_IMMEDIATELY flag is set."


> > Signed-off-by: Andy Walls <awalls@md.metrocast.net>
> > Cc: Kyungmin Park <kyungmin.park@samsung.com>
> > Cc: PawelOsciak<pawel@osciak.com>
> > Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> > 
> > 
> > diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
> > index 9d4e9ed..f330aa4 100644
> > --- a/drivers/media/video/videobuf2-core.c
> > +++ b/drivers/media/video/videobuf2-core.c
> > @@ -1796,6 +1796,7 @@ struct vb2_fileio_data {
> >  	unsigned int dq_count;
> >  	unsigned int flags;
> >  };
> > +#define FILEIO_INDEX_NOT_SET	((unsigned int) INT_MAX)
> >  
> >  /**
> >   * __vb2_init_fileio() - initialize file io emulator
> > @@ -1889,6 +1890,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
> >  				goto err_reqbufs;
> >  			fileio->bufs[i].queued = 1;
> >  		}
> > +		fileio->index = FILEIO_INDEX_NOT_SET;
> >  
> >  		/*
> >  		 * Start streaming.
> > @@ -1975,15 +1977,11 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
> >  	 */
> >  	q->fileio = NULL;
> >  
> > -	index = fileio->index;
> > -	buf = &fileio->bufs[index];
> > -
> >  	/*
> >  	 * Check if we need to dequeue the buffer.
> >  	 */
> > -	if (buf->queued) {
> > -		struct vb2_buffer *vb;
> > -
> > +	index = fileio->index;
> > +	if (index == FILEIO_INDEX_NOT_SET) {
> >  		/*
> >  		 * Call vb2_dqbuf to get buffer back.
> >  		 */
> > @@ -1997,12 +1995,19 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
> >  			goto end;
> >  		fileio->dq_count += 1;
> >  
> > +		fileio->index = fileio->b.index;
> > +		index = fileio->index;
> > +		buf = &fileio->bufs[index];
> > +		
> >  		/*
> >  		 * Get number of bytes filled by the driver
> >  		 */
> > -		vb = q->bufs[index];
> > -		buf->size = vb2_get_plane_payload(vb, 0);
> > +		buf->pos = 0;
> >  		buf->queued = 0;
> > +		buf->size = read ? vb2_get_plane_payload(q->bufs[index], 0)
> > +				 : vb2_plane_size(q->bufs[index], 0);
> > +	} else {
> > +		buf = &fileio->bufs[index];
> >  	}
> >  
> >  	/*
> > @@ -2070,13 +2075,28 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
> >  		 */
> >  		buf->pos = 0;
> >  		buf->queued = 1;
> > -		buf->size = q->bufs[0]->v4l2_planes[0].length;
> > +		buf->size = vb2_plane_size(q->bufs[index], 0);
> >  		fileio->q_count += 1;
> >  
> >  		/*
> > -		 * Switch to the next buffer
> > +		 * Decide on the next buffer
> >  		 */
> > -		fileio->index = (index + 1) % q->num_buffers;
> > +		if (read || (q->num_buffers == 1)) {

Change to

		if (read || (fileio->q_count >= q->num_buffers))

After the initial write() calls queue all the buffers, steady state is
all the buffers queued in the driver.  At steady state, the do-while
loop below is wasted effort.  This change to the if() condition avoids
that wasted effort, except for briefly after every roll-over of
fileio->q_count.

> > +			/* Use the next buffer the driver provides back */
> > +			fileio->index = FILEIO_INDEX_NOT_SET;
> > +		} else {
> > +			/* Prefer a buffer that is not quequed in the driver */

s/quequed/queued/

> > +			int initial_index = fileio->index;
> > +			fileio->index = FILEIO_INDEX_NOT_SET;
> > +			do {
> > +				if (++index == q->num_buffers)
> > +					index = 0;
> > +				if (!fileio->bufs[index].queued) {
> > +					fileio->index = index;
> > +					break;
> > +				}
> > +			} while (index != initial_index);
> > +		}
> >  		/*
> >  		 * Start streaming if required.
> > 
> > 

Regards,
Andy

