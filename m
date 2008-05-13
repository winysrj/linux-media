Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4DFuQlR003509
	for <video4linux-list@redhat.com>; Tue, 13 May 2008 11:56:26 -0400
Received: from smtp1.mtw.ru (smtp1.mtw.ru [194.135.105.241])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4DFu6dc027188
	for <video4linux-list@redhat.com>; Tue, 13 May 2008 11:56:14 -0400
Date: Tue, 13 May 2008 19:55:59 +0400
From: Andrew Junev <a-j@a-j.ru>
Message-ID: <1455396550.20080513195559@a-j.ru>
To: hermann pitton <hermann-pitton@arcor.de>
In-Reply-To: <1207782190.5554.47.camel@pc08.localdom.local>
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
	<1207702576.5135.42.camel@pc08.localdom.local>
	<1271819320.20080409101744@a-j.ru>
	<1207782190.5554.47.camel@pc08.localdom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TT S-1401 problem with kernel 2.6.24 ???
Reply-To: Andrew Junev <a-j@a-j.ru>
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


Thursday, April 10, 2008, 3:03:10 AM, you wrote:

> Am Mittwoch, den 09.04.2008, 10:17 +0400 schrieb Andrew Junev:
>> > Hi Andrew,
>> 
>> > Am Dienstag, den 08.04.2008, 19:34 +0400 schrieb Andrew Junev:
>> >> Hello Hermann,
>> >> 
>> >> Monday, April 7, 2008, 2:58:05 AM, you wrote:
>> >> 
>> >> > you always drop the lists.
>> >> 
>> >> Not always. :) I do it just sometimes, when I feel my message doesn't
>> >> contain useful information for everybody on the list.
>> >> But we can move back to the lists, if you think it's more appropriate.
>> >> 
>> >> > I come back to you, if nobody else who is more fluently in just add a
>> >> > patch and compile a vanilla kernel does not move in. 
>> >> 
>> >> Well, I believe I can do it, if noone else does. It shouldn't be that
>> >> hard.
>> >> 
>> >> > I of course know for sure the fix is correct, but the stable team wants
>> >> > a report from a user on 2.6.24 and support for my stuff is new and it is
>> >> > nonsense to bring it down to 2.6.24 to demonstrate it working for
>> >> > someone on 2.6.24 ...
>> >> 
>> >> I wonder how the unpatched driver made its way to 2.6.24 stable...
>> >> Or maybe it's just me who gets affected by this problem that much.
>> >> 
>> >> > B.T.W, why you don't use at least the v4l-dvb master stuff to come over
>> >> > it. Needs no patching :)
>> >> 
>> >> If I ever need to move to 2.6.24 and it gets no patch included by
>> >> then, I'll surely do so! :)
>> >> At the moment I'm perfectly fine with 2.6.23...
>> >> 
>> 
>> > however it will go out for now, seems in the end you will have something
>> > to test ;)
>> 
>> 
>> I have no problems with that! :)
>> 
>> Ok, can you point me to a guide on how to do this? Otherwise I'm
>> affraid I'll waste lots of time just by trying something that I should
>> not...
>> 
>> I'm ready to test it sometime this week.
>> 

> Hi Andrew,

> Mike has forwarded the patch to the stable kernel team. (Thanks!)

> Likely it will be fixed in 2.6.24.5 then.

> To build a vanilla kernel is still a very easy task, but there are
> distribution specific helper scripts and customs.

> The real problem, that could appear, is that dependencies on other
> utilities are not resolved on your current distribution version anymore
> and you run into some circular dependencies, not easy to resolve and
> then you must know what you are doing exactly or upgrade.

> If a 2.6.24 is available for your current stuff, just install it and see
> the missing. If you then install the kernel source for it, we can apply
> the patch also there and build a new kernel.

> Cheers,
> Hermann


Sorry for my slow response...
I just installed kernel 2.6.24.5 and my S-1401 works good now!

Thanks a million to everyone who was involved!

And once again sorry for not providing my feedback fast enough.


-- 
Best regards,
 Andrew

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
