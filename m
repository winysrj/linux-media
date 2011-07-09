Return-path: <mchehab@localhost>
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.106]:41744
	"EHLO outbound.icp-qv1-irony-out1.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752216Ab1GIRVp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Jul 2011 13:21:45 -0400
Message-ID: <4E188BFB.2080406@iinet.net.au>
Date: Sun, 10 Jul 2011 01:12:27 +0800
From: Mike <michael.stock@iinet.net.au>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org
Subject: Re: Bug in HVR1300. Found part of a patch, if reverted
References: <4DCBEB52.5060808@iinet.net.au> <CAGoCfixa7tT1rensOa9GW1NRHrkxgSmwvSrAqP=THJpm2rZJzQ@mail.gmail.com>
In-Reply-To: <CAGoCfixa7tT1rensOa9GW1NRHrkxgSmwvSrAqP=THJpm2rZJzQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

On Thu, May 12, 2011 at 10:14 AM, Mike <michael.stock@iinet.net.au> wrote:
>> Hi there
>>
>> in the latest kernel (and all those since when the patch was written) this
>> patch is still required for the HVR-1300 to work, any chance of it getting
>> incorporated?
>>
>> thanks
>> Mike
> Hello Mike,
>
> Please try out the following patch which has been submitted upstream,
> which should fix the actual underlying problem (the patch that has
> been circulating in Launchpad 439163 doesn't fix the *actual* issue).
>
> https://launchpadlibrarian.net/74557311/frontend_dvb_init.patch
>
> The above patch has been submitted for upstream inclusion, so feedback
> from users would be useful.
>
> Thanks,
>
> Devin
>
Hi Devin,

thankyou very much for investigating and patching.

unfortunately for me, my system (ubuntu 10.04 with 2.6.32-32) will not 
boot to try it...

After downloading source via "git clone 
git://linuxtv.org/media_build.git" and successfully patching, compiling 
and installing the modules using a text terminal, i reboot and before i 
get to X my system hangs about 30 seconds into the boot process right 
after a bunch of messages warning me about using backported media build 
on an old kernel ("don't use it for production" etc etc).

i would be more than happy to test your patch but i'm sorry i'm not sure 
what to do about that booting problem. i think i will need to try to 
find a way to re-install the standard ubuntu media modules into my 
2.6.32-32 module directories (whilst running a different kernel) to even 
allow my system to boot on 2.6.32-32 !!

Mike

