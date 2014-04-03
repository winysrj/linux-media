Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:38885 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbaDCWG2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Apr 2014 18:06:28 -0400
Date: Thu, 03 Apr 2014 19:06:19 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	james.hogan@imgtec.com
Subject: Re: [GIT PULL for v3.15-rc1] media updates
Message-id: <20140403190619.4878ddb4@samsung.com>
In-reply-to: <20140403214656.GA4662@hardeman.nu>
References: <20140403131143.69f324c7@samsung.com>
 <20140403214656.GA4662@hardeman.nu>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 03 Apr 2014 23:46:56 +0200
David Härdeman <david@hardeman.nu> escreveu:

> On Thu, Apr 03, 2014 at 01:11:43PM -0300, Mauro Carvalho Chehab wrote:
> >Hi Linus,
> >
> >Please pull from:
> >  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus
> >
> ...
> >James Hogan (27):
> ...
> >      [media] media: rc: add sysfs scancode filtering interface
> >      [media] media: rc: change 32bit NEC scancode format
> ...
> >      [media] rc-main: add generic scancode filtering
> 
> Umm...we (mostly James and I, but you as well) have been discussing on
> the linux-media whether those patches shouldn't be reverted...this pull
> request seems to have overlooked that discussion...or have I missed
> something?

The discussions didn't finish yet. We can't hold pushing the patches
forever due to a few patches in this series, and there's another pull
request waiting for this to be merged.

We can latter send a fix for the patches that are not ok early at
-rc tests, or next week if we come on an agreement.

Regards,
Mauro
