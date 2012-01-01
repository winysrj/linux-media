Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34800 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab2AAN4R (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Jan 2012 08:56:17 -0500
Received: by wgbdr13 with SMTP id dr13so25833098wgb.1
        for <linux-media@vger.kernel.org>; Sun, 01 Jan 2012 05:56:15 -0800 (PST)
Message-ID: <1325426171.4812.28.camel@mint>
Subject: Re: em28xx: new board id [eb1a:5051]
From: Gareth Williams <gareth@garethwilliams.me.uk>
To: Reuben Stokes <okonomiyakisan@gohighspeed.com>
Cc: linux-media@vger.kernel.org
Date: Sun, 01 Jan 2012 13:56:11 +0000
In-Reply-To: <201112311701.57879.okonomiyakisan@gohighspeed.com>
References: <201112291513.16680.okonomiyakisan@gohighspeed.com>
	 <201112301516.55814.okonomiyakisan@gohighspeed.com>
	 <1325325105.9483.20.camel@mint>
	 <201112311701.57879.okonomiyakisan@gohighspeed.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2011-12-31 at 17:01 -0800, Reuben Stokes wrote:
> On Saturday 31 December 2011 01:51:45 Gareth Williams wrote:
> > On Fri, 2011-12-30 at 15:16 -0800, Reuben Stokes wrote:
> > > On Friday 30 December 2011 14:27:57 Gareth Williams wrote:
> > > > On Fri, 2011-12-30 at 05:04 -0800, Reuben Stokes wrote:
> > > > > On Friday 30 December 2011 02:01:35 you wrote:
> > > > > > On Thu, 2011-12-29 at 15:13 -0800, Reuben Stokes wrote:
> > > > > > > Hi,
> > > > > > > 
> > > > > > > Not nearly as linux-savvy as most of the users here, but I attempted to operate a "Raygo USB Video Recorder" (audio/video capture device). Don't know if my efforts qualify as a "test".
> > > > > > > 
> > > > > > > 
> > > > > > > Model Number: 
> > > > > > > R12-41373
> > > > > > > 
> > > > > > > Display name: 
> > > > > > > USB 2861 Device
> > > > > > > 
> > > > > > > lsusb: 
> > > > > > > Bus 001 Device 002: ID eb1a:5051 eMPIA Technology, Inc. 
> > > > > > > 
> > > > > > > dmesg:
> > > > > > > [ 7182.076058] usb 1-1: new high speed USB device using ehci_hcd and address 3
> > > > > > > [ 7182.212702] usb 1-1: New USB device found, idVendor=eb1a, idProduct=5051
> > > > > > > [ 7182.212714] usb 1-1: New USB device strings: Mfr=0, Product=1, SerialNumber=2
> > > > > > > [ 7182.212723] usb 1-1: Product: USB 2861 Device
> > > > > > > [ 7182.212729] usb 1-1: SerialNumber: 0
> > > > > > > 
> > > > > > > System:
> > > > > > > HP Pavilion dv6910 laptop
> > > > > > > AMD Turion X2 CPU (64 bit)
> > > > > > > Mepis 11; 64 bit( based on Debian Squeeze)
> > > > > > > 
> > > > > > > 
> > > > > > > Tried
> > > > > > > -------
> > > > > > > * Installed em28xx drivers using instructions found at linuxtv.org.
> > > > > > >   I note however that this particular vendor/product ID is not validated in the em28xx devices list.
> > > > > > > * As new drivers do not automatically load, I use command: modprobe em28xx
> > > > > > >    After this "modprobe -l | grep em28xx" yields
> > > > > > >         kernel/drivers/media/video/em28xx/em28xx-alsa.ko
> > > > > > >         kernel/drivers/media/video/em28xx/em28xx.ko
> > > > > > >         kernel/drivers/media/video/em28xx/em28xx-dvb.ko
> > > > > > > * Device comes with a driver CD for Windows which does work in Windows.
> > > > > > > 
> > > > > > > End result is the device is not recognized as a capture device option in any software tried including vlc, cheese, guvcview, kdenlive.
> > > > > > > 
> > > > > > > Any help getting this to work in Linux would be appreciated as it completely sucks in my bloated, memory-hogging, 32-bit Windows Vista.
> > > > > > > 
> > > > > > > Reuben <okonomiyakisan@gohighspeed.com>
> > > > > > > --
> > > > > > > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > > > > > > the body of a message to majordomo@vger.kernel.org
> > > > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > > > 
> > > > > > Reuben,
> > > > > > 
> > > > > > If you're willing, then open up the device and see what the chips within
> > > > > > are.  You believe it's em28xx based, but there may well be additional
> > > > > > devices in there for audio and video.
> > > > > > 
> > > > > > Once you've found out what's inside it will be easier to get it working.
> > > > > > It may be as simple as getting the driver to recognise the USB Vendor ID
> > > > > > or it may require much more work.
> > > > > > 
> > > > > > Regards,
> > > > > > 
> > > > > > Gareth
> > > > > > 
> > > > > > --
> > > > > > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > > > > > the body of a message to majordomo@vger.kernel.org
> > > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > > > 
> > > > > > 
> > > > > 
> > > > > Thank you very much for the response.
> > > > > 
> > > > > Okay, opening it was easier than first suspected. 
> > > > > 
> > > > > The main (biggest) chip reads with nice big letters and a logo:
> > > > > eMPIA
> > > > > EM2860
> > > > > P86J3-011
> > > > > 201047-01AG
> > > > > 
> > > > > Less useful information inlcudes:
> > > > > 
> > > > > A smaller chip on the flip side of the circuit board, in letters visible only through a magnifying glass, reads:
> > > > > eMPIA
> > > > > TECHNOLOGY
> > > > > EMP202
> > > > > T10164
> > > > > 1052
> > > > > 
> > > > > The circuit board itself is stamped:
> > > > > PM22860-2GOB
> > > > > 
> > > > > Again, thank you.
> > > > > 
> > > > > Reuben
> > > > Reuben,
> > > > 
> > > > Was there another chip on there?  The EMP202 is an audio chip that can
> > > > covert analogue audio to digital PCM (and vice versa).  The EM2860 sends
> > > > this digital audio along with digital video over USB.  For this to work
> > > > though, the device will need to convert analogue video to digital and
> > > > will need another chip to do this.  An example would be a SAA7113 from
> > > > Philips. Have another look and post back here.
> > > > 
> > > > The two chips you've identified are commonly used in for this type of
> > > > device and should be easily configurable in the em28xx driver.  We just
> > > > need the video chip now! And a tail wind...
> > > > 
> > > > Regards,
> > > > 
> > > > Gareth
> > > > 
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > 
> > > > 
> > > 
> > > Good call.  There is another chip. The logo appears to be the Texas Instrument logo. It's stamped:
> > > 5150AM1
> > > 09T
> > > C9JJ
> > > 
> > > lsusb lists the product ID as "5051", but the chip clearly reads "5150...". I have no idea if those two numbers are suppose to be the same of if they have nothing to do with each other, but I thought I'd confirm the numbers.
> > > 
> > > Also, I noted in my earlier post that the circuit board was stamped " PM22860-2GOB", but I made a typo.  It's actually, " PM42860-2GOB".
> > > 
> > > Thank you for the continued help!!
> > > 
> > > Reuben
> > 
> > Reuben,
> > 
> > A Google of that chip brings 'Ultralow Power NTSC/PAL/SECAM Video
> > Decoder w/Robust Sync Detector' - exactly what we were looking for.
> > 
> > You now need to download the video4linux drivers source code, modify it
> > so that your device is recognised and configured correctly, then finally
> > install the new driver.  It's not a daunting as it sounds.
> > 
> > I don't know what Linux distro you're using, but somehow you need to
> > install 'git' and other tools to compile C source.  On my Ubuntu based
> > machine, 'build-essential' is a package that will download all I need.
> > However, if you have a different distro, then you will need to work out
> > what's needed to compile the source.  As a minimum, you will need
> > 'make', 'gcc', 'libc' I'd have thought.
> > 
> > Once you have a system capable of downloading the source and building
> > it, download the v4l source from git using:-
> > 
> > cd ~
> > git clone git://linuxtv.org/media_build.git v4l_driver
> > 
> > This will download a copy of the v4l drivers into a directory called
> > v4l_driver within your home directory.
> > 
> > Next, 'cd v4l_driver' and 'make download untar' to extract some
> > compressed files.
> > 
> > Next 'make config' to check that make works - it may ask you to download
> > some libs for building the config gui.
> > 
> > Finally, 'make' by itself will build the drivers.  This will build all
> > drivers and as we haven't modified it yet, will be of no use apart from
> > showing that your system is capable of building these drivers.
> > 
> > Let me know how you get on with this and then we'll attempt to configure
> > the drivers for your device - the exciting bit ;-)
> > 
> > Apologies for only replying to you once a day, but I think the 8 hour
> > time difference has a lot to do with it!
> > 
> > Regards,
> > 
> > Gareth
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > 
> 
> Okay.  Followed your perfect directions.
> Incidentally, I'm using a Debian based distro called Mepis.  Although it uses it's own modified kernel, I believe it's a derivative of kernel 2.6.36.
> 
> I seemed to have had all the make/build components in place when I started.  At least, it all seemed to work without a hitch.
> 
> The 'make config' command never did result in me having to download any libs to build a config gui, but it did ask me a series of questions in regular command line format.  I answered with the default option on all of them.
> 
> As for the one answer a day you're providing, I am appreciative and humbled I'm getting so much.  I think I would feel guilty if I took up any more of your time than that.  Especially during the holiday season, especially for a device I purchased because I was too cheap to get a quality video/audio capture device.
> 
> Speaking of holidays, I hope you're having a Happy New Year.
> 
> I'm ready for the next step at your convenience.
> 
> Thanks again,
> Reuben
> 
Reuben,

