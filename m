Return-path: <mchehab@pedra>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:1071 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab1F2GbF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2011 02:31:05 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFCv3 PATCH 12/18] vb2_poll: don't start DMA, leave that to the first read().
Date: Wed, 29 Jun 2011 08:30:30 +0200
Cc: Andy Walls <awalls@md.metrocast.net>, linux-media@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
References: <1307459123-17810-1-git-send-email-hverkuil@xs4all.nl> <4E09CC6A.8080900@redhat.com> <201106281558.37065.hverkuil@xs4all.nl>
In-Reply-To: <201106281558.37065.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106290830.30494.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday, June 28, 2011 15:58:36 Hans Verkuil wrote:
> On Tuesday, June 28, 2011 14:43:22 Mauro Carvalho Chehab wrote:
> > Em 28-06-2011 09:21, Andy Walls escreveu:
> > > Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> > 
> > >> I'm not very comfortable with vb2 returning unexpected errors there.
> > >> Also,
> > >> for me it is clear that, if read will fail, POLLERR should be rised.
> > >>
> > >> Mauro. 
> > >> --
> > >> To unsubscribe from this list: send the line "unsubscribe linux-media"
> > >> in
> > >> the body of a message to majordomo@vger.kernel.org
> > >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > 
> > > It is also the case that a driver's poll method should never sleep.
> > 
> > True.
> 
> Actually, it is allowed, but only since kernel 2.6.29 (before that it could
> apparently give rise to busy looping if you were unlucky). But the main use
> case is userspace file systems like fuse. Not so much in regular drivers.
> 
> Since drivers can sleep when starting streaming (ivtv will do that, in any
> case), we were in violation of the poll kernel API for a long time :-)
> 
> > > I will try to find the conversation I had with laurent on interpreting the POSIX spec on error returns from select() and poll().  I will also try to find links to previos discussion with Hans on this.
> > > 
> > > One issue is how to start streaming with apps that:
> > > - Open /dev/video/ in a nonblocking mode, and
> > > - Use the read() method
> > > 
> > > while doing it in a way that is POSIX compliant and doesn't break existing apps.  
> > 
> > Well, a first call for poll() may rise a thread that will prepare the buffers, and
> > return with 0 while there's no data available.
> 
> There is actually no guarantee whatsoever that if poll says you can read(), that that
> read also has to succeed. Other threads can have read the data already, and errors may
> have occured. And in fact, just starting streaming gives no guarantee that there is
> anything to read. For example, starting the DMA engine when there is no valid input
> signal. Many drivers (certainly those dealing with digital interfaces as opposed to
> analog) will just sit and wait. A non-blocking read will just return 0 without
> reading anything.
> 
> So the current poll implementation (and that includes the one in videobuf-core.c as
> well) actually does *not* give any guarantee about whether data will be available
> in read().

Never mind this. I didn't look carefully enough: it does start the DMA and then poll
waits for data to arrive. So when poll says there is data, then there is really data.
Although applications should always handle EAGAIN anyway: some drivers do return it,
even when data is supposed to be available (I had to add that to qv4l2 at one time).

Regards,

	Hans

> 
> And from the same POSIX link you posted:
> 
> "The poll() function shall support regular files, terminal and pseudo-terminal devices,
> FIFOs, pipes, sockets and [XSR] [Option Start]  STREAMS-based files. [Option End]
> The behavior of poll() on elements of fds that refer to other types of file is unspecified."
> 
> Note the last line: we do not fall under this posix document.
>  
> > > The other constraint is to ensure when only poll()-ing for exception conditions, not having significant IO side effects.
> > > 
> > > I'm pretty sure sleeping in a driver's poll() method, or having significant side effects, is not ine the spirit of the POSIX select() and poll(), even if the letter of POSIX says nothing about it.
> > > 
> > > The method I suggested to Hans is completely POSIX compliant for apps using read() and select() and was checked against MythTV as having no bad side effects.  (And by thought experiment doesn't break any sensible app using nonblocking IO with select() and read().)
> > > 
> > > I did not do analysis for apps that use mmap(), which I guess is the current concern.
> 
> There isn't a problem with mmap(). For the stream I/O API you have to call STREAMON
> explicitly in order to start streaming. poll() will not do that for you.
> 
> I was thinking that one improvement that could be realized is that vb2_poll could
> do some basic checks, such as checking whether streaming was already in progress
> (EBUSY), but then I realized that it already does that: this code is only active
> if there is no streaming in progress anyway.
> 
> Regards,
> 
> 	Hans
> 
> > 
> > The concern is that it is pointing that there are available data, even when there is an error.
> > This looks like a POSIX violation for me.
> > 
> > Cheers,
> > Mauro.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
