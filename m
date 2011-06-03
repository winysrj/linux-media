Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52510 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab1FCAhZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jun 2011 20:37:25 -0400
Received: by fxm17 with SMTP id 17so1025729fxm.19
        for <linux-media@vger.kernel.org>; Thu, 02 Jun 2011 17:37:23 -0700 (PDT)
Date: Fri, 3 Jun 2011 11:41:03 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org, thunder.m@email.cz,
	"istvan_v@mailbox.hu" <istvan_v@mailbox.hu>, bahathir@gmail.com
Subject: Re: [linux-dvb] XC4000 patches for kernel 2.6.37.2
Message-ID: <20110603114103.451f1375@glory.local>
In-Reply-To: <4DE7A131.7010208@redhat.com>
References: <4D764337.6050109@email.cz>
	<20110531124843.377a2a80@glory.local>
	<BANLkTi=Lq+FF++yGhRmOa4NCigSt6ZurHg@mail.gmail.com>
	<20110531174323.0f0c45c0@glory.local>
	<BANLkTimEEGsMP6PDXf5W5p9wW7wdWEEOiA@mail.gmail.com>
	<4DE7A131.7010208@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, 02 Jun 2011 11:41:53 -0300
Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

> Em 02-06-2011 07:52, Devin Heitmueller escreveu:
> > 2011/5/31 Dmitri Belimov <d.belimov@gmail.com>:
> >> Is it possible make some patches and add support xc4000 into
> >> kernel?
> >>
> >> With my best regards, Dmitry.
> > 
> > What needs to happen here is somebody needs to prepare a patch
> > series which contains all the relevant patches, including the
> > SOBs.  This is entirely an janitorial task which can be done by
> > anyone and frankly I don't have time for this sort of crap anymore.
> > 
> > Any volunteers?
> > 
> > All my patches have my SOB attached.  I explicitly got Davide's
> > permission to add his SOB to his original patch, but it's not in the
> > HG tree since I got the permission after I committed his change to
> > my repo.  I can forward the email with his SOB so the person
> > constructing the tree can add it on (as well as my SOB to preserve
> > the chain of custody).
> > 
> > Secondly, we need to build a firmware image which is based off of
> > the *actual* xceive firmware sources, so that we can be confident
> > that all the blobs are from the same firmware revision and so that
> > we can maintain them going forward.  I can provide them off-list to
> > someone willing to do this work and testing.  Istann_v's firmware
> > image is based off of i2c dumps and extracted by hand from
> > disassembled firmware, which is less than ideal from an ongoing
> > maintenance perspective.
> > 
> > And of course it's worth mentioning that the driver itself still
> > needs a ton of cleanup, doesn't meet the coding standards, and
> > wouldn't be accepted upstream in its current state.  Somebody will
> > need to do the work to clean up the driver, as well as testing to
> > make sure he/she didn't cause any regressions.
> > 
> > In summary, here are the four things that need to happen:
> > 
> > 1.  Assemble tree with current patches
> 
> It is probably easier for me to do this step, as I have my hg import
> scripts. However, as I don't have the PCTV devices added at dib0700,
> I can't test.
> 
> OK, I did this work, as it just took me a few minutes to rebase
> patches 1 and 2. I didn't apply the patches that started with "djh"
> since they seemed to be a few hacks during the development time.
> 
> The tree is at:
> 
> git://linuxtv.org/mchehab/experimental.git branch xc4000
> 
> There are two warnings there that needs to be fixed:
> 
> drivers/media/common/tuners/xc4000.c:1293: warning:
> ‘xc4000_is_firmware_loaded’ defined but not used
> drivers/media/common/tuners/xc4000.c: In function
> ‘check_firmware.clone.0’: drivers/media/common/tuners/xc4000.c:1107:
> warning: ‘version’ may be used uninitialized in this function
> 
> Both seems to be trivial.
> 
> A disclaimer notice here: I didn't make any cleanup at the code,
> (except by running a whitespace cleanup script) nor I've reviewed it. 
> 
> IMO, the next step is to test the rebases against a real hardware, 
> and adding a few patches fixing it, if the rebases broke.
> 
> The next step would be fix the CodingStyle, and run checkpatch.pl.
> There aren't many CodingStyle warnings/errors (13 errors, 28
> warnings). Most of the errors are due to the excess usage of printk's
> for debug, and due to some obsolete code commented with //.
> 
> > 2.  Construct valid firmware image off of current sources
> > 3.  Cleanup/coding style
> > 4.  Testing
> > 
> > Now that we've got a bunch of people who are interested in seeing
> > this upstream, who is going to volunteer to do which items in the
> > above list?
> > 
> > Devin
> > 
> 

One of our TV card has this tuner. It works in analog mode. I try get right firmware
cleanup and test.

Can I use 
git://linuxtv.org/mchehab/experimental.git branch xc4000
for do it?

With my best regards, Dmitry.
