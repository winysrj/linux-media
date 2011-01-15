Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:41571 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752448Ab1AOEgI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jan 2011 23:36:08 -0500
Subject: Re: [PATCH] hdpvr: enable IR part
From: Andy Walls <awalls@md.metrocast.net>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Jean Delvare <khali@linux-fr.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Janne Grunau <j@jannau.net>, Jarod Wilson <jarod@redhat.com>
In-Reply-To: <661A728F-3CF1-47F3-A650-D17429AF7DF1@wilsonet.com>
References: <20110114195448.GA9849@redhat.com>
	 <1295041480.2459.9.camel@localhost> <20110114220759.GG9849@redhat.com>
	 <661A728F-3CF1-47F3-A650-D17429AF7DF1@wilsonet.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Jan 2011 23:35:41 -0500
Message-ID: <1295066141.2459.34.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, 2011-01-14 at 21:30 -0500, Jarod Wilson wrote:
> On Jan 14, 2011, at 5:08 PM, Jarod Wilson wrote:

> >>> Registered IR keymap rc-hauppauge-new
> >>> input: i2c IR (HD PVR) as /devices/virtual/rc/rc1/input6
> >>> rc1: i2c IR (HD PVR) as /devices/virtual/rc/rc1
> >>> ir-kbd-i2c: i2c IR (HD PVR) detected at i2c-1/1-0071/ir0 [Hauppage HD PVR I2C]
> 
> And it *almost* works. Every key on the bundled remote is recognized, but
> every press gets feedback about like this w/evtest:
> 
> Event: time 1295058330.966180, type 4 (Misc), code 4 (ScanCode), value 29
> Event: time 1295058330.966212, type 1 (Key), code 401 (Blue), value 1
> Event: time 1295058330.966220, -------------- Report Sync ------------
> Event: time 1295058331.066175, type 4 (Misc), code 4 (ScanCode), value 29
> Event: time 1295058331.166290, type 4 (Misc), code 4 (ScanCode), value 29
> Event: time 1295058331.275664, type 4 (Misc), code 4 (ScanCode), value 29
> Event: time 1295058331.376160, type 4 (Misc), code 4 (ScanCode), value 29
> Event: time 1295058331.465505, type 1 (Key), code 401 (Blue), value 2
> Event: time 1295058331.476161, type 4 (Misc), code 4 (ScanCode), value 29
> Event: time 1295058331.498502, type 1 (Key), code 401 (Blue), value 2
> Event: time 1295058331.531504, type 1 (Key), code 401 (Blue), value 2
> Event: time 1295058331.564503, type 1 (Key), code 401 (Blue), value 2
> Event: time 1295058331.576153, type 4 (Misc), code 4 (ScanCode), value 29
> Event: time 1295058331.597502, type 1 (Key), code 401 (Blue), value 2
> Event: time 1295058331.630501, type 1 (Key), code 401 (Blue), value 2
> Event: time 1295058331.663502, type 1 (Key), code 401 (Blue), value 2
> Event: time 1295058331.696500, type 1 (Key), code 401 (Blue), value 2
> Event: time 1295058331.729503, type 1 (Key), code 401 (Blue), value 2
> Event: time 1295058331.762502, type 1 (Key), code 401 (Blue), value 2
> Event: time 1295058331.795500, type 1 (Key), code 401 (Blue), value 2
> Event: time 1295058331.825507, type 1 (Key), code 401 (Blue), value 0
> Event: time 1295058331.825526, -------------- Report Sync ------------
> 
> That's just a single short press. With arrow keys, its quite funky to
> watch in, say, mythtv UI menus. Hit up, and it moves up one, stalls for a
> second, then moves up several more.

Hmm bizzarre.

> ...
> >> Note, that code in lirc_zilog.c indicates that ir-kbd-i2c.c's function
> >> get_key_haup_xvr() *may* need some additions to account for the Rx data
> >> format.  I'm not sure of this though.  (Or a custom get_key() in the
> >> hdpvr module could be provided as a function pointer to ir-kbd-i2c.c via
> >> platform_data.)
> >> 
> >> I will provide a debug patch in another email so that it's easier to see
> >> the data ir-kbd-i2c.c sees coming from the Z8.
> > 
> > I'll tack that onto the machine I've got hooked to the hdpvr and see what
> > I can see this weekend, thanks much for the pointers.
> 
> I'm inclined to think that it does indeed need some of the changes from
> lirc_zilog brought over (or the custom get_key()). Now on to adding that
> patch and some testing with lirc_zilog...

Yes, maybe both the Rx data parsing *and* the precise delay between Rx
polls.


BTW, a checkpatch and compiler tested lirc_zilog.c is here:

http://git.linuxtv.org/awalls/media_tree.git?a=shortlog;h=refs/heads/z8

It should fix all the binding and allocation problems related to
ir_probe()/ir_remove().  Except I suspect it may leak the Rx poll
kthread.  That's possibly another bug to add to the list.

Anyway, $DIETY knows if the lirc_zilog module actually still works after
all my hacks.  Give it a test if you are adventurous.  I won't be able
to test until tomorrow evening.

Regards,
Andy

