Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:63684 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754155Ab0A1M0b (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jan 2010 07:26:31 -0500
Subject: Re: cx18 fix patches
From: Andy Walls <awalls@radix.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <4B60F901.20301@redhat.com>
References: <4B60F901.20301@redhat.com>
Content-Type: text/plain
Date: Thu, 28 Jan 2010 07:26:02 -0500
Message-Id: <1264681562.3081.3.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2010-01-28 at 00:40 -0200, Mauro Carvalho Chehab wrote:
> Hi Andy,
> 
> I've made two fix patches to solve the issues with cx18 compilation.
> My original intention were to send you an email for your ack.
> 
> Unfortunately, those got added at the wrong branch and went upstream.
> 
> That proofs that my scripts aren't reliable yet, and that I need
> an independent tree for such patches... I hope I have enough disk for all
> those trees...

I understand.


> As we can't rebase the -git tree without breaking the replicas,
> I'd like you to review the patches:
> 
> http://git.linuxtv.org/v4l-dvb.git?a=commit;h=701ca4249401fe9705a66ad806e933f15cb42489
> http://git.linuxtv.org/v4l-dvb.git?a=commit;h=dd01705f6a6f732ca95d20959a90dd46482530df
> 
> If a committed patch is bad, the remaining solution is to write a patch reverting
> it, and generating some dirty at the git logs.
> 
> So, I hope both patches are ok...
> 
> Please test.

I had coordinated with Devin on IRC and was going to work up fixes
tonight. 

Now I'll just review and test tonight (some time between 6:00 - 10:30
p.m. EST)


> Sorry for the mess.

No problem.

Regards,
Andy

> Cheers,
> Mauro.


