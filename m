Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-05.arcor-online.net ([151.189.21.45])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1K81u4-0003vs-4V
	for linux-dvb@linuxtv.org; Mon, 16 Jun 2008 01:44:57 +0200
From: hermann pitton <hermann-pitton@arcor.de>
To: Andy Walls <awalls@radix.net>
In-Reply-To: <1213567472.3173.50.camel@palomino.walls.org>
References: <de8cad4d0806150505k6b865dedq359d278ab467c801@mail.gmail.com>
	<1213567472.3173.50.camel@palomino.walls.org>
Date: Mon, 16 Jun 2008 01:43:13 +0200
Message-Id: <1213573393.2683.85.camel@pc10.localdom.local>
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

Hi,

Am Sonntag, den 15.06.2008, 18:04 -0400 schrieb Andy Walls:
> On Sun, 2008-06-15 at 08:05 -0400, Brandon Jenkins wrote:
> > I use SageTV and upon launch it initializes the adapters resulting in
> > the following error messages in dmesg:
> > 
> > [   36.371502] compat_ioctl32: VIDIOC_G_EXT_CTRLSioctl32(java:7613):
> > Unknown cmd fd(13) cmd(c0185647){t:'V';sz:24} arg(caafeaf0) on
> > /dev/video1
> > [   36.373068] compat_ioctl32: VIDIOC_S_AUDIOioctl32(java:7613):
> > Unknown cmd fd(13) cmd(40345622){t:'V';sz:52} arg(caaffbfc) on
> > /dev/video1
> > [   29.311447] compat_ioctl32: VIDIOC_G_EXT_CTRLSioctl32(java:7613):
> > Unknown cmd fd(18) cmd(c0185647){t:'V';sz:24} arg(caafeaf0) on
> > /dev/video0
> > [   29.312857] compat_ioctl32: VIDIOC_S_AUDIOioctl32(java:7613):
> > Unknown cmd fd(18) cmd(40345622){t:'V';sz:52} arg(caaffbfc) on
> > /dev/video0
> 
> The general V4L2 function used by cx18:
> 
> linux/drivers/media/video/compat_ioctl32.c:v4l_compat_ioctl32()
> 
> doesn't support these ioctls.  The absence of support is larger than
> just for cx18.  The following command roughly shows all the drivers that
> rely on v4l_compat_ioctl32():
> 
> $ grep -Rl v4l_compat_ioctl32 linux/drivers/media/* 
> 
> If really needed, I guess one could add the ioctls one needs to the code
> in compat_ioctl32.c.
> 
> 
> 
> 
> > I contacted SageTV about the error and was told they don't affect
> > anything, but I would like to make sure that is the case.
> 
> Only the SageTV authors are in a position to easily tell you if the
> unimplemented ioctls matter or not for what SageTV is trying to do.
> 
> (Of course if they don't affect anything, why are they doing them? ;] )
> 
> > Also, I have noticed a new message in dmesg indicating that ir
> > transmitters may now be accessible? Is there anything I need to do to
> > make use of them?
> > 
> > tveeprom 2-0050: has no radio, has IR receiver, has IR transmitter
> 
> The IR on the HVR-1600 (a Zilog Z8F0811 microcontroller) is very much
> like that of the PVR-150.  From what I can tell, it even appears to be
> at the same i2c address. 
> 
> This previous message also indicates the PVR-150/500 IR is very similar
> to the HVR-1600:
> http://www.linuxtv.org/pipermail/linux-dvb/2008-February/023532.html
> 
> 
> Right now the cx18 driver has omitted some code present in ivtv related
> to explicit reset of the IR microcontroller.  It shouldn't be hard to
> add back that reset code,  if needed. 
> 
> I haven't had a chance to try the IR blaster out yet (it was on my todo
> list before Feb 2009).  "Mark's brain dump" has a modified lirc package
> for the PVR-150 IR blaster:
> 
> http://www.blushingpenguin.com/mark/blog/?p=24
> http://charles.hopto.org/blog/?p=24
> 
> It's probably a good starting point.  There are likely to be differences
> though, as the cx23418 has 2 I2C buses where the cx23416 only has 1 I2C
> bus.
> 
> It looks like you're blazing a trail, as I can't find any documentation
> on the 'net by anyone who has done this with a HVR-1600.  If lirc_i2c,
> available with the normal lirc distribution for IR receive, can detect
> the Z8F0811, you've probably got a good start.
> 
> Regards,
> Andy
> 
> > Thanks!
> > 
> > Brandon
> 

just a note, have been there already coming from other stuff to it,
but don't remember the details off hand.

http://marc.info/?l=linux-video&m=119705840327989&w=2

and following.

I was under the impression we have already duplicate code?

Cheers,
Hermann



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
