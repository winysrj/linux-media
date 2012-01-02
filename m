Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:49875 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab2ABVEN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Jan 2012 16:04:13 -0500
Received: by werm1 with SMTP id m1so7571865wer.19
        for <linux-media@vger.kernel.org>; Mon, 02 Jan 2012 13:04:12 -0800 (PST)
Message-ID: <4f021bca.e913b40a.71d1.6609@mx.google.com>
Subject: Re: em28xx: new board id [eb1a:5051]
From: Gareth Williams <gareth@garethwilliams.me.uk>
To: okonomiyakisan@my180.net
Cc: Reuben Stokes <okonomiyakisan@gohighspeed.com>,
	linux-media@vger.kernel.org
Date: Mon, 02 Jan 2012 21:04:01 +0000
In-Reply-To: <42398.97.115.190.132.1325479257.squirrel@webmail.my180.net>
References: <201112291513.16680.okonomiyakisan@gohighspeed.com>
	 <201112301516.55814.okonomiyakisan@gohighspeed.com>
	 <1325325105.9483.20.camel@mint>
	 <201112311701.57879.okonomiyakisan@gohighspeed.com>
	 <1325426171.4812.28.camel@mint>
	 <42398.97.115.190.132.1325479257.squirrel@webmail.my180.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2012-01-01 at 20:40 -0800, okonomiyakisan@my180.net wrote:
