Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3KIE27f019709
	for <video4linux-list@redhat.com>; Mon, 20 Apr 2009 14:14:02 -0400
Received: from hosted02.westnet.com.au (hosted02.westnet.com.au [203.10.1.213])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n3KIDkmF028950
	for <video4linux-list@redhat.com>; Mon, 20 Apr 2009 14:13:47 -0400
Date: Tue, 21 Apr 2009 04:13:38 +1000
From: Anthony Hogan <anthony-v4l@hogan.id.au>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
Message-Id: <20090421041338.4a2a9222.anthony-v4l@hogan.id.au>
In-Reply-To: <412bdbff0904200941m254f57aep3850374f87ebc413@mail.gmail.com>
References: <20090420230653.7089115b.anthony-v4l@hogan.id.au>
	<412bdbff0904200632n5c395252s3f27335c575b188f@mail.gmail.com>
	<20090421023426.b1a37cdf.anthony-v4l@hogan.id.au>
	<412bdbff0904200941m254f57aep3850374f87ebc413@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: eMPIA device without unique USB ID or EEPROM..
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

> It's possible that it mis-detected a tvp5150, but it's unlikely.
> There aren't many different decoders that were used for those boards
> (all the ones I have seen are either tvp5150 or saa711x).  You might
> want to check the .vmux field, since it's possible that it's tied to a
> different input.
> 
> Also, I would suggest you hook up both the s-video and the composite
> to valid video sources, so you can test both inputs (this lets you see
> if one is working but not the other).
> 
> > Am I thinking along the correct lines? Missing something? As I said,
> > I'm no C coder, but I'll give stuff a go :)
> 
> Looks like you're on the right track.  Keep up the good work.
> 
> Why don't you compile the code as you describe above, and then open
> tvtime, select the composite or s-video output, and then send the full
> dmesg output.

Before leaping into coding, I took a punt, installed tvtime as you
suggested (hadn't tried it before), tried it (failed), then rmmod'd
em28xx and then figured if the device detection is likely correct
(em2860/TVP5150) I'd try forcing a card with that config in
em28xx-cards.c via the card parm to em28xx module in a modprobe.. It
would appear that the card 11 (Terratec Hybrid XS) matches most closely.

Ie. em2860 + TVP5150

Also worked with card 38 (Yakumo MovieMixer) which apparently uses an
em2861 instead. Card 11 matches more closely, but tries to load DVB
module (em28xx-dvb) also. Card 38 doesn't try to load this extra DVB
module.

Vision occasionally glitches - this could be because my SVideo cable is
an old Apple ADB lead I dug out of my bits box and my test video source
is a DVD player or just that I'm running on an old P4) on composite1
and svideo with a blank blue screen on the television input.

Haven't gotten audio yet - may take some more fiddling :) (perhaps it's
my audio config) - an extra audio capture device has appeared in my
ALSA mixer tho.

This would seem to suggest that rather than remove the TV input they
just haven't connected a tuner to it and have left the composite and
svideo inputs in the same "place".

I guess if I find a profile that works, the next step is to copy and
adapt that profile to not list television as an input, add the i2c hash
and then reload the new module without any parms..

Thus far with card 11:

em28xx v4l2 driver version 0.1.0 loaded
em28xx new video device (eb1a:2861): interface 0, class 255
em28xx Has usb audio class
em28xx #0: Alternate settings: 8
em28xx #0: Alternate setting 0, max size= 0
em28xx #0: Alternate setting 1, max size= 0
em28xx #0: Alternate setting 2, max size= 1448
em28xx #0: Alternate setting 3, max size= 2048
em28xx #0: Alternate setting 4, max size= 2304
em28xx #0: Alternate setting 5, max size= 2580
em28xx #0: Alternate setting 6, max size= 2892
em28xx #0: Alternate setting 7, max size= 3072
em28xx #0: chip ID is em2860
em28xx #0: board has no eeprom
tvp5150 5-005c: tvp5150am1 detected.
em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
em28xx #0: Found Terratec Hybrid XS
usbcore: registered new interface driver em28xx
zl10353_read_register: readreg error (reg=127, ret==-19)
em28xx #0/2: dvb frontend not attached. Can't attach xc3028
Em28xx: Initialized (Em28xx dvb Extension) extension
tvp5150 5-005c: tvp5150am1 detected.

card 38:

em28xx v4l2 driver version 0.1.0 loaded
em28xx new video device (eb1a:2861): interface 0, class 255
em28xx Has usb audio class
em28xx #0: Alternate settings: 8
em28xx #0: Alternate setting 0, max size= 0
em28xx #0: Alternate setting 1, max size= 0
em28xx #0: Alternate setting 2, max size= 1448
em28xx #0: Alternate setting 3, max size= 2048
em28xx #0: Alternate setting 4, max size= 2304
em28xx #0: Alternate setting 5, max size= 2580
em28xx #0: Alternate setting 6, max size= 2892
em28xx #0: Alternate setting 7, max size= 3072
em28xx #0: chip ID is em2860
em28xx #0: board has no eeprom
em28xx #0: 

em28xx #0: The support for this board weren't valid yet.
em28xx #0: Please send a report of having this working
em28xx #0: not to V4L mailing list (and/or to other addresses)

tvp5150 5-005c: tvp5150am1 detected.
em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
em28xx #0: Found Yakumo MovieMixer
usbcore: registered new interface driver em28xx
tvp5150 5-005c: tvp5150am1 detected.

Thanks for your suggestions and pointers thus far.. I might finish up
for this evening, it's 4.12am here :)

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