Now that we know that we can build the drivers, it is time to go ahead
and configure, build and install them.

The 'make config' option allows you to chose which drivers you want to
build.  By default, it will build most drivers.  As you are only
interested in a very small subset of those, then it is worth configuring
the build so that only the ones you need are built.

Also, 'make xconfig' (preceding 'x') is a much nicer GUI based
configuration (although you may need the qt-dev libraries installed).
You basically, need to configure it so that only EM2860, EMP202 and
TVP5150 is built.  However, be aware, that many of these configuration
options are well and truly hidden amongst all the others.

As a starter, try disabling everything except:
Enable 'Multimedia support\Video For Linux'
Enable 'Multimedia support\Customize analog and hybrid tuner modules to
build' so that you can disable all tuners in 'Multimedia support
\Customize TV tuners'

As a quick test, when I ran 'grep =m v4l/.config | wc -l' within the
'~/v4l_driver' directory (or whatever you named it), it return 28.  It
checks how many modules are going to be built from your config.  If
you're near that number then it should be OK; if it's much larger then
you are probably configured to build too much.  Try again, if you have
the patience!

Once you're happy, run 'make' again.  If you get no errors, then it's
time to go for it and modify the source code for your device.

Change to directory 'linux/drivers/media/video/em28xx/' within your work
area ('~/v4l_driver') and look at the file called 'em28xx-cards.c'.  At
around line 797 you should see a section that starts:
[EM2860_BOARD_TVP5150_REFERENCE_DESIGN] =
By luck, this seems to have the same video chipset as you: EM2860 &
TVP5150.  You can therefore configure the driver so that it recognises
your USB Id as this card - it may work, it may not.

