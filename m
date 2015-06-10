Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:41796 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086AbbFJURh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2015 16:17:37 -0400
Date: Wed, 10 Jun 2015 17:17:32 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Andy Furniss <adf.lists@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: dvbv5-tzap with pctv 290e/292e needs EAGAIN for pat/pmt to work
 when recording.
Message-ID: <20150610171732.49e60671@recife.lan>
In-Reply-To: <20150610155047.25b92662@recife.lan>
References: <556E2D5B.5080201@gmail.com>
	<20150610095215.79e5e77e@recife.lan>
	<55787382.5010607@gmail.com>
	<20150610155047.25b92662@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 10 Jun 2015 15:50:47 -0300
Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:

> Em Wed, 10 Jun 2015 18:27:30 +0100
> Andy Furniss <adf.lists@gmail.com> escreveu:
> 
> > Mauro Carvalho Chehab wrote:
> > 
> > > Just applied a fix for it:
> > > 	http://git.linuxtv.org/cgit.cgi/v4l-utils.git/commit/?id=c7c9af17163f282a147ea76f1a3c0e9a0a86e7fa
> > >
> > > It will retry up to 10 times. This should very likely be enough if the
> > > driver doesn't have any bug.
> > >
> > > Please let me know if this fixes the issue.
> > 
> > No, it doesn't, so I reverted the above and added back my hack + a 
> > counter as below and it seems to be retrying > a million times.
> 
> Hmm.... that's likely a bug at the demod driver. It doesn't make much
> sense to keep a mutex hold for that long. 
> 
> Anyway, I modified the patch to use a timeout of 1 second, instead of
> trying 10 times. It is still a hack, as IMHO this is a driver bug,
> but it should produce a better result.
> 
> Please check if the patch below works for you.
> 
> You may change the MAX_TIME there if 1 second is not enough.
> 
> It could be interesting if you add a printf with the difference
> between start and end time, for us to have an idea about how
> much time the driver is kept on such unreliable state.

Actually, there was an error on that patch. I did some tests here
with a PCTV 292e. While I was not able to reproduce the issue
you're reporting, I forced some errors. The patch should be
working. The only question is if 1 second is enough or not.

So, please test.

PS.: the patch was already merged upstream.

Regards,
Mauro
