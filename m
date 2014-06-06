Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbaFFJjC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Jun 2014 05:39:02 -0400
Message-ID: <53918C2C.3070505@redhat.com>
Date: Fri, 06 Jun 2014 11:38:52 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Thiago Santos <ts.santos@sisa.samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH/RFC 2/2] libv4l2: release the lock before doing a DQBUF
References: <1401982284-1983-1-git-send-email-ts.santos@sisa.samsung.com> <1401982284-1983-3-git-send-email-ts.santos@sisa.samsung.com>
In-Reply-To: <1401982284-1983-3-git-send-email-ts.santos@sisa.samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 06/05/2014 05:31 PM, Thiago Santos wrote:
> In blocking mode, if there are no buffers available the DQBUF will block
> waiting for a QBUF to be called but it will block holding the streaming
> lock which will prevent any QBUF from happening, causing a deadlock.
> 
> Can be tested with: v4l2grab -t 1 -b 1 -s 2000
> 
> Signed-off-by: Thiago Santos <ts.santos@sisa.samsung.com>

Thanks for catching this, and thanks for the patch fixing it.

I'm afraid it is not that simple though. Without the lock the app may do the
following:

Control-thread: set_fmt(fmt), requestbuf(x), map buffers, queue buffers, streamon
Work-thread: dqbuf, process, qbuf, rinse-repeat
Control-thread: streamoff, requestbuf(0), wait for work thread, unmap buffers.

There is a race here with dqbuf succeeding, but not yet being processed
while the control-thread is tearing things down.

If we hit this race then the v4lconvert_convert call will be passed a no longer
valid pointer in the form of devices[index].frame_pointers[buf->index] and likewise
its other parameters may also no longer be accurate (or point to invalid mem
alltogether).

Fixing this without breaking stuff / causing the risk of regressions is very much
non trivial. Since this is a race (normally the dqbuf call would return with an
error because of the streamoff), I believe the best way to fix this is to just
detect this situation and make v4l2_dequeue_and_convert return an error in this
case.

So I suggest that you respin the patch with the following additions.
* Add a frame_info_generation variable to struct v4l2_dev_info
  (below the frame_queued field)
* In v4l2_check_buffer_change_ok() increment this field *before* calling v4l2_unmap_buffers()
* Read frame_info_generation into a local variable before dropping the lock for the VIDIOC_DQBUF
* Check if frame_info_generation is not changed after this line:
  devices[index].frame_queued &= ~(1 << buf->index);
* If it is changed set errno to -EINVAL (this is what the kernel does when a streamoff is done
  while a dqbuf is pending), and return -1.

* You should also unlock + relock around the DQBUF for the non converted case around line 1297
  in this case no special handling is needed.

Regards,

Hans


> ---
>  lib/libv4l2/libv4l2.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/lib/libv4l2/libv4l2.c b/lib/libv4l2/libv4l2.c
> index c4d69f7..5589fe0 100644
> --- a/lib/libv4l2/libv4l2.c
> +++ b/lib/libv4l2/libv4l2.c
> @@ -290,9 +290,11 @@ static int v4l2_dequeue_and_convert(int index, struct v4l2_buffer *buf,
>  		return result;
>  
>  	do {
> +		pthread_mutex_unlock(&devices[index].stream_lock);
>  		result = devices[index].dev_ops->ioctl(
>  				devices[index].dev_ops_priv,
>  				devices[index].fd, VIDIOC_DQBUF, buf);
> +		pthread_mutex_lock(&devices[index].stream_lock);
>  		if (result) {
>  			if (errno != EAGAIN) {
>  				int saved_err = errno;
> 
