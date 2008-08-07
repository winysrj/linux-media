Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1KQuvx-0004mp-2L
	for linux-dvb@linuxtv.org; Thu, 07 Aug 2008 04:08:58 +0200
From: Andy Walls <awalls@radix.net>
To: Brian Steele <steele.brian@gmail.com>
In-Reply-To: <5f8558830808051733w5960fb03p169ae2aa6d893ce8@mail.gmail.com>
References: <5f8558830807291934i34579ed6s8de1dd8240d2f93e@mail.gmail.com>
	<1217728894.5348.72.camel@morgan.walls.org>
	<5f8558830808031049p1a714907y94e9d2e98e30ba8b@mail.gmail.com>
	<1217791214.2690.31.camel@morgan.walls.org>
	<5f8558830808031428u3c9a8191tcd1705b27087f992@mail.gmail.com>
	<1217814427.23133.24.camel@palomino.walls.org>
	<5f8558830808051733w5960fb03p169ae2aa6d893ce8@mail.gmail.com>
Date: Wed, 06 Aug 2008 22:07:48 -0400
Message-Id: <1218074868.2689.34.camel@morgan.walls.org>
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

On Tue, 2008-08-05 at 17:33 -0700, Brian Steele wrote:
> On Sun, Aug 3, 2008 at 6:47 PM, Andy Walls <awalls@radix.net> wrote:
> > Well, let's collect some debug data about how the tuner is getting set
> > up and what happens on channel change.  (Because it's either tuner
> > commands not working, or cx18-av setup or register changes not working.)
> >
> > Add lines like these to /etc/modprobe.conf
> >
> > options tuner show_i2c=1 debug=2
> > options tuner-simple debug=1
> > options tda8290 debug=1
> > options tda9887 debug=2
> >
> >   (and/or debug options for whatever other tuner modules your
> >    system loads for the cx18)
> >
> > Then do
> >
> > # modprobe -r cx18 tda9887 tda8290 tuner-simple tuner
> > # modprobe cx18 debug=83      (<---- warn, info, i2c, ioctl)
> >
> > I'd be interested in all the messages when the cx18 module initializes
> > (not just the ones prefixed with "cx18") and the messages that occur
> > when you change channels.
> 
> Andy,
> 
> I pulled the latest from Hg, recompiled, executed the commands above,
> then did ivtv-tune -c <channel> twice.  Here is the output in dmesg:
> Linux video capture interface: v2.00
> cx18:  Start initialization, version 1.0.0
> cx18-0: Initializing card #0
> cx18-0: Autodetected Hauppauge card


OK.  All of the tuner setup command you sent match the setup being sent
to my card switching to the same frequencies.  Since the video is
switching to the proper channel for you, that means the commands are
getting to the tuner over the I2C bus.  For now, I'd say a tuner problem
is highly unlikely.


That leaves the microcontroller in the AV core as the culprit or routing
of the I2S audio from the AV core to the MPEG encoder as the problem.

Some thing to try:

Start an analog video capture and tune to the channel that you want to
watch.  If/When you have video and no sound, switch to line in 1 and
then back to tuner with v4l2-ctl.  This switching  should reset the
audio standard detection microcontroller (twice).  This switching should
also set the I2S routing input for the MPEG encoder to the line in and
then back to the tuner.

Hopefully that works as a work-around.


With an analog tuner capture running could you please send me the
complete output of 

# v4l-dvb/v4l2-apps/util/v4l2-dbg -R type=host
ioctl: VIDIOC_DBG_G_REGISTER

                00       04       08       0C       10       14       18       1C
02c40000: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 
[...]
02c409a0: 00000000 00000000 00000001 80000005 00000001 80000000 00000000 00000368 
02c409c0: 004400b4 0000000a 


For the cx18 driver, this command will default to dumping the register
of the AV core inside the CX23418.  (It must be run as root.)  I want to
inspect the register settings to make sure they are OK.


I'll look at adding some verbose debug and improvements to the digitizer
firmware load tomorrow night.  I think a problem with the firmware load
has the highest likelyhood of being the problem.

The function that loads the firmware is in
cx18-av-firmware.c:cx18_av_loadfw() if you care to inspect what it
does.  

Regards,
Andy

> Thanks for all your help so far.
> Brian



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
