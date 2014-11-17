Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:45456 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961AbaKQO7U (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Nov 2014 09:59:20 -0500
Date: Mon, 17 Nov 2014 12:59:09 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sean Young <sean@mess.org>
Cc: Andy Walls <awalls.cx18@gmail.com>,
	Jarod Wilson <jwilson@redhat.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>,
	linux-media@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: staging: media: lirc: lirc_zilog.c: replace custom print macros
 with dev_* and pr_*
Message-ID: <20141117125909.2729440b@recife.lan>
In-Reply-To: <20141109213517.GA1349@gofer.mess.org>
References: <20141031130600.GA16310@mwanda>
	<20141031142644.GA4166@localhost.localdomain>
	<20141031143541.GM6890@mwanda>
	<20141106124629.GA898@gofer.mess.org>
	<20141106110549.1812acc7@recife.lan>
	<20141106132113.GA1367@gofer.mess.org>
	<697D038C-4BD9-4113-8E7E-B89BACF09AC2@gmail.com>
	<6BB6C08A-32A2-4A37-B6F7-332556C9626E@gmail.com>
	<20141109213517.GA1349@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 9 Nov 2014 21:35:17 +0000
Sean Young <sean@mess.org> escreveu:

> On Thu, Nov 06, 2014 at 08:56:47AM -0500, Andy Walls wrote:
> > On November 6, 2014 8:54:28 AM EST, Andy Walls <awalls.cx18@gmail.com> wrote:
> > >Sean,
> > >
> > >Ir-kbd-i2c was never intended for Tx.
> > >
> > >You can transmit *short* arbitrary pulse-space streams with the zilog
> > >chip, by feeding it a parameter block that has the pulse timing
> > >information and then subsequently has been obfuscated.  The firmware
> > >file that LIRC uses in userspace is full of predefined versions of
> > >these things for RC5 and NEC IIRC.  This LIRC firmware file also holds
> > >the (de)obfuscation key.
> > >
> > >I've got a bunch of old notes on this stuff from essentially reverse
> > >engineering the firmware in the Z8.  IANAL, but to me, its use in
> > >developing in-kernel stuff could be dubious.
> > >
> > >Regards,
> > >Andy
> 
> Very interesting.
> 
> I had considered reverse engineering the z8 firmware but I never found a
> way to access it. I guess we have three options:
> 
> 1. I could use Andy's notes to implement Tx. I have not seen the original
>    firmware code so I'm not contaminated by reverse engineering it. IANAL 
>    but I thought this is an acceptable way of writing a driver.
> 
> 2. Hauppauge could prove us with documentation to write a driver with.

I tried to get some info about that, but they are unable to get anything
related to this design so far.

So, I think that, if you have some time to dedicate to it, the best would
be to go for  option #1.

> 3. Leave it as-is, lirc_zilog will eventually be deleted from staging as it
>    can't be ported to rc-core.
> 
> 
> Sean
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
