Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:46046 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932346AbcDLOTu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Apr 2016 10:19:50 -0400
Date: Tue, 12 Apr 2016 11:19:45 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Russel Winder <russel@winder.org.uk>
Cc: DVB_Linux_Media <linux-media@vger.kernel.org>
Subject: Re: libdvbv5 licencing
Message-ID: <20160412111945.22846572@recife.lan>
In-Reply-To: <1458972788.3344.8.camel@winder.org.uk>
References: <1458972788.3344.8.camel@winder.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Russel,

Em Sat, 26 Mar 2016 06:13:08 +0000
Russel Winder <russel@winder.org.uk> escreveu:

> I hadn't noticed previously, but it has been brought to my attention
> that libdvbv5 is licenced as GPLv2. This makes it impossible
> (effectively) for any non-GPL code to make use of libdvbv5. This seems
> to undermine the whole point of libdvbv5. 
> 
> In particular, I wanted to rip out all the Linux API based code from
> the GStreamer DVB plugins and replace it with use of libdvbv5. However
> because of the licencing (GStreamer is LGPL and must only use LGPL or
> more liberal licenced code), this is going to be impossible.
> 
> Instead of ripping out the current code (which is DVBv3) and using
> libdvbv5, it looks like I will be forced to recreate libdvbv5 but as
> LGPL code.
> 
> Is there any chance of relicencing libdvbv5 as LGPL code so that others
> may use it?

Yes. We had some discussions in the past to re-license it to LGPL,
if this is going to be used by some other OSS project that would
require that. Most of the code was written by me, and, in the past
the other developers that worked on that also agreed on re-licensing
as LGPL.

So, basically, if gstreamer is willing to use libdvbv5, we'll
relicense it to LGPL.

Regards,
Mauro
