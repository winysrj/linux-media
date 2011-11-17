Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48171 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754346Ab1KQT3x (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Nov 2011 14:29:53 -0500
Date: Thu, 17 Nov 2011 11:22:16 -0800
From: Greg KH <gregkh@suse.de>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	devel@driverdev.osuosl.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/3] Move media staging drivers to staging/media
Message-ID: <20111117192216.GA32280@suse.de>
References: <20111102094509.4954fead@redhat.com>
 <20111102151009.GA22699@suse.de>
 <CA+i0qc4v=X+swmTdc26nTcjFSnj1kSpKvhG2vvQeaRbKTxjmQQ@mail.gmail.com>
 <20111117180941.GA13717@suse.de>
 <CA+i0qc6yCjo+abxf8L5LvLqUfXPE8xN0fBqaFigLAmgXLNZvqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+i0qc6yCjo+abxf8L5LvLqUfXPE8xN0fBqaFigLAmgXLNZvqg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 17, 2011 at 09:10:27PM +0200, Tomas Winkler wrote:
> On Thu, Nov 17, 2011 at 8:09 PM, Greg KH <gregkh@suse.de> wrote:
> > On Thu, Nov 17, 2011 at 07:47:50PM +0200, Tomas Winkler wrote:
> >> On Wed, Nov 2, 2011 at 5:10 PM, Greg KH <gregkh@suse.de> wrote:
> >> > On Wed, Nov 02, 2011 at 09:45:09AM -0200, Mauro Carvalho Chehab wrote:
> >> >> Greg,
> >> >>
> >> >> As agreed, this is the patches that move media drivers to their
> >>
> >> I've probably missed the news so  I'd like ask what is the current
> >> patch flow for staging/media?
> >> Are the patches applied first to linux-media and then merged to the
> >> greg's staging tree or the staging tree remains the first sync point?
> >
> > Mauro handles all of the drivers/staging/media/ patches, I'm going to
> > just ignore them all, or, worse case, just bounce them to him :)
> 
> Thanks for clarification. One more thing should I also omit posting to
> the  driverdev mailing list?

Probably, I doubt anyone there cares about these drivers, but hey, it
can't hurt :)

thanks,

greg k-h
