Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1JMuvPA030781
	for <video4linux-list@redhat.com>; Tue, 19 Feb 2008 17:56:57 -0500
Received: from mail-in-13.arcor-online.net (mail-in-13.arcor-online.net
	[151.189.21.53])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1JMuPN5031619
	for <video4linux-list@redhat.com>; Tue, 19 Feb 2008 17:56:25 -0500
From: hermann pitton <hermann-pitton@arcor.de>
To: Patrick Boettcher <patrick.boettcher@desy.de>
In-Reply-To: <Pine.LNX.4.64.0802192327000.13027@pub6.ifh.de>
References: <1203434275.6870.25.camel@tux>
	<Pine.LNX.4.64.0802192208010.13027@pub6.ifh.de>
	<1203457264.8019.6.camel@anden.nu> <1203459408.28796.19.camel@youkaida>
	<Pine.LNX.4.64.0802192327000.13027@pub6.ifh.de>
Content-Type: text/plain
Date: Tue, 19 Feb 2008 23:50:40 +0100
Message-Id: <1203461440.5358.2.camel@pc08.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org,
	Nicolas Will <nico@youplala.net>
Subject: Re: [linux-dvb] [patch] support for key repeat with dib0700 ir
	receiver
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

Am Dienstag, den 19.02.2008, 23:29 +0100 schrieb Patrick Boettcher:
> Hi,
> 
> On Tue, 19 Feb 2008, Nicolas Will wrote:
> >> I would suggest creating a netlink device which lircd (or similar) can
> >> read from.
> >
> > Be ready to discount my opinion, I'm not too good at those things.
> >
> > Wouldn't going away from an event interface kill a possible direct link
> > between the remote and X?
> >
> > The way I see it, LIRC is an additional layer that may be one too many
> > in most cases. From my point of view, it is a relative pain I could do
> > without. But I may have tunnel vision by lack of knowledge.
> 
> I agree with you. I'm more looking for a solution with existing things. 
> LIRC is not in kernel. I don't think we should do something specific, new. 
> If there is nothing which can be done with the event system I think we 
> should either extend it or just drop this idea.
> 
> What about HID?
> 
> Patrick.
> 

Hi,

for what we have ir-common then already?

Did not look in any details, but we have a hook there,
also for RC5 remotes.

Cheers,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
