Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f192.google.com ([209.85.221.192]:43842 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757651AbZLEDpu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Dec 2009 22:45:50 -0500
MIME-Version: 1.0
In-Reply-To: <1259977687.27969.18.camel@localhost>
References: <20091204220708.GD25669@core.coreip.homeip.net> <BEJgSGGXqgB@lirc>
	 <9e4733910912041628g5bedc9d2jbee3b0861aeb5511@mail.gmail.com>
	 <1259977687.27969.18.camel@localhost>
Date: Fri, 4 Dec 2009 22:45:55 -0500
Message-ID: <9e4733910912041945g14732dcfgbb2ef6437ef62bb6@mail.gmail.com>
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR
	system?
From: Jon Smirl <jonsmirl@gmail.com>
To: Andy Walls <awalls@radix.net>
Cc: Christoph Bartelmus <lirc@bartelmus.de>, dmitry.torokhov@gmail.com,
	j@jannau.net, jarod@redhat.com, jarod@wilsonet.com, khc@pm.waw.pl,
	kraxel@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@redhat.com, superm1@ubuntu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Dec 4, 2009 at 8:48 PM, Andy Walls <awalls@radix.net> wrote:
> On Fri, 2009-12-04 at 19:28 -0500, Jon Smirl wrote:
>> On Fri, Dec 4, 2009 at 6:01 PM, Christoph Bartelmus <lirc@bartelmus.de> wrote:
>> > BTW, I just came across a XMP remote that seems to generate 3x64 bit scan
>> > codes. Anyone here has docs on the XMP protocol?
>>
>> Assuming a general purpose receiver (not one with fixed hardware
>> decoding), is it important for Linux to receive IR signals from all
>> possible remotes no matter how old or obscure?
>
> Importance of any particular requirement is relative/subjective.  As is
> usefulness of any existing functionality.
>
> Personally, I just think it's cool to pick up a random remote and use
> Linux to figure out its protocol and its codes and get it working.

You are a technical user.

>
>
>
>>  Or is it acceptable to
>> tell the user to throw away their dedicated remote and buy a universal
>> multi-function one?
>
> Nope.  That other OS provider forces device obsolescence or arbitrary
> constraints on users quite often and I don't like it myself.  That's why
> I use Linux.
>
>
>>   Universal multi-function remotes are $12 in my
>> grocery store - I don't even have to go to an electronics store.
>
> The old remote in my possession costs $0, and I don't even have to leave
> the house.
>
>
>> I've been working off the premise of getting rid of obscure remotes
>> and replacing them with a universal one. The universal one can be set
>> to send a common protocol like JVC or Sony. That implies that we only
>> need one or two protocol decoders in-kernel which greatly reduces the
>> surface area of the problem.
>
> The design should serve the users, the users should not serve the
> design.  If the reduction of requirements scope starts forcing users to
> buy new hardware, are we really serving the users or just asking them to
> pay to compensate for our shortcomings?

Use of arbitrary remotes is a complex process. It almost certainly can
not be done in a transparent "just works" manner.

Let me rephrase, is it ok to tell people to buy a new remote if they
want to avoid a complex, technical configuration process that isn't
even guaranteed to work (they might have a 56K remote and a 38K
receiver or a Sony remote and a fixed RC-5 receiver).

I'm not proposing that we prevent arbitrary remotes from working,
you're just going to need to expend more effort to make them work.
For example, you have to have a fair amount of IR knowledge to figure
out why those two cases above don't work. You might have to install
LIRC and futz with irrecord and build your own config files and
mapping tables, etc...

It doesn't have to only be a universal remote, we can pre-install
mapping tables for the remotes commonly shipped with the v4l hardware.
When the v4l drivers load they could even poke the default map for
their bundled remotes directly into the input system if they wanted
to. Doing that might save a lot of config issues.

How this for new goals?
  Specific IR drivers autoload maps for their bundled remotes by
poking them into the input subsystem during module load
  IR always has default map for a universal remote - it provides five
devices and uses a common protocol like JVC (may not work for fixed
hardware, you have to set these five common devices into the universal
remote)
  All of these maps can be overriden with user space commands (which
lets you configure funky remotes)

-- 
Jon Smirl
jonsmirl@gmail.com
