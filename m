Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:48988 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201AbcD1Qnm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Apr 2016 12:43:42 -0400
Date: Thu, 28 Apr 2016 13:43:29 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
	Shuah Khan <shuah.kh@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Rafael =?UTF-8?B?TG91cmVuw6dv?= de Lima Chehab
	<chehabrafael@gmail.com>
Subject: Re: [PATCH 4/4] [meida] media-device: dynamically allocate struct
 media_devnode
Message-ID: <20160428134329.5e60ec3e@recife.lan>
In-Reply-To: <572238EE.2090303@osg.samsung.com>
References: <cover.1458760750.git.mchehab@osg.samsung.com>
	<0e1737bc1fd4fb4c114cd1f4823767a35b5c5b77.1458760750.git.mchehab@osg.samsung.com>
	<4033448.cTfoZapJ5n@avalon>
	<20160324083710.24d0d57e@recife.lan>
	<57213B48.50109@samsung.com>
	<20160428084155.65c812b1@recife.lan>
	<57222353.6090107@osg.samsung.com>
	<20160428120453.40889d4b@recife.lan>
	<572238EE.2090303@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Shuah,

Em Thu, 28 Apr 2016 10:23:10 -0600
Shuah Khan <shuahkh@osg.samsung.com> escreveu:

> >>> I'm running it today with the stress test. So far (~100 unbind loops, with 5
> >>> concurrent accesses via mc_nextgen_test), the only issue it got so
> >>> far seems to be at V4L2 cdev stuff (not at the media side, but at the
> >>> V4L2 API side):    
> >>
> >> Are you planning to debug this further to isolate the problem?  
> > 
> > Not now. I didn't actually check the code, but, after thinking
> > a little bit more, this is very likely the media cdev issue.
> > your cdev patch setting the parent should fix it.  
> 
> Looks like you still have some comments from Lars that aren't
> addressed - looking at the
> 
> https://git.linuxtv.org/mchehab/experimental.git/commit/?h=au0828-unbind-fixes-v5&id=0ab1eadf69c73e66860d2ee3ed8d7ceebac222d5
> 
> Please see inline on what needs fixing:
> 
> > + struct media_device *dev = devnode->media_dev;  
> 
> You need a lock to protect this from running concurrently with
> media_device_unregister() otherwise the struct might be freed while still in
> use.

Let's not try to solve multiple multiple different issues in the
same patch. The rule is one patch per logical change.

This one deals *only* with the dynamic allocation of media_devnode.

So, adding other locks, using krefs, cdevs, etc should be done on
separate patches.

> Not sure if this follwoing comment is relevant for your patch.
> It was for mine.

It is relevant: accessing mdev from devnode should be protected,
e. g. we cannot let the driver free media_dev() while the pointer
is being used.

I guess this could easily be fixed by locking any changes to
devnode->media_dev using the media devnode static lock.

> mdev->devnode->media_dev needs to be set to NULL.

I guess my patch already does that.

> 
> Please let me know once you have these addressed. Are you planning to
> send the patch out for review once these comments are addressed?
> 
> thanks,
> -- Shuah
