Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:63467 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757165AbZLFCbl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Dec 2009 21:31:41 -0500
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR  system?
From: Andy Walls <awalls@radix.net>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Christoph Bartelmus <lirc@bartelmus.de>, dmitry.torokhov@gmail.com,
	j@jannau.net, jarod@redhat.com, jarod@wilsonet.com, khc@pm.waw.pl,
	kraxel@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@redhat.com, superm1@ubuntu.com
In-Reply-To: <9e4733910912041945g14732dcfgbb2ef6437ef62bb6@mail.gmail.com>
References: <20091204220708.GD25669@core.coreip.homeip.net>
	 <BEJgSGGXqgB@lirc>
	 <9e4733910912041628g5bedc9d2jbee3b0861aeb5511@mail.gmail.com>
	 <1259977687.27969.18.camel@localhost>
	 <9e4733910912041945g14732dcfgbb2ef6437ef62bb6@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 05 Dec 2009 21:30:24 -0500
Message-Id: <1260066624.3105.33.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2009-12-04 at 22:45 -0500, Jon Smirl wrote:
> On Fri, Dec 4, 2009 at 8:48 PM, Andy Walls <awalls@radix.net> wrote:
> > On Fri, 2009-12-04 at 19:28 -0500, Jon Smirl wrote:
> >> On Fri, Dec 4, 2009 at 6:01 PM, Christoph Bartelmus <lirc@bartelmus.de> wrote:
> >> > BTW, I just came across a XMP remote that seems to generate 3x64 bit scan
> >> > codes. Anyone here has docs on the XMP protocol?
> >>
> >> Assuming a general purpose receiver (not one with fixed hardware
> >> decoding), is it important for Linux to receive IR signals from all
> >> possible remotes no matter how old or obscure?
> >
> > Importance of any particular requirement is relative/subjective.  As is
> > usefulness of any existing functionality.
> >
> > Personally, I just think it's cool to pick up a random remote and use
> > Linux to figure out its protocol and its codes and get it working.
> 
> You are a technical user.

Yes, I agree.  I do not know what percentage of current Linux users are
technical vs non-technical, so I cannot gauge the current improtance.

I can see the trend line though: as time goes by, the percentage of all
linux users that have a technical bent will only get smaller.




> >> I've been working off the premise of getting rid of obscure remotes
> >> and replacing them with a universal one. The universal one can be set
> >> to send a common protocol like JVC or Sony. That implies that we only
> >> need one or two protocol decoders in-kernel which greatly reduces the
> >> surface area of the problem.
> >
> > The design should serve the users, the users should not serve the
> > design.  If the reduction of requirements scope starts forcing users to
> > buy new hardware, are we really serving the users or just asking them to
> > pay to compensate for our shortcomings?
> 
> Use of arbitrary remotes is a complex process. It almost certainly can
> not be done in a transparent "just works" manner.
> 
> Let me rephrase, is it ok to tell people to buy a new remote if they
> want to avoid a complex, technical configuration process that isn't
> even guaranteed to work (they might have a 56K remote and a 38K
> receiver or a Sony remote and a fixed RC-5 receiver).

"Recommended hardware" to guide users is usually an acceptable concept.

I have a feeling though, we may end up with a lot of "hey I got this
remote and video card on eBay and ..."

If the in kernel IR Rx handling is going to be really limited in trying
to "keep it simple", then that remote control hardware recommendation
should probably be strictly "the remote bundled with your IR receiver
hardware" to handle the most important use case for the in kernel IR Rx
handling to meet.



> I'm not proposing that we prevent arbitrary remotes from working,
> you're just going to need to expend more effort to make them work.
> For example, you have to have a fair amount of IR knowledge to figure
> out why those two cases above don't work. You might have to install
> LIRC and futz with irrecord and build your own config files and
> mapping tables, etc...
> 
> It doesn't have to only be a universal remote, we can pre-install
> mapping tables for the remotes commonly shipped with the v4l hardware.

At least one vendor, has shipped two different type of remote with the
same board over the years.  Also MCE versions of cards usually ship with
an MCE remote versus the standard one.  

I think it still could be possible to avoid a user interview process,
but I suspect you'll need a userspace set of "scripting" tools to take
detection data from the kernel and select the right kepymap.



> When the v4l drivers load they could even poke the default map for
> their bundled remotes directly into the input system if they wanted
> to. Doing that might save a lot of config issues.

They do that right now (well some of them and ir-kbd-i2c).  But there is
*no* intelligence beyond the most current or popular remote for a board.
Also, some things require things a manual or scripted module load by the
user: ir-kbd-i2c and lirc_i2c can't currently hook to the same I2C
device at once, so the user has to set one or the other up to be loaded.


> How this for new goals?
>   Specific IR drivers autoload maps for their bundled remotes by
> poking them into the input subsystem during module load
>   IR always has default map for a universal remote - it provides five
> devices and uses a common protocol like JVC (may not work for fixed
> hardware, you have to set these five common devices into the universal
> remote)
>   All of these maps can be overriden with user space commands (which
> lets you configure funky remotes)

This looks like it just adds the option for the user to trade away
mental effort with purchasing power (for a universal remote).  Not an
unacceptable trade for many people I guess.

I suppose it gives the user one option than he had before, if you have a
target set of universal remote hardware.  I'd like to see some vendor
diversity in that target set of "just works" universal remotes.




My whole thought on the in-kernel IR Rx implementation is try to do it
all, or do just enough to get by.

The just works case is improtant enough for me to relent that something
should reside in kernel.  I'm certainly OK with folks not spending a lot
of effort on it and not adding lots of code in kernel, so it works just
enough to hit the ground running for 80% of users.  But if that's the
case, do we need to also allow LIRC to process more than just raw pulse
data?


BTW, I found this breif a while ago that gives an algorithm for multiple
protocol recognition/discrimination:

http://www.audiodevelopers.com/temp/Remote_Controls.ppt

Maybe this would be easier for protocol detection than running
"parallel" decoders that spit out an answer and a confidence factor.


Regards,
Andy

