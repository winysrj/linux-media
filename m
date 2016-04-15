Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:36721 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585AbcDOJry (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Apr 2016 05:47:54 -0400
Date: Fri, 15 Apr 2016 06:47:47 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>, <nenggun.kim@samsung.com>,
	<akpm@linux-foundation.org>, <jh1009.sung@samsung.com>,
	<inki.dae@samsung.com>, <arnd@arndb.de>,
	<linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] media: saa7134 fix media_dev alloc error path to not
 free when alloc fails
Message-ID: <20160415064747.2735370d@recife.lan>
In-Reply-To: <57101729.1030909@samsung.com>
References: <1460651480-6935-1-git-send-email-shuahkh@osg.samsung.com>
	<20160414180858.43c8620b@recife.lan>
	<57101729.1030909@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 14 Apr 2016 16:18:17 -0600
Shuah Khan <shuah.kh@samsung.com> escreveu:

> On 04/14/2016 03:08 PM, Mauro Carvalho Chehab wrote:
> > Em Thu, 14 Apr 2016 10:31:20 -0600
> > Shuah Khan <shuahkh@osg.samsung.com> escreveu:
> >   
> >> media_dev alloc error path does kfree when alloc fails. Fix it to not call
> >> kfree when media_dev alloc fails.  
> > 
> > No need. kfree(NULL) is OK.  
> 
> Agreed.
> 
> > 
> > Adding a label inside a conditional block is ugly.  
> 
> In this case, if label is in normal path, we will see defined, but not
> used warnings when condition isn't defined. 

True, but we don't need a label here, as kfree() can be called with a null
pointer.

> We seem to have many such
> cases for CONFIG_MEDIA_CONTROLLER :(

We may try to address those media-controller dependent code latter on.

I have some ideas of adding some macros and helper functions to allow
getting rid of those ifdefs and not add extra code if !MEDIA_CONTROLLER,
but the better seems to first add MC support to ALSA and make the
enable/disable functions generic, and then cleanup the code to remove
those ifdefs.

> 
> thanks,
> -- Shuah
> 
> 


-- 
Thanks,
Mauro
