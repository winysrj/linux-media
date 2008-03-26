Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2QMPkTq022943
	for <video4linux-list@redhat.com>; Wed, 26 Mar 2008 18:25:46 -0400
Received: from cinke.fazekas.hu (cinke.fazekas.hu [195.199.244.225])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2QMPamt022817
	for <video4linux-list@redhat.com>; Wed, 26 Mar 2008 18:25:36 -0400
Date: Wed, 26 Mar 2008 23:25:29 +0100 (CET)
From: Balint Marton <cus@fazekas.hu>
To: Torsten Seeboth <Torsten.Seeboth@t-online.de>
In-Reply-To: <001a01c88f81$80aec670$6402a8c0@desktop>
Message-ID: <Pine.LNX.4.64.0803262240060.29375@cinke.fazekas.hu>
References: <patchbomb.1206497254@bluegene.athome>
	<001a01c88f81$80aec670$6402a8c0@desktop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH 0 of 3] cx88: fix oops on rmmod and implement
	stereodetection
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

> No, the Nicam_Status_Regs contain only and only if Nicam is forced before.
> Your patch _can_ work for B/G, but I don't think so for others, like D/K
> etc.
It works for me on B/G. Unfortunately i can't test the others, because my 
cable tv provider only uses B/G. Anyway, if it really doesn't work on 
other sound systems, we can use the mono fallback there, like before, and 
use the stereo detection based on Nicam_Status regs only for B/G mode.

> Still not finished as you can see in comments. There is much more to do if
> you want to get safe mono/stereo or a2/nicam/btsc detection.
> 
> I did many things trying to understand on how audio things are going on on
> this chip. Together witht some others from this list I have learned from m$
> driver how it really works by using de-asm/debuggers tools. To make a long
> story short: The only way is to take some audio samples into memory, compare
> it to tables and do some calculations depands on video-mode.

I don't see much chance anyone will ever going to do it. On top of 
that, taking audio samples is not easy, if the tuner card is connected to 
a sound card input... Considering what you said, detecting the audio mode 
properly in the audio thread seems impossible to me. So I still think the 
audio thread should be removed, unless someone came up with a better idea.

Regards,
   Marton

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
