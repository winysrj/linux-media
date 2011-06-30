Return-path: <mchehab@pedra>
Received: from sj-iport-3.cisco.com ([171.71.176.72]:50517 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057Ab1F3Nql (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jun 2011 09:46:41 -0400
From: Hans Verkuil <hansverk@cisco.com>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: RFC: poll behavior
Date: Thu, 30 Jun 2011 15:46:35 +0200
Cc: linux-media@vger.kernel.org
References: <201106291326.47527.hansverk@cisco.com> <201106291543.51271.hansverk@cisco.com> <4E0B3818.5060200@redhat.com>
In-Reply-To: <4E0B3818.5060200@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106301546.35803.hansverk@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wednesday, June 29, 2011 16:35:04 Hans de Goede wrote:
> Hi,
> 
> On 06/29/2011 03:43 PM, Hans Verkuil wrote:
> > On Wednesday, June 29, 2011 15:07:14 Hans de Goede wrote:
> 
> <snip>
> 
> >   	if (q->num_buffers == 0&&  q->fileio == NULL) {
> > -		if (!V4L2_TYPE_IS_OUTPUT(q->type)&&  (q->io_modes&  VB2_READ)) {
> > -			ret = __vb2_init_fileio(q, 1);
> > -			if (ret)
> > -				return POLLERR;
> > -		}
> > -		if (V4L2_TYPE_IS_OUTPUT(q->type)&&  (q->io_modes&  VB2_WRITE)) {
> > -			ret = __vb2_init_fileio(q, 0);
> > -			if (ret)
> > -				return POLLERR;
> > -			/*
> > -			 * Write to OUTPUT queue can be done immediately.
> > -			 */
> > -			return POLLOUT | POLLWRNORM;
> > -		}
> > +		if (!V4L2_TYPE_IS_OUTPUT(q->type)&&  (q->io_modes&  VB2_READ))
> > +			return res | POLLIN | POLLRDNORM;
> > +		if (V4L2_TYPE_IS_OUTPUT(q->type)&&  (q->io_modes&  VB2_WRITE))
> > +			return res | POLLOUT | POLLWRNORM;
> >   	}
> >
> >   	/*
> >   	 * There is nothing to wait for if no buffers have already been 
queued.
> >   	 */
> >   	if (list_empty(&q->queued_list))
> > -		return POLLERR;
> > +		return have_events ? res : POLLERR;
> >
> 
> This seems more accurate to me, given that in case of select the 2 influence
> different fd sets:
> 
> 		return res | POLLERR;

Hmm. The problem is that the poll(2) API will always return if POLLERR is set, 
even if you only want to wait on POLLPRI. That's a perfectly valid thing to 
do. An alternative is to just not use POLLERR and return res|POLLIN or res|
POLLOUT depending on V4L2_TYPE_IS_OUTPUT().

Another option is to just return res (which is your suggestion below as well).
I think this is also a reasonable approach. It would in fact allow one thread 
to call poll(2) and another thread to call REQBUFS/QBUF/STREAMON on the same 
filehandle. And the other thread would return from poll(2) as soon as the 
first frame becomes available.

This also leads to another ambiguity with poll(): what should poll do if 
another filehandle started streaming? So fh1 called STREAMON (and so becomes 
the 'owner' of the stream), and you poll on fh2. If a frame becomes available, 
should fh2 wake up? Is fh2 allowed to call DQBUF?

To be honest, I think vb2 should keep track of the filehandle that started 
streaming rather than leaving that to drivers, but that's a separate issue.

I really wonder whether we should ever use POLLERR at all: it is extremely
vague how it should be interpreted, and it doesn't actually tell you what is 
wrong. And is it really an error if you poll on a non-streaming node?

As shown by the use-case above, I don't think it is an error at all.

The default poll mask that is returned when the device doesn't support poll
is #define DEFAULT_POLLMASK (POLLIN | POLLOUT | POLLRDNORM | POLLWRNORM).

So if they don't return POLLERR for such devices, perhaps we shouldn't either.

Regards,

	Hans

> 
> >   	poll_wait(file,&q->done_wq, wait);
> >
> > @@ -1414,10 +1416,10 @@ unsigned int vb2_poll(struct vb2_queue *q, struct 
file *file, poll_table *wait)
> >
> >   	if (vb&&  (vb->state == VB2_BUF_STATE_DONE
> >   			|| vb->state == VB2_BUF_STATE_ERROR)) {
> > -		return (V4L2_TYPE_IS_OUTPUT(q->type)) ? POLLOUT | POLLWRNORM :
> > +		return res | (V4L2_TYPE_IS_OUTPUT(q->type)) ? POLLOUT | 
POLLWRNORM :
> >   			POLLIN | POLLRDNORM;
> 
> I would prefer to see this as:
> 		res |= (V4L2_TYPE_IS_OUTPUT(q->type)) ? POLLOUT | POLLWRNORM :
> 			POLLIN | POLLRDNORM;
> 
> 
> >   	}
> > -	return 0;
> > +	return res;
> >   }
> >   EXPORT_SYMBOL_GPL(vb2_poll);
> >
> >
> > One note: the only time POLLERR is now returned is if no buffers have been 
queued
> > and no events have been subscribed to. I think that qualifies as an error 
condition.
> > I am not 100% certain, though.
> 
> I think it would be better to simply wait (iow return 0) then. I know that
> gstreamer for example uses separate consumer and producer threads, so it is
> possible for the producer thread to wait in select while all buffers have 
been
> handed to the (lagging) consumer thread, once the consumer thread has 
consumed
> a buffer it will queue it, and once filled the select will return it to
> the producer thread, who shoves it into the pipeline again, etc.
> 
> Regards,
> 
> Hans
> 
> 
