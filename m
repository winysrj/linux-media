Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46287 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755141AbZB0Phu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Feb 2009 10:37:50 -0500
Date: Fri, 27 Feb 2009 12:37:14 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Douglas Schilling Landgraf <dougsland@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Old Video ML <video4linux-list@redhat.com>
Subject: Re: Conversion of vino driver for SGI to not use the legacy decoder
 API
Message-ID: <20090227123714.393831b0@pedra.chehab.org>
In-Reply-To: <20090227105057.6dc04bf0@gmail.com>
References: <20090226214742.6576f30b@pedra.chehab.org>
	<200902270819.17862.hverkuil@xs4all.nl>
	<20090227100947.160abd0b@hyperion.delvare>
	<20090227082216.574b42cf@pedra.chehab.org>
	<20090227105057.6dc04bf0@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 27 Feb 2009 10:50:57 -0300
Douglas Schilling Landgraf <dougsland@gmail.com> wrote:

> > Douglas,
> > 
> > As you've done several radio conversions to V4L2 API, maybe you can
> > also handle this one.
> 
> yes.

Hmm... too late, I've just converted it ;) My Internet connection dropped and I
was without email access, so... Well, it is done.

I'll commit the changesets right now. Could you please help reviewing it? I'll
also forward it to -alsa people.


Cheers,
Mauro
