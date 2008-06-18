Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1K8loy-0001Ie-Oo
	for linux-dvb@linuxtv.org; Wed, 18 Jun 2008 02:46:45 +0200
From: Andy Walls <awalls@radix.net>
To: Brandon Jenkins <bcjenkins@tvwhere.com>
In-Reply-To: <D5F1658C-2441-4532-859E-D9ABECA20BA5@tvwhere.com>
References: <de8cad4d0806150505k6b865dedq359d278ab467c801@mail.gmail.com>
	<1213567472.3173.50.camel@palomino.walls.org>
	<1213573393.2683.85.camel@pc10.localdom.local>
	<1213579027.3164.36.camel@palomino.walls.org>
	<D5F1658C-2441-4532-859E-D9ABECA20BA5@tvwhere.com>
Date: Tue, 17 Jun 2008 20:46:02 -0400
Message-Id: <1213749962.5101.11.camel@palomino.walls.org>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] cx18 - dmesg errors and ir transmit
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

On Tue, 2008-06-17 at 09:17 -0400, Brandon Jenkins wrote:
> On Jun 15, 2008, at 9:17 PM, Andy Walls wrote:

> Andy,
> 
> Thank you for taking an interest.

I need a working IR blaster for my ATSC to NTSC converter box by Feb
2009, so I was mildly interested anyway.


>  I am not quite sure what you said  
> above,

Short story:

1. I need to make additions to cx18 first.  I've noted which pins are
used on the IR chip on the HVR-1600, and have to make some informed
guesses about how to properly write a reset function for the IR chip.
I'll have to test that reset function before I release it so as not to
cause anyone problems.

2. Someone will have to modify the lirc_pvr150 module to work with a
cx18 based card.  In the course of testing the driver reset function,
I'll probably have to hack that together anyway.  I'll provide a patch,
but I won't follow through with the lirc_pvr150 maintainer.


>  but if you need someone to test I am willing to do so. While I  
> was trying to figure out how to make this work; I did find the  
> lirc_pvr150 code, but got lost when trying to make it work with the  
> cx18.

Yeah, it's not the easiest to read.


>  I do have the firmware downloaded as well.

The "firmware" is kind of weird.  The author captured the Windows driver
sending data loads to the IR blaster chip for every supported remote at
the time.  In the author's words, the lirc_pvr150 module does a "replay
attack" to get the IR blaster work working.


> I can set up a HG clone of which ever branch of yours you'd like me to  
> use. The only drivers I compile are for the cx18 and for the HD-PVR,  
> which I can merge into your branch.

I'll let you know when I have something working.  It might be longer
than I originally thought though.  I have 2 HVR-1600's and only one
available PCI slot on a machine that's a real pain to take apart.  Right
now I have a card w/o the IR blaster chip in the machine.

Regards,
Andy

> Regards,
> 
> Brandon
> 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
