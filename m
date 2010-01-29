Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694Ab0A2DJZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jan 2010 22:09:25 -0500
Message-ID: <4B625155.5020403@redhat.com>
Date: Fri, 29 Jan 2010 01:09:09 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: cx18 fix patches
References: <4B60F901.20301@redhat.com> <1264731845.3095.16.camel@palomino.walls.org>
In-Reply-To: <1264731845.3095.16.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Walls wrote:
> On Thu, 2010-01-28 at 00:40 -0200, Mauro Carvalho Chehab wrote:
>> Hi Andy,
>>
>> I've made two fix patches to solve the issues with cx18 compilation.
>> My original intention were to send you an email for your ack.
>>
>> Unfortunately, those got added at the wrong branch and went upstream.
>>
>> That proofs that my scripts aren't reliable yet, and that I need
>> an independent tree for such patches... I hope I have enough disk for all
>> those trees...
>>
>> As we can't rebase the -git tree without breaking the replicas,
>> I'd like you to review the patches:
>>
>> http://git.linuxtv.org/v4l-dvb.git?a=commit;h=701ca4249401fe9705a66ad806e933f15cb42489
>> http://git.linuxtv.org/v4l-dvb.git?a=commit;h=dd01705f6a6f732ca95d20959a90dd46482530df
>>
>> If a committed patch is bad, the remaining solution is to write a patch reverting
>> it, and generating some dirty at the git logs.
>>
>> So, I hope both patches are ok...
> 
> Mauro,
> 
> By visual inspection, compilation test, and module loading test on a
> kernel configured to be modular the patches are OK.
> 
> I did not test with them statically recompiled in the kernel, but by
> inspection, they should be OK.

Thanks for the test.

I did the compilations and the errors disappeared. The only remaining
one is that "%d" instead of "%zd" that appears with x86_64 (I sent
you a report earlier today).

Cheers,
Mauro.
