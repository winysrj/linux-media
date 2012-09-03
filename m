Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:45166 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692Ab2ICVz0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Sep 2012 17:55:26 -0400
Date: Mon, 3 Sep 2012 23:55:21 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Jarod Wilson <jarod@redhat.com>
Cc: linux-media@vger.kernel.org, mchehab@redhat.com, sean@mess.org
Subject: Re: [PATCH 0/8] rc-core: patches for 3.7
Message-ID: <20120903215521.GA6675@hardeman.nu>
References: <20120825214520.22603.37194.stgit@localhost.localdomain>
 <20120830195612.GA13026@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120830195612.GA13026@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 30, 2012 at 03:56:12PM -0400, Jarod Wilson wrote:
>On Sat, Aug 25, 2012 at 11:46:47PM +0200, David Härdeman wrote:
>> This is two minor winbond-cir fixes as well as the first six patches
>> from my previous patchbomb.
>> 
>> The latter have been modified so that backwards compatibility is retained
>> as much as possible (the format of the sysfs files do not change for
>> example).
>
>I've read through the set, and it all seems to make sense to me, but I
>haven't actually tried it out with any of the hardware I've got. I assume
>its been tested on various other hardware though.

I've tested the patches on mceusb hardware (RX only) and using some
scripted TX/RX testing with rc-loopback. I haven't tested (this latest
version) on winbond-cir hardware yet as I'm travelling.

>Side note: my life has been turned a wee bit upside down, been busy
>dealing with some fairly big changes, and that's still ongoing, thus the
>relative lack of repsonsiveness on, well, anything, lately.

If you have limited time and bandwidth I'd suggest that you focus on the
API changes - in this particular patchset that would be the addition of
the "struct rc_keymap_entry" to the EVIOC[GS]KEYCODE_V2 ioctl (maybe we
should involve the input maintainer as well?).

Getting the API right would benefit from you cooperation, getting bugs
worked out is hopefully something which can be done with or without you.

Thanks,
David

