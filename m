Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m390ub9B003553
	for <video4linux-list@redhat.com>; Tue, 8 Apr 2008 20:56:37 -0400
Received: from mail-in-12.arcor-online.net (mail-in-12.arcor-online.net
	[151.189.21.52])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m390uOkv006504
	for <video4linux-list@redhat.com>; Tue, 8 Apr 2008 20:56:24 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Andrew Junev <a-j@a-j.ru>
In-Reply-To: <1135983778.20080408193408@a-j.ru>
References: <1115343012.20080318233620@a-j.ru>
	<200803200048.15063@orion.escape-edv.de>
	<1206067079.3362.10.camel@pc08.localdom.local>
	<200803210742.57119@orion.escape-edv.de>
	<1206912674.3520.58.camel@pc08.localdom.local>
	<1063704330.20080331082850@a-j.ru>
	<1206999694.7762.41.camel@pc08.localdom.local>
	<1112443057.20080402224744@a-j.ru>
	<1207179525.14887.13.camel@pc08.localdom.local>
	<1207265002.3364.12.camel@pc08.localdom.local>
	<20080403221833.34d3c4d6@gaivota>
	<1207275545.3365.26.camel@pc08.localdom.local>
	<1076827621.20080406215420@a-j.ru>
	<1207522685.6334.29.camel@pc08.localdom.local>
	<1135983778.20080408193408@a-j.ru>
Content-Type: text/plain
Date: Wed, 09 Apr 2008 02:56:16 +0200
Message-Id: <1207702576.5135.42.camel@pc08.localdom.local>
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

Hi Andrew,

Am Dienstag, den 08.04.2008, 19:34 +0400 schrieb Andrew Junev:
> Hello Hermann,
> 
> Monday, April 7, 2008, 2:58:05 AM, you wrote:
> 
> > you always drop the lists.
> 
> Not always. :) I do it just sometimes, when I feel my message doesn't
> contain useful information for everybody on the list.
> But we can move back to the lists, if you think it's more appropriate.
> 
> > I come back to you, if nobody else who is more fluently in just add a
> > patch and compile a vanilla kernel does not move in. 
> 
> Well, I believe I can do it, if noone else does. It shouldn't be that
> hard.
> 
> > I of course know for sure the fix is correct, but the stable team wants
> > a report from a user on 2.6.24 and support for my stuff is new and it is
> > nonsense to bring it down to 2.6.24 to demonstrate it working for
> > someone on 2.6.24 ...
> 
> I wonder how the unpatched driver made its way to 2.6.24 stable...
> Or maybe it's just me who gets affected by this problem that much.
> 
> > B.T.W, why you don't use at least the v4l-dvb master stuff to come over
> > it. Needs no patching :)
> 
> If I ever need to move to 2.6.24 and it gets no patch included by
> then, I'll surely do so! :)
> At the moment I'm perfectly fine with 2.6.23...
> 

however it will go out for now, seems in the end you will have something
to test ;)

Cheers,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
