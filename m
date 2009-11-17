Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47139 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbZKQQ2y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 11:28:54 -0500
Date: Tue, 17 Nov 2009 14:28:20 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Cc: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Help in adding documentation
Message-ID: <20091117142820.1e62a362@pedra.chehab.org>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE401559C59A2@dlee06.ent.ti.com>
References: <A69FA2915331DC488A831521EAE36FE401559C59A2@dlee06.ent.ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 17 Nov 2009 10:00:07 -0600
"Karicheri, Muralidharan" <m-karicheri2@ti.com> escreveu:

> >Hi Mauro,
> >
> >Is there some instructions on adding new sections in the v4l2 documentation.

No, sorry. The documentation build is undocumented..

> >I had been struggling yesterday to add my documentation for video timing
> >API. It is easy to make minor documentation changes. But since I am adding
> >new ioctls, Looks like I need to create vidioc-<xxx>.xml under DoCBook/v4l/
> >directory since media-specs/Makefile is generating videodev2.h.xml
> >automatically (I learned it in the hard way). 

Yes, this is the better way: create a separate xml file for it, to keep the
same concept used there.

> >I have added the IOCTL name
> >in media-specs/Makefile and also added the structure name. 

We may try to add the ioctls automatically at the Makefile. I started doing things
like that at the DVB side of the Makefile. It is not that hard, since all we need
to do is to check for _IO defines at videodev2.h.

> >But somehow, the
> >videodev2.h.xml file doesn't show my structure types documented in vidioc-
> ><xxx>.xml. Any idea what could be wrong?

Probably, the name is wrong. Maybe lower-case/upper-case? Some DocBook tool
versions are case sensitive, while others aren't.

> After compilation I get the following error
> Error: no ID for contstraint linkend: v4l2-dv-enum-presets.
> v4l2-dv-enum-presets is the new structure type added. 

This probably means that videodev2.h has it defined, while you didn't have the
link id created at the xml file you've created.

You probably need a tag like:

<table pgwide="1" frame="none" id="v4l2-dv-enum-presets">
<!-- your enum table -->
</table>


Cheers,
Mauro
