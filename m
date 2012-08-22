Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([75.149.91.89]:35619 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932663Ab2HVPTi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Aug 2012 11:19:38 -0400
Date: Wed, 22 Aug 2012 10:19:37 -0500 (CDT)
From: Mike Isely <isely@isely.net>
Reply-To: Mike Isely at pobox <isely@pobox.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>,
	Andy Walls <awalls@md.metrocast.net>
Subject: Re: RFC: Core + Radio profile
In-Reply-To: <5034E1C2.30205@redhat.com>
Message-ID: <alpine.DEB.2.00.1208221013110.8031@cnc.isely.net>
References: <201208221140.25656.hverkuil@xs4all.nl> <201208221211.47842.hverkuil@xs4all.nl> <5034E1C2.30205@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 22 Aug 2012, Mauro Carvalho Chehab wrote:

> Em 22-08-2012 07:11, Hans Verkuil escreveu:
> > I've added some more core profile requirements.
> 
> >>
> >> Streaming I/O is not supported by radio nodes.
> 
> 	Hmm... pvrusb2/ivtv? Ok, it makes sense to move it to use the alsa
> mpeg API there. If we're enforcing it, we should deprecate the current way
> there, and make it use ALSA.

I am unaware of any ALSA MPEG API.  It's entirely likely that this is 
because I haven't been paying attention.  Nevertheless, can you please 
point me at any documentation on this so I can get up to speed?

Currently the pvrusb2 driver does not attempt to perform any processing 
or filtering of the data stream, so radio data is just the same mpeg 
stream as video (but without any real embedded video data).  If I have 
to get into the business of processing the MPEG data in order to adhere 
to this proposal, then that will be a very big deal for this driver.

  -Mike

-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
