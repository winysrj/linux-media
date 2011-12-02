Return-path: <linux-media-owner@vger.kernel.org>
Received: from yop.chewa.net ([91.121.105.214]:33514 "EHLO yop.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932065Ab1LBRtY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Dec 2011 12:49:24 -0500
From: "=?iso-8859-1?q?R=E9mi?= Denis-Courmont" <remi@remlab.net>
To: linux-media@vger.kernel.org
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver because of worrying about possible misusage?
Date: Fri, 2 Dec 2011 19:49:18 +0200
Cc: linux-kernel@vger.kernel.org
References: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com> <4ED7BBA3.5020002@redhat.com> <CAJbz7-1_Nb8d427bOMzCDbRcvwQ3QjD=2KhdPQS_h_jaYY5J3w@mail.gmail.com>
In-Reply-To: <CAJbz7-1_Nb8d427bOMzCDbRcvwQ3QjD=2KhdPQS_h_jaYY5J3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201112021949.19395.remi@remlab.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le jeudi 1 décembre 2011 21:59:56 HoP, vous avez écrit :
> > Kernel code is GPLv2. You can use its code on a GPLv2 licensed library.
> 
> I see. So if you think it is nice to get dvb-core, make a wrapper around
> to get it usable in userspace and maintain totally same functionality
> by myself then I say it is no go. If it looks for you like good idea
> I must disagree. Code duplication?

Sure, some core code would be duplicated. That is not a big deal.

This proposal however has three big advantages:
- Proprietary drivers are not enabled as the library would be GPL.
- The virtual DVB device runs in the same process as the DVB application, 
which saves context switching and memory copying.
- It would be your project. You do not need to agree with Mauro ;-)

> Two maintaners? That is crazy idea man.

Someone would have to maintain the device driver anyway. I don't see much of a 
difference on maintainance side.

> > And I can't see any advantage on yours ;) Putting something that belongs
> > to userspace into kernelspace just because it is easier to re-use the
> > existing code inside the kernel is not a good argument.
> 
> It is only your POV that it should be in userspace.

Except for backward compatiblity, this would actually belong in userspace. It 
would be more efficient and easier to maintain as a userspace library than as 
a kernel driver.

If you need backward compatibility, I am still inclined to believe that you 
could write a CUSE frontend, so it does involve some extra work and looses the 
performance benefit.

-- 
Rémi Denis-Courmont
http://www.remlab.net/
http://fi.linkedin.com/in/remidenis
