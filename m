Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f181.google.com ([209.85.216.181]:38036 "EHLO
        mail-qt0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966075AbdKQRUp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Nov 2017 12:20:45 -0500
Date: Fri, 17 Nov 2017 15:20:36 -0200
From: Gustavo Padovan <gustavo@padovan.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        Thierry Escande <thierry.escande@collabora.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: Re: [RFC v5 07/11] [media] vb2: add in-fence support to QBUF
Message-ID: <20171117172036.GJ19033@jade>
References: <20171115171057.17340-1-gustavo@padovan.org>
 <20171115171057.17340-8-gustavo@padovan.org>
 <20171117105351.3bb0af32@vento.lan>
 <20171117131248.GI19033@jade>
 <20171117114751.2dc10542@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171117114751.2dc10542@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-11-17 Mauro Carvalho Chehab <mchehab@osg.samsung.com>:

> Em Fri, 17 Nov 2017 11:12:48 -0200
> Gustavo Padovan <gustavo@padovan.org> escreveu:
> 
> > > >  	/*
> > > >  	 * If streamon has been called, and we haven't yet called
> > > >  	 * start_streaming() since not enough buffers were queued, and
> > > >  	 * we now have reached the minimum number of queued buffers,
> > > >  	 * then we can finally call start_streaming().
> > > > -	 *
> > > > -	 * If already streaming, give the buffer to driver for processing.
> > > > -	 * If not, the buffer will be given to driver on next streamon.
> > > >  	 */
> > > >  	if (q->streaming && !q->start_streaming_called &&
> > > > -	    q->queued_count >= q->min_buffers_needed) {
> > > > +	    __get_num_ready_buffers(q) >= q->min_buffers_needed) {  
> > > 
> > > I guess the case where fences is not used is not covered here.
> > > 
> > > You probably should add a check at __get_num_ready_buffers(q)
> > > as well, making it just return q->queued_count if fences isn't
> > > used.  
> > 
> > We can't know that beforehand, some buffer ahead may have a fence,
> > but there is already a check for !fence for each buffer. If none of
> > them have fences the return will be equal to q->queued_count.
> 
> Hmm... are we willing to support the case where just some
> buffers have fences? Why?

It may be that some fences are already signaled before the QBUF call
happens, so the app may just pass -1 instead.

> In any case, we should add a notice at the documentation telling
> about what happens if not all buffers have fences, and if fences
> are required to be setup before starting streaming, or if it is
> possible to dynamically change the fances behavior while streaming.

We don't have such thing. The fence behavior is tied to each QBUF call,
the stream can be setup without knowing anything about if fences are
going to be used or not. I think we need a good reason to do otherwise.
Yet, I can add something to the docs saying that fences are exclusively
per QBUF call.

Gustavo
