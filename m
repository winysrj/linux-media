Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3QHlu7w015168
	for <video4linux-list@redhat.com>; Sat, 26 Apr 2008 13:47:56 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3QHlfxi006450
	for <video4linux-list@redhat.com>; Sat, 26 Apr 2008 13:47:41 -0400
From: Andy Walls <awalls@radix.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <200804261657.37708.hverkuil@xs4all.nl>
References: <200804261657.37708.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Sat, 26 Apr 2008 13:47:35 -0400
Message-Id: <1209232055.3195.57.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: Is PAL-N supported by an NTSC tuner?
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

On Sat, 2008-04-26 at 16:57 +0200, Hans Verkuil wrote:
> Hi all,
> 
> I am trying to figure out which analog TV standards are supported by a 
> card with an NTSC tuner. Most cards come in two variants: one with an 
> NTSC tuner and one with a PAL/SECAM tuner. However, it is not as clear 
> to me which of the more obscure PAL standards require an NTSC tuner.

I'll try and answer off the cuff (I left my EE's Handbook on my
bookshelf at work).

I think the critical thing here is which letter system the tuner needs
to support, M, J, N, etc. and not NTSC this vs. PAL that.  The letters
M, N, etc. give information about channel bandwidth, vestigal sideband
width, video signal bandwidth, color carrier freq and bandwidth, and
audio freq and bandwidth.  These are the things that matter to the
design of analog tuner stages (Pre-amps, synthesizers, 1st mixers, IF
amps, IF filters, detectors, AGC amps, PLLs, demodulators, traps, output
filters and output amps).

This page gives a short (non-authoritative) comparison of M vs. N
systems:

http://www.pembers.freeserve.co.uk/World-TV-Standards/Transmission-Systems.html

If this page is accurate, M & N systems are pretty much the same, except
for the color subcarrier center freqs. 


> 
> I know that an NTSC tuner is required for PAL-M and PAL-Nc, but what 
> about PAL-N?

N and Nc appear to only differ on things like sync, black, and blanking
levels.  It really shouldn't be a critical difference to a programmable
tuner can, but the video detector and/or AGC may get thrown off a
little.

As long as all the filter stages of an analog tuner are designed for the
bandwidth (or larger) that the letter standard calls out, and the
oscillators/synthesizers can be programmed to the proper frequencies to
get the right IF freq's and have PLL's lock onto the right sound and
color subcarriers, it should be doable.  (No guarantees on meeting
rejection specifications though, if the tuner wasn't designed for the
particular letter standard.)

Given how close M is to N, all you may need to worry about is color
subcarrier locking.

Summary:
No other letter designation looks closer to N and Nc (combination N)
than M on the webpage cited above.  So a programmable (NTSC-)M tuner can
is probably something you could use to support PAL-N.  A programmable
tuner can designated Nc should be able to do N as well.


Does anyone have experience to the contrary?  (I have no experience with
the difference between M, N, & Nc, aside from reading the specs.)

Regards,
Andy

> PAL-60 and NTSC 4.43 are never broadcast, so these play no role when it 
> comes to tuner support.
> 
> Regards,
> 
> 	Hans
> 
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
