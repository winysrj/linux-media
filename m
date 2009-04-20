Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3KIZ3O4002632
	for <video4linux-list@redhat.com>; Mon, 20 Apr 2009 14:35:03 -0400
Received: from yw-out-2324.google.com (yw-out-2324.google.com [74.125.46.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n3KIYkid009220
	for <video4linux-list@redhat.com>; Mon, 20 Apr 2009 14:34:47 -0400
Received: by yw-out-2324.google.com with SMTP id 3so1244501ywj.81
	for <video4linux-list@redhat.com>; Mon, 20 Apr 2009 11:34:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090421041338.4a2a9222.anthony-v4l@hogan.id.au>
References: <20090420230653.7089115b.anthony-v4l@hogan.id.au>
	<412bdbff0904200632n5c395252s3f27335c575b188f@mail.gmail.com>
	<20090421023426.b1a37cdf.anthony-v4l@hogan.id.au>
	<412bdbff0904200941m254f57aep3850374f87ebc413@mail.gmail.com>
	<20090421041338.4a2a9222.anthony-v4l@hogan.id.au>
Date: Mon, 20 Apr 2009 14:34:46 -0400
Message-ID: <412bdbff0904201134k255b30bob008a2b92d8235e5@mail.gmail.com>
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Anthony Hogan <anthony-v4l@hogan.id.au>
Content-Type: text/plain; charset=ISO-8859-1
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

On Mon, Apr 20, 2009 at 2:13 PM, Anthony Hogan <anthony-v4l@hogan.id.au> wrote:
> Before leaping into coding, I took a punt, installed tvtime as you
> suggested (hadn't tried it before), tried it (failed), then rmmod'd
> em28xx and then figured if the device detection is likely correct
> (em2860/TVP5150) I'd try forcing a card with that config in
> em28xx-cards.c via the card parm to em28xx module in a modprobe.. It
> would appear that the card 11 (Terratec Hybrid XS) matches most closely.
>
> Ie. em2860 + TVP5150
>
> Also worked with card 38 (Yakumo MovieMixer) which apparently uses an
> em2861 instead. Card 11 matches more closely, but tries to load DVB
> module (em28xx-dvb) also. Card 38 doesn't try to load this extra DVB
> module.
>
> Vision occasionally glitches - this could be because my SVideo cable is
> an old Apple ADB lead I dug out of my bits box and my test video source
> is a DVD player or just that I'm running on an old P4) on composite1
> and svideo with a blank blue screen on the television input.
>
> Haven't gotten audio yet - may take some more fiddling :) (perhaps it's
> my audio config) - an extra audio capture device has appeared in my
> ALSA mixer tho.

Bear in mind that tvtime won't play the audio, regardless of the
device.  You can hear the audio by running arecord/aplay from a
separate window:

arecord -D hw:1,0 -r 48000 -c 2 -f S16_LE | aplay -

> This would seem to suggest that rather than remove the TV input they
> just haven't connected a tuner to it and have left the composite and
> svideo inputs in the same "place".

Entirely possible.  You should make sure that both the composite and
s-video input work (and to test you should disconnect the inputs in
sequence to ensure that the inputs are mapped properly [e.g. you're
not reading on the composite input when you've selected s-video])

> I guess if I find a profile that works, the next step is to copy and
> adapt that profile to not list television as an input, add the i2c hash
> and then reload the new module without any parms..

You can remove the "has_dvb" from the device profile and the
em28xx-dvb stuff won't load.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
