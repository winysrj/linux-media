Return-path: <linux-media-owner@vger.kernel.org>
Received: from bamako.nerim.net ([62.4.17.28]:60561 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754099AbZJAKGI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Oct 2009 06:06:08 -0400
Date: Thu, 1 Oct 2009 12:06:09 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Andy Walls <awalls@radix.net>,
	=?UTF-8?B?UGF3ZcWC?= Sikora <pluto@agmk.net>
Cc: linux-kernel@vger.kernel.org, LMML <linux-media@vger.kernel.org>
Subject: Re: [2.6.31] ir-kbd-i2c oops.
Message-ID: <20091001120609.50327134@hyperion.delvare>
In-Reply-To: <1254354167.4771.7.camel@palomino.walls.org>
References: <200909160300.28382.pluto@agmk.net>
	<200909161003.33090.pluto@agmk.net>
	<20090929161629.2a5c8d30@hyperion.delvare>
	<200909301016.15327.pluto@agmk.net>
	<20090930125737.704413c8@hyperion.delvare>
	<1254354167.4771.7.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

On Wed, 30 Sep 2009 19:42:46 -0400, Andy Walls wrote:
> On Wed, 2009-09-30 at 12:57 +0200, Jean Delvare wrote:
> > Not sure why you look at address 0x83e? The stack trace says +0x64. As
> > function ir_input_init() starts at 0x800, the oops address would be
> > 0x864, which is:
> > 
> > 864:	f0 0f ab 31          	lock bts %esi,(%rcx)
> > 
> > If my disassembler skills are still worth anything, this corresponds to
> > the set_bit instruction in:
> > 
> > 	for (i = 0; i < IR_KEYTAB_SIZE; i++)
> > 		set_bit(ir->ir_codes[i], dev->keybit);
> > 
> > in the source code. This suggests that ir->ir_codes is smaller than
> > expected (sounds unlikely as this array is included in struct
> > ir_input_state) or dev->keybit isn't large enough (sounds unlikely as
> > well, it should be large enough to contain 0x300 bits while ir keycodes
> > are all below 0x100.) So most probably something went wrong before and
> > we're only noticing now.
> 
> Jean,
> 
> You should be aware that the type of ir_codes changed recently from 
> 
> IR_KEYTAB_TYPE
> 
> to
> 
> struct ir_scancode_table *
> 
> 
> I'm not sure if it is the problem here, but it may be prudent to check
> that there's no mismatch between the module and the structure
> definitions being pulled in via "#include"  (maybe by stopping gcc after
> the preprocessing with -E ).

Thanks for the hint. As far as I can see, this change is new in kernel
2.6.32-rc1. In 2.6.31, which is where Pawel reported the issue, we
still have IR_KEYTAB_TYPE.

Pawel, are you by any chance mixing kernel drivers of different
sources? Best would be to provide the output of rpm -qf and modinfo for
all related kernel modules:

rpm -qf /lib/modules/$(uname -r)/kernel/drivers/media/video/ir-kbd-i2c.ko
rpm -qf /lib/modules/$(uname -r)/kernel/drivers/media/common/ir-common.ko
rpm -qf /lib/modules/$(uname -r)/kernel/drivers/media/video/saa7134/saa7134.ko

modinfo ir-kbd-i2c
modinfo ir-common
modinfo saa7134

Thanks,
-- 
Jean Delvare
