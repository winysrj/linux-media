Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3QE8M9d011226
	for <video4linux-list@redhat.com>; Sat, 26 Apr 2008 10:08:22 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3QE8BXQ013943
	for <video4linux-list@redhat.com>; Sat, 26 Apr 2008 10:08:12 -0400
Date: Sat, 26 Apr 2008 11:06:59 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: ian@pickworth.me.uk
Message-ID: <20080426110659.39fa836f@gaivota>
In-Reply-To: <481326E4.2070909@pickworth.me.uk>
References: <20080425114526.434311ea@gaivota> <4811F391.1070207@linuxtv.org>
	<20080426085918.09e8bdc0@gaivota>
	<481326E4.2070909@pickworth.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-dvb@linuxtv.org, video4linux-list@redhat.com, mkrufky@linuxtv.org,
	gert.vervoort@hccnet.nl
Subject: Re: Hauppauge WinTV regreession from 2.6.24 to 2.6.25
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Sat, 26 Apr 2008 13:58:12 +0100
Ian Pickworth <ian@pickworth.me.uk> wrote:

> Mauro Carvalho Chehab wrote:
> > 
> > The issue is that set_type_addr were called at the wrong place.
> > 
> > Anyway, I've just committed a patch that should fix this for cx88. I'll soon
> > use the same logic to fix also saa7134.
> > 
> > I've also added a patch for tuner-core, to improve debug (of course, this
> > doesn't need to go to -stable). This helps to see the bug, if tuner debug is
> > enabled.
> > 
> > Cheers,
> > Mauro
> Hi Mauro,
> I have pulled the latest Mercurial source (at about 13:30 BST), compiled 
> and installed. I also removed the "tuner=38" workaround from my 
> modprobe.conf file. On reboot the WinTV cx88 card was detected correctly 
>   - thus curing the original problem in the standard 2.6.25 drivers. 
> Also, tvtime works OK with created devices - tuning to all 5 channels OK.
> The dmesg trace is below.

Thanks for your tests. Please try also to load first tuner, and then cx88.
> 
> About how long would it take for a fix like this to reach the kernel 
> tree - any chance for 2.6.25?
I'll wait for one or two days for more people to test. Then, I'll send to
mainstream, together with saa7134 fix for the same issue.

After mainstream merge, we'll send for 2.6.25. I think this should also be sent
to 2.6.24, since the same bug is present on older versions, if tuner is loaded
before cx88 or saa7134.

Btw, I've just added the corresponding saa7134 patch.

Hermann,

Could you test it please?

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
