Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6QEF3aL030994
	for <video4linux-list@redhat.com>; Sat, 26 Jul 2008 10:15:03 -0400
Received: from nlpi053.prodigy.net (nlpi053.sbcis.sbc.com [207.115.36.82])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6QEEqIa028389
	for <video4linux-list@redhat.com>; Sat, 26 Jul 2008 10:14:52 -0400
Message-ID: <488B3155.3060109@xnet.com>
Date: Sat, 26 Jul 2008 09:14:45 -0500
From: stuart <stuart@xnet.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <488B3012.3080004@xnet.com>
In-Reply-To: <488B3012.3080004@xnet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: IR remote control support for kworld 120???
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



stuart wrote:
> Hi...
> 
> I understand the new kworld 120 (replacement for the kworld 115 and 110) 
> is not supported w.r.t. IR remote control.
> 
> So...
> 
> Was digging through the v4l code (staging from last week) and happened 
> upon a "fixme note" w.r.t. the cx23885 chip.  At about line 550 in 
> cx23885-cards.c there appears to be an unimplemented IR method for 
> initializing the cx23885.  Does that mean there is no IR remote control 
> support for any cx2388 based board?  I was hoping to find that all that 
> was needed to get the kworld 120's IR remote working was the right 
> connections into such IR methods.  (Yeah, I know, if it was that easy 
> then the original kworld 120 author (thank you to him) would have done it.)

I meant that as a sincere thank you as in:

"...thank you, I appreciate all the hard work you put into the kworld 
120 driver...",

just to be clear.

> ...thanks
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
