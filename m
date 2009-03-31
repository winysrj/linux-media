Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:34543 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbZCaKsb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Mar 2009 06:48:31 -0400
Subject: Re: Problems with Hauppauge HVR 1600 and cx18 driver
From: Andy Walls <awalls@radix.net>
To: Brandon Jenkins <bcjenkins@tvwhere.com>
Cc: Corey Taylor <johnfivealive@yahoo.com>,
	linux-media@vger.kernel.org, ivtv-devel@ivtvdriver.org,
	ivtv-users@ivtvdriver.org
In-Reply-To: <de8cad4d0903310302s2df38ba8re605fc0cc3a4f266@mail.gmail.com>
References: <164695.77575.qm@web56903.mail.re3.yahoo.com>
	 <412bdbff0903161118o2d038bdetc4d52851e35451df@mail.gmail.com>
	 <63160.21731.qm@web56906.mail.re3.yahoo.com>
	 <1237251478.3303.37.camel@palomino.walls.org>
	 <954486.20343.qm@web56908.mail.re3.yahoo.com>
	 <1237425168.3303.94.camel@palomino.walls.org>
	 <de8cad4d0903220853v4b871e91x7de6efebfb376034@mail.gmail.com>
	 <871136.15243.qm@web56908.mail.re3.yahoo.com>
	 <1238297237.3235.42.camel@palomino.walls.org>
	 <de8cad4d0903290725t2e7764a8pe2c0d1b7d67ea8c4@mail.gmail.com>
	 <de8cad4d0903310302s2df38ba8re605fc0cc3a4f266@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 31 Mar 2009 06:44:28 -0400
Message-Id: <1238496268.3238.15.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2009-03-31 at 06:02 -0400, Brandon Jenkins wrote:
> On Sun, Mar 29, 2009 at 10:25 AM, Brandon Jenkins <bcjenkins@tvwhere.com> wrote:
> > On Sat, Mar 28, 2009 at 11:27 PM, Andy Walls <awalls@radix.net> wrote:
> >> On Mon, 2009-03-23 at 06:52 -0700, Corey Taylor wrote:

> >>
> > Hi Andy,
> >
> > I have cloned this tree and loaded on the server. I'll let you know
> > over the next couple of days if there is any improvement.
> >
> > Thanks!
> >
> > Brandon
> >
> 
> Andy,
> 
> Based on continued discussions it seems you're still exploring things.
> I can tell you that the analog captures are still exhibiting
> artifacts.

Well, the patch you have to work with essentially does a poll every 1/4
of a millisecond (a rate of 67 times per NTSC field while polling) with
a wait between the polls.  If you're still getting artifacts, then I
suspect your artifacts problems may not lie where I'm looking right now.

I have no artifacts with analog captures, so let me get through this
first problem and then I'll ask more about your symptoms.  I don't have
a 3 HVR-1600 card setup.  You may try setting enc_mpg_bufsize to a value
different than 32 kB.  Setting it higher will make you less likely to
lose buffers due to the firmware timing out when it sends buffers to the
driver.  Setting it lower will make the loss of any one buffer of less
impact to the stream, and setting the analog capture to provide TS vs
the deault of a PS may help too.

>  I'll get to some of the HD captures tonight.

OK.

Regards,
Andy

> Brandon