At around line 2045 of the same file you should see two lines that
start:	{ USB_DEVICE(0x2040, 0x1605),
			.driver_info = EM2884_BOARD_HAUPPAUGE_WINTV_HVR_930C },
(this may show as three lines due to word-wrapping in your mail reader)
Create a similar line after this with the USB Id of your device and the
configuration you will use:-
{ USB_DEVICE(0xeb1a, 0x5051),
			.driver_info = EM2860_BOARD_TVP5150_REFERENCE_DESIGN },
Note again: 1st line starts '{ USB_DEVICE' and 2nd line starts
'.driver'. There is NO third line and there IS a comma at the end.
Save the file.
The simple modification above will tell the driver that it is
responsible for that USB Id.

Back in your working directory '~/v4l_driver' type 'make'.  If all goes
well (no errors), follow it with 'sudo make install' to copy the newly
built files into your working system.

When you next plug in the device, it should be recognised.  Type 'dmesg
| grep em28xx' to see what the system thinks.  You should see it being
recognised.  It might work, or it might not!  Let me know how it goes.
We can tweak the configuration etc to see if we can make the device work
in Linux.

If it does look OK in 'dmesg' then quickly run:-

mplayer tv:// -tv
driver=v4l2:device=/dev/video0:audiorate=48000:immediatemode=0:forceaudio:alsa:adevice=hw.1:buffersize=64

(again one line) and you should see the video from composite and hear
audio (you may need to turn the capture level up on your system).

Good luck and a Happy New Year!

Regards,

Gareth

