Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:64340 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbZJDIcV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Oct 2009 04:32:21 -0400
Received: by bwz6 with SMTP id 6so1883547bwz.37
        for <linux-media@vger.kernel.org>; Sun, 04 Oct 2009 01:31:43 -0700 (PDT)
Date: Sun, 4 Oct 2009 11:31:39 +0300
From: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>
To: Andy Walls <awalls@radix.net>
Cc: Jean Delvare <khali@linux-fr.org>,
	"Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>,
	Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org,
	Oldrich Jedlicka <oldium.pro@seznam.cz>, hverkuil@xs4all.nl
Subject: Re: [REVIEW] ivtv, ir-kbd-i2c: Explicit IR support for the AVerTV
	M116 for newer kernels
Message-ID: <20091004083139.GA20457@moon>
References: <1254584660.3169.25.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254584660.3169.25.camel@palomino.walls.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Oct 03, 2009 at 11:44:20AM -0400, Andy Walls wrote:
> Aleksandr and Jean,
> 
> Zdrastvoitye & Bonjour,
> 
> To support the AVerMedia M166's IR microcontroller in ivtv and
> ir-kbd-i2c with the new i2c binding model, I have added 3 changesets in
> 
> 	http://linuxtv.org/hg/~awalls/ivtv
> 
> 01/03: ivtv: Defer legacy I2C IR probing until after setup of known I2C devices
> http://linuxtv.org/hg/~awalls/ivtv?cmd=changeset;node=3d243437f046
> 
> 02/03: ivtv: Add explicit IR controller initialization for the AVerTV M116
> http://linuxtv.org/hg/~awalls/ivtv?cmd=changeset;node=0127ed2ea55b
> 
> 03/03: ir-kbd-i2c: Add support for the AVerTV M116 with the new binding model
> http://linuxtv.org/hg/~awalls/ivtv?cmd=changeset;node=c10e0d5d895c
> 
> 
> I cannot really test them as I still am using an older kernel.  Could
> you please review, and test them if possible?
> 

Thank you, Andy! Much more elegant solution than simply pounding 0x40 on every ivtv
board.

Tested on 2.6.30.8, one of Ubuntu mainline kernel builds.

ivtv-i2c part works, ivtv_i2c_new_ir() gets called, according to /sys/bus/i2c
device @ 0x40 gets a name ir_rx_em78p153s_ave.

Now according to my (very) limited understanding of new binding model, ir-kbd-i2c
should attach to this device by its name. Somehow it doesn't, ir-kbd-i2c gets loaded
silently without doing anything.
