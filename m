Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:58930 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757904AbZJDUjx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 4 Oct 2009 16:39:53 -0400
Subject: Re: [REVIEW] ivtv, ir-kbd-i2c: Explicit IR support for the AVerTV
 M116 for newer kernels
From: Andy Walls <awalls@radix.net>
To: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>,
	Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org,
	Oldrich Jedlicka <oldium.pro@seznam.cz>, hverkuil@xs4all.nl
In-Reply-To: <20091004092621.GB20457@moon>
References: <1254584660.3169.25.camel@palomino.walls.org>
	 <20091004083139.GA20457@moon> <20091004104452.7a6d0f9b@hyperion.delvare>
	 <20091004092621.GB20457@moon>
Content-Type: text/plain
Date: Sun, 04 Oct 2009 16:41:01 -0400
Message-Id: <1254688861.3148.137.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-10-04 at 12:26 +0300, Aleksandr V. Piskunov wrote:
> On Sun, Oct 04, 2009 at 10:44:52AM +0200, Jean Delvare wrote:
> > On Sun, 4 Oct 2009 11:31:39 +0300, Aleksandr V. Piskunov wrote:
> > > Tested on 2.6.30.8, one of Ubuntu mainline kernel builds.
> > > 
> > > ivtv-i2c part works, ivtv_i2c_new_ir() gets called, according to /sys/bus/i2c
> > > device @ 0x40 gets a name ir_rx_em78p153s_ave.
> > > 
> > > Now according to my (very) limited understanding of new binding model, ir-kbd-i2c
> > > should attach to this device by its name. Somehow it doesn't, ir-kbd-i2c gets loaded
> > > silently without doing anything.
> > 
> > Change the device name to a shorter string (e.g. "ir_rx_em78p153s").
> > You're hitting the i2c client name length limit. More details about
> > this in the details reply I'm writing right now.
> 
> Thanks, it works now. ir-kbd-i2c picks up the short name, input device is created, remote
> works.
> 
> Another place where truncation occurs is name field in em78p153s_aver_ir_init_data 
> ("ivtv-CX23416 EM78P153S AVerMedia"). Actual input device ends up with a name
> "i2c IR (ivtv-CX23416 EM78P153S ", limited by char name[32] in IR_i2c struct.

I'm naive here.  What applications actually show this string or use it?
For what purposes do applications use it?


> IMHO actual name of resulting input device should be readable by end-user. Perhaps it should
> include the short name of the card itself, or model/color of remote control itself if several
> revisions exist, etc.

The em28xx driver uses things like:

	i2c IR (EM28XX Terratec)
	i2c IR (EM28XX Pinnacle PCTV)

The saa7134 driver uses thing like:
	
	Pinnacle PCTV
	Purple TV
	MSI TV@nywhere Plus
	HVR 1110
	BeholdTV

The cx18 driver (i.e. me) uses:

	CX23418 Z8F0811 Hauppauge


I appear to be user-unfriendly. ;)  I guess I like knowing what devices
are precisely involved, as it helps me when I need to troubleshoot.  I
agree that it doesn't help the normal user in day to day operations.

I will change the names to something more card specific.  It could end
up slightly misleading in the long run.  A single card entry in
ivtv-cards.c can describe multiple card variants, but gives all those
variants the same "name" whether or not the consumer retail names are
the same.


Regards,
Andy


