Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:60093 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644AbbHZPR3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Aug 2015 11:17:29 -0400
Date: Wed, 26 Aug 2015 12:17:24 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	shuahkh@osg.samsung.com
Subject: Re: [PATCH v7 15/44] [media] media: get rid of an unused code
Message-ID: <20150826121724.6688bc67@recife.lan>
In-Reply-To: <CAKocOOOsd66roTdJSf6qUmn49Lc7ARqxMEKPGA_LAvfXcowL5g@mail.gmail.com>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
	<5ccb3df9166af331070f546a7d3c522d65964919.1440359643.git.mchehab@osg.samsung.com>
	<55DC1501.5000208@xs4all.nl>
	<20150825071058.29bcc207@recife.lan>
	<CAKocOOOsd66roTdJSf6qUmn49Lc7ARqxMEKPGA_LAvfXcowL5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 25 Aug 2015 16:32:19 -0600
Shuah Khan <shuahkhan@gmail.com> escreveu:

> On Tue, Aug 25, 2015 at 4:10 AM, Mauro Carvalho Chehab
> <mchehab@osg.samsung.com> wrote:
> > Em Tue, 25 Aug 2015 09:10:57 +0200
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >
> >> On 08/23/2015 10:17 PM, Mauro Carvalho Chehab wrote:
> >> > This code is not used in practice. Get rid of it before
> >> > start converting links to lists.
> >>
> >> I assume the reason is that links are always created *after*
> >> entities are registered?
> >
> > That was the assumption. However, Javier found some cases where drivers
> > are creating links before.
> >
> > So, we should either drop this patch and add some additional logic
> > on the next one to handle late graph object init or to fix the
> > drivers before.
> >
> > I'll work on the delayed graph object init, as it sounds the
> > easiest way, but let's see how such change will actually work.
> >
> 
> I think we should drop this patch for now.

We can't, as otherwise it will break compilation on patch 16/44.

What we need to do is to ensure that all drivers will be doing the
right thing before this one.

> I also would like to see
> this new code
> in action on a driver that has DVB and V4L modules and creates entities during
> probe and maybe even links during probe with no specific probe ordering between
> individual module probes. This way we are sure we need this code and know that
> it is correct.

See media-ctl --print-t output:
	http://pastebin.com/ckxafiJB

Please notice that the media-ctl version I'm using doesn't know the DVB
entity types yet, as it needs to be patched to be aware of the new API.
So, it reports the DVB stuff as "unknow entities".

And that's the output of the new tool that uses the new API:
	http://pastebin.com/fRhMcTue

Regards,
Mauro
