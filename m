Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9V9Qpnc010796
	for <video4linux-list@redhat.com>; Fri, 31 Oct 2008 05:26:51 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m9V9Q2xe006313
	for <video4linux-list@redhat.com>; Fri, 31 Oct 2008 05:26:03 -0400
Date: Fri, 31 Oct 2008 10:26:07 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <200810191632.36406.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.0810310955190.5691@axis700.grange>
References: <200810191632.36406.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jean Delvare <khali@linux-fr.org>, v4l <video4linux-list@redhat.com>
Subject: Re: Feedback wanted: V4L2 framework additions
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

Hi Hans,

On Sun, 19 Oct 2008, Hans Verkuil wrote:

> Hi all,
> 
> During the Linux Plumbers Conference I proposed additions to the V4L2 
> framework that should simplify driver development and ensure better 
> consistency between drivers.
> 
> The last few days I worked to get this framework in place and I would 
> like to get feedback on what I have right now.
> 
> The repository is here: 
> 
> http://linuxtv.org/hg/~hverkuil/v4l-dvb-media2/
> 
> The documentation is in:
> 
> linux/Documentation/video4linux/v4l2-framework.txt
> 
> The documentation is pretty complete, so that's probably a good place to 
> start.
> 
> The purpose of the framework is to move common administrative tasks to 
> the framework so that drivers do not have to do that themselves. In 
> addition, having all drivers use the same basic structures will make it 
> much easier to write new helper functions that only use those basic 
> structures and so can be independent of the driver-specific structs.

[snip]

ok, I had a very short look at your proposed framework. I only looked at 
the video part, because that's what I'm working with, and that's what I'm 
going to comment on here.

And there is at least one thing I haven't found there at all, which, I 
think, belongs to such an interface (and what currently makes up a 
significant part of the soc-camera framework): hardware interface 
parameter negotiation. Maybe this is not a big problem on closed cards / 
dongles, where the interface is fixed, but even then, I think, if you have 
two usb cameras with the same sensor, they might use different video 
interface configurations. If you want to share that sensor driver, you 
have to be able to negotiate with it which configuration to use. E.g., 
some sensors support both master and slave modes, some only master, maybe 
there are some, that only support the slave mode (I haven't seen any, but 
there can be some). Some hosts support one or the other mode, and some 
support both and have to be programmed accordingly. We assume, those who 
design hardware will only choose valid host / sensor configurations. So, 
let's assume, you have one USB camera with host A and sensor X, and one 
camera with host A and sensor Y, where X only runs as a master, and Y only 
as a slave. As long as you have two completely different drivers AX and 
AY, you just hard code master or slave and you're done. However, if you 
share the A driver and want to be able to talk to X and Y, you have to ask 
them what modes they support. Same goes for signal polarities (hsync, 
vsync, pixel clock, master clock, data), bus width.

Then there's a question of on-the-wire data representation, which I tried 
to discuss here:

http://marc.info/?l=linux-video&m=122423270414747&w=2

Ok, if I really wanted to start a discussion, I should have used a new 
thread with a different subject, but so far almost all my attempts to 
discuss design decisions on v4l ended up with silence:-) In any case, 
there came one reply from Magnus Damm, and he agreed with my idea to treat 
every possible pixel-format as transferred over the data bus as a new 
fourcc format, but I cannot say I'm quite happy about this, and not quite 
sure this wouldn't lead to an explosive growth of the number of fourcc 
codes, of which many will actually provide the same "end-user experience" 
and only differ in the way they are transferred from the sensor to the 
host.

So, if we decide to only maintain a minimal number of really different 
(from the user PoV) fourcc codes and use additional parameters 
(endianness, packing,...) to describe their on-the-wire representation, 
we'd need to handle that in such a host-device interface too.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
