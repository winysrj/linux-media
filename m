Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m31KBiEH011554
	for <video4linux-list@redhat.com>; Tue, 1 Apr 2008 16:11:44 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m31KBRDH003634
	for <video4linux-list@redhat.com>; Tue, 1 Apr 2008 16:11:28 -0400
Date: Tue, 1 Apr 2008 17:10:51 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Message-ID: <20080401171051.724a9f75@gaivota>
In-Reply-To: <20080330162006.GA6048@joi>
References: <20080330162006.GA6048@joi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Morton <akpm@google.com>, video4linux-list@redhat.com,
	linux-kernel@vger.kernel.org, "Rafael J.
	Wysocki" <rjw@sisk.pl>, Bongani Hlope <bonganilinux@mweb.co.za>
Subject: Re: 2.6.25-rc regression: bttv: oops on radio access (bisected)
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

Hi Marcin

On Sun, 30 Mar 2008 18:20:49 +0200
Marcin Slusarz <marcin.slusarz@gmail.com> wrote:

> Hi
> 2.6.25-rc7 kernel oopses on exec of "radio -c /dev/radio0".
> I bisected it down to:
> 
> 402aa76aa5e57801b4db5ccf8c7beea9f580bb1b is first bad commit
> commit 402aa76aa5e57801b4db5ccf8c7beea9f580bb1b
> Author: Douglas Schilling Landgraf <dougsland@gmail.com>
> Date:   Thu Dec 27 22:20:58 2007 -0300
> 
>     V4L/DVB (6911): Converted bttv to use video_ioctl2
> 
>     Signed-off-by: Douglas Schilling Landgraf <dougsland@gmail.com>
>     Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
> 

There are three patches that are meant to fix the bugs with radio. On the tests
I did here, they worked, but the Bongani still points that the fixes didn't
solve for him.

On the tests I did here, the three patches seemed to work [1]. Maybe you could
test with those patches and post us some results.

There are three patches meant to fix several issues caused by the conversion: 

http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdiff;h=bdd38d9b5c6365ea004df6d8a183dd1344b4801f
http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdiff;h=055a6282cabd311cf010a5a83f0494558504f7d0
http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdiff;h=6e07ff78274752fe812a1e8bddb6013a278e62e8

Could you test please and give us some feedback?

[1] Yet, I've discovered recently that the hardware I use for testing PCI
devices is broken. Probably, my motherboard chipset is damaged, since I'm
getting intermittent bugs on several parts of the machine - even with stable
kernels - so my tests with bttv aren't conclusive.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
