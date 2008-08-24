Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1KX4IG-0004t2-Jy
	for linux-dvb@linuxtv.org; Sun, 24 Aug 2008 03:21:27 +0200
From: Andy Walls <awalls@radix.net>
To: Brian Steele <steele.brian@gmail.com>
In-Reply-To: <5f8558830808071830u4c8d882dse362748942ccec5b@mail.gmail.com>
References: <5f8558830807291934i34579ed6s8de1dd8240d2f93e@mail.gmail.com>
	<1217728894.5348.72.camel@morgan.walls.org>
	<5f8558830808031049p1a714907y94e9d2e98e30ba8b@mail.gmail.com>
	<1217791214.2690.31.camel@morgan.walls.org>
	<5f8558830808031428u3c9a8191tcd1705b27087f992@mail.gmail.com>
	<1217814427.23133.24.camel@palomino.walls.org>
	<5f8558830808051733w5960fb03p169ae2aa6d893ce8@mail.gmail.com>
	<1218074868.2689.34.camel@morgan.walls.org>
	<5f8558830808071830u4c8d882dse362748942ccec5b@mail.gmail.com>
Date: Sat, 23 Aug 2008 21:20:19 -0400
Message-Id: <1219540819.11451.36.camel@morgan.walls.org>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR-1600 - No audio
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

On Thu, 2008-08-07 at 18:30 -0700, Brian Steele wrote:
> On Wed, Aug 6, 2008 at 7:07 PM, Andy Walls <awalls@radix.net> wrote:
> > Some thing to try:
> >
> > Start an analog video capture and tune to the channel that you want to
> > watch.  If/When you have video and no sound, switch to line in 1 and
> > then back to tuner with v4l2-ctl.  This switching  should reset the
> > audio standard detection microcontroller (twice).  This switching should
> > also set the I2S routing input for the MPEG encoder to the line in and
> > then back to the tuner.
> >
> > Hopefully that works as a work-around.
> 
> 
> Unfortunately, this doesn't give me any sound.  I even tried changing
> channels in the middle of the capture after doing the above steps.  I
> could see the channel change when I played back the MPEG but still no
> audio.
> >
> > With an analog tuner capture running could you please send me the
> > complete output of
> >
> > # v4l-dvb/v4l2-apps/util/v4l2-dbg -R type=host
> 
> Here is the output:
> 
> ioctl: VIDIOC_DBG_G_REGISTER


Brian,

v4l2-dbg didn't output the data I was expecting.  Here's a more explicit
command line to try for me, if you could:

# v4l2-apps/util/v4l2-dbg -d /dev/video0 -R type=host,chip=0,min=0x02c40000,max=0x2c409c7

Substitute in the correct device node for /dev/video0 to access the
cx23418 based card, if you more than 1 type of video capture card in
your system.

This will let me compare the setup of your CX23418's AV core with mine,
to help me figure out where things may be failing for your tuner audio.

Regards,
Andy

>                 00       04       08       0C       10       14
> 18       1C
> 02000000: 007c0000 009bfc11 00000000 00000000 00000000 000df604
> 00000000 00000000
> 02000020: 0035f815 00260dec 006a100f 004c0000 004c0002 00001d70
> 00000000 00023d81
> 02000040: 000fe40a 00000000 000e0201 007ff611 00000000 000016c0
> 011306db 00000000
> 02000060: 000deffd 00180000 000ff9fa 00000000 007e0213 0055fe0a
> 00bbe400 00000000
> 02000080: 00080000 000fedf8 004801ff 00a7e418 00000000 005de408
> 00000000 00000000
> 020000a0: 00000010 000027f0 011307e9 00000000 00000000 001c0000
> 000fe1ed 0017ffea
> 020000c0: 0013fc15 0031f611 003bfe08 002a0001 01627765 00000000
> 00000000 00000000
> 020000e0: 00000000 00000000 00000000 00000000 00000000 00000000
> 00000000 00000000
> 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
