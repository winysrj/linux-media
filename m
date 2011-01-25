Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:4609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314Ab1AYBO4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Jan 2011 20:14:56 -0500
Message-ID: <4D3E240B.8040807@redhat.com>
Date: Mon, 24 Jan 2011 23:14:51 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 12/13] [media] rc/keymaps: Rename Hauppauge table as rc-hauppauge
References: <cover.1295882104.git.mchehab@redhat.com>	 <20110124131847.59882afe@pedra> <1295914959.2420.38.camel@localhost>
In-Reply-To: <1295914959.2420.38.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 24-01-2011 22:22, Andy Walls escreveu:
> On Mon, 2011-01-24 at 13:18 -0200, Mauro Carvalho Chehab wrote:
>> There are two "hauppauge-new" keymaps, one with protocol
>> unknown, and the other with the protocol marked accordingly.
>> However, both tables are miss-named.
>>
>> Also, the old rc-hauppauge-new is broken, as it mixes
>> three different controllers as if they were just one.
>>
>> This patch solves half of the problem by renaming the
>> correct keycode table as just rc-hauppauge. This table
>> contains the codes for the four different types of
>> remote controllers found on Hauppauge cards, properly
>> mapped with their different addresses.
> 
> Are you sure about doing this?
> 
> The problem is that the old black Hauppauge remote is using the same
> RC-5 address as a common RC-5 TV remote: address 0x00.
> 
> See the table at the bottom of:
> 	http://www.sbprojects.com/knowledge/ir/rc5.htm
> 
> IMO, RC-5 address 0x00 is not an address that every Hauppauge card
> should be responding to by default.
> 
> I'm not too concerned with addresses 0x1d, 0x1e, and 0x1f colliding with
> other consumer electronics remotes.

I understand your points. This is part of a major plan of cleaning
up the keyboard tables.

With respect to this change, there are some points to consider:

1) Both of the current Hauppauge-new tables are already "polluted"
   with the 4 remote controllers (see the comments about the
   Hauppauge black inside them);

2) Currently, for all drivers that use the old RC_HAUPPAUGE_NEW 
   (most drivers), will only only with the Hauppauge Black, as
   the get_key functions for Hauppauge will return the full scancode.
   As the table as just the command part, that means that remote
   controls with address <> 0 won't work anymore (ok, this is a
   regression);

3) The RC_RC5_HAUPPAUGE_NEW table is also broken, as it has the
   "Hauppauge Black" keycodes there, but all prefixed by 0x1e.

4) There are several hacks to enable/disable the Hauppauge black,
   on several drivers. I doubt that those modprobe parameters 
   are properly documented at the Kernel docs, so users will
   likely have some bad time to discover the issues and find some
   useful information for their device to work.

5) Not all TV sets will accept address=0. I did a quick test here with
   5 different TV sets. None accepted it. Ok, this is not a good statistics,
   but, any Universal keyboard has hundreds of different keycodes for
   different TV sets, so, the changes to actually having a TV that
   accepts RC5 is not that high;

6) Not all TV boards/sticks are used on places with a TV set;

7) From my POV, it is more important to make the devices hot-pluggable
   than to be concerned about any possible interferences with other
   devices;

8) Since the old "RC_HAUPPAUGE_NEW" supports the Hauppauge black,
   that means that old boards were shipped with that IR and that people
   didn't bother on that time to split because the same board type were 
   sold with different remote types. So, there's probably no safe
   way to uniquely associate the Old Black with the cards.

9) The people that needs to take care about interference between
   Remotes can/should customise their RC keycode tables. It is simple
   to remove the conflict keycodes from the /etc/rc_maps/rc-hauppauge
   and let udev load a table that won't cause any conflict. On VDR
   environments, this will likely be done anyway, as the users won't
   use the shipped remote but, instead, an universal one.

10) The idea is to remove the in-kernel maps from the kernel, in favor
    of just using the userspace tool. On this scenario, all those in-kernel
    hacks interfere at the keycode loads should disappear, otherwise,
    they'll cause problems. We'll likely remove it for .39 or .40,
    after having some feedback from users. My plan is to have v4l-utils
    0.8.2 with the udev-load mechanism (is is already there at git), and
    ship it on Fedora 15, to get such feedback. Other distros are welcome
    to do the same.

11) After having all keycodes shipped via userspace, I think we should
    break those keytables that support more than one different type into
    per-remote keytables, and having "grouped" keycodes for those that
    just want their device to support and don't want to spend some time
    to discover what's his specific remote type.

So, I think that, while it might cause some confusion at the beginning
for a few, this change is the right way for doing it in the long term.

Cheers,
Mauro
