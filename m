Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5K0aMiT002188
	for <video4linux-list@redhat.com>; Thu, 19 Jun 2008 20:36:22 -0400
Received: from mail-in-17.arcor-online.net (mail-in-17.arcor-online.net
	[151.189.21.57])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5K0a8Zj030672
	for <video4linux-list@redhat.com>; Thu, 19 Jun 2008 20:36:09 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Dag Wieers <dag@wieers.com>
In-Reply-To: <alpine.LRH.1.10.0806191639240.24892@horsea.3ti.be>
References: <alpine.LRH.1.10.0806191639240.24892@horsea.3ti.be>
Content-Type: text/plain
Date: Fri, 20 Jun 2008 02:33:47 +0200
Message-Id: <1213922027.2655.24.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Looking for a well suppord TV card with some requirements
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

Hi Dag, 

Am Donnerstag, den 19.06.2008, 16:47 +0200 schrieb Dag Wieers:
> Hi,
> 
> I am looking for a well support TV card with the following feature list:
> 
>    - Must have at least one tuner (PAL), preferably two
>    - Must have composite input (for connecting a Nintendo Wii)
>    - Should not have any delay between input signal and output
>    - Works on kernel 2.6.18 (either vanilla, or by adding a driver)
>    - Additionally, DVB-T would be nice
> 
> I bought a Hauppauge PVR-150 because I thought it complied to the above, 
> but apparently (because it is an MPEG encoder and not a real TV card) 
> there was a 2 second delay between the image from the Wii and the output 
> on screen which is unacceptable for playing games.
> 
> (And the sound didn't work, but I didn't try to look for a solution 
> because of the delay)
> 
> I still have an old Hauppauge WinTV card from 2000, based on the bttv 
> driver which works fine, but does not have composite input.
> 
> Who can help me find something acceptable ?
> 

this is likely still totally underinvestigated for GNU/Linux.

There was a recent newspaper/internet article somewhere about how
different and delayed the football goals come in depending on the used
TV reception system :)

This is a fact. Also censorship in the US for realtime broadcast.

Your best friends, sorry to say so, are likely the robotic and military
guys on it.

>From the surveillance freaks hanging around here, I can say that xawtv
has a fairly low latency, but it is still noticeable.

As a count of thumb, one likely can say as more physical memory is
involved, starts with what is on the card for risc operations and
buffering, the possible delay increases and it has an open end for any
application to do large buffering to escape real time hickups ...

Gaming is not such harmless as it sounds,
but it should be allowed ;)

Cheers,
Hermann




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
