Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:40748 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757357AbZJBULd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Oct 2009 16:11:33 -0400
Subject: Re: Upgrading from FC4 to current Linux
From: Andy Walls <awalls@radix.net>
To: Bill Davidsen <davidsen@tmr.com>
Cc: video4linux M/L <video4linux-list@redhat.com>,
	linux-media@vger.kernel.org
In-Reply-To: <4AC5FA6E.2000201@tmr.com>
References: <4AC5FA6E.2000201@tmr.com>
Content-Type: text/plain
Date: Fri, 02 Oct 2009 16:14:14 -0400
Message-Id: <1254514454.3169.51.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Bill,

On Fri, 2009-10-02 at 09:04 -0400, Bill Davidsen wrote:
> I am looking for a video solution which works on recent Linux, like Fedora-11.

The video4linux ML is just about dead.  You should post to
linux-media@vger.kernel.org 


> Video used to be easy, plug in the capture device, install xawtv via rpm, and 
> use. However, recent versions of Fedora simply don't work, even on the same 
> hardware, due to /dev/dsp no longer being created and the applications like 
> xawtv or tvtime still looking for it.

(Non-emulated) OSS was ditched by the linux kernel folks long ago.  And
I thought xawtv and tvtime were abandon-ware.


> The people who will be using this are looking for hardware which is still made 
> and sold new, and software which can be installed by a support person who can 
> plug in cards (PCI preferred) or USB devices, and install rpms.

rpmfusion, ATrpms, and I even think Fedora have MythTV available now.
mplayer is probably also available from 2 of those 3 resources.

For any open source software that implements video and audio decoders,
you will need to investigate if you must pay someone licensing fees to
use the decoders you need to meet your usage requirements.  Fedora has a
mechanism in place by which you can pay for the non-free codecs, IIRC.


>  I maintain the 
> servers on Linux there, desktop support is unpaid (meaning I want a solution 
> they can use themselves).
> 
> We looked at vlc, which seems to want channel frequencies in kHz rather than 
> channels, mythtv, which requires a database their tech isn't able (or willing) 
> to support, etc.

After vlc or mplayer has started capturing, just use ivtv-tune to change
analog channels by channel numbers (using your applicable channel table
built into ivtv-tune).  You can even set the channel before starting the
capture, if you can supress vlc from trying to change the channel.


> It seems that video has gone from "easy as Windows" 3-4 years ago to "insanely 
> complex" according to to one person in that group who wanted an upgrade on his 
> laptop.

Most people perceive large number of "options", and the control afforded
to the user by those options, as "complexity".  I'd say that Linux is
all about giving the user options and control.  I wouldn't expect that
to go away any time soon.

If your user wants someone else to put in the effort for him, he either
has to give up control (e.g. buy Windows) or incentivize someone to
manage the options and flexibility (a.k.a. complexity) he does not wish
to manage.



> There is some pressure from Windows users to mandate Win7 as the 
> desktop, which Linux users are rejecting.

And if the Linux users value their freedoms and control over their own
destiny, you think they'd be willing to put in the effort to maintain
it.

The price of freedom is eternal vigilance.


As far as mandates go, those are usually short-sighted one-size-fits-all
solution attempts, often backed by flawed reasoning along the lines of:

"Keeping track of all these different things (computers and OSen, and
software apps) is complex.  My life would be simpler, if I reduced the
complexity by standardizing on what I think is right; regardless of all
the domain or department specific subtlties and requirements that I'm
choosing to ignore."

Mandates are easy to push back on once you debunk the cost equation the
person is using to justify the mandate.  They often haven't considered
everthing.



> The local cable is a mix of analog channels (for old TVs) and clear qam. The 
> capture feeds from the monitor system are either S-video or three wire composite 
> plus L-R audio. Any reasonable combination of cards (PCI best, PCIe acceptable), 


An HVR-1600 is a PCI board based on the CX23418, that can capture analog
(NTSC for RF, Worldwide for CVBS or SVideo) and digital (ATSC or QAM) TV
simultaneously.

The Leadtek WinFast DVR 3100 H board, based on the CX23418, can accept Y
Pr Pb inputs as analog baseband.  I would need to fix the cx18 driver
under Linux to actually support that input (so far no one has asked for
it and I don't have test hardware).  Simultaneous analog and digital
capture are possible as long as they both aren't trying to use the
XCeive tuner (which can only do one thing at any one time).

But PCI is rapidly disappearly from modern motherboards.  I assume
within 5 years, most PCI-only motherboards will be failing due to old
age.



> USB device, and application which can monitor/record would be fine, but the 
> users are not going to type in kHz values, create channel tables, etc.

Honestly, a separate analog tuning app is something one can easily write
to meet the exact requirements of one's demanding userbase.  Of course
ivtv-tune is good enough for mostly everyone I've heard express a need.

With DVB under linux, you have no choice but to build a channels.conf
file.  Whether that's MythTV, mplayer, or something else.  You could
build a single file for all your users and install it for them, if it is
beyond their skills.


>  They want 
> something as easy to use as five years ago.

> Any thoughts?

One person's "easy to use", is another person's "alot of work".

You mentioned where you work Linux desktop support is unpaid, so I
assume you don't want to do that extra work.  Likewise most of the folks
here are unpaid and don't want to do your users' work for them either.

As for a suggestion:
Move to Ubuntu.  That distribution has a focus on helping the novice or
unskilled user that is unparalleled by the other distributions, IMO.
They've done "alot of work" on usability; maybe they've got video
smoothed out for the average user (I don't know for sure).

I started using RedHat (now Fedora) because of my prior years of
REAL/IX, IRIX, and HP-UX system admin experience and the similar System
V-ish feel of RedHat 5.2.  "Fedora" and "easy to use" are two things I
rarely associate without a lot of qualification.


If you really want a RH-like distribution that's easy to use, then pay
for RHEL support or some other support plan.  I bet they'll still be
cheaper than Windows support in the long run, but that also depends on
your actual requirements.




Regards,
Andy