> > On Sat, 2011-12-31 at 17:01 -0800, Reuben Stokes wrote:
> >> On Saturday 31 December 2011 01:51:45 Gareth Williams wrote:
> >> > On Fri, 2011-12-30 at 15:16 -0800, Reuben Stokes wrote:
> >> > > On Friday 30 December 2011 14:27:57 Gareth Williams wrote:
> >> > > > On Fri, 2011-12-30 at 05:04 -0800, Reuben Stokes wrote:
> >> > > > > On Friday 30 December 2011 02:01:35 you wrote:
> >> > > > > > On Thu, 2011-12-29 at 15:13 -0800, Reuben Stokes wrote:
> >> > > > > > > Hi,
> >> > > > > > >
> >> > > > > > > Not nearly as linux-savvy as most of the users here, but I
> >> attempted to operate a "Raygo USB Video Recorder"
> >> (audio/video capture device). Don't know if my efforts
> >> qualify as a "test".
> >> > > > > > >
> >> > > > > > >
> >> > > > > > > Model Number:
> >> > > > > > > R12-41373
> >> > > > > > >
> >> > > > > > > Display name:
> >> > > > > > > USB 2861 Device
> >> > > > > > >
> >> > > > > > > lsusb:
> >> > > > > > > Bus 001 Device 002: ID eb1a:5051 eMPIA Technology, Inc.
> >> > > > > > >
> >> > > > > > > dmesg:
> >> > > > > > > [ 7182.076058] usb 1-1: new high speed USB device using
> >> ehci_hcd and address 3
> >> > > > > > > [ 7182.212702] usb 1-1: New USB device found, idVendor=eb1a,
> >> idProduct=5051
> >> > > > > > > [ 7182.212714] usb 1-1: New USB device strings: Mfr=0,
> >> Product=1, SerialNumber=2
> >> > > > > > > [ 7182.212723] usb 1-1: Product: USB 2861 Device
> >> > > > > > > [ 7182.212729] usb 1-1: SerialNumber: 0
> >> > > > > > >
> >> > > > > > > System:
> >> > > > > > > HP Pavilion dv6910 laptop
> >> > > > > > > AMD Turion X2 CPU (64 bit)
> >> > > > > > > Mepis 11; 64 bit( based on Debian Squeeze)
> >> > > > > > >
> >> > > > > > >
> >> > > > > > > Tried
> >> > > > > > > -------
> >> > > > > > > * Installed em28xx drivers using instructions found at
> >> linuxtv.org.
> >> > > > > > >   I note however that this particular vendor/product ID is
> >> not validated in the em28xx devices list.
> >> > > > > > > * As new drivers do not automatically load, I use command:
> >> modprobe em28xx
> >> > > > > > >    After this "modprobe -l | grep em28xx" yields
> >> > > > > > >         kernel/drivers/media/video/em28xx/em28xx-alsa.ko
> >> > > > > > >         kernel/drivers/media/video/em28xx/em28xx.ko
> >> > > > > > >         kernel/drivers/media/video/em28xx/em28xx-dvb.ko
> >> > > > > > > * Device comes with a driver CD for Windows which does work
> >> in Windows.
> >> > > > > > >
> >> > > > > > > End result is the device is not recognized as a capture
> >> device option in any software tried including vlc, cheese,
> >> guvcview, kdenlive.
> >> > > > > > >
> >> > > > > > > Any help getting this to work in Linux would be appreciated
> >> as it completely sucks in my bloated, memory-hogging, 32-bit
> >> Windows Vista.
> >> > > > > > >
> >> > > > > > > Reuben <okonomiyakisan@gohighspeed.com>
> >> > > > > > > --
> >> > > > > > > To unsubscribe from this list: send the line "unsubscribe
> >> linux-media" in
> >> > > > > > > the body of a message to majordomo@vger.kernel.org
> >> > > > > > > More majordomo info at
> >> http://vger.kernel.org/majordomo-info.html
> >> > > > > >
> >> > > > > > Reuben,
> >> > > > > >
> >> > > > > > If you're willing, then open up the device and see what the
> >> chips within
> >> > > > > > are.  You believe it's em28xx based, but there may well be
> >> additional
> >> > > > > > devices in there for audio and video.
> >> > > > > >
> >> > > > > > Once you've found out what's inside it will be easier to get
> >> it working.
> >> > > > > > It may be as simple as getting the driver to recognise the USB
> >> Vendor ID
> >> > > > > > or it may require much more work.
> >> > > > > >
> >> > > > > > Regards,
> >> > > > > >
> >> > > > > > Gareth
> >> > > > > >
> >> > > > > > --
> >> > > > > > To unsubscribe from this list: send the line "unsubscribe
> >> linux-media" in
> >> > > > > > the body of a message to majordomo@vger.kernel.org
> >> > > > > > More majordomo info at
> >> http://vger.kernel.org/majordomo-info.html
> >> > > > > >
> >> > > > > >
> >> > > > >
> >> > > > > Thank you very much for the response.
> >> > > > >
> >> > > > > Okay, opening it was easier than first suspected.
> >> > > > >
> >> > > > > The main (biggest) chip reads with nice big letters and a logo:
> >> > > > > eMPIA
> >> > > > > EM2860
> >> > > > > P86J3-011
> >> > > > > 201047-01AG
> >> > > > >
> >> > > > > Less useful information inlcudes:
> >> > > > >
> >> > > > > A smaller chip on the flip side of the circuit board, in letters
> >> visible only through a magnifying glass, reads:
> >> > > > > eMPIA
> >> > > > > TECHNOLOGY
> >> > > > > EMP202
> >> > > > > T10164
> >> > > > > 1052
> >> > > > >
> >> > > > > The circuit board itself is stamped:
> >> > > > > PM22860-2GOB
> >> > > > >
> >> > > > > Again, thank you.
> >> > > > >
> >> > > > > Reuben
> >> > > > Reuben,
> >> > > >
> >> > > > Was there another chip on there?  The EMP202 is an audio chip that
> >> can
> >> > > > covert analogue audio to digital PCM (and vice versa).  The EM2860
> >> sends
> >> > > > this digital audio along with digital video over USB.  For this to
> >> work
> >> > > > though, the device will need to convert analogue video to digital
> >> and
> >> > > > will need another chip to do this.  An example would be a SAA7113
> >> from
> >> > > > Philips. Have another look and post back here.
> >> > > >
> >> > > > The two chips you've identified are commonly used in for this type
> >> of
> >> > > > device and should be easily configurable in the em28xx driver.  We
> >> just
> >> > > > need the video chip now! And a tail wind...
> >> > > >
> >> > > > Regards,
> >> > > >
> >> > > > Gareth
> >> > > >
> >> > > > --
> >> > > > To unsubscribe from this list: send the line "unsubscribe
> >> linux-media" in
> >> > > > the body of a message to majordomo@vger.kernel.org
> >> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> > > >
> >> > > >
> >> > >
> >> > > Good call.  There is another chip. The logo appears to be the Texas
> >> Instrument logo. It's stamped:
> >> > > 5150AM1
> >> > > 09T
> >> > > C9JJ
> >> > >
> >> > > lsusb lists the product ID as "5051", but the chip clearly reads
> >> "5150...". I have no idea if those two numbers are suppose to be the
> >> same of if they have nothing to do with each other, but I thought
> >> I'd confirm the numbers.
> >> > >
> >> > > Also, I noted in my earlier post that the circuit board was stamped
> >> " PM22860-2GOB", but I made a typo.  It's actually, " PM42860-2GOB".
> >> > >
> >> > > Thank you for the continued help!!
> >> > >
> >> > > Reuben
> >> >
> >> > Reuben,
> >> >
> >> > A Google of that chip brings 'Ultralow Power NTSC/PAL/SECAM Video
> >> > Decoder w/Robust Sync Detector' - exactly what we were looking for.
> >> >
> >> > You now need to download the video4linux drivers source code, modify
> >> it
> >> > so that your device is recognised and configured correctly, then
> >> finally
> >> > install the new driver.  It's not a daunting as it sounds.
> >> >
> >> > I don't know what Linux distro you're using, but somehow you need to
> >> > install 'git' and other tools to compile C source.  On my Ubuntu based
> >> > machine, 'build-essential' is a package that will download all I need.
> >> > However, if you have a different distro, then you will need to work
> >> out
> >> > what's needed to compile the source.  As a minimum, you will need
> >> > 'make', 'gcc', 'libc' I'd have thought.
> >> >
> >> > Once you have a system capable of downloading the source and building
> >> > it, download the v4l source from git using:-
> >> >
> >> > cd ~
> >> > git clone git://linuxtv.org/media_build.git v4l_driver
> >> >
> >> > This will download a copy of the v4l drivers into a directory called
> >> > v4l_driver within your home directory.
> >> >
> >> > Next, 'cd v4l_driver' and 'make download untar' to extract some
> >> > compressed files.
> >> >
> >> > Next 'make config' to check that make works - it may ask you to
> >> download
> >> > some libs for building the config gui.
> >> >
> >> > Finally, 'make' by itself will build the drivers.  This will build all
> >> > drivers and as we haven't modified it yet, will be of no use apart
> >> from
> >> > showing that your system is capable of building these drivers.
> >> >
> >> > Let me know how you get on with this and then we'll attempt to
> >> configure
> >> > the drivers for your device - the exciting bit ;-)
> >> >
> >> > Apologies for only replying to you once a day, but I think the 8 hour
> >> > time difference has a lot to do with it!
> >> >
> >> > Regards,
> >> >
> >> > Gareth
> >> >
> >> >
> >> > --
> >> > To unsubscribe from this list: send the line "unsubscribe linux-media"
> >> in
> >> > the body of a message to majordomo@vger.kernel.org
> >> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> >
> >> >
> >>
> >> Okay.  Followed your perfect directions.
> >> Incidentally, I'm using a Debian based distro called Mepis.  Although it
> >> uses it's own modified kernel, I believe it's a derivative of kernel
> >> 2.6.36.
> >>
> >> I seemed to have had all the make/build components in place when I
> >> started.  At least, it all seemed to work without a hitch.
> >>
> >> The 'make config' command never did result in me having to download any
> >> libs to build a config gui, but it did ask me a series of questions in
> >> regular command line format.  I answered with the default option on all
> >> of them.
> >>
> >> As for the one answer a day you're providing, I am appreciative and
> >> humbled I'm getting so much.  I think I would feel guilty if I took up
> >> any more of your time than that.  Especially during the holiday season,
> >> especially for a device I purchased because I was too cheap to get a
> >> quality video/audio capture device.
> >>
> >> Speaking of holidays, I hope you're having a Happy New Year.
> >>
> >> I'm ready for the next step at your convenience.
> >>
> >> Thanks again,
> >> Reuben
> >>
> > Reuben,
> >
> > Now that we know that we can build the drivers, it is time to go ahead
> > and configure, build and install them.
> >
> > The 'make config' option allows you to chose which drivers you want to
> > build.  By default, it will build most drivers.  As you are only
> > interested in a very small subset of those, then it is worth configuring
> > the build so that only the ones you need are built.
> >
> > Also, 'make xconfig' (preceding 'x') is a much nicer GUI based
> > configuration (although you may need the qt-dev libraries installed).
> > You basically, need to configure it so that only EM2860, EMP202 and
> > TVP5150 is built.  However, be aware, that many of these configuration
> > options are well and truly hidden amongst all the others.
> >
> > As a starter, try disabling everything except:
> > Enable 'Multimedia support\Video For Linux'
> > Enable 'Multimedia support\Customize analog and hybrid tuner modules to
> > build' so that you can disable all tuners in 'Multimedia support
> > \Customize TV tuners'
> >
> > As a quick test, when I ran 'grep =m v4l/.config | wc -l' within the
> > '~/v4l_driver' directory (or whatever you named it), it return 28.  It
> > checks how many modules are going to be built from your config.  If
> > you're near that number then it should be OK; if it's much larger then
> > you are probably configured to build too much.  Try again, if you have
> > the patience!
> >
> > Once you're happy, run 'make' again.  If you get no errors, then it's
> > time to go for it and modify the source code for your device.
> >
> > Change to directory 'linux/drivers/media/video/em28xx/' within your work
> > area ('~/v4l_driver') and look at the file called 'em28xx-cards.c'.  At
> > around line 797 you should see a section that starts:
> > [EM2860_BOARD_TVP5150_REFERENCE_DESIGN] =
> > By luck, this seems to have the same video chipset as you: EM2860 &
> > TVP5150.  You can therefore configure the driver so that it recognises
> > your USB Id as this card - it may work, it may not.
> >
> > At around line 2045 of the same file you should see two lines that
> > start:	{ USB_DEVICE(0x2040, 0x1605),
> > 			.driver_info = EM2884_BOARD_HAUPPAUGE_WINTV_HVR_930C },
> > (this may show as three lines due to word-wrapping in your mail reader)
> > Create a similar line after this with the USB Id of your device and the
> > configuration you will use:-
> > { USB_DEVICE(0xeb1a, 0x5051),
> > 			.driver_info = EM2860_BOARD_TVP5150_REFERENCE_DESIGN },
> > Note again: 1st line starts '{ USB_DEVICE' and 2nd line starts
> > '.driver'. There is NO third line and there IS a comma at the end.
> > Save the file.
> > The simple modification above will tell the driver that it is
> > responsible for that USB Id.
> >
> > Back in your working directory '~/v4l_driver' type 'make'.  If all goes
> > well (no errors), follow it with 'sudo make install' to copy the newly
> > built files into your working system.
> >
> > When you next plug in the device, it should be recognised.  Type 'dmesg
> > | grep em28xx' to see what the system thinks.  You should see it being
> > recognised.  It might work, or it might not!  Let me know how it goes.
> > We can tweak the configuration etc to see if we can make the device work
> > in Linux.
> >
> > If it does look OK in 'dmesg' then quickly run:-
> >
> > mplayer tv:// -tv
> > driver=v4l2:device=/dev/video0:audiorate=48000:immediatemode=0:forceaudio:alsa:adevice=hw.1:buffersize=64
> >
> > (again one line) and you should see the video from composite and hear
> > audio (you may need to turn the capture level up on your system).
> >
> > Good luck and a Happy New Year!
> >
> > Regards,
> >
> > Gareth
> >
> >
> 
> The end result is the device is still not recognized fully, but I see
> glimmers of hope.
> 
> To begin with, the 'make xconfig' did not work. Trouble started with the
> line,
> "/lib/modules/2.6.36-1-mepis64-smp/source/scripts/basic/Makefile: No such
> file or directory", and it went downhill from there.  I didn't spend any
> time worrying about this and just used the regular command line "make
> config'.
> 
> Hopefully, I found all the right options to enable, but I fear because I
> did not see any options for anything with 'emp202'.
> Incidentally, the return on 'grep =m v4l/.config | wc -l' for me was 56.
> Precisely double what you got, but manageable, I thought. It shows, sadly,
> that my direction following is not as precise as hoped or intended. 
> Still, better to have too many drivers than not enough (I think).
> 
> The  'make' command, the addition to the em28xx.cards.c, and the 'make
> install' command as root all seemed to work without errors.
> 
> At this point 'lsmod | grep em28xx' yielded nothing. As root I did
> 'modprobe em28xx' and did another lsmod. This time I got
> em28xx                 77393  0
> v4l2_common             5075  1 em28xx
> videobuf_vmalloc        3773  1 em28xx
> videobuf_core          12892  2 em28xx,videobuf_vmalloc
> tveeprom               12753  1 em28xx
> videodev               66396  3 em28xx,v4l2_common,uvcvideo
> i2c_core               16325  6
> em28xx,v4l2_common,tveeprom,nvidia,videodev,i2c_nforce2
> 
> I plugged the device in and looked at dmesg:
> dmesg | grep usb:
> [ 6454.048064] usb 1-1: new high speed USB device using ehci_hcd and
> address 5
> [ 6454.184432] usb 1-1: New USB device found, idVendor=eb1a, idProduct=5051
> [ 6454.184443] usb 1-1: New USB device strings: Mfr=0, Product=1,
> SerialNumber=2
> [ 6454.184452] usb 1-1: Product: USB 2861 Device
> [ 6454.184457] usb 1-1: SerialNumber: 0
> 
> dmesg | grep em28xx:
> [  553.016820] usbcore: registered new interface driver em28xx
> [  553.016830] em28xx driver loaded
> (note: I don't think I ever got linux to recognize it before, so this
> seems like major progress and the reason I have a glimmer of hope.)
> 
> It looked fine, but the mplayer command turned on my built-in webcam.  I
> knew the darn thing was my /dev/video0 device, but I wasn't thinking. I
> changed the command to read '/dev/video1' and got:
> MPlayer SVN-r32610-snapshot-Ubuntu-RVM (C) 2000-2010 MPlayer Team
> Can't open joystick device /dev/input/js0: No such file or directory
> Can't init input joystick
> mplayer: could not connect to socket
> mplayer: No such file or directory
> Failed to open LIRC support. You will not be able to use your remote control.
> Playing tv://.
> TV file format detected.
> Selected driver: v4l2
>  name: Video 4 Linux 2 input
>  author: Martin Olschewski <olschewski@zpr.uni-koeln.de>
>  comment: first try, more to come ;-)
> v4l2: unable to open '/dev/video1': No such file or directory
> v4l2: ioctl set mute failed: Bad file descriptor
> v4l2: 0 frames successfully processed, 0 frames dropped.
> 
> I rebooted the machine and tried the device again with the same results. 
> I even had to do the 'modprobe em28xx' to get the drivers loaded. Still
> nothing.
> 
> None of my other video capture programs (vlc, cheese, guvcview) recognized
> it at all.
> 
> Did I do something amiss, or do you think further tweaking is in order?
> 
> Again, thank you.
> 
> Reuben
> 
> 
Reuben,

