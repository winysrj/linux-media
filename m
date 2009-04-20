Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3KDWkgO027443
	for <video4linux-list@redhat.com>; Mon, 20 Apr 2009 09:32:46 -0400
Received: from yw-out-2324.google.com (yw-out-2324.google.com [74.125.46.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n3KDWUCN026919
	for <video4linux-list@redhat.com>; Mon, 20 Apr 2009 09:32:30 -0400
Received: by yw-out-2324.google.com with SMTP id 3so1150264ywj.81
	for <video4linux-list@redhat.com>; Mon, 20 Apr 2009 06:32:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090420230653.7089115b.anthony-v4l@hogan.id.au>
References: <20090420230653.7089115b.anthony-v4l@hogan.id.au>
Date: Mon, 20 Apr 2009 09:32:29 -0400
Message-ID: <412bdbff0904200632n5c395252s3f27335c575b188f@mail.gmail.com>
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Anthony Hogan <anthony-v4l@hogan.id.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
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

On Mon, Apr 20, 2009 at 9:06 AM, Anthony Hogan <anthony-v4l@hogan.id.au> wrote:
> Aldi (Supermarket chain) Fission (home brand) USB hi-speed dvd maker
> Aldi Product number/SKU: 6675
> Model Number: DK-8703
> Composite + SVHS video input
> Stereo line-level audio input
> Single button, single LED
> No FCC ID (intended for Australian/European market, only has CE and "Tick" mark)
>
> Using linux kernel 2.6.28.4, custom compilation
>
> Connected a video source to it and tried a few apps to view with a few
> different card parms, but could not get anything to display on screen.
>
> Supplied documentation claims 720x480 resolution and
>
> What should I be trying to get this going?
>
> dmesg output:
> ==============================================================================
> em28xx v4l2 driver version 0.1.0 loaded
> em28xx new video device (eb1a:2861): interface 0, class 255
> em28xx Has usb audio class
> em28xx #0: Alternate settings: 8
> em28xx #0: Alternate setting 0, max size= 0
> em28xx #0: Alternate setting 1, max size= 0
> em28xx #0: Alternate setting 2, max size= 1448
> em28xx #0: Alternate setting 3, max size= 2048
> em28xx #0: Alternate setting 4, max size= 2304
> em28xx #0: Alternate setting 5, max size= 2580
> em28xx #0: Alternate setting 6, max size= 2892
> em28xx #0: Alternate setting 7, max size= 3072
> em28xx #0: chip ID is em2860
> em28xx #0: board has no eeprom
> em28xx #0: found i2c device @ 0xb8 [tvp5150a]
> em28xx #0: Your board has no unique USB ID and thus need a hint to be detected.
> em28xx #0: You may try to use card=<n> insmod option to workaround that.
> em28xx #0: Please send an email with this log to:
> em28xx #0:      V4L Mailing List <video4linux-list@redhat.com>
> em28xx #0: Board eeprom hash is 0x00000000
> em28xx #0: Board i2c devicelist hash is 0x77800080
> em28xx #0: Here is a list of valid choices for the card=<n> insmod option:
> em28xx #0:     card=0 -> Unknown EM2800 video grabber
> ....
> em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
> tvp5150 5-005c: tvp5150am1 detected.
> em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
> em28xx #0: Found Unknown EM2750/28xx video grabber
> usbcore: registered new interface driver snd-usb-audio
> usbcore: registered new interface driver em28xx
> tvp5150 5-005c: tvp5150am1 detected.
> ==============================================================================
> lsusb -vvd eb1a:2861 output
>

<snip>

In cases like this, you typically make use of the i2c hash.  Create an
entry in the list of devices using i2c hashes (using 0x77800080 as the
value based on your dmesg output), and then just create a regular
device profile.

Cheers,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
