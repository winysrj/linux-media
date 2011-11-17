Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42184 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398Ab1KQSQh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Nov 2011 13:16:37 -0500
Date: Thu, 17 Nov 2011 10:09:41 -0800
From: Greg KH <gregkh@suse.de>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	devel@driverdev.osuosl.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/3] Move media staging drivers to staging/media
Message-ID: <20111117180941.GA13717@suse.de>
References: <20111102094509.4954fead@redhat.com>
 <20111102151009.GA22699@suse.de>
 <CA+i0qc4v=X+swmTdc26nTcjFSnj1kSpKvhG2vvQeaRbKTxjmQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+i0qc4v=X+swmTdc26nTcjFSnj1kSpKvhG2vvQeaRbKTxjmQQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 17, 2011 at 07:47:50PM +0200, Tomas Winkler wrote:
> On Wed, Nov 2, 2011 at 5:10 PM, Greg KH <gregkh@suse.de> wrote:
> > On Wed, Nov 02, 2011 at 09:45:09AM -0200, Mauro Carvalho Chehab wrote:
> >> Greg,
> >>
> >> As agreed, this is the patches that move media drivers to their
> 
> I've probably missed the news so  I'd like ask what is the current
> patch flow for staging/media?
> Are the patches applied first to linux-media and then merged to the
> greg's staging tree or the staging tree remains the first sync point?

Mauro handles all of the drivers/staging/media/ patches, I'm going to
just ignore them all, or, worse case, just bounce them to him :)

thanks,

greg k-h
