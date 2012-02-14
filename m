Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754400Ab2BNUIf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Feb 2012 15:08:35 -0500
Message-ID: <4F3ABF41.9060800@redhat.com>
Date: Tue, 14 Feb 2012 15:08:33 -0500
From: Jarod Wilson <jarod@redhat.com>
MIME-Version: 1.0
To: W R <gridmuncher@hotmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Fintek driver linux
References: <BLU145-W35C32BF2C2E1EDFD8DC5F4BD800@phx.gbl>,<4F2822AE.1020705@redhat.com>,<BLU145-W31A99136480C1FBA4E0AC7BD770@phx.gbl>,<4F356866.6090208@redhat.com> <BLU145-W1658A220E336DBC96C53D7BD7C0@phx.gbl>
In-Reply-To: <BLU145-W1658A220E336DBC96C53D7BD7C0@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/14/2012 02:47 PM, W R wrote:
> Thanks again Jarod. I have emailed Jetway asking about the specs for the
> CIR header on the motheboard. (JNC64-LF - nvidia chipset, *not* Atom/Ion
> though...) which they have replied is the Fintek F71809 I/O chipset, and
> I believe the same chipset on many of their Atom boards.
> According to Fintek this had linux support since kernel 2.6.36? Not sure
> about that.

Looks like it went in upstream after 2.6.39, so the first release that 
carried it was actually 3.0.

If it really is the F71809, then the fix I had in mind shouldn't matter, 
but I'd have to question if its really that and not an F71869A, which is 
nearly identical, but needs to use a different logical device for the IR 
input, lest you lock up the system -- sounds familiar, eh? :)

However, its also possible its something else going on here, some sort 
of bad interaction between multiple different drivers all poking at the 
super i/o chip without any coordinated locking.

Now, I *think* that if you get evdev installed and run it against the 
input device that fintek-cir exposes, you should be able to see the chip 
ID to confirm if its really the F71809 or not. If you see Product and 
Version of 0x08 and 0x04 (or vice versa), then its indeed one of the 
older chips that use logical device 5. Anything else, and it should be 
logical device 8, and a patch that just went into the for-v3.4 media 
tree branch is necessary.

-j


> Since my previous email I have left my IR device plugged in to the
> header on the motherboard and I have added fintek-cir to the blacklist.
> After boot if I modprobe ir-rc6-decoder (which triggers rc-core and
> lirc_dev and all the other protocols etc.) then fairly quickly after
> that modprobe fintek-cir then 1 in 10 times it actually works. The other
> 9 times it freezes. It freezes everytime if I try to start fintek-cir
> first.
> I have already added my remotes config with the help of ir-keytable to
> /etc/rc_keymaps/ and pointed /etc/rc_maps.cfg towards it. It gets loaded
> automatically. I have uninstalled LIRC. A copy of my logs when it hasn't
> crashed is here: http://pastebin.com/MqETvBsz
> Not sure if any of this helps anyone, and to anyone reading this please
> feel free to point out any of my stupid errors!
>
>
>  > Date: Fri, 10 Feb 2012 13:56:38 -0500
>  > From: jarod@redhat.com
>  > To: gridmuncher@hotmail.com
>  > Subject: Re: Fintek driver linux
>  >
>  > On 02/05/2012 10:48 AM, W R wrote:
>  > > Tried various kernels, including 3.0.0 and 3.2 and kernel panic is
>  > > almost always caused when ir receiver plugged into cir header on
>  > > motherboard. If device plugged in after boot then it works fine.
> Can use
>  > > remote and configure buttons etc.
>  > >
>  > > Where's a good forum to discuss this openly so others with perhaps the
>  > > same issues can read it?
>  >
>  > linux-media@vger.kernel.org is the relevant upstream mailing list.
>  >
>  >
>  > > Any ideas off-hand why this is? I have various cir header options in
>  > > bios: Disabled, 3F8/IRQ4, 2F8/IRQ3, 3E8/IRQ4, 2E8/IRQ3 and have tried
>  > > all of these without luck, although I have once or twice been able to
>  > > boot into mythbuntu and its worked. But out of 50 odd boot attempts it
>  > > worked twice. I also have the choice to enable wake from CIR which
>  > > obviously I need to have on to be able to wake my HTPC with remote. Any
>  > > help would be greatly appreciated.
>  >
>  > According to my fintek contact, the CIR logical device on a number of
>  > shipped systems is actually different than the devel board I was
>  > provided, so there's a patch coming to account for that. Its possible
>  > what you're seeing is due to the incorrect logical device number, but
>  > I'm just shooting in the dark.
>  >
>  >
>  > --
>  > Jarod Wilson
>  > jarod@redhat.com


-- 
Jarod Wilson
jarod@redhat.com
