Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1KlCMZ-0002Ps-LZ
	for linux-dvb@linuxtv.org; Thu, 02 Oct 2008 02:48:16 +0200
From: Andy Walls <awalls@radix.net>
To: David Cintron <loudestnoise@gmail.com>
In-Reply-To: <2D4C0F1E-D73D-475C-BF64-91EF4A6E0BFE@gmail.com>
References: <2D4C0F1E-D73D-475C-BF64-91EF4A6E0BFE@gmail.com>
Date: Wed, 01 Oct 2008 20:47:05 -0400
Message-Id: <1222908425.2641.37.camel@morgan.walls.org>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] cx18: Testers needed for patch to solve	non-working
	CX23418 cards	under linux (Re: cx18: Possible
	causal	realtionship for HVR-1600 I2C	errors)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Mon, 2008-09-29 at 23:08 -0500, David Cintron wrote:
> > > > To all the users of CX23418 based cards that currently don't  
> seem to
> work, showing some of the above symptoms, please test my latest changes
> at: http://linuxtv.org/hg/~awalls/v4l-dvb

This repo should be OK for getting over initial problems (but it has a
buffering change that I probably won't ask to be pulled).  I would
however encourage you to use the main repo at

http://linuxtv.org/hg/v4l-dvb

or this one which has a patch to improve reliability for some older
systems:

http://linuxtv.org/hg/~awalls/cx18-mmio-fixes




> I can't seem to get the HVR-1600 working on my system and I've tried  
> awalls' revisions.  I already have a working PVR-500 in my system and  
> have am wondering if this is contributing to my problems.

Maybe, but not likely.



>  I can't seem  
> to get the card to initialize.  dmesg | grep cx18 returns nothing.

OK.  Let me ask some basic questions that you may have already verified:


1.  Does the following command show a cx18.ko module installed?

$ find /lib/modules -name cx18.ko -print



2. Does this command:

$ /sbin/lspci -vv

show a

"Multimedia video controller: Conexant CX23418 Single-Chip MPEG-2 Encoder with Integrated Analog Video/Broadcast Audio Decoder
Subsystem: Hauppauge computer works Inc. Unknown device 7444"

?


3. Have you installed the firmware from this archive:

http://dl.ivtvdriver.org/ivtv/firmware/cx18-firmware.tar.gz

into the proper directory (e.g. /lib/firmware) for your distribution?



4.  When you perform these commands as root:

# modprobe -r cx18
# modprobe cx18 debug=3

does modporbe emit any errors and what does 'dmesg' or /var/log/messages
show?  (Please don't grep on cx18, as not all relevant messages will
have cx18 in them.)


5.  When the module is loaded, it should always blurt out at least
"cx18:  Start initialization, version 1.0.0" in dmesg and messages,
unless the kernel couldn't load the module.  If the kernel couldn't load
the module, it should log an error message: what is that message?


> Also, I get the errors when running make unload:
> loudestnoise@loudestnoise-desktop:~/v4l-dvb-fc3285e4b3fa$ sudo make  
> unload

I wouldn't worry about those.  I get them too.  As long as lsmod shows
the modules have been unloaded, you're fine.



Regards,
Andy

> - David C. (loudestnoise)



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
