Return-path: <mchehab@pedra>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1081 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161Ab1GAJqA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Jul 2011 05:46:00 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: RFC: poll behavior
Date: Fri, 1 Jul 2011 11:45:51 +0200
Cc: Hans Verkuil <hansverk@cisco.com>,
	Hans de Goede <hdegoede@redhat.com>,
	linux-media@vger.kernel.org
References: <201106291326.47527.hansverk@cisco.com> <201106301546.35803.hansverk@cisco.com> <4E0CDE03.1040906@redhat.com>
In-Reply-To: <4E0CDE03.1040906@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107011145.51118.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thursday, June 30, 2011 22:35:15 Mauro Carvalho Chehab wrote:
> Em 30-06-2011 10:46, Hans Verkuil escreveu:
> > On Wednesday, June 29, 2011 16:35:04 Hans de Goede wrote:
> >> Hi,
> >>
> >> On 06/29/2011 03:43 PM, Hans Verkuil wrote:
> >>> On Wednesday, June 29, 2011 15:07:14 Hans de Goede wrote:
> >>
> >> <snip>
> >>
> >>>   	if (q->num_buffers == 0&&  q->fileio == NULL) {
> >>> -		if (!V4L2_TYPE_IS_OUTPUT(q->type)&&  (q->io_modes&  VB2_READ)) {
> >>> -			ret = __vb2_init_fileio(q, 1);
> >>> -			if (ret)
> >>> -				return POLLERR;
> >>> -		}
> >>> -		if (V4L2_TYPE_IS_OUTPUT(q->type)&&  (q->io_modes&  VB2_WRITE)) {
> >>> -			ret = __vb2_init_fileio(q, 0);
> >>> -			if (ret)
> >>> -				return POLLERR;
> >>> -			/*
> >>> -			 * Write to OUTPUT queue can be done immediately.
> >>> -			 */
> >>> -			return POLLOUT | POLLWRNORM;
> >>> -		}
> >>> +		if (!V4L2_TYPE_IS_OUTPUT(q->type)&&  (q->io_modes&  VB2_READ))
> >>> +			return res | POLLIN | POLLRDNORM;
> >>> +		if (V4L2_TYPE_IS_OUTPUT(q->type)&&  (q->io_modes&  VB2_WRITE))
> >>> +			return res | POLLOUT | POLLWRNORM;
> 
> It is wrong to return POLLIN/POLLOUT if the stream hasn't started yet. You should
> return it only when data is ready. Otherwise you should return 0.
> 
> >>>   	}
> >>>
> >>>   	/*
> >>>   	 * There is nothing to wait for if no buffers have already been 
> > queued.
> >>>   	 */
> >>>   	if (list_empty(&q->queued_list))
> >>> -		return POLLERR;
> >>> +		return have_events ? res : POLLERR;
> >>>
> >>
> >> This seems more accurate to me, given that in case of select the 2 influence
> >> different fd sets:
> >>
> >> 		return res | POLLERR;
> > 
> > Hmm. The problem is that the poll(2) API will always return if POLLERR is set, 
> > even if you only want to wait on POLLPRI.
> 
> Yes, but this is the right thing to do: an error condition has happened. If you're
> in doubt, think that poll() is being used for a text file or a socket: if the connection
> has dropped, or there's a problem to access the file, poll() needs to return, as there is
> a condition error that needs to be handled.
> 
> > That's a perfectly valid thing to 
> > do. An alternative is to just not use POLLERR and return res|POLLIN or res|
> > POLLOUT depending on V4L2_TYPE_IS_OUTPUT().
> 
> You should only rise POLLERR if a problem happened at the events delivery or at
> the device streaming.
> 
> > Another option is to just return res (which is your suggestion below as well).
> > I think this is also a reasonable approach. It would in fact allow one thread 
> > to call poll(2) and another thread to call REQBUFS/QBUF/STREAMON on the same 
> > filehandle. And the other thread would return from poll(2) as soon as the 
> > first frame becomes available.
> > 
> > This also leads to another ambiguity with poll(): what should poll do if 
> > another filehandle started streaming? So fh1 called STREAMON (and so becomes 
> > the 'owner' of the stream), and you poll on fh2. If a frame becomes available, 
> > should fh2 wake up? Is fh2 allowed to call DQBUF?
> 
> IMO, both fh's should get the same results. This is what happens if you're
> writing into a file and two or more processes are selecting at the EOF.

Yes, but multiple filehandles are allowed to write/read from a file at the
same time. That's not true for V4L2. Only one filehandle can do I/O at a time.

I'm going to look into changing fs/select.c so that the poll driver function
can actually see the event mask provided by the application.

Regards,

	Hans

> 
> Anyway, changing from the current behavior may break applications.
> 
> > To be honest, I think vb2 should keep track of the filehandle that started 
> > streaming rather than leaving that to drivers, but that's a separate issue.
> > 
> > I really wonder whether we should ever use POLLERR at all: it is extremely
> > vague how it should be interpreted, and it doesn't actually tell you what is 
> > wrong. And is it really an error if you poll on a non-streaming node?
> 
> See above. You need to rise it if, for example, an error occurred, and no data
> will be ready for read(), write() or DQEVENT. That's the reason why POLLERR
> exists.
> 
> Cheers,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