I don't think the driver has recognised your USB Id.  Double check that
the two hex values you placed in your edits of the file are the same
number as is shown by 'lsusb'.  All you've seen in the result of 'dmesg'
is the driver loading.  If the driver recognises your USB device (which
it should do if your modification worked ok) then you will get quite a
few lines from dmesg.  Here is mine when I fit a similar device into my
machine:-

[   65.774296] usb 2-1.2: new high speed USB device number 3 using
ehci_hcd
[   65.984316] em28xx: New device USB VIDBOX Audio @ 480 Mbps
(eb1a:5006, interface 0, class 0)
[   65.984478] em28xx #0: chip ID is em2860
[   66.112534] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 06 50 50 00
20 03 6a 24 8e 28
[   66.112550] em28xx #0: i2c eeprom 10: 00 00 24 57 06 02 00 00 00 00
00 00 00 00 00 00
[   66.112565] em28xx #0: i2c eeprom 20: 02 00 01 00 f0 10 01 00 00 00
00 00 5b 00 00 00
[   66.112579] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01
00 00 00 00 00 00
[   66.112593] em28xx #0: i2c eeprom 40: 00 00 03 00 00 00 00 00 00 00
00 00 00 00 00 00
[   66.112607] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   66.112621] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00
24 03 55 00 53 00
[   66.112634] em28xx #0: i2c eeprom 70: 42 00 20 00 56 00 49 00 44 00
42 00 4f 00 58 00
[   66.112648] em28xx #0: i2c eeprom 80: 20 00 41 00 75 00 64 00 69 00
6f 00 00 00 28 03
[   66.112662] em28xx #0: i2c eeprom 90: 55 00 53 00 42 00 32 00 2e 00
30 00 20 00 56 00
[   66.112676] em28xx #0: i2c eeprom a0: 49 00 44 00 42 00 4f 00 58 00
20 00 4e 00 57 00
[   66.112690] em28xx #0: i2c eeprom b0: 30 00 33 00 00 00 00 00 00 00
00 00 00 00 00 00
[   66.112696] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   66.112702] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   66.112708] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   66.112714] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   66.112721] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash =
0x5129e4d9
[   66.112723] em28xx #0: EEPROM info:
[   66.112724] em28xx #0:	AC97 audio (5 sample rates)
[   66.112725] em28xx #0:	500mA max power
[   66.112726] em28xx #0:	Table at 0x24, strings=0x246a, 0x288e, 0x0000
[   66.113891] em28xx #0: Identified as Honestech Vidbox NW03 (card=83)
[   66.485024] saa7115 15-0025: saa7113 found (1f7113d0e100000) @ 0x4a
(em28xx #0)
[   67.255220] em28xx #0: Config register raw data: 0x50
[   67.278929] em28xx #0: AC97 vendor ID = 0x83847650
[   67.291041] em28xx #0: AC97 features = 0x6a90
[   67.291045] em28xx #0: Empia 202 AC97 audio processor detected
[   67.750130] em28xx #0: v4l2 driver version 0.1.3
[   68.771595] em28xx #0: V4L2 video device registered as video0
[   68.771599] em28xx #0: V4L2 VBI device registered as vbi0
[   68.771619] em28xx audio device (eb1a:5006): interface 1, class 1
[   68.771632] em28xx audio device (eb1a:5006): interface 2, class 1
[   68.771651] usbcore: registered new interface driver em28xx
[   68.771653] em28xx driver loaded
[   68.814917] usbcore: registered new interface driver snd-usb-audio

Also, 'lsmod | grep em28xx' gives:-

em28xx                 93080  0 
v4l2_common            15793  2 saa7115,em28xx
videobuf_vmalloc       13336  1 em28xx
videobuf_core          25097  2 em28xx,videobuf_vmalloc
tveeprom               17009  1 em28xx
videodev               86252  3 saa7115,em28xx,v4l2_common

You will see the em28xx driver loaded and also, in my case, the saa7115
video decoder.  You will have the 5051 chip shown here, not saa7115
though.

I'll send you my '.config' file which I've changed to build your video
driver and now has 29 modules as a separate email.

So, to confirm:-

1.  Make sure your device is not connected to the USB port.
2.  Modify the file to add the USB Id of your device as in my previous
post, checking that the USB Id you add is the same as that given by
'lsusb' (they should both be prefixed by 0x to signify hex values).
3.  Either use 'make config' to configure only the drivers you need, or
use the one I've sent you.
4.  Run 'make' and ensure no errors.
5.  Run 'sudo make install' and ensure no errors.
6.  Connect your device to the USB port.
7.  Check the result of 'dmesg'.

Let me know how it goes.

Regards,

Gareth

