Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293Ab1HSFxw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Aug 2011 01:53:52 -0400
Message-ID: <4E4DFA65.4090508@redhat.com>
Date: Thu, 18 Aug 2011 22:53:41 -0700
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Chris Rankin <rankincj@yahoo.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCH] Latest version of em28xx / em28xx-dvb patch for PCTV
 290e
References: <4E4D5157.2080406@yahoo.com> <CAGoCfiwk4vy1V7T=Hdz1CsywgWVpWEis0eDoh2Aqju3LYqcHfA@mail.gmail.com> <CAGoCfiw4v-ZsUPmVgOhARwNqjCVK458EV79djD625Sf+8Oghag@mail.gmail.com> <4E4D8DFD.5060800@yahoo.com>
In-Reply-To: <4E4D8DFD.5060800@yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 18-08-2011 15:11, Chris Rankin escreveu:
> Two more patches:
> 
> a) clean up resources more reliably if em28xx_init_dev() fails,
> b) move two printk() statements outside the mutex lock
> 
> Cheers,
> Chris
> 
> Signed-off-by: Chris Rankin <rankincj@yahoo.com>
> 
Chris,

Please, never send two patches at the same email. This doesn't
work: patchwork and all tools used by me and other maintainers
will either discard one or both patches, or even merge both into
one.

Also, when you're sending us a series of patches, be sure to
number the patch series with PATCH 01/xx (where xx is the last
patch), and put a different subject on each patch. There's no
need to reply the original thread.

See how all your patches will appear for me:

https://patchwork.kernel.org/project/linux-media/list/?submitter=4542

It is very hard to know that you have a complese series of patches,
instead of just a new version of a patch that you've already sent. 
By default, the last case is assumed, as it is somewhat common to reply
to a patch with a new version of it (yet, the best practice would be
to rename the new patch series as PATCH v2, PATCH v3, etc). If I wouldn't
notice this before I would simply mark all patches except by the last
one as superseded, and just get the last one.

Thanks!
Mauro


PS.: I suggest you to take a look at the wiki page bellow. It helps 
people about what's the expected way for you to submit your work
http://linuxtv.org/wiki/index.php/Development:_How_to_submit_patches
