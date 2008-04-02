Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m32NdB3q020770
	for <video4linux-list@redhat.com>; Wed, 2 Apr 2008 19:39:11 -0400
Received: from mail-in-07.arcor-online.net (mail-in-07.arcor-online.net
	[151.189.21.47])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m32Ncw56012594
	for <video4linux-list@redhat.com>; Wed, 2 Apr 2008 19:38:58 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Andrew Junev <a-j@a-j.ru>
In-Reply-To: <1112443057.20080402224744@a-j.ru>
References: <1115343012.20080318233620@a-j.ru>
	<200803200048.15063@orion.escape-edv.de>
	<1206067079.3362.10.camel@pc08.localdom.local>
	<200803210742.57119@orion.escape-edv.de>
	<1206912674.3520.58.camel@pc08.localdom.local>
	<1063704330.20080331082850@a-j.ru>
	<1206999694.7762.41.camel@pc08.localdom.local>
	<1112443057.20080402224744@a-j.ru>
Content-Type: text/plain
Date: Thu, 03 Apr 2008 01:38:45 +0200
Message-Id: <1207179525.14887.13.camel@pc08.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TT S-1401 problem with kernel 2.6.24 ???
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

Hi again,

Am Mittwoch, den 02.04.2008, 22:47 +0400 schrieb Andrew Junev:
> Hello Hermann,
> 
> Thanks a lot for this detailed explanation!
> I really appreciate your help!
> 
> One small question: does it mean that kernels 2.6.24.5 or 2.6.24.6
> _should_ have this patch already included?
> 

seems we hang in current stable kernel rules.

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob_plain;f=Documentation/stable_kernel_rules.txt;hb=HEAD

If we go back to 2.6.23 level, that patch might have less than 100 lines
with context, but we break the

 - It must fix only one thing

rule, since we break the 2.6.24 LifeView Trio DVB-S support too then.

Seems sombody with such a device should reopen the bug on Bugzilla ...

Cheers,
Hermann



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
