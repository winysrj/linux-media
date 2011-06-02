Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:37442 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932591Ab1FBKwo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jun 2011 06:52:44 -0400
Received: by ewy4 with SMTP id 4so232012ewy.19
        for <linux-media@vger.kernel.org>; Thu, 02 Jun 2011 03:52:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110531174323.0f0c45c0@glory.local>
References: <4D764337.6050109@email.cz>
	<20110531124843.377a2a80@glory.local>
	<BANLkTi=Lq+FF++yGhRmOa4NCigSt6ZurHg@mail.gmail.com>
	<20110531174323.0f0c45c0@glory.local>
Date: Thu, 2 Jun 2011 06:52:41 -0400
Message-ID: <BANLkTimEEGsMP6PDXf5W5p9wW7wdWEEOiA@mail.gmail.com>
Subject: Re: [linux-dvb] XC4000 patches for kernel 2.6.37.2
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Dmitri Belimov <d.belimov@gmail.com>
Cc: linux-media@vger.kernel.org, thunder.m@email.cz,
	"istvan_v@mailbox.hu" <istvan_v@mailbox.hu>, linux-dvb@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

2011/5/31 Dmitri Belimov <d.belimov@gmail.com>:
> Is it possible make some patches and add support xc4000 into kernel?
>
> With my best regards, Dmitry.

What needs to happen here is somebody needs to prepare a patch series
which contains all the relevant patches, including the SOBs.  This is
entirely an janitorial task which can be done by anyone and frankly I
don't have time for this sort of crap anymore.

Any volunteers?

All my patches have my SOB attached.  I explicitly got Davide's
permission to add his SOB to his original patch, but it's not in the
HG tree since I got the permission after I committed his change to my
repo.  I can forward the email with his SOB so the person constructing
the tree can add it on (as well as my SOB to preserve the chain of
custody).

Secondly, we need to build a firmware image which is based off of the
*actual* xceive firmware sources, so that we can be confident that all
the blobs are from the same firmware revision and so that we can
maintain them going forward.  I can provide them off-list to someone
willing to do this work and testing.  Istann_v's firmware image is
based off of i2c dumps and extracted by hand from disassembled
firmware, which is less than ideal from an ongoing maintenance
perspective.

And of course it's worth mentioning that the driver itself still needs
a ton of cleanup, doesn't meet the coding standards, and wouldn't be
accepted upstream in its current state.  Somebody will need to do the
work to clean up the driver, as well as testing to make sure he/she
didn't cause any regressions.

In summary, here are the four things that need to happen:

1.  Assemble tree with current patches
2.  Construct valid firmware image off of current sources
3.  Cleanup/coding style
4.  Testing

Now that we've got a bunch of people who are interested in seeing this
upstream, who is going to volunteer to do which items in the above
list?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
