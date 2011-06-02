Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:39851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753338Ab1FBRFJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Jun 2011 13:05:09 -0400
Message-ID: <4DE7C2C0.9030900@redhat.com>
Date: Thu, 02 Jun 2011 14:05:04 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Mohammad Bahathir Hashim <bahathir@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] XC4000 patches for kernel 2.6.37.2
References: <4D764337.6050109@email.cz> <20110531124843.377a2a80@glory.local> <BANLkTi=Lq+FF++yGhRmOa4NCigSt6ZurHg@mail.gmail.com> <20110531174323.0f0c45c0@glory.local> <BANLkTimEEGsMP6PDXf5W5p9wW7wdWEEOiA@mail.gmail.com> <is8blb$fan$1@dough.gmane.org>
In-Reply-To: <is8blb$fan$1@dough.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 02-06-2011 12:53, Mohammad Bahathir Hashim escreveu:
> Now I understood how thing works here, and it clear to me, why the
> xc4000 driver is not being included in mainline V4L2. 
> 
> It will be lots of commitments and hard work to be the maintainer, and
> I respect Mr. Devin's choice and decisions. There are several peoples
> that are interested in this driver, such as Mr. Istvan. I realized
> this driver does not have huge users/audiences, but still there are
> peoples who really need it. But, yeah, not everybody can 'port' the
> driver each time Linux kernel or V4L2 version being updated. 
> 
> In this case, IF no one is able to maintains the driver, how others
> can benefit the 'updated' driver or patches for the new V4L2 or Linux
> releases? 
> 

Out of tree drivers tend to become obsolete on a few kernel releases, as the
internal kernel API's were not designed to be stable, as we want innovation
inside the kernel. So, people are free to change the internal APIs when
needed.

That's why the best way is to submit patches upstream as they're ready
for it.

> At the moment I still be able to port and test it for my private use.
> Sometime I sent the patches to Mr.  Istvan to be included in his
> xc4000 driver's website, for  other users to use it. 
> 
> BTW, I am not a programmer. I am just a system administrator, who only
> like to use shell scripts, awk, sed and grep. I only know how 'read' C,
> and can do SIMPLE 'porting' and testing tasks :). Still I really hope
> other developers able to include the analog TV/FM tuning and S-Video input
> feature to PCTV-340e. 
> 
> Anyway, if this driver is not elligible to be included in V4L2
> mainline, I know where to 'push' my patches. :)

Almost all drivers are eligible to be included, but the author needs to 
submit them, or someone on their behalf. If the driver doesn't have enough
quality or needs some fixes, the submitter may need to fix it or, eventually,
move it to staging.

With respect to xc4000, we need someone to test if the driver works after
the backports. Please test it and answer to us with a "Tested-by" tag.

After the tests, it would be great to apply any pending patches for xc4000
before cleaning it, as if we do the reverse, existing patches won't apply.

Cheers,
Mauro

