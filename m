Return-path: <mchehab@pedra>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3282 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756189Ab1F1HeF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2011 03:34:05 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFCv3 PATCH 12/18] vb2_poll: don't start DMA, leave that to the first read().
Date: Tue, 28 Jun 2011 09:33:57 +0200
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <1307459123-17810-1-git-send-email-hverkuil@xs4all.nl> <f1a14e0985ddaa053e45522fe7bbdfae56057ec2.1307458245.git.hans.verkuil@cisco.com> <4E08FBA5.5080006@redhat.com>
In-Reply-To: <4E08FBA5.5080006@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106280933.57364.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Monday, June 27, 2011 23:52:37 Mauro Carvalho Chehab wrote:
> Em 07-06-2011 12:05, Hans Verkuil escreveu:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > The vb2_poll function would start read-DMA if called without any streaming
> > in progress. This unfortunately does not work if the application just wants
> > to poll for exceptions. This information of what the application is polling
> > for is sadly unavailable in the driver.
> > 
> > Andy Walls suggested to just return POLLIN | POLLRDNORM and let the first
> > call to read() start the DMA. This initial read() call will return EAGAIN
> > since no actual data is available yet, but it does start the DMA.
> > 
> > Applications must handle EAGAIN in any case since there can be other reasons
> > for EAGAIN as well.
> > 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  drivers/media/video/videobuf2-core.c |   17 +++--------------
> >  1 files changed, 3 insertions(+), 14 deletions(-)
> > 
> > diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
> > index 6ba1461..ad75c95 100644
> > --- a/drivers/media/video/videobuf2-core.c
> > +++ b/drivers/media/video/videobuf2-core.c
> > @@ -1372,27 +1372,16 @@ static int __vb2_cleanup_fileio(struct vb2_queue *q);
> >  unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
> >  {
> >  	unsigned long flags;
> > -	unsigned int ret;
> >  	struct vb2_buffer *vb = NULL;
> >  
> >  	/*
> >  	 * Start file I/O emulator only if streaming API has not been used yet.
> >  	 */
> >  	if (q->num_buffers == 0 && q->fileio == NULL) {
> > -		if (!V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_READ)) {
> > -			ret = __vb2_init_fileio(q, 1);
> > -			if (ret)
> > -				return POLLERR;
> > -		}
> > -		if (V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_WRITE)) {
> > -			ret = __vb2_init_fileio(q, 0);
> > -			if (ret)
> > -				return POLLERR;
> > -			/*
> > -			 * Write to OUTPUT queue can be done immediately.
> > -			 */
> > +		if (!V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_READ))
> > +			return POLLIN | POLLRDNORM;
> > +		if (V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_WRITE))
> >  			return POLLOUT | POLLWRNORM;
> > -		}
> >  	}
> 
> There is one behavior change on this patchset:  __vb2_init_fileio() checks for some
> troubles that may happen during device streaming initialization, returning POLLERR
> if there is a problem there.
> 
> By moving this code to be called only at read, it means the poll() will not fail
> anymore, but the first read() will fail. The man page for read() doesn't tell that
> -EBUSY or -ENOMEM could happen there. The same happens with V4L2 specs. So, it is
> clearly violating kernel ABI.
> 
> NACK.

Actually, almost nothing changes in the ABI. It's counterintuitive, but
this is what happens:

1) The poll() function in a driver does not actually return any error codes.
It never did. It returns a poll mask, which is expected to be POLLERR in case
of any error. All that it does is that select() returns if it waits for reading
or writing. Any actual error codes are never propagated. This means BTW that
our poll manual page is wrong (what a surprise), most of those error codes can
never be returned.

2) Suppose we try to start streaming in poll. If this works, then poll returns,
with POLLIN set, and the next read() will succeed (actually, it can return an
error as well, but for other error conditions in case of e.g. hardware errors).

The problem with this is of course that this will also start the streaming if
all we wanted to wait for was an exception. That's not what we want at all.
Ideally we could inspect in the driver what the caller wanted to wait for, but
that information is not available, unfortunately.

3) The other case is that we try to start streaming in poll and it fails.
In that case any errors are lost and poll returns POLLERR (note that the poll(2)
manual page says that POLLERR is for output only, but clearly in the linux
kernel it is accepted both input and output).

But for the select() call this POLLERR information is lost as well and the
application will call read() anyway, which now will attempt to start the
streaming (again after poll() tried it the first time) and this time it
returns the actual error code.

Just try this with capture-example: start it in mmap mode, then try to run
it in read mode from a second console. The EBUSY error comes from the read()
command, not from select(). With or without this patch, capture-example
behaves exactly the same.

The only ABI change I see is with poll(2) and epoll(7) where POLLERR is no
longer returned. Since this isn't documented at all anyway (and the poll(2)
manual page is actually unclear about whether you can expect it), I am
actually quite happy with this change. After this analysis I realized it is
even better than expected.

I never liked that poll starts streaming, poll should be a fast function,
not something that does a lot of other things.

It's actually a very nice change, but I admit that it is tricky to analyze.

Regards,

	Hans
