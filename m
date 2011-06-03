Return-path: <mchehab@pedra>
Received: from lo.gmane.org ([80.91.229.12]:55180 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569Ab1FCDy0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Jun 2011 23:54:26 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1QSLSr-00009Y-7T
	for linux-media@vger.kernel.org; Fri, 03 Jun 2011 05:54:25 +0200
Received: from 60.52.205.105 ([60.52.205.105])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 03 Jun 2011 05:54:25 +0200
Received: from bahathir by 60.52.205.105 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 03 Jun 2011 05:54:25 +0200
To: linux-media@vger.kernel.org
From: Mohammad Bahathir Hashim <bahathir@gmail.com>
Subject: Re: [linux-dvb] XC4000 patches for kernel 2.6.37.2
Date: Fri, 3 Jun 2011 03:54:13 +0000 (UTC)
Message-ID: <is9lt4$jt6$1@dough.gmane.org>
References: <4D764337.6050109@email.cz>
 <20110531124843.377a2a80@glory.local>
 <BANLkTi=Lq+FF++yGhRmOa4NCigSt6ZurHg@mail.gmail.com>
 <20110531174323.0f0c45c0@glory.local>
 <BANLkTimEEGsMP6PDXf5W5p9wW7wdWEEOiA@mail.gmail.com>
 <is8blb$fan$1@dough.gmane.org> <4DE7C2C0.9030900@redhat.com>
Reply-To: Mohammad Bahathir Hashim <bahathir@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Thank you for the comments and pointers. I am happy, at least there
are peoples who want to see the xc4000 driver alive. 

On 2011-06-02, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> Em 02-06-2011 12:53, Mohammad Bahathir Hashim escreveu:
>> Now I understood how thing works here, and it clear to me, why the
>> xc4000 driver is not being included in mainline V4L2. 
>> 
>> It will be lots of commitments and hard work to be the maintainer, and
>> I respect Mr. Devin's choice and decisions. There are several peoples
>> that are interested in this driver, such as Mr. Istvan. I realized
>> this driver does not have huge users/audiences, but still there are
>> peoples who really need it. But, yeah, not everybody can 'port' the
>> driver each time Linux kernel or V4L2 version being updated. 
>> 
>> In this case, IF no one is able to maintains the driver, how others
>> can benefit the 'updated' driver or patches for the new V4L2 or Linux
>> releases? 
>> 
>
> Out of tree drivers tend to become obsolete on a few kernel releases, as the
> internal kernel API's were not designed to be stable, as we want innovation
> inside the kernel. So, people are free to change the internal APIs when
> needed.
>
> That's why the best way is to submit patches upstream as they're ready
> for it.
>
>> At the moment I still be able to port and test it for my private use.
>> Sometime I sent the patches to Mr.  Istvan to be included in his
>> xc4000 driver's website, for  other users to use it. 
>> 
>> BTW, I am not a programmer. I am just a system administrator, who only
>> like to use shell scripts, awk, sed and grep. I only know how 'read' C,
>> and can do SIMPLE 'porting' and testing tasks :). Still I really hope
>> other developers able to include the analog TV/FM tuning and S-Video input
>> feature to PCTV-340e. 
>> 
>> Anyway, if this driver is not elligible to be included in V4L2
>> mainline, I know where to 'push' my patches. :)
>
> Almost all drivers are eligible to be included, but the author needs to 
> submit them, or someone on their behalf. If the driver doesn't have enough
> quality or needs some fixes, the submitter may need to fix it or, eventually,
> move it to staging.
>
> With respect to xc4000, we need someone to test if the driver works after
> the backports. Please test it and answer to us with a "Tested-by" tag.
>
> After the tests, it would be great to apply any pending patches for xc4000
> before cleaning it, as if we do the reverse, existing patches won't apply.
>
> Cheers,
> Mauro
>

