Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:50496 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753945AbcFQBCg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2016 21:02:36 -0400
Date: Thu, 16 Jun 2016 22:02:31 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Gregor Jasny <gjasny@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Ulrich Eckhardt <uli-lirc@uli-eckhardt.de>
Subject: Re: Need help with ir-keytable imon bug report
Message-ID: <20160616220231.69616e84@recife.lan>
In-Reply-To: <ac402439-e317-9d83-6c70-df592cc3cf63@googlemail.com>
References: <ac402439-e317-9d83-6c70-df592cc3cf63@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

HI Gregor,

Em Wed, 15 Jun 2016 22:25:06 +0200
Gregor Jasny <gjasny@googlemail.com> escreveu:

> Hello,
> 
> could someone please help me triaging the following ir-keytable bug? The
> reporter complains that the 'other' IR protocol results in double clicks
> and we should set the device to RC6 instead:
> 
> https://bugs.launchpad.net/ubuntu/+source/v4l-utils/+bug/1579760
> 
> This is what we have in v4l-utils:
> https://git.linuxtv.org/v4l-utils.git/tree/utils/keytable/rc_keymaps/imon_pad

The way it works is that the keymap table comes from the Kernel driver.

The scripts at v4l-utils just copies whatever is there.

Please notice that the IMON keymap is used by only one Kernel driver:
drivers/media/rc/imon.c, with supports two different protocols: RC6 and
a proprietary one (the driver calls it iMON protocol).
The driver actually supports two types of IR key maps, depending
on the protocol:

	if (ictx->rc_type == RC_BIT_RC6_MCE)
		rdev->map_name = RC_MAP_IMON_MCE;
	else
		rdev->map_name = RC_MAP_IMON_PAD;

In other words, it uses either the code at:
	drivers/media/IR/keymaps/rc-imon-pad.c (for the IMON protocol)
or
	drivers/media/rc/keymaps/rc-imon-mce.c (for RC6)

I suspect that the user is selecting the wrong keymap on the BZ
you mentioned. It should be using: 
	utils/keytable/rc_keymaps/imon_mce

if his device came with a RC6 IR. There's another possibility:
maybe some newer devices come with a different keymap than the
one available when the driver was originally written.

That's said, from his report:

	$ sudo ir-keytable
	Found /sys/class/rc/rc0/ (/dev/input/event4) with:
	 Driver imon, table rc-imon-pad
	 Supported protocols: other

It should be listing both "other" and "RC6" protocols there.
It sounds a Kernel regression. I remember one Kernel patch once
broke the list of protocols. Maybe the fix patch were not applied
on Ubuntu, or maybe some other regression happened.

-- 
Thanks,
Mauro
