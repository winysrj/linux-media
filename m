Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37028 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366AbcCHNj3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Mar 2016 08:39:29 -0500
Date: Tue, 8 Mar 2016 10:39:22 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Dan Allen <dan@opendevise.io>
Cc: Jani Nikula <jani.nikula@intel.com>,
	Russel Winder <russel@winder.org.uk>,
	Keith Packard <keithp@keithp.com>,
	Jonathan Corbet <corbet@lwn.net>,
	LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Graham Whaley <graham.whaley@linux.intel.com>
Subject: Re: Kernel docs: muddying the waters a bit
Message-ID: <20160308103922.48d87d9d@recife.lan>
In-Reply-To: <CAKeHnO7R25knFH07+3trdi0ZotsrEE+5ZzDZXdx33+DUW=q2Ug@mail.gmail.com>
References: <20160213145317.247c63c7@lwn.net>
	<87y49zr74t.fsf@intel.com>
	<20160303071305.247e30b1@lwn.net>
	<20160303155037.705f33dd@recife.lan>
	<86egbrm9hw.fsf@hiro.keithp.com>
	<1457076530.13171.13.camel@winder.org.uk>
	<CAKeHnO6sSV1x2xh_HgbD5ddZ8rp+SVvbdjVhczhudc9iv_-UCQ@mail.gmail.com>
	<87a8m9qoy8.fsf@intel.com>
	<20160308082948.4e2e0f82@recife.lan>
	<CAKeHnO7R25knFH07+3trdi0ZotsrEE+5ZzDZXdx33+DUW=q2Ug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 08 Mar 2016 05:13:13 -0700
Dan Allen <dan@opendevise.io> escreveu:

> On Tue, Mar 8, 2016 at 4:29 AM, Mauro Carvalho Chehab <
> mchehab@osg.samsung.com> wrote:  
> 
> > pandoc did a really crap job on the conversion. To convert this
> > into something useful, we'll need to spend a lot of time, as it lost
> > most of the cross-references, as they were defined via DocBook macros.
> >  
> 
> I agree pandoc creates crappy AsciiDoc. We have a much better converter in
> the works called DocBookRx.
> 
> https://github.com/opendevise/docbookrx
> 
> It has converted several very serious DocBook documents and we're
> continuing to improve it. It's also a lot easier to hack than pandoc.

Didn't work:

$ ./bin/docbookrx ~/devel/docbook_test/v4l2.xml 
No visitor defined for <part>! Skipping.
No visitor defined for <part>! Skipping.
No visitor defined for <part>! Skipping.
No visitor defined for <part>! Skipping.
No visitor defined for <appendixinfo>! Skipping.


> 
> -Dan
> 
> 


-- 
Thanks,
Mauro
