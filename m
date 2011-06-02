Return-path: <mchehab@pedra>
Received: from lo.gmane.org ([80.91.229.12]:60590 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160Ab1FBPxa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Jun 2011 11:53:30 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1QSADA-0006Mz-PX
	for linux-media@vger.kernel.org; Thu, 02 Jun 2011 17:53:28 +0200
Received: from 118.100.23.139 ([118.100.23.139])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 02 Jun 2011 17:53:28 +0200
Received: from bahathir by 118.100.23.139 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 02 Jun 2011 17:53:28 +0200
To: linux-media@vger.kernel.org
From: Mohammad Bahathir Hashim <bahathir@gmail.com>
Subject: Re: [linux-dvb] XC4000 patches for kernel 2.6.37.2
Date: Thu, 2 Jun 2011 15:53:15 +0000 (UTC)
Message-ID: <is8blb$fan$1@dough.gmane.org>
References: <4D764337.6050109@email.cz>
 <20110531124843.377a2a80@glory.local>
 <BANLkTi=Lq+FF++yGhRmOa4NCigSt6ZurHg@mail.gmail.com>
 <20110531174323.0f0c45c0@glory.local>
 <BANLkTimEEGsMP6PDXf5W5p9wW7wdWEEOiA@mail.gmail.com>
Reply-To: Mohammad Bahathir Hashim <bahathir@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Now I understood how thing works here, and it clear to me, why the
xc4000 driver is not being included in mainline V4L2. 

It will be lots of commitments and hard work to be the maintainer, and
I respect Mr. Devin's choice and decisions. There are several peoples
that are interested in this driver, such as Mr. Istvan. I realized
this driver does not have huge users/audiences, but still there are
peoples who really need it. But, yeah, not everybody can 'port' the
driver each time Linux kernel or V4L2 version being updated. 

In this case, IF no one is able to maintains the driver, how others
can benefit the 'updated' driver or patches for the new V4L2 or Linux
releases? 

At the moment I still be able to port and test it for my private use.
Sometime I sent the patches to Mr.  Istvan to be included in his
xc4000 driver's website, for  other users to use it. 

BTW, I am not a programmer. I am just a system administrator, who only
like to use shell scripts, awk, sed and grep. I only know how 'read' C,
and can do SIMPLE 'porting' and testing tasks :). Still I really hope
other developers able to include the analog TV/FM tuning and S-Video input
feature to PCTV-340e. 

Anyway, if this driver is not elligible to be included in V4L2
mainline, I know where to 'push' my patches. :)

Thank you.

On 2011-06-02, Devin Heitmueller <dheitmueller@kernellabs.com> wrote:
> 2011/5/31 Dmitri Belimov <d.belimov@gmail.com>:
>> Is it possible make some patches and add support xc4000 into kernel?
>>
>> With my best regards, Dmitry.
>
> What needs to happen here is somebody needs to prepare a patch series
> which contains all the relevant patches, including the SOBs.  This is
> entirely an janitorial task which can be done by anyone and frankly I
> don't have time for this sort of crap anymore.
>
> Any volunteers?
>
> All my patches have my SOB attached.  I explicitly got Davide's
> permission to add his SOB to his original patch, but it's not in the
> HG tree since I got the permission after I committed his change to my
> repo.  I can forward the email with his SOB so the person constructing
> the tree can add it on (as well as my SOB to preserve the chain of
> custody).
>
> Secondly, we need to build a firmware image which is based off of the
> *actual* xceive firmware sources, so that we can be confident that all
> the blobs are from the same firmware revision and so that we can
> maintain them going forward.  I can provide them off-list to someone
> willing to do this work and testing.  Istann_v's firmware image is
> based off of i2c dumps and extracted by hand from disassembled
> firmware, which is less than ideal from an ongoing maintenance
> perspective.
>
> And of course it's worth mentioning that the driver itself still needs
> a ton of cleanup, doesn't meet the coding standards, and wouldn't be
> accepted upstream in its current state.  Somebody will need to do the
> work to clean up the driver, as well as testing to make sure he/she
> didn't cause any regressions.
>
> In summary, here are the four things that need to happen:
>
> 1.  Assemble tree with current patches
> 2.  Construct valid firmware image off of current sources
> 3.  Cleanup/coding style
> 4.  Testing
>
> Now that we've got a bunch of people who are interested in seeing this
> upstream, who is going to volunteer to do which items in the above
> list?
>
> Devin
>

